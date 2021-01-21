//
//  TenonProtocolView.swift
//  TenonVPN
//
//  Created by admin on 2021/1/20.
//  Copyright © 2021 zly. All rights reserved.
//

import UIKit

@objcMembers
class TenonProtocolView: UIView {

    @IBAction func clickAgree(_ sender: Any) {
        let defaluts = UserDefaults.standard
        defaluts.setValue("FIRST_ENTER_APP", forKey: "FIRST_ENTER_APP")
        defaluts.synchronize()
        self.removeFromSuperview()
    }
}
