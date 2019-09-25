//
//  payConfirmTableViewCell.swift
//  TenonVPN
//
//  Created by friend on 2019/9/24.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
typealias inputAmountBlock = (Int) -> (Void)
class payConfirmTableViewCell: UITableViewCell {
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var tfPayMoney: UITextField!
    @IBOutlet weak var lbTenonCount: UILabel!
    var inputAmountBlk:inputAmountBlock!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // confirmPayBlck(lbPayMoney.text!)
//        self.tfPayMoney.text = String(Int(self.tfPayMoney.text!)! - 1)
//        self.lbTenonCount.text = String(Int(self.tfPayMoney.text!)!*500)
        tfPayMoney.addTarget(self, action: Selector(("textFieldDidChange:")), for: .editingChanged)
        btnAdd.layer.masksToBounds = true
        btnAdd.layer.cornerRadius = 4
        btnAdd.layer.borderColor = UIColor.black.cgColor
        btnAdd.layer.borderWidth = 1
        
        btnMinus.layer.masksToBounds = true
        btnMinus.layer.cornerRadius = 4
        btnMinus.layer.borderColor = UIColor.black.cgColor
        btnMinus.layer.borderWidth = 1
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickAdd(_ sender: Any) {
        let value:Int = (Int(tfPayMoney.text!) ?? 0)
        tfPayMoney.text = String((value + 1))
        inputAmountBlk(value + 1)
        lbTenonCount.text = String((Int(tfPayMoney.text!) ?? 0)*500)
    }
    
    @IBAction func clickMinus(_ sender: Any) {
        let value:Int = (Int(tfPayMoney.text!) ?? 0)
        if value <= 0{
            return
        }
        tfPayMoney.text = String((value - 1))
        inputAmountBlk(value - 1)
        lbTenonCount.text = String((Int(tfPayMoney.text!) ?? 0)*500)
    }
    //    - (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
//    NSString *filterText = string;
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
//    return result;
//    }
    @objc func filterCharactor(_ string:String, _ regexStr:String){
        
    }
    //...
    @objc func textFieldDidChange(_ textField: UITextField) {
        inputAmountBlk((Int(textField.text!) ?? 0))
        self.lbTenonCount.text = String((Int(textField.text!) ?? 0)*500)
    }

}
