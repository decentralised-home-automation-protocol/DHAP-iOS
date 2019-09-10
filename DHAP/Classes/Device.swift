//
//  Device.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation

public struct Device: Equatable {
    
    public var macAddress: String
    
    public var ipAddress: String
    
    public var name: String?
    
    public var location: String?
    
    init(macAddress: String, ipAddress: String) {
        self.macAddress = macAddress
        self.ipAddress = ipAddress
    }
    
}
