//
//  Discovery.swift
//  DHAP
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation
import CocoaAsyncSocket

public enum DevicesResult {
    case foundDevices([String])
    case noDevicesFound
    case failure(Error)
}

public class Discovery: NSObject, GCDAsyncUdpSocketDelegate {
    
    private let broadcastAddress = "255.255.255.255"
    private let udpPort: UInt16 = 8888
    
    private var socket: GCDAsyncUdpSocket?
    
    private var censusList = [String]()
    private var previousCensusList = [String]()
    
    private var repliedDevices = [String]()
    
    public override init() {
        super.init()
        
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .global(qos: .utility))
    }
    
    public func discover(_ completion: @escaping (DevicesResult) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            do {
                defer {
                    self.socket?.close()
                }
                
                try self.socket?.bind(toPort: self.udpPort)
                try self.socket?.enableBroadcast(true)
                
                try self.findDevices()
                
                if self.censusList.count > 0 {
                    completion(.foundDevices(self.censusList))
                } else {
                    completion(.noDevicesFound)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func findDevices() throws {
        var emptyRepliesCount = 0
        var listRepeatedCount = 0
        
        while true {
            broadcastList()
            
            // listen for replies
            do {
                try socket?.beginReceiving()
                // try socket?.receiveOnce()
            } catch {
                print(error)
            }
            
            let testDGroup = DispatchGroup()
            
            testDGroup.enter()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                print("should stop receiving now")
                self.socket?.pauseReceiving()
                testDGroup.leave()
            }
            
            testDGroup.wait()
            // end listen for replies
            
            print("Received (\(repliedDevices.count)) replies.")
            if repliedDevices.count > 0 {
                // update list
                print("Updating list...")
                censusList.append(contentsOf: repliedDevices)
            } else {
                print("Empty replies: \(emptyRepliesCount)")
                emptyRepliesCount += 1
                if emptyRepliesCount == 3 {
                    print("Third empty reply, Finishing discovery.")
                    return
                }
            }
            
            repliedDevices.removeAll()
            
            if previousCensusList == censusList {
                listRepeatedCount += 1
                print("List repeated (\(listRepeatedCount)) times.")
            } else {
                print("Setting previous list to current list.")
                previousCensusList.removeAll()
                previousCensusList.append(contentsOf: censusList)
            }
            
            if listRepeatedCount > 5 {
                print("List repeated 5 times. Finishing discovery.")
                return
            }
            
            print("Repeating...")
        }
    }
    
    private func broadcastList() {
        print("Broadcasting list...")
        
        var censusListString = "300"
        
        if censusList.count > 0 {
            censusListString += "|" + censusList.joined(separator: "-")
        }
        
        let data = censusListString.data(using: .utf8)!
        
        socket?.send(data, toHost: broadcastAddress, port: udpPort, withTimeout: 0, tag: 0)
    }
    
    private func parsePacket(data: Data) {
        let packetString = String(data: data, encoding: .utf8)!
        print("Packet data: \(packetString)")
        
        let contents = packetString.split(separator: "|")
        //        let device = contents[1].split(separator: ",")
        // make device instance
        
        repliedDevices.append(String(contents[1]))
    }
    
    // MARK: - GCDAsyncUdpSocket Delegate Methods
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        guard let senderAddress = parseRemoteAddress(remoteAddress: address) else {
            return
        }
        
        guard let strIPAddress = getIPAddress() else {
            return
        }
        
        //        print("Sender IP: \(senderAddress)")
        //        print("IPAddress: \(strIPAddress)")
        
        //        print("received data")
        
        if strIPAddress == senderAddress {
            //            print("this must be broadcast packet, ignore.")
        } else {
            print("Received packet from \(senderAddress)")
            parsePacket(data: data)
        }
        
    }
    
    
    
    private func parseRemoteAddress(remoteAddress: Data) -> String? {
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        do {
            try remoteAddress.withUnsafeBytes { (pointer: UnsafePointer<sockaddr>) -> Void in
                guard getnameinfo(pointer, socklen_t(remoteAddress.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    throw NSError(domain: "domain", code: 0, userInfo: ["error": "unable to get ip address"])
                }
            }
        } catch {
            print(error)
            return nil
        }
        let address = String(cString: hostname)
        
        if address.contains("::ffff:") {
            return nil
        }
        
        return address
    }
    
    
    // ip address
    private func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: (interface!.ifa_name))
                    if  name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            
            freeifaddrs(ifaddr)
        }
        
        return address ?? nil
    }
    
}
