//
//  PacketCodes.swift
//  DHAP
//
//  Created by Aiden Garipoli on 1/9/19.
//

import Foundation

enum PacketCodes: Int {

    // MARK: - Display

    case uiRequest = 200
    case uiResponse = 210

    // MARK: - Discovery

    case discoveryRequest = 300
    case discoveryResponse = 310
    case discoveryHeaderRequest = 320
    case discoveryHeaderRespone = 330
    
    // MARK: - Command
    
    case commandRequest = 400
    
    // MARK: - Status
    
    case statusLeaseRequest = 500
    case statusLeaseResponse = 510
    case statusUpdate = 530

}
