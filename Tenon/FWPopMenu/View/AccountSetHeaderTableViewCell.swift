//
//  AccountSetHeaderTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/11.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class AccountSetHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lbPrivateKeyValue: UILabel!
//    @IBOutlet weak var tfPrivateKeyValue: UITextField!
    @IBOutlet weak var lbAccountAddress: UILabel!
    @IBOutlet weak var lbBalanceLego: UILabel!
    @IBOutlet weak var lbBalanceCost: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBottom.backgroundColor = APP_COLOR
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
