//
//  DHAP.swift
//  DHAP
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation

public class DHAP {
    
    private let udpHandler: UDPHandler
    private let discovery: Discovery
    
    public init() {
        udpHandler = UDPHandler()
        discovery = Discovery(udpHandler: udpHandler)
    }
    
    public func discoverDevices(completion: @escaping (DevicesResult) -> Void) {
        discovery.discover { (result) in
            completion(result)
        }
    }
    
    public func fetchDeviceInterface(device: Device) {
//        let uiRequest = PacketCodes.uiRequest
        
//        let packet = UDPPacket(data: uiRequest.data(using: .utf8)!, host: device.ipAddress, port: 8888)
//
//        udpHandler.sendPacket(packet: packet)
    }
    
}
