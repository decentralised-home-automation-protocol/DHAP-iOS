//
//  Device.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation

public struct Device {
    
    var macAddress: String
    
    var ipAddress: String
    
    var name: String?
    
    var room: String?
    
    init(macAddress: String, ipAddress: String) {
        self.macAddress = macAddress
        self.ipAddress = ipAddress
    }
    
}
