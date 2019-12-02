//
//  AccountSetHeaderTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/11.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        viewController.present(alert, animated: true)
    }
     
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
     
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
     
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc, confirm: confirm)
        }
    }
}

typealias clickBtn = () -> (Void)
typealias PKChangeBlock = (String) -> ()
class AccountSetHeaderTableViewCell: UITableViewCell,UITextViewDelegate {
//    @IBOutlet weak var lbPrivateKeyValue: UILabel!
    @IBOutlet weak var tvPrivateKeyValue: UITextView!
    //    @IBOutlet weak var tfPrivateKeyValue: UITextField!
    @IBOutlet weak var btnNotice: UIButton!
    @IBOutlet weak var lbAccountAddress: UILabel!
    @IBOutlet weak var lbBalanceLego: UILabel!
    @IBOutlet weak var lbBalanceCost: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    var pkBlock:PKChangeBlock!
    var clickNoticeBtn:clickBtn!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBottom.backgroundColor = APP_COLOR
        self.vwBottom.layer.masksToBounds = true
        self.vwBottom.layer.cornerRadius = 4
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        btnNotice.layer.masksToBounds = true
        btnNotice.layer.cornerRadius = 4
        btnNotice.layer.borderColor = APP_COLOR.cgColor
        btnNotice.layer.borderWidth = 1
        
        tvPrivateKeyValue.delegate = self
    }
    @IBAction func clickNotice(_ sender: Any) {
        clickNoticeBtn()
    }
    
    @IBAction func clickCopyAccount(_ sender: Any) {
        UIPasteboard.general.string = TenonP2pLib.sharedInstance.account_id
        CBToast.showToast(message: "copy account address success.", aLocationStr: "center", aShowTime: 3.0)
    }
    @IBAction func clickPastePrikey(_ sender: Any) {
        let ss: String = UIPasteboard.general.string ?? ""
        if ss == TenonP2pLib.sharedInstance.private_key {
            return
        }
        
        if ss.count != 64 {
            CBToast.showToast(message: "invalid private key.", aLocationStr: "center", aShowTime: 3)
            return
        }
        
        if !TenonP2pLib.sharedInstance.SavePrivateKey(prikey_in: ss) {
            CBToast.showToast(message: "Set up to 3 private keys.", aLocationStr: "center", aShowTime: 3)
            return
        }
        
        if !TenonP2pLib.sharedInstance.ResetPrivateKey(prikey: ss) {
            CBToast.showToast(message: "invalid private key.", aLocationStr: "center", aShowTime: 3)
            return
        }
        
        VpnManager.shared.disconnect()
        UIAlertController.showConfirm(message: "after success reset private key, must restart program.") { (_) in
            _exit(0)
        }
        //_exit(0)
    }
    @IBAction func clickCopyPrikey(_ sender: Any) {
        UIPasteboard.general.string = TenonP2pLib.sharedInstance.private_key
        CBToast.showToast(message: "copy private key success.", aLocationStr: "center", aShowTime: 3.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @available(iOS 2.0, *)
//    optional func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
//
//    @available(iOS 2.0, *)
//    optional func textViewDidChange(_ textView: UITextView)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 回车时退出编辑
        if text == "\n"
        {
            textView.resignFirstResponder()
            
            return true
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView){
        self.pkBlock(textView.text)
    }
    func textViewDidEndEditing(_ textView: UITextView){
        self.pkBlock(textView.text)
    }
}
