//
//  ViewController.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//


//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let product:[SKProduct] = response.products
//        if product.count == 0 {
//            print("没有该商品")
//            CBToast.hiddenToastAction()
//            CBToast.showToastAction(message: "没有该商品")
//        }else{
//            var requestProduct:SKProduct!
//            for pro:SKProduct in product{
//                if pro.productIdentifier == productId{
//                    requestProduct = pro
//                }
//            }
//            let payment:SKMutablePayment = SKMutablePayment(product: requestProduct)t
//            payment.applicationUsername = local_account_id+productId
//            SKPaymentQueue.default().add(payment)
//        }
//    }
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for tran:SKPaymentTransaction in transactions{
//            switch tran.transactionState{
//            case .purchased:do {
//                print("交易完成")
//                CBToast.hiddenToastAction()
//                SKPaymentQueue.default().finishTransaction(tran)
//                completeTransaction(transaction: tran)
//            }
//            case .purchasing:do {
//                print("商品添加进列表")
//            }
//            case .failed:do {
//                CBToast.hiddenToastAction()
//                CBToast.showToastAction(message: "购买失败")
//                SKPaymentQueue.default().finishTransaction(tran)
//            }
//            case .restored:do {
//                print("已经购买过商品")
//            }
//            case .deferred:do {
//                print("延迟购买")
//            }
//            @unknown default:
//                print("未知错误")
//            }
//        }
//    }
//    func completeTransaction(transaction:SKPaymentTransaction) {
//        let receiptURL:NSURL = Bundle.main.appStoreReceiptURL! as NSURL
//        let receiptData:NSData! = NSData(contentsOf: receiptURL as URL)
//        let encodeStr:NSString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString
//        let reqDic:[String:String] = ["transactionID":transaction.transactionIdentifier!,"receipt":encodeStr as String]
//        AF.request(URL_SERVER + INTERFACE_API ,parameters:reqDic).responseJSON {
//            (response)   in
//            let result:Bool = response.value as! Bool
//            if result == true{
//                CBToast.showToastAction(message: "服务端验证通过")
//            }else{
//                CBToast.showToastAction(message: "服务端验证未通过")
//            }
//        }


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
//            NSLog(@"验证失败");
//            return;
//        }
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"请求成功后的数据:%@",dic);
//        //这里可以通过判断 state == 0 验证凭据成功，然后进入自己服务器二次验证，,也可以直接进行服务器逻辑的判断。
//        //本地服务器验证成功之后别忘了 [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//
//        NSString *productId = transaction.payment.productIdentifier;
//        NSString *applicationUsername = transaction.payment.applicationUsername;
//    }

import UIKit
import NetworkExtension
import Eureka
import NEKit
import libp2p
import StoreKit
import Alamofire
import SwiftyJSON
import UserNotifications

class ViewController: BaseViewController {
    @IBOutlet weak var btnChangePK: UIButton!
    @IBOutlet weak var vwCircleBack: CircleProgress!
    @IBOutlet weak var lbAccountAddress: UILabel!
    @IBOutlet weak var lbLego: UILabel!
    @IBOutlet weak var lbDolor: UILabel!
    @IBOutlet weak var imgConnect: UIImageView!
    @IBOutlet weak var lbConnect: UILabel!
    @IBOutlet weak var vwBackHub: CircleProgress!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    @IBOutlet weak var imgCountryIcon: UIImageView!
    @IBOutlet weak var lbNodes: UILabel!
    @IBOutlet weak var smartRoute: UISwitch!
    @IBOutlet weak var btnUpgrade: UIButton!
    
    
//    let productId = "a4d599c18b9943de8d5bc020f0b88fc7"
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
    
    var popBottomView:FWBottomPopView!
    var popUpgradeView:FWUpgradeView!
    var popBottomPayWayView:FWPayPopView!
    var popPKPopView:FWOperPKView!
    
    var local_country: String = ""
    var local_private_key: String = ""
    var local_account_id: String = ""
    var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England","China"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb","cn"]
    let encodeMethodList:[String] = ["aes-128-cfb","aes-192-cfb","aes-256-cfb","chacha20","salsa20","rc4-md5"]
    var transcationList = [TranscationModel]()
    var payModelList = [payModel]()
    
    let kCurrentVersion = "1.0.3"
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        SKPaymentQueue.default().add(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        SKPaymentQueue.default().remove(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        btnUpgrade.layer.masksToBounds = true
        btnUpgrade.layer.cornerRadius = 4
        let url = URL(string:"https://www.baidu.com");
        URLSession(configuration: .default).dataTask(with: url!, completionHandler: {
            (data, rsp, error) in
            //do some thing
            print("visit network ok");
        }).resume()
        
        // test for p2p library
        
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork("0.0.0.0", 7981)
        
        local_country = res.local_country as String
        local_private_key = res.prikey as String
        local_account_id = res.account_id as String
        print("account id:" + local_account_id)
        self.lbAccountAddress.text = local_account_id

        print("local country:" + res.local_country)
        print("private key:" + res.prikey)
        print("account id:" + res.account_id)
        
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
        
        self.btnChoseCountry.setTitle("America", for: UIControl.State.normal)
        self.imgCountryIcon.image = UIImage(named:self.iCon[0])
        self.lbNodes.text = self.countryNodes[0]
        self.choosed_country = self.getCountryShort(countryCode: self.countryCode[0])

        requestData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func clickSmartRoute(_ sender: Any) {
        if VpnManager.shared.vpnStatus == .on {
            clickConnect(sender)
        }
    }
    @IBAction func clickPKPop(_ sender: Any) {
        self.btnChangePK.isUserInteractionEnabled = false
        self.popPKPopView = FWOperPKView.init(frame:CGRect(x: Int(AUTOSIZE_HEIGHT(value: 60.0)),
                                                           y: Int(SCREEN_HEIGHT/2.0 - AUTOSIZE_HEIGHT(value: 300)/2),
                                                           width: Int(SCREEN_WIDTH - AUTOSIZE_HEIGHT(value: 60.0)*2),
                                                           height: Int(AUTOSIZE_HEIGHT(value: 300))))
        self.popPKPopView.transform = __CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0)
        self.popPKPopView.privateKey = self.local_private_key
        self.popPKPopView.clickBlck = {(value) in
            UIView.animate(withDuration: 0.2, animations: {
                self.popPKPopView.transform = __CGAffineTransformMake(1.2, 0, 0, 1.2, 0, 0)
            }) { (Bool) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.popPKPopView.transform = __CGAffineTransformMake(0.5, 0, 0, 0.5, 0, 0)
                    self.popPKPopView.alpha = 0
                }) { (Bool) in
                    self.popPKPopView.removeFromSuperview()
                    self.btnChangePK.isUserInteractionEnabled = true
                }
            }
        }
        self.view.addSubview(self.popPKPopView)
        UIView.animate(withDuration: 0.2, animations: {
            self.popPKPopView.transform = __CGAffineTransformMake(1.2, 0, 0, 1.2, 0, 0)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.popPKPopView.transform = CGAffineTransform.identity
            }) { (Bool) in
                
            }
        }
        
    }

    @objc func requestData(){
        transcationList.removeAll()
        self.balance = TenonP2pLib.sharedInstance.GetBalance()
        if balance == UInt64.max {
            self.balance = 0
        }
        self.Dolor = Double(balance)*0.002
        
        self.lbLego.text = String(balance) + " Tenon"
        self.lbDolor.text = String(format:"%.2f $",Dolor)
        
        let trascationValue:String = TenonP2pLib.sharedInstance.GetTransactions()
        let dataArray = trascationValue.components(separatedBy: ";")
        for value in dataArray{
            if value == ""{
                continue
            }
            let model = TranscationModel()
            let dataDetailArray = value.components(separatedBy: ",")
            model.dateTime = dataDetailArray[0]
            model.type = dataDetailArray[1]
            model.acount = dataDetailArray[2]
            model.amount = dataDetailArray[3]
            transcationList.append(model)
        }
        self.perform(#selector(requestData), afterDelay: 3)
    }
    
    
    @IBAction func clickConnect(_ sender: Any) {

        UNUserNotificationCenter.current().getNotificationSettings { set in
//            if set.authorizationStatus == UNAuthorizationStatus.authorized{
//                print("推送允许")
                DispatchQueue.main.sync {
                    if VpnManager.shared.vpnStatus == .off {
                        if self.choosed_country != nil{
                            var route_node = super.getOneRouteNode(country: self.choosed_country)
                            if (route_node.ip.isEmpty) {
                                route_node = super.getOneRouteNode(country: self.local_country)
                                if (route_node.ip.isEmpty) {
                                    for country in self.iCon {
                                        route_node = super.getOneRouteNode(country: country)
                                        if (!route_node.ip.isEmpty) {
                                            break
                                        }
                                    }
                                }
                                VpnManager.shared.disconnect()}
                            
                            var vpn_node = super.getOneVpnNode(country: self.choosed_country)
                            if (vpn_node.ip.isEmpty) {
                                for country in self.iCon {
                                    vpn_node = super.getOneVpnNode(country: country)
                                    if (!vpn_node.ip.isEmpty) {
                                        break
                                    }
                                }
                            }
                            
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
                                
                                print("rotue: \(route_node.ip):\(route_node.port)")
                                print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
                                let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
                                VpnManager.shared.public_key = LibP2P.getPublicKey() as String
                                
                                VpnManager.shared.enc_method = (
                                    "aes-128-cfb," + String(vpn_ip_int) + "," +
                                        vpn_node.port + "," + String(self.smartRoute.isOn))
                                VpnManager.shared.password = vpn_node.passwd
                                VpnManager.shared.algorithm = "aes-128-cfb"
                                VpnManager.shared.connect()
                            }else{
                                CBToast.showToastAction(message: "first use, wairting for search nodes...")
                            }
                        }else{
                            CBToast.showToastAction(message: "please chose a country")
                        }
                        
                    } else {
                        self.vwBackHub.proEndgress = 0.0
                        self.vwBackHub.proStartgress = 0.0
                        self.playAnimotion()
                        VpnManager.shared.disconnect()
                    }
                }
//            }
//            else{
//                CBToast.showToastAction(message: "Please Open Notification in Setting-TenonVPN")
//            }
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
        if btnUpgrade.isUserInteractionEnabled == true {
            let version_str = TenonP2pLib.sharedInstance.CheckVersion()
            let plats = version_str.split(separator: ",")
            var down_url: String = "";
            for item in plats {
                let item_split = item.split(separator: ";")
                if (item_split[0] == "ios") {
                    if (item_split[1] != kCurrentVersion) {
                        down_url = String(item_split[2])
                    }
                    break
                }
            }
            
            popUpgradeView = FWUpgradeView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 150, width: SCREEN_WIDTH, height: 150))
            popUpgradeView.Show(download_url: down_url)
            self.popUpgradeView.clickBlck = {(idx) in
                if idx == -1{
                    UIView.animate(withDuration: 0.4, animations: {
                        self.popUpgradeView.top = SCREEN_HEIGHT
                    }, completion: { (Bool) in
                        self.popUpgradeView.removeFromSuperview()
                    })
                }
//                self.btnUpgrade.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
            }
            self.popUpgradeView.top = self.popUpgradeView.height
            self.view.addSubview(popUpgradeView)
            UIView.animate(withDuration: 0.4, animations: {
                self.popUpgradeView.top = 0
            }, completion: { (Bool) in
//                self.btnUpgrade.isUserInteractionEnabled = !self.btnUpgrade.isUserInteractionEnabled
            })
        }else{
            
        }
    }
    
    @IBAction func clickAccountSetting(_ sender: Any) {
        if self.btnAccount.isUserInteractionEnabled == true{
            self.popBottomView = FWBottomPopView.init(frame:CGRect(x: 0, y: SCREEN_HEIGHT - (SCREEN_HEIGHT/3*2), width: SCREEN_WIDTH, height: SCREEN_HEIGHT/3*2))
            self.popBottomView.loadCell("AccountSetTableViewCell","AccountSetHeaderTableViewCell", self.transcationList.count)
            self.popBottomView.callBackBlk = {(cell,indexPath) in
                if indexPath.section == 0 {
                    let tempCell:AccountSetHeaderTableViewCell = cell as! AccountSetHeaderTableViewCell
                    tempCell.lbPrivateKeyValue.text = self.local_private_key
                    tempCell.lbAccountAddress.text = self.local_account_id
                    
                    tempCell.lbBalanceLego.text = String(self.balance) + " Tenon"
                    tempCell.lbBalanceCost.text = String(format:"%.2f $",self.Dolor)
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
                    tempCell.lbAmount.text = model.amount
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
                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
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
        }else{
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
}
