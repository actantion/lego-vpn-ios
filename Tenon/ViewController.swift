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

class ViewController: BaseViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    
    @IBOutlet weak var swSmartRoute: UISwitch!
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
    
    let productId = "a4d599c18b9943de8d5bc020f0b88fc7"
    var isHub:Bool = false
    var popMenu:FWPopMenu!
    var isClick:Bool = false
    var timer:Timer!
    var isNetChange:Bool = false
    var choosed_country:String!
    var balance:UInt64!
    var Dolor:Double!
    
    
    var popBottomView:FWBottomPopView!
    var local_country: String = ""
    var local_private_key: String = ""
    var local_account_id: String = ""
    var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England","China"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb","cn"]
    let encodeMethodList:[String] = ["aes-128-cfb","aes-192-cfb","aes-256-cfb","chacha20","salsa20","rc4-md5"]
    var transcationList = [TranscationModel]()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TenonVPN"
        self.navigationController?.navigationBar.isHidden = true
        self.btnConnect.layer.masksToBounds = true
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        self.btnConnect.backgroundColor = UIColor(rgb: 0xDAD8D9)
        
        self.btnAccount.layer.masksToBounds = true
        self.btnAccount.layer.cornerRadius = 20
        self.btnChoseCountry.layer.masksToBounds = true
        self.btnChoseCountry.layer.cornerRadius = 4
        self.vwBackHub.proEndgress = 0.0
        self.vwBackHub.proStartgress = 0.0
        
        self.vwCircleBack.layer.masksToBounds = true
        self.vwCircleBack.layer.cornerRadius = self.vwCircleBack.width/2
        
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
    @IBAction func clickApplePay(_ sender: Any) {
        if IS_IN_CN == true{
            applePayInit()
        }else{
            if SKPaymentQueue.canMakePayments(){
                CBToast.showToastAction()
                let product:NSArray = [productId]
                let nsset:NSSet = NSSet(array: product as! [Any])
                let request:SKProductsRequest = SKProductsRequest(productIdentifiers: nsset as! Set<String>)
                request.delegate = self
                request.start()
            }else{
                CBToast.showToastAction(message: "您的手机暂时不支持苹果内购哦!")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SKPaymentQueue.default().add(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SKPaymentQueue.default().remove(self)
    }
    @IBAction func clickSwitch(_ sender: Any) {
        if self.swSmartRoute.isOn == true{
            print("开启智能路由")
        }else{
            print("关闭智能路由")
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product:[SKProduct] = response.products
        if product.count == 0 {
            print("没有该商品")
            CBToast.hiddenToastAction()
            CBToast.showToastAction(message: "没有该商品")
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
                print("交易完成")
                CBToast.hiddenToastAction()
                SKPaymentQueue.default().finishTransaction(tran)
                completeTransaction(transaction: tran)
            }
            case .purchasing:do {
                print("商品添加进列表")
            }
            case .failed:do {
                CBToast.hiddenToastAction()
                CBToast.showToastAction(message: "购买失败")
                SKPaymentQueue.default().finishTransaction(tran)
            }
            case .restored:do {
                print("已经购买过商品")
            }
            case .deferred:do {
                print("延迟购买")
            }
            @unknown default:
                print("未知错误")
            }
        }
    }
    func completeTransaction(transaction:SKPaymentTransaction) {
        let receiptURL:NSURL = Bundle.main.appStoreReceiptURL! as NSURL
        let receiptData:NSData! = NSData(contentsOf: receiptURL as URL)
        let encodeStr:NSString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString
        let reqDic:[String:String] = ["transactionID":transaction.transactionIdentifier!,"receipt":encodeStr as String]
        AF.request(URL_SERVER + INTERFACE_API ,parameters:reqDic).responseJSON {
            (response)   in
            let result:Bool = response.value as! Bool
            if result == true{
                CBToast.showToastAction(message: "服务端验证通过")
            }else{
                CBToast.showToastAction(message: "服务端验证未通过")
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
    func getCountryShort(countryCode:String) -> String {
        switch countryCode {
        case "America":
            return "US"
        case "Singapore":
            return "SG"
        case "Brazil":
            return "BR"
        case "Germany":
            return "DE"
        case "France":
            return "FR"
        case "Korea":
            return "KR"
        case "Japan":
            return "JP"
        case "Canada":
            return "CA"
        case "Australia":
            return "AU"
        case "Hong Kong":
            return "HK"
        case "India":
            return "IN"
        case "England":
            return "GB"
        case "China":
            return "CN"
        default:
            return ""
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
    @IBAction func clickConnect(_ sender: Any) {
        if VpnManager.shared.vpnStatus == .off {
            if choosed_country != nil{
                var route_node = getOneRouteNode(country: choosed_country)
                if (route_node.ip.isEmpty) {
                    route_node = getOneRouteNode(country: choosed_country)
                    if (route_node.ip.isEmpty) {
                        for country in self.iCon {
                            route_node = getOneRouteNode(country: country)
                            if (!route_node.ip.isEmpty) {
                                break
                            }
                        }
                    }
                VpnManager.shared.disconnect()}
                
                var vpn_node = getOneVpnNode(country: choosed_country)
                if (vpn_node.ip.isEmpty) {
                    for country in self.iCon {
                        vpn_node = getOneVpnNode(country: country)
                        if (!vpn_node.ip.isEmpty) {
                            break
                        }
                    }
                }
                
                if !route_node.ip.isEmpty && !vpn_node.ip.isEmpty{
                    self.vwBackHub.proEndgress = 0.0
                    self.vwBackHub.proStartgress = 0.0
                    self.playAnimotion()
                    
                    VpnManager.shared.ip_address = vpn_node.ip
                    VpnManager.shared.port = Int(vpn_node.port)!
                    
                    print("rotue: \(route_node.ip):\(route_node.port)")
                    print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
                    let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
//                    let index:Int = Int(arc4random_uniform((UInt32)(encodeMethodList.count)))
                    VpnManager.shared.public_key = LibP2P.getPublicKey() as String
                    
                    VpnManager.shared.enc_method = "aes-128-cfb," + String(vpn_ip_int) + "," + vpn_node.port
                    VpnManager.shared.password = vpn_node.passwd
                    VpnManager.shared.algorithm = "aes-128-cfb"
                    VpnManager.shared.connect()
                }else{
                    CBToast.showToastAction(message: "node error")
                }
            }else{
                CBToast.showToastAction(message: "please chose a country")
            }
            
        } else {
            self.vwBackHub.proEndgress = 0.0
            self.vwBackHub.proStartgress = 0.0
            VpnManager.shared.disconnect()
//            self.playAnimotion()
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
                    self.choosed_country = self.getCountryShort(countryCode: self.countryCode[idx])
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
                self.btnAccount.isUserInteractionEnabled = !self.btnAccount.isUserInteractionEnabled
                UIView.animate(withDuration: 0.4, animations: {
                    self.popBottomView.top = SCREEN_HEIGHT
                }, completion: { (Bool) in
                    self.popBottomView.removeFromSuperview()
                })
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
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    func getOneRouteNode(country: String) -> (ip: String, port: String) {
        let res_str = LibP2P.getVpnNodes(country, true) as String
        if (res_str.isEmpty) {
            return ("", "")
        }
        
        let node_arr: Array = res_str.components(separatedBy: ",")
        if (node_arr.count <= 0) {
            return ("", "")
        }
        
        let rand_pos = randomCustom(min: 0, max: node_arr.count)
        let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
        if (node_info_arr.count < 5) {
            return ("", "")
        }
        
        return (node_info_arr[0], node_info_arr[1])
    }
    
    func getOneVpnNode(country: String) -> (ip: String, port: String, passwd: String) {
        let res_str = LibP2P.getVpnNodes(country, false) as String
        if (res_str.isEmpty) {
            return ("", "", "")
        }
        
        let node_arr: Array = res_str.components(separatedBy: ",")
        if (node_arr.count <= 0) {
            return ("", "", "")
        }
        
        let rand_pos = randomCustom(min: 0, max: node_arr.count)
        let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
        if (node_info_arr.count < 5) {
            return ("", "", "")
        }
        
        return (node_info_arr[0], node_info_arr[1], node_info_arr[3])
    }
    
    func stopAnimotion() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    @objc func playAnimotion() {
        if self.timer == nil {
            self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(startAnimotion), userInfo: nil, repeats: true)
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
