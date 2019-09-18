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

class Discovery: UDPHandlerDelegate {
    
    private let udpHandler: UDPHandler
    
    private var censusList = [Device]()
    private var previousCensusList = [Device]()
    
    private var repliedDevices = [Device]()
    
    init(udpHandler: UDPHandler) {
        self.udpHandler = udpHandler
        udpHandler.delegate = self
    }
    
    func discover(_ completion: @escaping (DevicesResult) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            do {
                try self.findDevices()
                
                if self.censusList.count > 0 {
                    
                    // request header information from each device
                    self.getDeviceHeaders()
                    
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
            
            let timeoutDispatchGroup = DispatchGroup()
            
            timeoutDispatchGroup.enter()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                print("should stop receiving now")
                timeoutDispatchGroup.leave()
            }
            
            timeoutDispatchGroup.wait()
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
        
        var censusListString = String(PacketCodes.discoveryRequest.hashValue)
        
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
        udpHandler.sendBroadcastPacket(packet: packet)
    }
    
    private func getDeviceHeaders() {
        // go through each device in the censuslist and request header from it
        // check if any device still doesnt have a header then repeat for those devices
        previousCensusList.removeAll()
        var devicesWithoutHeader = censusList
        
        var timeout = 10
        
        while devicesWithoutHeader.count > 0 && timeout > 0 {
            previousCensusList.removeAll()
            
            for device in devicesWithoutHeader {
                let data = String(PacketCodes.discoveryHeaderRequest.hashValue).data(using: .utf8)!
                let packet = UDPPacket(data: data, host: device.ipAddress, port: 8888)
                udpHandler.sendPacket(packet: packet)
                
                // sleep
                let timeoutDispatchGroup = DispatchGroup()
                
                timeoutDispatchGroup.enter()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    timeoutDispatchGroup.leave()
                }
                
                timeoutDispatchGroup.wait()
            }
            
            devicesWithoutHeader.removeAll { (device) -> Bool in
                return previousCensusList.contains(device)
            }
            previousCensusList.removeAll()
            timeout -= 1
        }
    }
    
    private func parsePacket(data: Data, remoteAddress: String) {
        
        guard let packetString = String(data: data, encoding: .utf8) else { return }
        
        print("Packet data: \(packetString)")
        
        let contents = packetString.split(separator: "|")
        
        guard let macAddress = contents[1].split(separator: ",").first else {
            return
        }
        
        // make device instance
        let device = Device(macAddress: String(macAddress), ipAddress: remoteAddress)
        
        repliedDevices.append(device)
    }
    
    private func addDeviceHeader(data: Data, fromAddress: String) {
        let headerData = String(data: data, encoding: .utf8)!.split(separator: ",")
        
        for var device in censusList {
            if device.ipAddress == fromAddress {
                device.name = String(headerData[0])
                device.location = String(headerData[1])
                previousCensusList.append(device)
                return
            }
        }
    }
    
    func packetReceived(_ handler: UDPHandler, packetCode: PacketCodes,
                        data: Data, fromAddress address: Data) {
        
        guard let senderAddress = Helpers.parseRemoteAddress(remoteAddress: address) else {
            return
        }

        guard let strIPAddress = Helpers.getIPAddress() else {
            return
        }

        if strIPAddress == senderAddress {
            print("Received packet from \(senderAddress)")
            print("\tthis must be broadcast packet, ignore.")
            return
        }
        
        print("Received packet from \(senderAddress)")
        
        switch packetCode {
        case .discoveryResponse:
            parsePacket(data: data, remoteAddress: senderAddress)
        case .discoveryHeaderRespone:
            addDeviceHeader(data: data, fromAddress: senderAddress)
        default:
            return
        }
    }

}
