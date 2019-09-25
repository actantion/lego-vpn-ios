//
//  PayWayTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/24.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class PayWayTableViewCell: UITableViewCell {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
