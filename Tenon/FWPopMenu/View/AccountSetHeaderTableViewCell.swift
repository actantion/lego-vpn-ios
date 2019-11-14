//
//  AccountSetHeaderTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/11.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
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
