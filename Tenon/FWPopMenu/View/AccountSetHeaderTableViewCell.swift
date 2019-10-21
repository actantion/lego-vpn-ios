//
//  AccountSetHeaderTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/11.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
typealias clickBtn = () -> (Void)
class AccountSetHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lbPrivateKeyValue: UILabel!
//    @IBOutlet weak var tfPrivateKeyValue: UITextField!
    @IBOutlet weak var btnNotice: UIButton!
    @IBOutlet weak var lbAccountAddress: UILabel!
    @IBOutlet weak var lbBalanceLego: UILabel!
    @IBOutlet weak var lbBalanceCost: UILabel!
    @IBOutlet weak var vwBottom: UIView!
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
    }
    @IBAction func clickNotice(_ sender: Any) {
        clickNoticeBtn()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
