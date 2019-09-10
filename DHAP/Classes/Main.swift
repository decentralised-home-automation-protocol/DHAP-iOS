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
                groupView.label.text = g.label
                
                for e in g.elements {
                    print("type: \(e.type.rawValue), label: \(e.displaySettings)")
                    
                    switch e.type {
                    case .buttontoggle:
                        let buttonToggleElement = ButtonToggleElement(frame: .zero)
                        
                        buttonToggleElement.button.setTitle("OFF", for: .normal)
                        buttonToggleElement.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(buttonToggleElement)
                    case .switchtoggle:
                        let switchToggleElement = SwitchToggleElement(frame: .zero)
                        
                        switchToggleElement.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(switchToggleElement)
                    case .stepper:
                        let stepperElement = StepperElement(frame: .zero)
                        
                        stepperElement.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(stepperElement)
                    case .rangeinput:
                        let rangeInput = RangeInput(frame: .zero)
                        
                        rangeInput.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(rangeInput)
                    default:
                        break
                    }
                    
                }
                
                groupElements.append(groupView)
            }
            
            completionHandler(groupElements)
        }
    }
    
}
