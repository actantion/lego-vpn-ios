//
//  ConfirmBtnTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/25.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

typealias clickConfirm = () -> (Void)
class ConfirmBtnTableViewCell: UITableViewCell {
    @IBOutlet weak var btnConfirm: UIButton!
    var confirmBlock:clickConfirm!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnConfirm.layer.masksToBounds = true
        btnConfirm.layer.cornerRadius = 4
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickConfirm(_ sender: Any) {
        confirmBlock()
    }
}
