//
//  Display.swift
//  DHAP
//
//  Created by Aiden Garipoli on 28/9/19.
//

import Foundation

class Display {
    
    private let udpHandler: UDPHandler
    
    private var completionHandler: ((String) -> Void)?
    
    init(udpHandler: UDPHandler) {
        self.udpHandler = udpHandler
        self.udpHandler.delegates.append(self)
    }
    
    func fetchDeviceInterface(device: Device, completion: @escaping (String) -> Void) {
        self.completionHandler = completion
        
        let uiRequest = String(PacketCodes.uiRequest.rawValue)
        
        let packet = UDPPacket(data: uiRequest.data(using: .utf8)!, host: device.ipAddress, port: 8888)

        udpHandler.sendPacket(packet: packet)
    }
    
}

extension Display: UDPHandlerDelegate {

    func packetReceived(_ handler: UDPHandler, packetCode: PacketCodes,
                        packetData: Data?, fromAddress: Data) {

        print("display: \(packetCode) - \(String(describing: packetData)) - \(fromAddress)")
        
        guard packetCode == PacketCodes.uiResponse else { return }

        guard let dataString = packetData else { return }
        
        let contents = String(data: dataString, encoding: .utf8)!

        completionHandler?(contents)
    }

}
