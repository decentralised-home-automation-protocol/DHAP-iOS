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
//    private let display: Display

    public init() {
        udpHandler = UDPHandler()
        discovery = Discovery(udpHandler: udpHandler)
//        display = Display(udpHandler: udpHandler)
    }

    public func discoverDevices(completion: @escaping (DevicesResult) -> Void) {
        discovery.discover { (result) in
            completion(result)
        }
    }

//    public func fetchDeviceInterface(device: Device, completion: @escaping (String) -> Void) {
//        display.fetchDeviceInterface(device: device) { (interface) in
//            completion(interface)
//        }
//    }
    
}
