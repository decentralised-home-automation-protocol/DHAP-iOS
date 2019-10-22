//
//  Main.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

public class Main {
    
    private let parser: Parser
    private let udpHandler: UDPHandler
    private let device: Device
    
    private var elements = [Int : ElementView]()
    private var displaySettings = [Int : [String]]()
    
    init(udpHandler: UDPHandler, device: Device) {
        parser = Parser()
        self.device = device
        self.udpHandler = udpHandler
        self.udpHandler.delegates.append(self)
    }
    
    func getGroupElements(xml: Data, completionHandler: @escaping ([GroupElement]) -> Void) {
        parser.parse(xml: xml) { (groups) in
            var groupElements = [GroupElement]()
            
            for g in groups {
                
                print("Group Start - \(g.id)")
                let groupView = GroupElement()
                groupView.label.text = g.label
                
                for e in g.elements {
                    print("id: \(e.id), type: \(e.type.rawValue), label: \(e.displaySettings)")
                    
                    switch e.type {
                    case .buttontoggle:
                        let buttonToggleElement = ButtonToggleElement(frame: .zero)
                        
                        buttonToggleElement.button.setTitle("OFF", for: .normal)
                        buttonToggleElement.label.text = e.displaySettings.first
                        
                        buttonToggleElement.delegate = self
                        
                        buttonToggleElement.groupId = g.id
                        buttonToggleElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(buttonToggleElement)
                        
                        self.elements[e.statusLocation] = buttonToggleElement
                        self.displaySettings[e.statusLocation] = e.displaySettings
                        
                    case .switchtoggle:
                        let switchToggleElement = SwitchToggleElement(frame: .zero)
                        
                        switchToggleElement.label.text = e.displaySettings.first
                        
                        switchToggleElement.delegate = self
                        
                        switchToggleElement.groupId = g.id
                        switchToggleElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(switchToggleElement)
                        
                        self.elements[e.statusLocation] = switchToggleElement
                    case .stepper:
                        let stepperElement = StepperElement(frame: .zero)
                        
                        stepperElement.label.text = e.displaySettings.first
                        
                        stepperElement.delegate = self
                        
                        stepperElement.groupId = g.id
                        stepperElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(stepperElement)
                        
                        self.elements[e.statusLocation] = stepperElement
                    case .rangeinput:
                        let rangeInputElement = RangeInputElement(frame: .zero)
                        
                        rangeInputElement.label.text = e.displaySettings.first
                        
                        rangeInputElement.delegate = self
                        
                        rangeInputElement.groupId = g.id
                        rangeInputElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(rangeInputElement)
                        
                        self.elements[e.statusLocation] = rangeInputElement
                    case .directionalbuttons:
                        let directionalButtonsElement = DirectionalButtonsElement(frame: .zero)
                        
                        directionalButtonsElement.label.text = e.displaySettings.first
                        
                        directionalButtonsElement.topButton.setTitle(e.displaySettings[1], for: .normal)
                        directionalButtonsElement.rightButton.setTitle(e.displaySettings[2], for: .normal)
                        directionalButtonsElement.bottomButton.setTitle(e.displaySettings[3], for: .normal)
                        directionalButtonsElement.leftButton.setTitle(e.displaySettings[4], for: .normal)
                        
                        directionalButtonsElement.delegate = self
                        
                        directionalButtonsElement.groupId = g.id
                        directionalButtonsElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(directionalButtonsElement)
                        
                        self.elements[e.statusLocation] = directionalButtonsElement
                    case .selection:
                        let selectionElement = SelectionElement(frame: .zero)
                        
                        selectionElement.label.text = e.displaySettings.first
                        
                        let data = e.displaySettings
                        selectionElement.data = Array(data.dropFirst())
                        
                        selectionElement.delegate = self
                        
                        selectionElement.groupId = g.id
                        selectionElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(selectionElement)
                        
                        self.elements[e.statusLocation] = selectionElement
                    case .status:
                        let statusElement = StatusElement(frame: .zero)
                        
                        statusElement.label.text = e.displaySettings.first
                        
                        statusElement.delegate = self
                        
                        statusElement.groupId = g.id
                        statusElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(statusElement)
                        
                        self.elements[e.statusLocation] = statusElement
                    case .textinput:
                        let textInputElement = TextInputElement(frame: .zero)
                        
                        textInputElement.label.text = e.displaySettings.first
                        textInputElement.button.setTitle(e.displaySettings[1], for: .normal)
                        
                        textInputElement.delegate = self
                        
                        textInputElement.groupId = g.id
                        textInputElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(textInputElement)
                        
                        self.elements[e.statusLocation] = textInputElement
                    case .progress:
                        let progressElement = ProgressElement(frame: .zero)
                        
                        progressElement.label.text = e.displaySettings.first
                        
                        progressElement.delegate = self
                        
                        progressElement.groupId = g.id
                        progressElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(progressElement)
                        
                        self.elements[e.statusLocation] = progressElement
                    case .buttongroup:
                        let buttonGroupElement = ButtonGroupElement(frame: .zero)
                        
                        buttonGroupElement.label.text = e.displaySettings.first
                        
                        // create buttons
                        let buttonLabels = e.displaySettings.dropFirst()
                        for buttonLabel in buttonLabels {
                            let button = UIButton()
                            button.setTitleColor(groupView.tintColor, for: .normal)
                            button.setTitle(buttonLabel, for: .normal)
                            buttonGroupElement.stackView.addArrangedSubview(button)
                        }
                        
                        buttonGroupElement.delegate = self
                        
                        buttonGroupElement.groupId = g.id
                        buttonGroupElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(buttonGroupElement)
                        
                        self.elements[e.statusLocation] = buttonGroupElement
                    case .scheduler:
                        let schedularElement = SchedularElement(frame: .zero)
                        
                        schedularElement.label.text = e.displaySettings.first
                        schedularElement.submitButton.setTitle(e.displaySettings[1], for: .normal)
                        
                        schedularElement.delegate = self
                        
                        schedularElement.groupId = g.id
                        schedularElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(schedularElement)
                        
                        self.elements[e.statusLocation] = schedularElement
                    case .password:
                        let passwordElement = PasswordElement(frame: .zero)
                        
                        passwordElement.label.text = e.displaySettings.first
                        passwordElement.submitButton.setTitle(e.displaySettings[1], for: .normal)
                        
                        passwordElement.delegate = self
                        
                        passwordElement.groupId = g.id
                        passwordElement.elementId = e.id
                        
                        groupView.stackView.addArrangedSubview(passwordElement)
                        
                        self.elements[e.statusLocation] = passwordElement
                    }
                    
                }
                
                groupElements.append(groupView)
            }
            
            completionHandler(groupElements)
        }
    }
    
}

extension Main: UDPHandlerDelegate {
    
    func packetReceived(_ handler: UDPHandler, packetCode: PacketCodes, packetData: Data?, fromAddress: Data) {
        guard packetCode == .statusUpdate else { return }
        
        guard let data = packetData else { return }
        
        guard let packetString = String(data: data, encoding: .utf8) else { return }
        
        let deviceMAC = packetString.split(separator: ",")[0]
        
        print("XX \(device.macAddress) = \(deviceMAC)")
        
        if device.macAddress == deviceMAC {
            for (st, element) in self.elements {
                let state = packetString.split(separator: ",")[st + 1]
                switch element {
                case is SwitchToggleElement:
                    let e = element as! SwitchToggleElement
                    if state == "false" {
                        DispatchQueue.main.async {
                            e.switchToggle.setOn(false, animated: true)
                        }
                    } else if state == "true" {
                        DispatchQueue.main.async {
                            e.switchToggle.setOn(true, animated: true)
                        }
                    }
                case is ButtonToggleElement:
                    let e = element as! ButtonToggleElement
                    let ds = self.displaySettings[st]
                    if state == "false" {
                        DispatchQueue.main.async {
                            e.button.setTitle(ds![2], for: .normal)
                        }
                    } else {
                        DispatchQueue.main.async {
                            e.button.setTitle(ds![1], for: .normal)
                        }
                    }
                case is StepperElement:
                    let e = element as! StepperElement
                    DispatchQueue.main.async {
                        e.valueLabel.text = String(state)
                    }
                case is SelectionElement:
                    let e = element as! SelectionElement
                    DispatchQueue.main.async {
                        e.selectionField.text = e.data[Int(String(state))!]
                    }
                case is TextInputElement:
                    let e = element as! TextInputElement
                case is StatusElement:
                    let e = element as! StatusElement
                    DispatchQueue.main.async {
                        e.status.text = String(state)
                    }
                default:
                    break
                }
            }
        }
    }
    
}

extension Main: CommandDelegate {
    
    func didSendCommand(_ sender: ElementView, command: String) {
        print("--- Command: \(command) ---")
        let dataString = "\(PacketCodes.commandRequest.rawValue)|\(sender.groupId!)-\(sender.elementId!)=\(command)"
        let data = dataString.data(using: .utf8)!
        let packet = UDPPacket(data: data, host: device.ipAddress, port: 8888)
        udpHandler.sendPacket(packet: packet)
        print("PAKCET: \(packet.data) - \(packet.host!) - \(packet.port)")
    }
    
}
