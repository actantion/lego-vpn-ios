//
//  FWUpgradeView.swift
//  TenonVPN
//
//  Created by friend on 2019/10/10.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class TenonGetView: UIView ,UIGestureRecognizerDelegate{
    var topView:UIView!
    var bottomView:UIView!
    var clickBlck: clickCellRow?
    var btnUpgrade:UIButton!
    var lbTitle:UILabel!
    var down_url: String!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.topView = UIView(frame: CGRect(x: 0, y: -SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*2-frame.height))
        self.topView.backgroundColor = UIColor.black
        self.topView.alpha = 0
        lbTitle = UILabel(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH - 20, height: 20))
        lbTitle.text = "Free traffic used up, buy tenon or use tomorrow."
        lbTitle.font = UIFont.systemFont(ofSize: 13)
        lbTitle.textColor = APP_COLOR
        lbTitle.textAlignment = NSTextAlignment.center
        self.bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - frame.height, width: SCREEN_WIDTH, height: frame.height))
        self.bottomView.backgroundColor = UIColor.white
        self.btnUpgrade = UIButton(frame: CGRect(x: SCREEN_WIDTH / 4, y: lbTitle.bottom + 30, width: SCREEN_WIDTH / 2, height: 30))
        self.btnUpgrade.setTitle("GET", for: UIControl.State.normal)
        
        self.btnUpgrade.backgroundColor = APP_COLOR
        self.btnUpgrade.layer.masksToBounds = true
        self.btnUpgrade.layer.cornerRadius = 4
        self.btnUpgrade.addTarget(self, action: #selector(clickUpgrade), for: UIControl.Event.touchUpInside)
        self.TapGestureRecognizer()
        lbTitle.centerX = self.bottomView.centerX
        self.bottomView.addSubview(self.lbTitle)
        self.bottomView.addSubview(self.btnUpgrade)
        self.addSubview(self.topView)
        self.addSubview(self.bottomView)
        UIView.animate(withDuration: 0.4, animations: {
            self.topView.alpha = 0.5
        }) { (Bool) in
            
        }
    }
    
    public func Show(download_url: String) {
            lbTitle.text = "Free traffic used up, buy tenon or use tomorrow."
            self.btnUpgrade.isHidden = false
    }
    
    @objc func clickUpgrade(){
        UIApplication.shared.openURL(NSURL(string: "http://222.186.170.72/chongzhi/" + TenonP2pLib.sharedInstance.account_id) as! URL)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func TapGestureRecognizer() -> Void {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1 
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapAction(action:)))
        self.topView.addGestureRecognizer(tap)
    }
    /*轻点手势的方法*/
    @objc func tapAction(action:UITapGestureRecognizer) -> Void {
        UIView.animate(withDuration: 0.4, animations: {
            self.topView.alpha = 0
        }) { (Bool) in
            
        }
        self.clickBlck!(-1)
    }
}
