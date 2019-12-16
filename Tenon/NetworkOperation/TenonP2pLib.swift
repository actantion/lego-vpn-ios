//
//  TenonP2pLib.swift
//  TenonVPN
//
//  Created by actantion on 2019/9/12.
//  Copyright © 2019 zly. All rights reserved.
//

import Foundation
import libp2p
import NEKit

extension Date {
    var milliStamp : UInt64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return UInt64(millisecond)
    }
}

class TenonP2pLib {
    static let sharedInstance = TenonP2pLib()
    public var now_balance: Int64 = 0
    var pay_to_account:[String] = [
        "dc161d9ab9cd5a031d6c5de29c26247b6fde6eb36ed3963c446c1a993a088262",
        "5595b040cdd20984a3ad3805e07bad73d7bf2c31e4dc4b0a34bc781f53c3dff7",
        "25530e0f5a561f759a8eb8c2aeba957303a8bb53a54da913ca25e6aa00d4c365",
        "9eb2f3bd5a78a1e7275142d2eaef31e90eae47908de356781c98771ef1a90cd2",
        "c110df93b305ce23057590229b5dd2f966620acd50ad155d213b4c9db83c1f36",
        "f64e0d4feebb5283e79a1dfee640a276420a08ce6a8fbef5572e616e24c2cf18",
        "7ff017f63dc70770fcfe7b336c979c7fc6164e9653f32879e55fcead90ddf13f",
        "6dce73798afdbaac6b94b79014b15dcc6806cb693cf403098d8819ac362fa237",
        "b5be6f0090e4f5d40458258ed9adf843324c0327145c48b55091f33673d2d5a4"
    ];
    public var payfor_timestamp: UInt64 = 0
    public let kFreeToUseVpnBandwidth = 64 * 1024 * 1024;
    public var today_used_bandwidth: Int = -1;
    public var account_id: String = ""
    public var private_key: String = ""

    var payfor_gid: String = ""
    var min_payfor_vpn_tenon: Int64 = 1900
    var is_vip: Bool = false
    var keeped_private_kyes: [String] = []
    
    func InitP2pNetwork (
            _ local_ip: String,
            _ local_port: Int) -> (local_country: String, prikey: String, account_id: String, def_route: String) {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file!
        let conf_path = path
        
        print("conf \(conf_path) get local private key \(private_key)")
        let res = LibP2P.initP2pNetwork(
                local_ip,
                local_port,
                "id:139.59.91.63:9001,id:39.105.125.37:9001,id:139.59.47.229:9001,id:46.101.152.5:9001,id:165.227.18.179:9001,id:165.227.60.177:9001,id:39.107.46.245:9001,id:39.97.224.47:9001",
                conf_path,
                "3.0.0",
                private_key) as String

        let array : Array = res.components(separatedBy: ",")
        if (array.count < 4) {
            return ("", "", "", "")
        }
        
        if (private_key.isEmpty) {
            SavePrivateKey(prikey_in: array[2])
        }
        
        account_id = array[1]
        private_key = array[2]
        return (array[0], array[2], array[1], array[3])
    }
    
    func GetSocketId() -> Int {
        return LibP2P.getSocketId()
    }
    
    func GetVpnNodes(_ country: String, _ route: Bool) -> String {
        let res = LibP2P.getVpnNodes(country, route) as String
        return res
    }
    
    func GetTransactions() -> String {
        let res = LibP2P.getTransactions() as String
        return res
    }
    
    func GetBalance() -> UInt64 {
        let res = LibP2P.getBalance() as UInt64
        return res
    }
    
    func ResetTransport(_ local_ip: String, _ local_port: Int) {
        LibP2P.resetTransport(local_ip, local_port)
    }
    
    func GetPublicKey() -> String {
        let res = LibP2P.getPublicKey()as String
        return res
    }
    
    func CheckVersion() -> String {
        let res = LibP2P.checkVersion() as String
        return res
    }
    
    func BandwidthFreeValid() -> Bool {
        let tmp_val = LibP2P.getUsedBandwidth()
        today_used_bandwidth = Int(tmp_val ?? "-1") ?? -1;
        return today_used_bandwidth <= kFreeToUseVpnBandwidth
    }
    
    func IsVip() -> Bool {
        return is_vip
    }
    
    func PayforVpn() {
        let day_msec: UInt64 = 3600 * 1000 * 24;
        let days_timestamp: UInt64 = payfor_timestamp / day_msec;
        let cur_timestamp: UInt64 = Date().milliStamp;
        let days_cur: UInt64 = cur_timestamp / day_msec;
        
        print("timestamp pay \(days_timestamp), now timestamp \(days_cur)")
        if (payfor_timestamp != Int64.max && days_timestamp + 30 >= days_cur) {
            payfor_gid = "";
            is_vip = true
            return;
        } else {
            is_vip = false
            if payfor_gid.isEmpty && payfor_timestamp != 0 {
                if now_balance >= min_payfor_vpn_tenon {
                    PayforVipTrans();
                }
            }
        }

        if !payfor_gid.isEmpty {
            payfor_timestamp = UInt64(LibP2P.checkVip()) ?? 0
            print("payfor vpn check \(payfor_timestamp)");
        }
    }
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    func PayforVipTrans() {
        let rand_num = randomCustom(min: 0, max: pay_to_account.count);
        let acc = pay_to_account[rand_num]
        if (acc.isEmpty) {
            return;
        }
        
        payfor_gid = LibP2P.payforVpn(acc, payfor_gid, Int(min_payfor_vpn_tenon));
        print("payfor vpn and get gid \(payfor_gid)");
    }
    
    /*
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }

        print("Local IP \(addresses)")
        return addresses
    }
     */
    private init() {
        let res = GetPrivateKey();
        let res_split = res.split(separator: ",")
        for item in res_split {
            let tmp_item = item.trimmingCharacters(in: [" ", "\n", "\t"])
            if tmp_item.count != 64 {
                continue
            }
            
            if private_key.isEmpty {
                private_key = tmp_item
            }
            
            keeped_private_kyes.append(tmp_item)
        }
    }
    
    func GetPrivateKey() -> String {
        return UserDefaults.standard.string(forKey: "all_private_key") ?? ""
    }
    
    public func SavePrivateKey(prikey_in: String) -> Bool {
        let prikey = prikey_in.trimmingCharacters(in: [" "])
        if prikey.count != 64 {
            return false
        }

        if keeped_private_kyes.contains(prikey) {
            let idx = keeped_private_kyes.firstIndex(of: prikey)
            if idx ?? -1 >= 0 {
                keeped_private_kyes.remove(at: idx ?? -1)
            }
        }
        
        if keeped_private_kyes.count >= 3 {
            return false
        }
        
        var tmp_str: String = prikey
        for item in keeped_private_kyes {
            tmp_str += "," + item
        }
        
        UserDefaults.standard.set(tmp_str, forKey: "all_private_key")
        return true
    }
    
    func ResetPrivateKey(prikey: String) -> Bool {
        let res: String = LibP2P.resetPrivateKey(prikey)
        let res_split = res.split(separator: ",")
        if res_split.count != 2 {
            return false
        }
        
        private_key = prikey
        account_id = String(res_split[1])
        return true
    }
}
