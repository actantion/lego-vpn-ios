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
    var payfor_vpn_accounts_arr:[String] = [
        "dc161d9ab9cd5a031d6c5de29c26247b6fde6eb36ed3963c446c1a993a088262",
        "5595b040cdd20984a3ad3805e07bad73d7bf2c31e4dc4b0a34bc781f53c3dff7",
        "25530e0f5a561f759a8eb8c2aeba957303a8bb53a54da913ca25e6aa00d4c365",
        "9eb2f3bd5a78a1e7275142d2eaef31e90eae47908de356781c98771ef1a90cd2",
        "c110df93b305ce23057590229b5dd2f966620acd50ad155d213b4c9db83c1f36",
        "f64e0d4feebb5283e79a1dfee640a276420a08ce6a8fbef5572e616e24c2cf18",
        "7ff017f63dc70770fcfe7b336c979c7fc6164e9653f32879e55fcead90ddf13f",
        "6dce73798afdbaac6b94b79014b15dcc6806cb693cf403098d8819ac362fa237",
        "b5be6f0090e4f5d40458258ed9adf843324c0327145c48b55091f33673d2d5a4"]
    
    public var payfor_timestamp: Int64 = 0
    public var payfor_amount: Int64 = 0
    private var payfor_gid: String = ""
    public var vip_left_days: Int32 = -1
    public var now_balance: Int64 = -1
    public let min_payfor_vpn_tenon: Int64 = 66
    public var share_ip: String = "39.107.46.245"
    public var buy_tenon_ip: String = "222.186.170.72"

    public let kFreeToUseVpnBandwidth = 64 * 1024 * 1024;
    public var today_used_bandwidth: Int = -1;
    public var account_id: String = ""
    public var private_key: String = ""

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
                "id:95.179.217.57:9001,id:104.238.186.74:9001,id:108.61.165.101:9001,id:199.247.1.63:9001,id:104.248.45.86:9001,id:206.189.151.124:9001,id:155.138.146.247:9001,id:138.197.130.242:9001,id:144.202.34.161:9001,id:114.67.115.16:9003,id:103.205.5.163:9001,id:206.189.239.148:9001,id:222.186.170.72:9001,id:178.128.174.110:9001,id:139.59.47.229:9001,id:144.202.102.112:9001,id:128.199.38.94:9001,id:139.59.91.63:9001,id:103.205.4.28:9001,id:103.205.4.77:9001,id:8.9.31.116:9001,id:104.207.151.228:9001,id:46.101.152.5:9001,id:159.65.0.164:9001,id:206.189.226.23:9001,id:149.28.211.64:9001,id:108.61.251.121:9001,id:144.202.46.74:9001,id:103.205.5.217:9001,id:165.227.60.177:9001,id:155.138.211.202:9001,id:207.148.75.27:9001,id:114.67.112.207:9003,id:103.205.4.139:9001,id:206.189.233.88:9001,id:149.28.108.72:9001,id:45.77.188.210:9001,id:114.67.112.242:9003,id:144.202.104.64:9001,id:165.227.18.179:9001,",
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
        let day_msec: Int64 = 3600 * 1000 * 24;
        let days_timestamp = payfor_timestamp / day_msec;
        let cur_timestamp: Int64 = Int64(Date().milliStamp)
        let days_cur = cur_timestamp / day_msec;
        let vip_days = payfor_amount / min_payfor_vpn_tenon
        if (payfor_timestamp != Int64.max && days_timestamp + vip_days > days_cur) {
            payfor_gid = "";
            vip_left_days = Int32((days_timestamp + vip_days - days_cur)) + (Int32)(now_balance / min_payfor_vpn_tenon);
            return;
        } else {
            if (now_balance >= min_payfor_vpn_tenon) {
                PayforVipTrans();
            }
        }

        _ = CheckVip()
    }
    
    func CheckVip() -> Int64 {
        let res: String = LibP2P.checkVip()
        let res_split = res.split(separator: ",")
        if (res_split.count != 2) {
            return Int64.max
        }
        
        payfor_amount = (Int64)(res_split[1]) ?? 0
        payfor_timestamp = (Int64)(res_split[0]) ?? Int64.max
        return payfor_timestamp
    }
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }

    func PayforVipTrans() {
        let rand_num = randomCustom(min: 0, max: payfor_vpn_accounts_arr.count)
        let acc: String = payfor_vpn_accounts_arr[rand_num];
        if (acc.isEmpty) {
            return;
        }
        
        var days = now_balance / min_payfor_vpn_tenon
        if days > 30 {
            days = 30
        }
          
        let amount = days * min_payfor_vpn_tenon
        if amount <= 0 || amount > now_balance {
            return
        }
        payfor_gid = LibP2P.payforVpn(acc, payfor_gid, Int(amount));
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
