//
//  FWOperPKView.swift
//  TenonVPN
//
//  Created by friend on 2019/9/25.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class FWOperPKView: UIView , UIGestureRecognizerDelegate{
    var selfView:UIView!
    var clickBlck: clickCellRow?
    var privateKey:String{
        set{
            self.lbPrivateKeyValue.text = newValue
            self.lbPrivateKeyValue.sizeToFit()
            
            let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(longTapRecognizer))
            tap.minimumPressDuration = 1.0
            
            tap.numberOfTouchesRequired = 1
            self.lbPrivateKeyValue.isUserInteractionEnabled = true
            self.lbPrivateKeyValue.addGestureRecognizer(tap)
            
            lbPrivateKeyChangeTitle.top = lbPrivateKeyValue.bottom + 30
            tfPrivatekey.top = lbPrivateKeyChangeTitle.bottom + 8
        }
        get{
            return lbPrivateKeyValue.text ?? ""
        }
    }
    var lbPrivateKeyValue:UILabel!
    var lbPrivateKeyChangeTitle:UILabel!
    var tfPrivatekey:UITextField!
    
    override init(frame:CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.selfView = UIView.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height))
        self.selfView.layer.cornerRadius = 8
        self.selfView.layer.masksToBounds = true
        self.selfView.backgroundColor = UIColor.white
        self.selfView.layer.borderColor = APP_COLOR.cgColor
        self.selfView.layer.borderWidth = 1
        initView(frame: frame)
        self.TapGestureRecognizer()
        
        self.addSubview(self.selfView)
    }
    @objc func longTapRecognizer(recognizer:UIGestureRecognizer){
        if recognizer.state == .ended{
            
        }else if recognizer.state == .began{
            let pboard = UIPasteboard.general
            pboard.string = self.privateKey
            CBToast.showToastAction(message: "Copy Success")
        }
    }
    func initView(frame:CGRect) {
        let lbTitle:UILabel = UILabel.init(frame:CGRect.zero)
        lbTitle.text = "Private Key"
        lbTitle.top = 16
        lbTitle.sizeToFit()
        lbTitle.centerX = frame.width/2
        lbTitle.font = UIFont.systemFont(ofSize: 16)
        lbTitle.textColor = APP_COLOR
        
        let lbPrivateKeyTitle:UILabel = UILabel.init(frame:CGRect.zero)
        lbPrivateKeyTitle.text = "Private Key (Long Press To Copy)"
        lbPrivateKeyTitle.sizeToFit()
        lbPrivateKeyTitle.top = lbTitle.bottom + 16
        lbPrivateKeyTitle.left = 16
        lbPrivateKeyTitle.font = UIFont.systemFont(ofSize: 14)
        lbPrivateKeyTitle.textColor = APP_COLOR
        
        lbPrivateKeyValue = UILabel.init(frame:CGRect.zero)
        lbPrivateKeyValue.width = selfView.width - 32
        lbPrivateKeyValue.numberOfLines = 0
        lbPrivateKeyValue.top = lbPrivateKeyTitle.bottom + 8
        lbPrivateKeyValue.left = 16
        lbPrivateKeyValue.font = UIFont.systemFont(ofSize: 12)
        lbPrivateKeyValue.textColor = UIColor.black
        
        lbPrivateKeyChangeTitle = UILabel.init(frame:CGRect.zero)
        lbPrivateKeyChangeTitle.text = "Private Key (Input New Private Key)"
        lbPrivateKeyChangeTitle.sizeToFit()
        lbPrivateKeyChangeTitle.top = lbPrivateKeyValue.bottom + 30
        lbPrivateKeyChangeTitle.left = 16
        lbPrivateKeyChangeTitle.font = UIFont.systemFont(ofSize: 14)
        lbPrivateKeyChangeTitle.textColor = APP_COLOR
        
        tfPrivatekey = UITextField.init(frame: CGRect(x: lbPrivateKeyChangeTitle.left, y: lbPrivateKeyChangeTitle.bottom + 8, width: selfView.width - 32, height: 30))
        tfPrivatekey.placeholder = " Input New Private Key Please"
        tfPrivatekey.text = privateKey
        tfPrivatekey.font = UIFont.systemFont(ofSize: 12)
        tfPrivatekey.layer.masksToBounds = true
        tfPrivatekey.layer.cornerRadius = 8
        tfPrivatekey.layer.borderColor = APP_COLOR.cgColor
        tfPrivatekey.layer.borderWidth = 1
        
        let btnChangeConfirm:UIButton = UIButton.init(frame: CGRect(x: 16, y: selfView.height - 56, width: selfView.width - 32, height: 40))
        btnChangeConfirm.setTitle("Change Confirm", for: UIControl.State.normal)
        btnChangeConfirm.backgroundColor = APP_COLOR
        btnChangeConfirm.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnChangeConfirm.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnChangeConfirm.layer.masksToBounds = true
        btnChangeConfirm.layer.cornerRadius = 4
        
        selfView.addSubview(lbTitle)
        selfView.addSubview(lbPrivateKeyTitle)
        selfView.addSubview(lbPrivateKeyValue)
        selfView.addSubview(lbPrivateKeyChangeTitle)
        selfView.addSubview(tfPrivatekey)
        selfView.addSubview(btnChangeConfirm)
    }
    func TapGestureRecognizer() -> Void {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapAction(action:)))
        self.addGestureRecognizer(tap)
    }
    /*轻点手势的方法*/
    @objc func tapAction(action:UITapGestureRecognizer) -> Void {
        self.clickBlck!(-1)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) ->   Bool {
        if touch.view.hashValue != selfView.hashValue && touch.view.hashValue != lbPrivateKeyValue.hashValue{
            return true
        } else {
            return false
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
