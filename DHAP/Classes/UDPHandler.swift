//
//  UDPHandler.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation
import CocoaAsyncSocket

class UDPHandler: NSObject, GCDAsyncUdpSocketDelegate {
    
    private var socket: GCDAsyncUdpSocket?
    
    override init() {
        super.init()
        
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .global(qos: .utility))
    }
    
    public func sendPacket(data: Data, host: String, port: UInt16) {
//        socket?.send(data, withTimeout: 0, tag: 0)
        socket?.send(data, toHost: host, port: port, withTimeout: 0, tag: 0)
    }
    
    public func sendPacketAndListen(packet: UDPPacket, for: Int, completion: ([Data]) -> Void) {
        
    }
    
    // - MARK: GCDAsyncUdpSocketDelegate Delegate Methods
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        print(data)
        
    }
    
}
