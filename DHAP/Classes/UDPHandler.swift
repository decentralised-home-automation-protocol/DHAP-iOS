//
//  UDPHandler.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation
import CocoaAsyncSocket

protocol UDPHandlerDelegate {
    func packetReceived(_ handler: UDPHandler, didReceive data: Data, fromAddress address: Data)
}

class UDPHandler: NSObject, GCDAsyncUdpSocketDelegate {
    
    private let broadcastAddress = "255.255.255.255"
    
    private var socket: GCDAsyncUdpSocket?
    
    var delegate: UDPHandlerDelegate?
    
//    private static var sharedUdpHandler: UDPHandler = {
//        let udpHandler = UDPHandler()
//
//        return udpHandler
//    }()
    
    override init() {
        super.init()
        
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .global(qos: .utility))
        
        do {
            try socket?.bind(toPort: 8888)
            try socket?.enableBroadcast(true)
            try socket?.beginReceiving()
        } catch {
            print(error)
        }
    }
    
//    class func shared() -> UDPHandler {
//        return sharedUdpHandler
//    }
    
    func sendPacket(packet: UDPPacket) {
        socket?.send(packet.data, toHost: packet.host!, port: packet.port, withTimeout: 0, tag: 0)
    }
    
    func sendBroadcastPacket(packet: UDPPacket) {
        socket?.send(packet.data, toHost: broadcastAddress, port: packet.port, withTimeout: 0, tag: 0)
    }
    
    
    
    func sendPacketForReply(packet: UDPPacket, retries: Int) {
        
    }
    
    func sendPacketAndListen(packet: UDPPacket, duration: Int, completion: ([Data]) -> Void) {
        
    }
    
    // - MARK: GCDAsyncUdpSocketDelegate Delegate Methods
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data,
                          fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        print("received packet")
        let dataString = String(data: data, encoding: .utf8)!
        print("\(dataString)")
        
        delegate?.packetReceived(self, didReceive: data, fromAddress: address)
        
    }
    
//    deinit {
//        socket?.close()
//    }
    
}
