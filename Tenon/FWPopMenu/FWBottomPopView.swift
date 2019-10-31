//
//  FWBottomPopView.swift
//  TenonVPN
//
//  Created by friend on 2019/9/11.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
class FWBottomPopView: UIView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var callBackBlk : callBackCellForRow?
    var clickBlck: clickCellRow?
    var cellName:String!
    var cellHeaderName:String!
    var tableView:UITableView!
    var rowCount:Int!
    var topView:UIView!
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
        self.TapGestureRecognizer()
        
//        self.backgroundColor = UIColor.clear
        self.tableView = UITableView(frame: frame)
//        self.tableView.isHidden = true
        self.tableView.delegate = self
        //        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        self.tableView.allowsSelection = false
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.addSubview(self.topView)
        self.addSubview(self.tableView)
        self.cellName = ""
        
        UIView.animate(withDuration: 0.4, animations: {
            self.topView.alpha = 0.5
        }) { (Bool) in
            
        }
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) ->   Bool {
        if String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        } else {
            return true
        }
    }
    
    public func loadCell(_ cellName:String ,_ rowCount:Int){
        self.cellName = cellName
        self.rowCount = rowCount
        self.tableView.loadCell(cellName)
        self.tableView.reloadData()
    }
    
    public func loadCell(_ cellName:String ,_ cellHeaderName:String ,_ rowCount:Int){
        self.cellName = cellName
        self.cellHeaderName = cellHeaderName
        self.rowCount = rowCount
        self.tableView.loadCell(cellName)
        self.tableView.loadCell(cellHeaderName)
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cellHeaderName == nil{
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cellHeaderName == nil{
            return self.rowCount
        }else{
            if section == 0 {
                return 1
            }else{
                return self.rowCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellHeaderName == nil{
            let cell:UITableViewCell = tableView.reUseCell(self.cellName)
            return self.callBackBlk!(cell,indexPath) as! UITableViewCell
        }else{
            if indexPath.section == 0 {
                let cell:UITableViewCell = tableView.reUseCell(self.cellHeaderName)
                return self.callBackBlk!(cell,indexPath) as! UITableViewCell
            }else{
                let cell:UITableViewCell = tableView.reUseCell(self.cellName)
                return self.callBackBlk!(cell,indexPath) as! UITableViewCell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickBlck!(indexPath.row)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
