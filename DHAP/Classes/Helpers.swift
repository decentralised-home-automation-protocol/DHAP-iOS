//
//  Helpers.swift
//  DHAP
//
//  Created by Aiden Garipoli on 1/9/19.
//

import Foundation

class Helper {
    
    private static var sharedHelper: Helper = {
        let helper = Helper()
        
        return helper
    }()
    
    class func shared() -> Helper {
        return sharedHelper
    }
    
    func parseRemoteAddress(remoteAddress: Data) -> String? {
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
    
    func getIPAddress() -> String? {
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
