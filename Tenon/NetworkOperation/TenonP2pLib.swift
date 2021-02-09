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

extension String {

    func subStringFrom(_ index: Int) -> String {
         let theIndex = self.index(self.endIndex, offsetBy: index - self.count)
         return String(self[theIndex..<endIndex])
     }


     func findFirst(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .literal ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }


     func findLast(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .backwards ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }


     func findFirst(_ sub:String,_ begin:Int)->Int {
         var str:String = self.subStringFrom(begin)
         var pos:Int = str.findFirst(sub)
         return pos == -1 ? -1 : (pos + begin)
     }


     func findLast(_ sub:String,_ begin:Int)->Int {
         var str:String = self.subStringFrom(begin)
         var pos:Int = str.findLast(sub)
         return pos == -1 ? -1 : (pos + begin)
     }
}

extension Date {
    var milliStamp : UInt64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return UInt64(millisecond)
    }
}

@objcMembers
class TenonP2pLib : NSObject {
    static let sharedInstance = TenonP2pLib()
    var payfor_vpn_accounts_arr:[String] = [
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
    public var share_ip: String = "https://www.tenonvpn.net"
    public var buy_tenon_ip: String = "https://www.tenonvpn.net"

    public let kFreeToUseVpnBandwidth = 64 * 1024 * 1024;
    public var today_used_bandwidth: Int = -1;
    public var account_id: String = ""
    public var private_key: String = ""
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
                1,
                "id:42.51.39.113:9001,id:42.51.33.89:9001,id:42.51.41.173:9001,id:113.17.169.103:9001,id:113.17.169.105:9001,id:113.17.169.106:9001,id:113.17.169.93:9001,id:113.17.169.94:9001,id:113.17.169.95:9001,id:216.108.227.52:9001,id:216.108.231.102:9001,id:216.108.231.103:9001,id:216.108.231.105:9001,id:216.108.231.19:9001,id:3.12.73.217:9001,id:3.137.186.226:9001,id:3.22.68.200:9001,id:3.138.121.98:9001,id:18.188.190.127:9001,",
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
        
        GetGlobalMode()
        account_id = array[1]
        private_key = array[2]
        CheckVip()
        GetVipStatus()
        PayforVpn()
        return (array[0], array[2], array[1], array[3])
    }
    
    func GetSocketId() -> Int {
        return LibP2P.getSocketId()
    }
    
    func GetVpnNodes(_ country: String, _ route: Bool) -> String {
        var is_vip: Bool = false
        if (vip_left_days > 0) {
            is_vip = true
        }

        let res = LibP2P.getVpnNodes(country, route, is_vip) as String
        return res
    }
    
    func GetTransactions() -> String {
        let res = LibP2P.getTransactions() as String
        return res
    }
    
    func GetLocalAmount() -> UInt64 {
        if KeychainManager.shareInstence().getKeyChainTranscate().count != 0 {
            let transcate = KeychainManager.shareInstence().getKeyChainTranscate()
            let array = transcate.split(separator: ",")
            let amount = array[2]
            return UInt64(amount)!
        }
        
        return 0;
    }
    
    func GetBalance() -> UInt64 {
        var res = LibP2P.getBalance() as UInt64
        if (res > 1844674407370955161) {
            res = 0
        }
//        let local_amount: Int = UserDefaults.standard.integer(forKey: "local_charge_info_amount")
//        if (local_amount != 0) {
//            let trans_res: String = LibP2P.getTransactions() as String
//            let local_gid: String = UserDefaults.standard.value(forKey: "local_charge_info_gid") as! String
//            let location = trans_res.findFirst(local_gid)
//            if (location > 0) {
//                UserDefaults.standard.setValue(0, forKey: "local_charge_info_amount")
//            }
//        }
        if (KeychainManager.shareInstence().getKeyChainTranscate().count != 0) {
            var local_transcation = KeychainManager.shareInstence().getKeyChainTranscate();
            let array = local_transcation.split(separator: ",")
            if (array.count > 4) {
                let trans_res: String = LibP2P.getTransactions() as String
                let location = trans_res.findFirst(String(array[4]))
                if (location > 0) {
                    KeychainManager.shareInstence().setKeyChainType(0)
                    KeychainManager.shareInstence().setKeyChainReceipt("")
                    KeychainManager.shareInstence().setKeyChainTranscate("")
                }
            }
            
        }
//        if KeychainManager.shareInstence().getKeyChainTranscate().count != 0 {
//            let transcate = KeychainManager.shareInstence().getKeyChainTranscate()
//            let array = transcate.split(separator: ",")
//            let amount = array[2]
//            print("amount = \(amount) res = \(res)")
//            res += UInt64(amount)!
//        }
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
        return vip_left_days > 0 ? true: false
    }
    
    
    func GetGlobalMode() {
        VpnManager.shared.use_global_mode = UserDefaults.standard.bool(forKey: "use_global_mode")
    }
    
    func SaveGlobalModeTrue() {
        UserDefaults.standard.set(true, forKey: "use_global_mode")
        VpnManager.shared.use_global_mode = true
    }
    
    func SaveGlobalModeFalse() {
        UserDefaults.standard.set(false, forKey: "use_global_mode")
        VpnManager.shared.use_global_mode = false
    }
    @objc func getLeftDays() -> Int32 {
        vip_left_days = (Int32)(Int64(GetBalance() + GetLocalAmount()) / min_payfor_vpn_tenon);
        return vip_left_days
    }
    func PayforVpn() {
        let day_msec: Int64 = 3600 * 1000 * 24;
        let days_timestamp = payfor_timestamp / day_msec;
        let cur_timestamp: Int64 = Int64(Date().milliStamp)
        let days_cur = cur_timestamp / day_msec;
        let vip_days = payfor_amount / min_payfor_vpn_tenon
        vip_left_days = getLeftDays() //  changed by FriendWu
        if (payfor_timestamp != Int64.max && days_timestamp + vip_days > days_cur) {
            payfor_gid = "";
            vip_left_days = Int32((days_timestamp + vip_days - days_cur)) + (Int32)((now_balance + Int64(GetLocalAmount())) / min_payfor_vpn_tenon);
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
        
        let tmp_payfor_timestamp = (Int64)(res_split[0]) ?? Int64.max
        if (tmp_payfor_timestamp == payfor_timestamp) {
            return payfor_timestamp;
        }
        
        payfor_amount = (Int64)(res_split[1]) ?? 0
        payfor_timestamp = (Int64)(res_split[0]) ?? Int64.max
        SaveVipStatus()
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
    
    private override init() {
        super.init()
        
        if KeychainManager.shareInstence().getKeyChainPrikey().count != 0 {
            private_key = KeychainManager.shareInstence().getKeyChainPrikey()
        }

    }
    
    func GetVipStatus() {
        payfor_timestamp = Int64(UserDefaults.standard.integer(forKey: "vip_status_payfor_tm"))
        payfor_amount = Int64(UserDefaults.standard.integer(forKey: "vip_status_payfor_amount"))
    }
    
    func SaveVipStatus() {
        UserDefaults.standard.set(payfor_timestamp, forKey: "vip_status_payfor_tm")
        UserDefaults.standard.set(payfor_amount, forKey: "vip_status_payfor_amount")
    }
    
    public func SavePrivateKey(prikey_in: String) -> Bool {
        KeychainManager.shareInstence().setKeyChainPrikey(prikey_in)
        
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
