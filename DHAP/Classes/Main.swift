//
//  Main.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

public class Main {
    
    private let parser: Parser
    
    public init() {
        parser = Parser()
    }
    
    func getGroupElements(xmlPath: URL, completionHandler: @escaping ([GroupElement]) -> Void) {
        parser.parse(xmlPath: xmlPath) { (groups) in
            var groupElements = [GroupElement]()
            
            for g in groups {
                
                print("Group Start")
                let groupView = GroupElement()
                
                for e in g.elements {
                    print("type: \(e.type.rawValue), label: \(e.label)")
                    
                    if e.type == .toggle {
                        let buttonToggleElement = ButtonToggleElement(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
                        
                        buttonToggleElement.button.setTitle("OFF", for: .normal)
                        buttonToggleElement.label.text = e.label
                        
                        groupView.stackView.addArrangedSubview(buttonToggleElement)
                    }
                    
                }
                
                groupElements.append(groupView)
            }
            
            completionHandler(groupElements)
        }
    }
    
}
