//
//  FWPopMenu.swift
//  TenonVPN
//
//  Created by friend on 2019/9/10.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
typealias callBackCellForRow = (UITableViewCell,IndexPath) -> (AnyObject)
typealias clickCellRow = (Int) -> (Void)
class FWPopMenu: UIView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var callBackBlk : callBackCellForRow?
    var clickBlck: clickCellRow?
    var cellName:String!
    var tableView:UITableView!
    var rowCount:Int!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.TapGestureRecognizer()
        self.backgroundColor = UIColor.clear
        self.tableView = UITableView(frame: frame)
        self.tableView.delegate = self
//        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.addSubview(self.tableView)
        self.cellName = ""
    }
    func TapGestureRecognizer() -> Void {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1 
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapAction(action:)))
        self.addGestureRecognizer(tap)
    }

    @objc func tapAction(action:UITapGestureRecognizer) -> Void {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.reUseCell(self.cellName)
        return self.callBackBlk!(cell,indexPath) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickBlck!(indexPath.row)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
