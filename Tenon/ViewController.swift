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

class ViewController: BaseViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver{

    
    @IBOutlet weak var vwSettingDesc: UIView!
    @IBOutlet weak var tvSetting: UITextView!
    //    @IBOutlet weak var btnChangePK: UIButton!
    @IBOutlet weak var tvInstruction: UITextView!
    @IBOutlet weak var vwCircleBack: CircleProgress!
    @IBOutlet weak var lbAccountAddress: UILabel!
//    @IBOutlet weak var lbLego: UILabel!
//    @IBOutlet weak var lbDolor: UILabel!
    @IBOutlet weak var imgConnect: UIImageView!
    @IBOutlet weak var lbConnect: UILabel!
    @IBOutlet weak var vwBackHub: CircleProgress!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lbNodes: UILabel!
    @IBOutlet weak var smartRoute: UISwitch!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet var exitBtn: UIButton!
    @IBOutlet weak var btnBuyTenon: UIButton!
    //    @IBOutlet weak var btnUpgrade: UIButton!
    
    
    let productId = "a4d599c18b9943de8d5bc020f0b88fc7"
    var payWay:Int = 0
    var payAmount:Int!
    var isHub:Bool = false
    var popMenu:FWPopMenu!
    var isClick:Bool = false
    var timer:Timer!
    var isNetChange:Bool = false
    var choosed_country:String!
    var balance:UInt64!
    var Dolor:Double!
    
    var getTenonView:TenonGetView!
    var popUpgradeView:FWUpgradeView!
    var popPKPopView:FWOperPKView!
    var popBottomView:FWBottomPopView!
    
    var local_country: String = ""
    var local_private_key: String = ""
    var local_account_id: String = ""
    var countryCode:[String] = ["United States", "Singapore", "Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "United Kingdom"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg","de","fr","kr", "jp", "ca","au","hk", "in", "gb"]
    var defaultCountry:[String] = ["US", "IN","CA","DE","AU"]
    let encodeMethodList:[String] = ["aes-128-cfb","aes-192-cfb","aes-256-cfb","chacha20","salsa20","rc4-md5"]
    var transcationList = [TranscationModel]()
    var payModelList = [payModel]()
    var clickToExit = false
    
    private var old_vpn_ip: String = ""
    private var check_vip_times: Int = 0
    
    let kCurrentVersion = "1.0.5"
    
    private var now_connect_status = 0
    
    private var user_started_vpn: Bool = false
    private var sleepBacked = false;
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SKPaymentQueue.default().add(self)
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        self.vwCircleBack.layer.cornerRadius = self.vwCircleBack.width/2
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SKPaymentQueue.default().remove(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


            self.vwBackHub.proEndgress = 0.0
            self.vwBackHub.proStartgress = 0.0
            VpnManager.shared.disconnect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
        self.title = "TenonVPN"
        self.navigationController?.navigationBar.isHidden = true
        self.btnConnect.layer.masksToBounds = true
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        self.btnConnect.backgroundColor = UIColor(rgb: 0xDAD8D9)
        
        self.btnAccount.layer.masksToBounds = true
        self.btnAccount.layer.cornerRadius = 4
        self.btnChoseCountry.layer.masksToBounds = true
        self.btnChoseCountry.layer.cornerRadius = 4
        self.vwBackHub.proEndgress = 0.0
        self.vwBackHub.proStartgress = 0.0
        
        self.vwCircleBack.layer.masksToBounds = true
        self.vwCircleBack.layer.cornerRadius = self.vwCircleBack.width/2
        
//        btnUpgrade.layer.masksToBounds = true
//        btnUpgrade.layer.cornerRadius = 4
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
        
        setRouteInfo()
        
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
        
        if VpnManager.shared.vpnStatus == .connecting {
            self.btnConnect.backgroundColor = APP_COLOR
            self.vwCircleBack.backgroundColor = UIColor(rgb: 0x6FFCEB)
            imgConnect.image = UIImage(named: "connected")
            lbConnect.text = "Connected"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }
        
        self.btnChoseCountry.setTitle("United States", for: UIControl.State.normal)
        self.imgCountryIcon.image = UIImage(named:self.iCon[0])
        self.lbNodes.text = self.countryNodes[0]
        self.choosed_country = self.getCountryShort(countryCode: self.countryCode[0])
        VpnManager.shared.choosed_country = self.choosed_country
        
        requestData()
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false {
            print("yes")
            tvInstruction.backgroundColor = UIColor.white
            instructionView.isHidden = false
        }else{
            
        }
        
        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
        userDefaults?.set("ok", forKey: "vpnsvr_status")
    }
    
    @IBAction func downToExit(_ sender: Any) {
        print("click to exit")
        clickToExit = true
        if VpnManager.shared.vpnStatus == .on {
            clickConnect(sender)
        } else {
            _exit(1)
        }
    }

    
    @objc func applicationWillResignActive(){
        print("home and background.")
        sleepBacked = true
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 25) {
//            if (self.sleepBacked) {
//                print("exit now")
//                _exit(0)
//            }
//        }
    }
    @objc func applicationDidBecomeActive(){
        print("active now.")
        sleepBacked = false
    }
    
    @objc func DidEnterBackground(){
    }
    
    @objc func applicationWillTerminate(){
        _exit(0)
    }
    
    @IBAction func clickSettingConfirm(_ sender: Any) {
        vwSettingDesc.isHidden = true
    }
    @IBAction func clickAgree(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "FirstEnter") == false{
            UserDefaults.standard.set(true, forKey: "FirstEnter")
        }else{
            UserDefaults.standard.set(true, forKey: "FirstConnect")
            clickConnect(btnConnect as Any)
        }
        instructionView.isHidden = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func clickSmartRoute(_ sender: Any) {
//        if VpnManager.shared.vpnStatus == .on {
//            clickConnect(sender)
//        }
//        
//        VpnManager.shared.use_smart_route = smartRoute.isOn
    }
    
    @IBAction func clickPKPop(_ sender: Any) {
//        self.btnChangePK.isUserInteractionEnabled = false
//        self.popPKPopView = FWOperPKView.init(frame:CGRect(x: Int(AUTOSIZE_HEIGHT(value: 60.0)),
//                                                           y: Int(SCREEN_HEIGHT/2.0 - AUTOSIZE_HEIGHT(value: 300)/2),
//                                                           width: Int(SCREEN_WIDTH - AUTOSIZE_HEIGHT(value: 60.0)*2),
//                                                           height: Int(AUTOSIZE_HEIGHT(value: 300))))
//        self.popPKPopView.transform = __CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0)
//        self.popPKPopView.privateKey = self.local_private_key
//        self.popPKPopView.clickBlck = {(value) in
//            UIView.animate(withDuration: 0.2, animations: {
//                self.popPKPopView.transform = __CGAffineTransformMake(1.2, 0, 0, 1.2, 0, 0)
//            }) { (Bool) in
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.popPKPopView.transform = __CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0)
//                    self.popPKPopView.alpha = 0
//                }) { (Bool) in
//                    self.popPKPopView.removeFromSuperview()
//                    self.btnChangePK.isUserInteractionEnabled = true
//                }
//            }
//        }
//        self.view.addSubview(self.popPKPopView)
//        UIView.animate(withDuration: 0.2, animations: {
//            self.popPKPopView.transform = __CGAffineTransformMake(1.2, 0, 0, 1.2, 0, 0)
//        }) { (Bool) in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.popPKPopView.transform = CGAffineTransform.identity
//            }) { (Bool) in
//
//            }
//        }
        
    }

    func setRouteInfo() {
        let iCon:[String] = ["US", "SG", "BR","DE","FR","KR", "JP", "CA","AU","HK", "IN", "GB","CN"]
                         
         var route_str: String = ""
         for country in iCon {
             let res_str = TenonP2pLib.sharedInstance.GetVpnNodes(country, true) as String
             if (res_str.isEmpty) {
                 continue
             }
             
             if (route_str.isEmpty) {
                 route_str = country + ";" + res_str;
             } else {
                 route_str += "`" + country + ";" + res_str;
             }
             
             
         }
        
         
         var vpn_str: String = ""
         for country in iCon {

             let res_str = TenonP2pLib.sharedInstance.GetVpnNodes(country, false) as String
             if (res_str.isEmpty) {
                 continue
             }
             
             if (vpn_str.isEmpty) {
                 vpn_str = country + ";" + res_str;
             } else {
                 vpn_str += "`" + country + ";" + res_str;
             }
             
             
         }
        
        setExRouteNode()
        VpnManager.shared.SetRouteNodes(nodes_str: route_str)
        VpnManager.shared.SetVpnNodes(nodes_str: vpn_str)
    }
    
    func OpenGet() {
      
        self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                if self.btnAccount.isUserInteractionEnabled == false{
                    self.getTenonView = TenonGetView.init(frame:CGRect(x: 0, y: SCREEN_HEIGHT - 150, width: SCREEN_WIDTH, height: 150))
                    
                    
                    self.getTenonView.clickBlck = {(idx) in
                        if idx == -1{
                            self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                            UIView.animate(withDuration: 0.4, animations: {
                                self.getTenonView.top = SCREEN_HEIGHT
                            }, completion: { (Bool) in
                                self.getTenonView.removeFromSuperview()
                            })
                        }
                    }
                    self.getTenonView.top = self.getTenonView.height
                    self.view.addSubview(self.getTenonView)
                    UIView.animate(withDuration: 0.4, animations: {
                        self.getTenonView.top = 0
                    }, completion: { (Bool) in
        //                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                    })
                }
    }
    
    func setExRouteNode() {
        if (local_country == "CN" && (choosed_country == "SG" || choosed_country == "JP")) {
            var route_node = super.getOneRouteNode(country: "US")
            if (route_node.ip.isEmpty) {
                for country in self.defaultCountry {
                    route_node = super.getOneRouteNode(country: country)
                    if (!route_node.ip.isEmpty) {
                        break
                    }
                }
            }
            
            if (!route_node.ip.isEmpty) {
                let vpn_ip_int = LibP2P.changeStrIp(route_node.ip)
                let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
                userDefaults?.set(String(vpn_ip_int), forKey: "ex_route_ip_int")
                userDefaults?.set(String(route_node.port), forKey: "ex_route_port_int")
            }
        } else {
            let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
            userDefaults?.set(0, forKey: "ex_route_ip_int")
            userDefaults?.set(0, forKey: "ex_route_port_int")
        }
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
            TenonP2pLib.sharedInstance.now_balance = Int64(balance)
        }
        
        if check_vip_times < 1 {
            let tm = TenonP2pLib.sharedInstance.CheckVip()
            if TenonP2pLib.sharedInstance.payfor_timestamp == 0 || tm != Int64.max {
                if tm != Int64.max && tm != 0 {
                    check_vip_times = 11
                }
                
                TenonP2pLib.sharedInstance.payfor_timestamp = tm
            }
            check_vip_times += 1
        } else {
            TenonP2pLib.sharedInstance.PayforVpn()
        }
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
        self.perform(#selector(requestData), afterDelay: 1)
    }
    
    func ConnectVpn() {
        if balance < 2000 {
            let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
            if let messages = userDefaults?.string(forKey: "vpnsvr_status") {
                if messages == "bwo" {
                    VpnManager.shared.disconnect()
                    
                    OpenGet()
                    userDefaults?.set("ok", forKey: "vpnsvr_status")
                    
                    return
                }
                
                if messages == "cni" {
                    CBToast.showToast(message: "Agent service is not supported \nin your country or region.", aLocationStr: "center", aShowTime: 10.0)
                    VpnManager.shared.disconnect()
                    return
                }
                
                if messages == "oul" {
                    CBToast.showToast(message: "Your account is logged in elsewhere.", aLocationStr: "center", aShowTime: 10.0)
                    VpnManager.shared.disconnect()
                    return
                }
            }
        } else {
            let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
            userDefaults?.set("ok", forKey: "vpnsvr_status")
        }
        
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
            
            setExRouteNode()
            print("rotue 1 : \(route_node.ip):\(route_node.port)")
            print("vpn 1: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
            
            if !route_node.ip.isEmpty && !vpn_node.ip.isEmpty{
                self.vwBackHub.proEndgress = 0.0
                self.vwBackHub.proStartgress = 0.0
                self.playAnimotion()
                
                if (self.smartRoute.isOn) {
                    VpnManager.shared.ip_address = route_node.ip
                    VpnManager.shared.port = Int(route_node.port)!
                } else {
                    VpnManager.shared.ip_address = vpn_node.ip
                    VpnManager.shared.port = Int(vpn_node.port)!
                }
                
                let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
                VpnManager.shared.public_key = LibP2P.getPublicKey() as String
                
                print("rotue: \(route_node.ip):\(route_node.port)")
                print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
                VpnManager.shared.enc_method = (
                    "aes-128-cfb," + String(vpn_ip_int) + "," +
                        vpn_node.port + "," + String(self.smartRoute.isOn))
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
    
    @IBAction func clickConnect(_ sender: Any) {

        if UserDefaults.standard.bool(forKey: "FirstConnect") == false {
            tvInstruction.backgroundColor = UIColor.white
            instructionView.isHidden = false
            return
        }
        self.user_started_vpn = false
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                if VpnManager.shared.vpnStatus == .off {
                    self.ConnectVpn()
                } else {
                    self.vwBackHub.proEndgress = 0.0
                    self.vwBackHub.proStartgress = 0.0
                    VpnManager.shared.disconnect()
                }
            }
        }
    }
    
    @IBAction func clickChoseCountry(_ sender: Any) {
        if self.isClick == true {
            self.popMenu.removeFromSuperview()
        }else{
            self.popMenu = FWPopMenu.init(frame:CGRect(x: self.btnChoseCountry.left, y: self.btnChoseCountry.bottom, width: self.btnChoseCountry.width, height: SCREEN_HEIGHT/2))
            self.popMenu.loadCell("CountryTableViewCell", countryCode.count)
            self.popMenu.callBackBlk = {(cell,indexPath) in
                let tempCell:CountryTableViewCell = cell as! CountryTableViewCell
                tempCell.backgroundColor = APP_COLOR
                tempCell.lbNodeCount.text = self.countryNodes[indexPath.row]
                tempCell.lbCountryName.text = self.countryCode[indexPath.row]
                tempCell.imgIcon.image = UIImage(named:self.iCon[indexPath.row])
                return tempCell
            }
            self.popMenu.clickBlck = {(idx) in
                if idx != -1{
                    self.btnChoseCountry.setTitle(self.countryCode[idx], for: UIControl.State.normal)
                    self.imgCountryIcon.image = UIImage(named:self.iCon[idx])
                    self.lbNodes.text = self.countryNodes[idx]
                    self.choosed_country = super.getCountryShort(countryCode: self.countryCode[idx])
                    VpnManager.shared.choosed_country = self.choosed_country
                    if VpnManager.shared.vpnStatus == .on{
                        self.clickConnect(self.btnConnect as Any)
                    }
                }
                
                self.popMenu.removeFromSuperview()
                self.isClick = !self.isClick
            }
            self.view.addSubview(self.popMenu)
        }
        
        self.isClick = !self.isClick
    }
    @IBAction func clickUpgrade(_ sender: Any) {
//        if btnUpgrade.isUserInteractionEnabled == true {
//            let version_str = TenonP2pLib.sharedInstance.CheckVersion()
//            let plats = version_str.split(separator: ",")
//            var down_url: String = "";
//            for item in plats {
//                let item_split = item.split(separator: ";")
//                if (item_split[0] == "ios") {
//                    if (item_split[1] != kCurrentVersion) {
//                        down_url = String(item_split[2])
//                    }
//                    break
//                }
//            }
//
//            popUpgradeView = FWUpgradeView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 150, width: SCREEN_WIDTH, height: 150))
//            popUpgradeView.Show(download_url: down_url)
//            self.popUpgradeView.clickBlck = {(idx) in
//                if idx == -1{
//                    UIView.animate(withDuration: 0.4, animations: {
//                        self.popUpgradeView.top = SCREEN_HEIGHT
//                    }, completion: { (Bool) in
//                        self.popUpgradeView.removeFromSuperview()
//                    })
//                }
////                self.btnUpgrade.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
//            }
//            self.popUpgradeView.top = self.popUpgradeView.height
//            self.view.addSubview(popUpgradeView)
//            UIView.animate(withDuration: 0.4, animations: {
//                self.popUpgradeView.top = 0
//            }, completion: { (Bool) in
////                self.btnUpgrade.isUserInteractionEnabled = !self.btnUpgrade.isUserInteractionEnabled
//            })
//        }else{
//
//        }
    }
    
    @IBAction func clickBuyTenon(_ sender: Any) {
        if SKPaymentQueue.canMakePayments() {
            CBToast.showToastAction()
            self.view.isUserInteractionEnabled = false;
            let product:NSArray = NSArray.init(object: productId)
            let nsset:NSSet = NSSet.init(array: product as! [Any])
            
            let request:SKProductsRequest = SKProductsRequest.init(productIdentifiers: nsset as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            CBToast.showToastAction(message: "your telephone not support IAP")
        }
    }
    @IBAction func clickAccountSetting(_ sender: Any) {
        self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
        if self.btnAccount.isUserInteractionEnabled == false{
            self.popBottomView = FWBottomPopView.init(frame:CGRect(x: 0, y: SCREEN_HEIGHT - 200, width: SCREEN_WIDTH, height: 200))
            self.popBottomView.loadCell("AccountSetTableViewCell","AccountSetHeaderTableViewCell", self.transcationList.count)
            self.popBottomView.callBackBlk = {(cell,indexPath) in
                if indexPath.section == 0 {
                    let tempCell:AccountSetHeaderTableViewCell = cell as! AccountSetHeaderTableViewCell
                    tempCell.tvPrivateKeyValue.text = self.local_private_key
                    tempCell.pkBlock = { (str) in
                        self.local_private_key = str
                        print("set private key :",self.local_private_key)
                    }
                    tempCell.lbAccountAddress.text = self.local_account_id

//                    tempCell.lbBalanceLego.text = String(self.balance) + " Tenon"
//                    tempCell.lbBalanceCost.text = String(format:"%.2f $",self.Dolor)
//                    tempCell.clickNoticeBtn = {
//                        self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
//                        UIView.animate(withDuration: 0.4, animations: {
//                            self.popBottomView.top = SCREEN_HEIGHT
//                        }, completion: { (Bool) in
//                            self.popBottomView.removeFromSuperview()
//                            self.tvSetting.backgroundColor = UIColor.white
//                            self.vwSettingDesc.isHidden = false
//                        })
//                    }
                    return tempCell
                }
                else{
                    let tempCell:AccountSetTableViewCell = cell as! AccountSetTableViewCell
                    tempCell.layer.masksToBounds = true
                    tempCell.layer.cornerRadius = 8
                    let model:TranscationModel = self.transcationList[indexPath.row]
                    tempCell.lbDateTime.text = model.dateTime
                    tempCell.lbType.text = model.type
                    tempCell.lbAccount.text = model.acount
                    //tetempCell.lbAmount.text = model.amount
                    return tempCell
                }
            }

            self.popBottomView.clickBlck = {(idx) in
                if idx == -1{
                    self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                    UIView.animate(withDuration: 0.4, animations: {
                        self.popBottomView.top = SCREEN_HEIGHT
                    }, completion: { (Bool) in
                        self.popBottomView.removeFromSuperview()
                    })
                }
            }
            self.popBottomView.top = self.popBottomView.height
            self.view.addSubview(self.popBottomView)
            UIView.animate(withDuration: 0.4, animations: {
                self.popBottomView.top = 0
            }, completion: { (Bool) in
//                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
            })
        }
    }
    
    @objc func onVPNStatusChanged(){
        isNetChange = true
        if VpnManager.shared.vpnStatus == .on{
            self.btnConnect.backgroundColor = APP_COLOR
            self.vwCircleBack.backgroundColor = UIColor(rgb: 0x6FFCEB)
            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xA1FDEE))
            imgConnect.image = UIImage(named: "connected")
            lbConnect.text = "Connected"
            self.user_started_vpn = true
            self.now_connect_status = 0
        }else{
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
            self.btnConnect.backgroundColor = UIColor(rgb: 0xDAD8D9)
            self.vwCircleBack.backgroundColor = UIColor(rgb: 0xF7f8f8)
            self.vwBackHub.setLayerColor(color: UIColor(rgb: 0xE4E2E3))
            imgConnect.image = UIImage(named: "connect")
            lbConnect.text = "Connect"
        }
    }
    
    func stopAnimotion() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    @objc func playAnimotion() {
        if self.timer == nil {
            self.timer = Timer(timeInterval: 0.05, target: self, selector: #selector(startAnimotion), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
        }
    }
    @objc func startAnimotion() {
        if self.vwBackHub.proStartgress == 0.0 {
            self.vwBackHub.proEndgress += 0.1
            if self.vwBackHub.proEndgress > 1{
                self.vwBackHub.proEndgress = 1
                self.vwBackHub.proStartgress += 0.1
            }
        }else{
            self.vwBackHub.proStartgress += 0.1
            if self.vwBackHub.proStartgress > 1.0{
                if isNetChange == true{
                    stopAnimotion()
                    isNetChange = false
                }else{
                    self.vwBackHub.proEndgress = 0.0
                    self.vwBackHub.proStartgress = 0.0
                }
            }
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product:[SKProduct] = response.products
        if product.count == 0 {
            CBToast.hiddenToastAction()
            CBToast.showToastAction(message: "no item")
        }else{
            var requestProduct:SKProduct!
            for pro:SKProduct in product{
                if pro.productIdentifier == productId{
                    requestProduct = pro
                }
            }
            let payment:SKMutablePayment = SKMutablePayment(product: requestProduct)
            payment.applicationUsername = local_account_id+productId
            SKPaymentQueue.default().add(payment)
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tran:SKPaymentTransaction in transactions{
            switch tran.transactionState{
            case .purchased:do {
                print("deal done")
                CBToast.hiddenToastAction()
                SKPaymentQueue.default().finishTransaction(tran)
                completeTransaction(transaction: tran)
            }
            case .purchasing:do {
                print("added")
            }
            case .failed:do {
                CBToast.hiddenToastAction()
                self.view.isUserInteractionEnabled = true
                SKPaymentQueue.default().finishTransaction(tran)
            }
            case .restored:do {
                print("purchased")
                self.view.isUserInteractionEnabled = true
            }
            case .deferred:do {
                print("delay")
                self.view.isUserInteractionEnabled = true
            }
            @unknown default:
                print("unknown error")
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func  completeTransaction(transaction:SKPaymentTransaction) {
        let receiptURL:NSURL = Bundle.main.appStoreReceiptURL! as NSURL
        let receiptData:NSData! = NSData(contentsOf: receiptURL as URL)
        let encodeStr:NSString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString
        let reqDic:Dictionary<String, String> = ["transactionID":transaction.transactionIdentifier!,"receipt":encodeStr as String]
        AF.request("http://98.126.31.159:80/appleIAPAuth" ,parameters:reqDic).responseJSON {
            (response)   in
            let result:Bool = response.value as! Bool
            CBToast.hiddenToastAction()
            self.view.isUserInteractionEnabled = true
            if result == true{
                CBToast.showToastAction(message: "Please record the privitekey")
            }else{
                CBToast.showToastAction(message: "server verify error")
            }
        }


//        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
//        urlRequest.HTTPMethod = @"POST";
//        NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        _receipt = encodeStr;
//        NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//        NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//        urlRequest.HTTPBody = payloadData;
//
//        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//
//        if (result == nil) {
//            NSLog(@"verify error.");
//            return;
//        }
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"success data:%@",dic);
//
//
//        NSString *productId = transaction.payment.productIdentifier;
//        NSString *applicationUsername = transaction.payment.applicationUsername;
    }
}
