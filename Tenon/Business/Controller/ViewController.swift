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
    var countryCode:[String] = ["United States", "Singapore", "Germany","France", "Netherlands", "Korea", "Japan", "Canada","Australia","Hong Kong", "India", "United Kingdom", "China"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg","de","fr", "nl", "kr", "jp", "ca","au","hk", "in", "gb", "cn"]
    var defaultCountry:[String] = ["US", "IN","CA","DE","AU"]
    let encodeMethodList:[String] = ["aes-128-cfb","aes-192-cfb","aes-256-cfb","chacha20","salsa20","rc4-md5"]
    private var old_vpn_ip: String = ""
    private var now_connect_status = 0
    @objc public var user_started_vpn: Bool = false
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
    
    @objc func InitP2p() -> Int {
        let bTime = Date().timeIntervalSince1970
        VpnManager.shared.vpn_init()

        let url = URL(string:"https://www.google.com");
        URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
            (data, rsp, error) in
            print("visit network ok");
        }).resume()


        let time1 = Date().timeIntervalSince1970
        print("time1: " , (time1 - bTime));
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        print("init network res: \(res)")
        let time2 = Date().timeIntervalSince1970
        print("time2: " , (time2 - time1));
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

        // 加载慢的原因 解决掉
        //setRouteInfo()

        local_country = res.local_country as String
        local_private_key = res.prikey as String
        local_account_id = res.account_id as String
        let time3 = Date().timeIntervalSince1970
        print("time3: " , (time3 - time2));
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
        let time4 = Date().timeIntervalSince1970
        print("time4: " , (time4 - time3));
        VpnManager.shared.local_country = local_country
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
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
        let time5 = Date().timeIntervalSince1970
        print("time5: " , (time5 - time4));
        requestData()
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false {
            print("yes")
        }else{

        }
        let time6 = Date().timeIntervalSince1970
        print("time6: ", (time6 - time5));
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
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
        
        // test for p2p library
        
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        print("init network res: \(res)")
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
        
        //setRouteInfo()
        
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
        
//        if VpnManager.shared.vpnStatus == .connecting {
//            self.btnConnect.backgroundColor = APP_COLOR
//            self.vwCircleBack.backgroundColor = UIColor(rgb: 0x6FFCEB)
//            imgConnect.image = UIImage(named: "connected")
//            lbConnect.text = "Connected"
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }
        
//        self.btnChoseCountry.setTitle("United States", for: UIControl.State.normal)
//        self.imgCountryIcon.image = UIImage(named:self.iCon[0])
//        self.lbNodes.text = self.countryNodes[0]
        self.choosed_country = self.getCountryShort(countryCode: self.countryCode[0])
        VpnManager.shared.choosed_country = self.choosed_country
        
        requestData()
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false {
            print("yes")
//            tvInstruction.backgroundColor = UIColor.white
//            instructionView.isHidden = false
        }else{
            
        }
        
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
    }

    @IBAction func downToExit(_ sender: Any) {
        print("click to exit")
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
      
//        self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
//                if self.btnAccount.isUserInteractionEnabled == false{
//                    self.getTenonView = TenonGetView.init(frame:CGRect(x: 0, y: SCREEN_HEIGHT - 150, width: SCREEN_WIDTH, height: 150))
//
//
//                    self.getTenonView.clickBlck = {(idx) in
//                        if idx == -1{
//                            self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
//                            UIView.animate(withDuration: 0.4, animations: {
//                                self.getTenonView.top = SCREEN_HEIGHT
//                            }, completion: { (Bool) in
//                                self.getTenonView.removeFromSuperview()
//                            })
//                        }
//                    }
//                    self.getTenonView.top = self.getTenonView.height
//                    self.view.addSubview(self.getTenonView)
//                    UIView.animate(withDuration: 0.4, animations: {
//                        self.getTenonView.top = 0
//                    }, completion: { (Bool) in
//        //                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
//                    })
//                }
    }
    
    @objc func requestData(){
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
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
        
//        if check_vip_times < 1 {
//            let tm = TenonP2pLib.sharedInstance.CheckVip()
//            if TenonP2pLib.sharedInstance.payfor_timestamp == 0 || tm != Int64.max {
//                if tm != Int64.max && tm != 0 {
//                    check_vip_times = 11
//                }
//
//                TenonP2pLib.sharedInstance.payfor_timestamp = tm
//            }
//            check_vip_times += 1
//        } else {
//            TenonP2pLib.sharedInstance.PayforVpn()
//        }
//
//        self.Dolor = Double(balance)*0.002
//        let trascationValue:String = TenonP2pLib.sharedInstance.GetTransactions()
//        let dataArray = trascationValue.components(separatedBy: ";")
//        for value in dataArray{
//            if value == ""{
//                continue
//            }
//            let model = TranscationModel()
//            let dataDetailArray = value.components(separatedBy: ",")
//            model.dateTime = dataDetailArray[0]
//            model.type = dataDetailArray[1]
//            model.acount = dataDetailArray[2]
//            model.amount = dataDetailArray[3]
//            transcationList.append(model)
//        }
//
        setRouteInfo()
        self.perform(#selector(requestData), afterDelay: 5)
    }
    
    @objc func ConnectVpn() {
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
        print("now connect vpn called")
        if self.choosed_country != nil{
            var route_node = super.getOneRouteNode(country: self.local_country)
            if (route_node.ip.isEmpty) {
                route_node = super.getOneRouteNode(country: self.choosed_country)
                if (route_node.ip.isEmpty) {
                    for country in self.defaultCountry {
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
                    if (!vpn_node.ip.isEmpty) {
                        break
                    }
                }
            }
    
            
            if !route_node.ip.isEmpty && !vpn_node.ip.isEmpty{
//                self.vwBackHub.proEndgress = 0.0
//                self.vwBackHub.proStartgress = 0.0
//                self.playAnimotion()
                
//                if (self.smartRoute.isOn) {
                    VpnManager.shared.ip_address = route_node.ip
                    VpnManager.shared.port = Int(route_node.port)!
//                } else {
//                    VpnManager.shared.ip_address = vpn_node.ip
//                    VpnManager.shared.port = Int(vpn_node.port)!
//                }
                
                let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
                VpnManager.shared.public_key = LibP2P.getPublicKey() as String
                
                print("rotue: \(route_node.ip):\(route_node.port)")
                print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
                VpnManager.shared.enc_method = (
                    "aes-128-cfb," + String(vpn_ip_int) + "," +
                        vpn_node.port + "," + String(true))
                VpnManager.shared.password = vpn_node.passwd
                VpnManager.shared.algorithm = "aes-128-cfb"
                self.now_connect_status = 1
                VpnManager.shared.connect()
                old_vpn_ip = vpn_node.ip
            }else{
                CBToast.showToastAction(message: "first use, wairting for search nodes...")
            }
        }else{
            CBToast.showToastAction(message: "please chose a country")
        }
    }
    
    @objc func DoClickDisconnect() {
        self.user_started_vpn = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus != .off {
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @objc func DoClickConnect() {
//        if UserDefaults.standard.bool(forKey: "FirstConnect") == false {
//            tvInstruction.backgroundColor = UIColor.white
//            instructionView.isHidden = false
//            return
//        }
        self.user_started_vpn = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus == .off {
                    self.ConnectVpn()
                } else {
//                    self.vwBackHub.proEndgress = 0.0
//                    self.vwBackHub.proStartgress = 0.0
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @IBAction func clickConnect(_ sender: Any) {

        if UserDefaults.standard.bool(forKey: "FirstConnect") == false {
//            tvInstruction.backgroundColor = UIColor.white
//            instructionView.isHidden = false
            return
        }
        self.user_started_vpn = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus == .off {
                    self.ConnectVpn()
                } else {
//                    self.vwBackHub.proEndgress = 0.0
//                    self.vwBackHub.proStartgress = 0.0
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
    
    @objc func onVPNStatusChanged(){
        
        if VpnManager.shared.vpnStatus == .on{
//            self.btnConnect.backgroundColor = APP_COLOR
//            self.vwCircleBack.backgroundColor = UIColor(rgb: 0x6FFCEB)
//            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xA1FDEE))
//            imgConnect.image = UIImage(named: "connected")
//            lbConnect.text = "Connected"
            self.user_started_vpn = true
            self.now_connect_status = 0
            print("reloadVPNStatus = onVPNStatusChanged = on")
//            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//            addBannerViewToView(bannerView)
//            bannerView.adUnitID = "ca-app-pub-1878869478486684/7948441541"
//            bannerView.rootViewController = self
//            bannerView.load(GADRequest())
//            let newThread = Thread.init(target: self, selector: #selector(threadOne), object: nil)
//            newThread.start()
        }else{
            self.user_started_vpn = false
            print("reloadVPNStatus = onVPNStatusChanged = off")
//            NotificationCenter.default.post(name: Notification.Name("NOTIFICATION_VPN_OFFLINE"), object: nil)
            
//            if (self.user_started_vpn) {
//                if (self.now_connect_status == 1) {
//                    return
//                }
//
//                let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
//                if let messages = userDefaults?.string(forKey: "vpnsvr_status") {
//                    if messages == "ok" {
//                        ConnectVpn()
//                        print("reconnect now. \(messages)")
//                        return
//                    }
//                }
//            }
//            self.btnConnect.backgroundColor = UIColor(rgb: 0xDAD8D9)
//            self.vwCircleBack.backgroundColor = UIColor(rgb: 0xF7f8f8)
//            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xE4E2E3))
//            imgConnect.image = UIImage(named: "connect")
//            lbConnect.text = "Connect"
        }
    }
    
}
