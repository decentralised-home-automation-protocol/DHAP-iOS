//
//  UDPHandler.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation
import CocoaAsyncSocket

protocol UDPHandlerDelegate {
    func packetReceived(_ handler: UDPHandler, packetCode: PacketCodes, packetData: Data?, fromAddress: Data)
}

class UDPHandler: NSObject, GCDAsyncUdpSocketDelegate {
    
    private let broadcastAddress = "255.255.255.255"
    
    private var socket: GCDAsyncUdpSocket?
    
    var delegate: UDPHandlerDelegate?
    
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
        
        guard let packetString = String(data: data, encoding: .utf8) else { return }
        
        print("received packet")
        print("\(packetString)")
        
        let packet = packetString.split(separator: "|")
        guard let codeString = packet.first, let code = Int(codeString) else { return }

        var dataString: String?
        if packetString.split(separator: "|").count > 1 {
            dataString = String(packetString.split(separator: "|")[1])
        }

        guard let packetCode = PacketCodes(rawValue: code) else { return }

        let contents = dataString?.data(using: .utf8)

        delegate?.packetReceived(self, packetCode: packetCode, packetData: contents, fromAddress: address)
        
    }
    
//    deinit {
//        socket?.close()
//    }
    
}
