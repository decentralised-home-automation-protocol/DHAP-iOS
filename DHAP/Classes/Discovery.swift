//
//  Discovery.swift
//  DHAP
//
//  Created by Aiden Garipoli on 29/8/19.
//

import Foundation
import CocoaAsyncSocket

public enum DevicesResult {
    case foundDevices([Device])
    case noDevicesFound
    case failure(Error)
}

public class Discovery: UDPHandlerDelegate {
    
    var udpHandler: UDPHandler?
    
    private var censusList = [Device]()
    private var previousCensusList = [Device]()
    
    private var repliedDevices = [Device]()
    
    public init() {
        udpHandler = UDPHandler()
        udpHandler?.delegate = self
    }
    
    public func discover(_ completion: @escaping (DevicesResult) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            do {
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
            
            let testDGroup = DispatchGroup()
            
            testDGroup.enter()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                print("should stop receiving now")
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
        
        var censusListString = PacketCodes.discovery
        
        if censusList.count > 0 {
            censusListString += "|"
            var deviceStrings = [String]()
            for device in censusList {
                deviceStrings.append("\(device.macAddress),0,0")
            }
            censusListString += deviceStrings.joined(separator: "-")
        }
        
        let data = censusListString.data(using: .utf8)!
        
        let packet = UDPPacket(data: data, port: 8888)
        udpHandler?.sendBroadcastPacket(packet: packet)
    }
    
    private func parsePacket(data: Data, remoteAddress: String) {
        let packetString = String(data: data, encoding: .utf8)!
        
        print("Packet data: \(packetString)")
        
        let contents = packetString.split(separator: "|")
        
        guard let macAddress = contents[1].split(separator: ",").first else {
            return
        }
        
        // make device instance
        let device = Device(macAddress: String(macAddress), ipAddress: remoteAddress)
        
        repliedDevices.append(device)
    }
    
    func packetReceived(_ handler: UDPHandler, didReceive data: Data, fromAddress address: Data) {
        guard let senderAddress = Helper.shared().parseRemoteAddress(remoteAddress: address) else {
            return
        }

        guard let strIPAddress = Helper.shared().getIPAddress() else {
            return
        }

        if strIPAddress == senderAddress {
            print("Received packet from \(senderAddress)")
            print("\tthis must be broadcast packet, ignore.")
        } else {
            print("Received packet from \(senderAddress)")
            parsePacket(data: data, remoteAddress: senderAddress)
        }
    }

}
