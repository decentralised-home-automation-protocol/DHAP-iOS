//
//  Parser.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

enum Schema: String {
    case group, gui_element, type, label
}

class Parser: NSObject, XMLParserDelegate {
    
    private var currentGroupLabel = String()
    private var currentElement = String()
    private var currentElementType = String()
    private var currentElementDisplaySettings = [String]()
    
    private var groups = [Group]()
    private var guiElements = [GUIElement]()
    
    private var completionHandler: (([Group]) -> Void)?
    
    func parse(xml: Data, completionHandler: (([Group]) -> Void)?) {
        self.completionHandler = completionHandler

        let parser = XMLParser(data: xml)
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if currentElement == "gui_element" {
            currentElementType = ""
            currentElementDisplaySettings.removeAll()
        }
        
        if elementName == "group" {
            currentGroupLabel = ""
        }
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "label":
            currentGroupLabel += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "type":
            currentElementType += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "disp_settings":
            let displaySettingsString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let displaySettings = displaySettingsString.split(separator: ",")
            for setting in displaySettings {
                currentElementDisplaySettings.append(String(setting))
            }
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case "gui_element":
            if let type = GUIElementType(rawValue: currentElementType) {
                let guiElement = GUIElement(type: type, displaySettings: currentElementDisplaySettings)
                self.guiElements.append(guiElement)
            }
        case "group":
            let group = Group(label: currentGroupLabel, elements: guiElements)
            self.groups.append(group)
            guiElements = []
        default: break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?(groups)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
