//
//  BaseViewContrller.swift
//  TenonVPN
//
//  Created by friend on 2019/9/9.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
import YYKit
import PassKit
import libp2p

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let APP_COLOR = UIColor(red: 9.0/255.0, green: 222.0/255.0, blue: 202.0/255.0, alpha: 1)
let NAVIGATION_HEIGHT = 44.0;
let WX_ID = "wxd930ea5d5a258f4f"
let WX_BUSINESS_ID = "123"
//let IS_IN_CN = false
//let URL_SERVER = "http://192.168.1.90:8080/"
//let INTERFACE_API = "appleIAPAuth"
class BaseViewController: UIViewController,PKPaymentAuthorizationViewControllerDelegate {
    var btnBack:EXButton!
    var vwNavigation:UIView!
    var shippingMethods:[PKShippingMethod]!
    var summaryItems:[PKPaymentSummaryItem]!
    
    func hiddenBackBtn(bHidden:Bool){
        self.btnBack.isHidden = bHidden;
        
    }
    public func AUTOSIZE_HEIGHT(value:CGFloat) -> CGFloat{
        return value*SCREEN_WIDTH/375.0
    }
    func IS_IPHONE_X() -> Bool {
        return self.isIphoneX()
    }
    func STATUS_BAR_HEIGHT() -> Double {
        if self.IS_IPHONE_X() == true {
            return 44.0
        }else{
            return 20.0
        }
    }
    @objc func clickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func addNavigationView(){
        self.vwNavigation = UIView.init(frame: CGRect.init(x: 0, y: 0, width:SCREEN_WIDTH , height:CGFloat(NAVIGATION_HEIGHT + self.STATUS_BAR_HEIGHT())))
        self.vwNavigation.backgroundColor = APP_COLOR;
        
        let lbTitle:UILabel = UILabel.init(frame: CGRect.init())
        lbTitle.text = self.title
        lbTitle.sizeToFit()
        lbTitle.bottom = self.vwNavigation.bottom - 11.0
        lbTitle.centerX = SCREEN_WIDTH/2.0
        lbTitle.textColor = UIColor.white
        
        self.btnBack = EXButton.init(frame: CGRect.init(x: 16, y: 0, width: 10, height: 18))
        self.btnBack.setImage(UIImage(named: "nav_btn_w_back"), for: UIControl.State.normal)
        self.btnBack.addTarget(nil, action: #selector(clickBack), for: UIControl.Event.touchUpInside)
        self.btnBack.centerY = lbTitle.centerY
        self.vwNavigation.addSubview(self.btnBack)
        self.vwNavigation.addSubview(lbTitle)
        self.view.addSubview(self.vwNavigation)
    }
    
    public func isIphoneX()->Bool{
        if #available(iOS 11.0, *){
            let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!;
            if (window.safeAreaInsets.bottom > 0.0){
                return true
            }else{
                return false
            }
        }
        else{
            return false
        }
    }

    func applePayInit(_ amount:Int) {
        if !PKPaymentAuthorizationViewController.canMakePayments(){
            print("not support ApplePay，please upgrade to ios 9.0 and iPhone6 or newer")
        }
        let supportedNetworks:NSArray = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard,PKPaymentNetwork.visa,PKPaymentNetwork.chinaUnionPay];
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks as! [PKPaymentNetwork]) {
            print("no card");
            return;
        }

        let payRequest:PKPaymentRequest = PKPaymentRequest()
        payRequest.countryCode = "CN"
        payRequest.currencyCode = "CNY"
        payRequest.merchantIdentifier = "merchant.TenonVpn.TenonCoin"
        payRequest.supportedNetworks = supportedNetworks as! [PKPaymentNetwork]
        payRequest.merchantCapabilities = PKMerchantCapability(rawValue: PKMerchantCapability.capability3DS.rawValue | PKMerchantCapability.capabilityEMV.rawValue)
        
        //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;

        //        payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;

        //        let freeShipping:PKShippingMethod = PKShippingMethod(label: "", amount: NSDecimalNumber.zero)
        //        freeShipping.identifier = "freeshipping"
        //        freeShipping.detail = "1 day"

        //        let expressShipping:PKShippingMethod = PKShippingMethod(label: "", amount: NSDecimalNumber.init(decimal:10.00) )
        //        expressShipping.identifier = "expressshipping"
        //        expressShipping.detail = "2-3 hours"

        //        shippingMethods = [freeShipping]
        //        payRequest.shippingMethods = shippingMethods

        let subtotalAmount:NSDecimalNumber = NSDecimalNumber.init(decimal: Decimal(amount))
        let subtotal:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "item:" + String(amount*500) + " Tenon", amount: subtotalAmount)

        //        let discountAmount:NSDecimalNumber = NSDecimalNumber.init(decimal: 1000)
        //        let discount:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "receive Tenon", amount: discountAmount)
        //
        //        let methodsAmount:NSDecimalNumber = NSDecimalNumber.zero
        //        let methods:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "", amount: methodsAmount)

        var totalAmount:NSDecimalNumber = NSDecimalNumber.zero
        totalAmount = totalAmount.adding(subtotalAmount)
        //        totalAmount = totalAmount.adding(discountAmount)
        //        totalAmount = totalAmount.adding(methodsAmount)

        let total:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "xielei", amount: totalAmount)

        summaryItems = [subtotal,total] // , discount, methods, total
        payRequest.paymentSummaryItems = summaryItems

        let view:PKPaymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: payRequest)!
        view.delegate = self
        self.present(view, animated: true, completion: nil)
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        //        PKPaymentToken *payToken = payment.token;
        //
        //        PKContact *billingContact = payment.billingContact;
        //        PKContact *shippingContact = payment.shippingContact;
        //        PKContact *shippingMethod = payment.shippingMethod;
        //        print("payment.token = %@",payment.token)
        print("paymentAuthorizationViewController")
        completion(PKPaymentAuthorizationStatus.success);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func getCountryShort(countryCode:String) -> String {
        switch countryCode {
        case "United States":
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
        case "United Kingdom":
            return "GB"
//        case "China":
//            return "CN"
        default:
            return ""
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
        
        return (node_info_arr[0], node_info_arr[2])
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
    
}
