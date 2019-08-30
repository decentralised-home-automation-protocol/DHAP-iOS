//
//  UDPPacket.swift
//  DHAP
//
//  Created by Aiden Garipoli on 30/8/19.
//

import Foundation

struct UDPPacket {
    
    var data: Data
    
    var host: String
    
    var port: UInt16
    
    init(data: Data, host: String, port: UInt16) {
        self.data = data
        self.host = host
        self.port = port
    }
    
}
