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

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let APP_COLOR = UIColor(red: 9.0/255.0, green: 222.0/255.0, blue: 202.0/255.0, alpha: 1)
let NAVIGATION_HEIGHT = 44.0;
let IS_IN_CN = false
let URL_SERVER = "http://192.168.1.90:8080/"
let INTERFACE_API = "appleIAPAuth"
class BaseViewController: UIViewController,PKPaymentAuthorizationViewControllerDelegate {
    var btnBack:EXButton!
    var vwNavigation:UIView!
    var shippingMethods:[PKShippingMethod]!
    var summaryItems:[PKPaymentSummaryItem]!
    
    func hiddenBackBtn(bHidden:Bool){
        self.btnBack.isHidden = bHidden;
        
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
    
    func applePayInit() {
        if !PKPaymentAuthorizationViewController.canMakePayments(){
            print("设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")
        }
        let supportedNetworks:NSArray = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard,PKPaymentNetwork.visa,PKPaymentNetwork.chinaUnionPay];
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks as! [PKPaymentNetwork]) {
            print("没有绑定支付卡");
            return;
        }
        print("可以支付，开始建立支付请求");
        let payRequest:PKPaymentRequest = PKPaymentRequest()
        payRequest.countryCode = "US"
        payRequest.currencyCode = "USD"
        payRequest.merchantIdentifier = "merchant.TenonVpn.TenonCoin"
        payRequest.supportedNetworks = supportedNetworks as! [PKPaymentNetwork]
        payRequest.merchantCapabilities = PKMerchantCapability(rawValue: PKMerchantCapability.capability3DS.rawValue | PKMerchantCapability.capabilityEMV.rawValue)
        //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
        //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
        //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
        //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
        //        payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
        //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
        //        let freeShipping:PKShippingMethod = PKShippingMethod(label: "包邮", amount: NSDecimalNumber.zero)
        //        freeShipping.identifier = "freeshipping"
        //        freeShipping.detail = "1 天 送达"
        
        //        let expressShipping:PKShippingMethod = PKShippingMethod(label: "极速送达", amount: NSDecimalNumber.init(decimal:10.00) )
        //        expressShipping.identifier = "expressshipping"
        //        expressShipping.detail = "2-3 小时 送达"
        
        //        shippingMethods = [freeShipping]
        //        payRequest.shippingMethods = shippingMethods
        
        let subtotalAmount:NSDecimalNumber = NSDecimalNumber.init(decimal: 0.01)
        let subtotal:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "商品:1000 Tenon", amount: subtotalAmount)
        
        //        let discountAmount:NSDecimalNumber = NSDecimalNumber.init(decimal: 1000)
        //        let discount:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "收到Tenon", amount: discountAmount)
        //
        //        let methodsAmount:NSDecimalNumber = NSDecimalNumber.zero
        //        let methods:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "包邮", amount: methodsAmount)
        
        var totalAmount:NSDecimalNumber = NSDecimalNumber.zero
        totalAmount = totalAmount.adding(subtotalAmount)
        //        totalAmount = totalAmount.adding(discountAmount)
        //        totalAmount = totalAmount.adding(methodsAmount)
        
        let total:PKPaymentSummaryItem = PKPaymentSummaryItem(label: "FriendWu", amount: totalAmount)
        
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
        //        //支付凭据，发给服务端进行验证支付是否真实有效
        //        PKContact *billingContact = payment.billingContact;     //账单信息
        //        PKContact *shippingContact = payment.shippingContact;   //送货信息
        //        PKContact *shippingMethod = payment.shippingMethod;     //送货方式
        //        print("payment.token = %@",payment.token)
        print("paymentAuthorizationViewController")
        completion(PKPaymentAuthorizationStatus.success);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
