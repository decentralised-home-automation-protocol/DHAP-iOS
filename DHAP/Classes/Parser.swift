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
    
    private var currentGroupId = Int()
    private var currentGroupLabel = String()
    
    private var currentElementId = Int()
    private var currentElement = String()
    private var currentElementType = String()
    private var currentElementDisplaySettings = [String]()
    private var currentElementStatusLocation = Int()
    
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
            
            if let elementId = attributeDict["id"] {
                if let id = Int(elementId) {
                    currentElementId = id
                }
            }
        }
        
        if elementName == "group" {
            currentGroupLabel = ""

            if let groupId = attributeDict["id"] {
                if let id = Int(groupId) {
                    currentGroupId = id
                }
            }
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
        case "status_location":
            currentElementStatusLocation = Int(string.trimmingCharacters(in: .whitespacesAndNewlines))!
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case "gui_element":
            if let type = GUIElementType(rawValue: currentElementType) {
                let guiElement = GUIElement(id: currentElementId, type: type, displaySettings: currentElementDisplaySettings, statusLocation: currentElementStatusLocation)
                self.guiElements.append(guiElement)
            }
        case "group":
            let group = Group(id: currentGroupId, label: currentGroupLabel, elements: guiElements)
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
