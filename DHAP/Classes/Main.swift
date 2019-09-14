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
                        let rangeInputElement = RangeInputElement(frame: .zero)
                        
                        rangeInputElement.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(rangeInputElement)
                    case .directionalbuttons:
                        let directionalButtonsElement = DirectionalButtonsElement(frame: .zero)
                        
                        directionalButtonsElement.label.text = e.displaySettings.first
                        
                        directionalButtonsElement.topButton.setTitle(e.displaySettings[1], for: .normal)
                        directionalButtonsElement.rightButton.setTitle(e.displaySettings[2], for: .normal)
                        directionalButtonsElement.bottomButton.setTitle(e.displaySettings[3], for: .normal)
                        directionalButtonsElement.leftButton.setTitle(e.displaySettings[4], for: .normal)
                        
                        groupView.stackView.addArrangedSubview(directionalButtonsElement)
                    case .selection:
                        let selectionElement = SelectionElement(frame: .zero)
                        
                        selectionElement.label.text = e.displaySettings.first
                        
                        let data = e.displaySettings
                        selectionElement.data = Array(data.dropFirst())
                        
                        groupView.stackView.addArrangedSubview(selectionElement)
                    case .status:
                        let statusElement = StatusElement(frame: .zero)
                        
                        statusElement.label.text = e.displaySettings.first
                        
                        groupView.stackView.addArrangedSubview(statusElement)
                    case .textinput:
                        let textInputElement = TextInputElement(frame: .zero)
                        
                        textInputElement.label.text = e.displaySettings.first
                        textInputElement.button.setTitle(e.displaySettings[1], for: .normal)
                        
                        groupView.stackView.addArrangedSubview(textInputElement)
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
