//
//  ViewController.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//
import UIKit
import NetworkExtension
import Eureka
import NEKit
import libp2p
import StoreKit
import Alamofire
import SwiftyJSON
import UserNotifications
import GoogleMobileAds

extension String{
    var myLocalizedString:String{
        get{
            return NSLocalizedString(self, comment: self)
        }
    }
}

@objc class ViewController: BaseViewController{
    @objc public var choosed_country:String!
    var balance:UInt64!
    var local_country: String = ""
    @objc public var local_private_key: String = ""
    @objc public var local_account_id: String = ""
    var countryCode:[String] = ["Automatic", "United States", "Singapore", "Germany","France", "Netherlands", "Korea", "Japan", "Canada","Australia","Hong Kong", "India", "United Kingdom", "China"]
    var countryNodes:[String] = []
    var iCon:[String] = ["aa", "us", "sg","de","fr", "nl", "kr", "jp", "ca","au","hk", "in", "gb", "cn"]
    var defaultCountry:[String] = ["US", "IN","CA","DE","AU"]
    let encodeMethodList:[String] = ["aes-128-cfb","aes-192-cfb","aes-256-cfb","chacha20","salsa20","rc4-md5"]
    private var old_vpn_ip: String = ""
    private var now_connect_status = 0
    
    @objc public static var global_test_str: String = "";
    
    @objc public func ResetPrivateKey(_ ss: String) -> Int {
        if ss == TenonP2pLib.sharedInstance.private_key {
            return 1
        }
        
        if ss.count != 64 {
            return 2
        }
        
        if !TenonP2pLib.sharedInstance.SavePrivateKey(prikey_in: ss) {
            return 3
        }
        
        if !TenonP2pLib.sharedInstance.ResetPrivateKey(prikey: ss) {
            return 2
        }
        
        VpnManager.shared.disconnect()
        return 0
    }
    
    @objc func onSetingVPNStatusChanged0() {
        print("onSetingVPNStatusChanged0 called")
    }
    
    @objc func user_started_vpn() -> Bool {
        return VpnManager.shared.vpn_connected
    }
    
    @objc func onSetingVPNStatusChanged1() {
        print("onSetingVPNStatusChanged1 called")
    }
    
    @objc func onSetingVPNStatusChanged2() {
        print("onSetingVPNStatusChanged2 called")
    }
    
    @objc func onSetingVPNStatusChanged3() {
        print("onSetingVPNStatusChanged3 called")
    }
    
    @objc func onSetingVPNStatusChanged4() {
        print("onSetingVPNStatusChanged4 called")
    }
    @objc func onSetingVPNStatusChanged5() {
        print("onSetingVPNStatusChanged5 called")
    }
    @objc func onSetingVPNStatusChanged6() {
        print("onSetingVPNStatusChanged6 called")
    }
    @objc func onSetingVPNStatusChanged7() {
        print("onSetingVPNStatusChanged7 called")
    }
    @objc func onSetingVPNStatusChanged8() {
        print("onSetingVPNStatusChanged8 called")
    }
    @objc func onSetingVPNStatusChanged9() {
        print("onSetingVPNStatusChanged9 called")
    }
    
    @objc func InitP2p() -> Int {
        VpnManager.shared.vpn_init()
        let url = URL(string:"https://www.google.com");
        URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
            (data, rsp, error) in
            print("visit network ok");
        }).resume()

        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        if (res.local_country.isEmpty) {
            let alertController = UIAlertController(title: "error",
                            message: "Network invalid, please retry!", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in _exit(0)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return -1
        }

        local_country = res.local_country as String
        local_private_key = res.prikey as String
        local_account_id = res.account_id as String
        let routes = res.def_route.split(separator: ";")
        for item in routes {
            let item_split = item.split(separator: ":");
            if item_split.count != 2 {
                continue
            }

            if item_split[0] == local_country {
                local_country = String(item_split[1])
            }
        }

        VpnManager.shared.local_country = local_country
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged), name: NSNotification.Name(rawValue: "kSetingProxyServiceVPNStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged0), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged0"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged1), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged2), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged3), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged4), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged5), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged5"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged6), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged6"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged7), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged7"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged8), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged8"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSetingVPNStatusChanged9), name: NSNotification.Name(rawValue: "onSetingVPNStatusChanged9"), object: nil)
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }

        self.choosed_country = self.getCountryShort(countryCode: self.countryCode[0])
        VpnManager.shared.choosed_country = self.choosed_country
        balance = TenonP2pLib.sharedInstance.GetBalance()
        if balance != UInt64.max {
            TenonP2pLib.sharedInstance.now_balance = Int64(balance)
            TenonP2pLib.sharedInstance.PayforVpn()
        }

        requestData()
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false {
            print("yes")
        }else{

        }

        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
        return 0
    }
    
    
    @objc func GetAccountBalance() -> UInt64 {
        return TenonP2pLib.sharedInstance.GetBalance()
    }
    
    @objc func GetAccountVipDays() -> Int32 {
        return TenonP2pLib.sharedInstance.vip_left_days
    }
    
    @objc func IsConnected()->Bool {
        if VpnManager.shared.vpnStatus == .connecting {
            return true
        }
        
        if VpnManager.shared.vpnStatus == .on {
            return true
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TenonVPN"
        self.navigationController?.navigationBar.isHidden = true
        let url = URL(string:"https://www.google.com");
        URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
            (data, rsp, error) in
            //do some thing
            print("visit network ok");
        }).resume()
        
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        if (res.local_country.isEmpty) {
            let alertController = UIAlertController(title: "error",
                            message: "Network invalid, please retry!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in _exit(0)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        local_country = res.local_country as String
        local_private_key = res.prikey as String
        local_account_id = res.account_id as String
        
        let routes = res.def_route.split(separator: ";")
        for item in routes {
            let item_split = item.split(separator: ":");
            if item_split.count != 2 {
                continue
            }
            
            if item_split[0] == local_country {
                local_country = String(item_split[1])
            }
        }
        
        VpnManager.shared.local_country = local_country
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }

        self.choosed_country = self.getCountryShort(countryCode: self.countryCode[0])
        VpnManager.shared.choosed_country = self.choosed_country
        
        requestData()
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false {

        }else{
            
        }
        
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
    }

    @IBAction func downToExit(_ sender: Any) {
        if VpnManager.shared.vpnStatus == .on {
            clickConnect(sender)
        } else {
            _exit(1)
        }
    }
    
    func setRouteInfo() {
        var res_str = TenonP2pLib.sharedInstance.GetVpnNodes("ALL", true) as String
        if (res_str.isEmpty) {
            return
        }

        let vpn_route_strs = res_str.split(separator: "~")
        if (vpn_route_strs.count == 2) {
            VpnManager.shared.SetRouteNodes(nodes_str: String(vpn_route_strs[1]))
            VpnManager.shared.SetVpnNodes(nodes_str: String(vpn_route_strs[0]))
        }
    }
    
    func OpenGet() {
      
    }
    
    @objc func requestData(){
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn")
        if let messages = userDefaults?.string(forKey: "vpnsvr_status") {
            if messages == "bwo" || messages == "cni" || messages == "oul" {
                VpnManager.shared.disconnect()
            }
        }

        balance = TenonP2pLib.sharedInstance.GetBalance()
        if balance != UInt64.max {
            if TenonP2pLib.sharedInstance.now_balance != Int64(balance) {
                NotificationCenter.default.post(name: Notification.Name("NOTIFICATION_BALANCE"), object: nil)
            }
            TenonP2pLib.sharedInstance.now_balance = Int64(balance)
            TenonP2pLib.sharedInstance.PayforVpn()
        }
        
        setRouteInfo()
        self.perform(#selector(requestData), afterDelay: 1)
    }
    
    @objc func ConnectVpn() {
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
        if self.choosed_country != nil{
            var route_node = super.getOneRouteNode(country: self.local_country)
            if (route_node.ip.isEmpty) {
                route_node = super.getOneRouteNode(country: self.choosed_country)
                if (route_node.ip.isEmpty) {
                    for country in self.defaultCountry {
                        print("get route node \(country)")
                        route_node = super.getOneRouteNode(country: country)
                        if (!route_node.ip.isEmpty) {
                            break
                        }
                    }
                }
            }
            
            var vpn_node = super.getOneVpnNode(country: self.choosed_country)
            if (old_vpn_ip == vpn_node.ip) {
                for _ in 0...10 {
                    vpn_node = super.getOneVpnNode(country: self.choosed_country)
                    if (old_vpn_ip != vpn_node.ip) {
                        break
                    }
                }
            }
            
            if (vpn_node.ip.isEmpty) {
                for country in self.defaultCountry {
                    vpn_node = super.getOneVpnNode(country: country)
                    print("get vpn node \(country)")
                    if (!vpn_node.ip.isEmpty) {
                        break
                    }
                }
            }
            
            if !route_node.ip.isEmpty && !vpn_node.ip.isEmpty{
                VpnManager.shared.ip_address = route_node.ip
                VpnManager.shared.port = Int(route_node.port)!
                let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
                VpnManager.shared.public_key = LibP2P.getPublicKey() as String
                VpnManager.shared.enc_method = (
                    "aes-128-cfb," + String(vpn_ip_int) + "," +
                        vpn_node.port + "," + String(true))
                VpnManager.shared.password = vpn_node.passwd
                VpnManager.shared.algorithm = "aes-128-cfb"
                self.now_connect_status = 1
                VpnManager.shared.disconnect()
                VpnManager.shared.connect()
                old_vpn_ip = vpn_node.ip
            }
        }
    }
    
    @objc func DoClickDisconnect() {
        VpnManager.shared.vpn_connected = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus != .off {
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @objc func DoClickConnect() {
        VpnManager.shared.vpn_connected = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus == .off {
                    self.ConnectVpn()
                } else {
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @IBAction func clickConnect(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "FirstConnect") == false {
            return
        }
        VpnManager.shared.vpn_connected = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus == .off {
                    self.ConnectVpn()
                } else {
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @objc func threadOne() {
        let url = URL(string:"https://www.google.com");
        for _ in 0...200 {
            URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
                (data, rsp, error) in
                //do some thing
                print("visit network ok");
            }).resume()
            usleep(50000)
        }
    }
    
    @objc func onSetingVPNStatusChanged() {
        VpnManager.shared.disconnect()
    }
    
    @objc func onVPNStatusChanged(){
        if VpnManager.shared.vpnStatus == .on{
            self.now_connect_status = 0
            LibP2P.vpnConnected()
        }else{
          
        }
    }
    
}
