//
//  FWPayPopView.swift
//  TenonVPN
//
//  Created by friend on 2019/9/24.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
class FWPayPopView: FWBottomPopView{
    var cellPayWayName:String!
    var cellConfirmName:String!
    
    override init(frame:CGRect){
        super.init(frame: CGRect(x: 0, y: frame.origin.y, width: SCREEN_WIDTH, height: frame.height))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadCell(_ cellName:String ,_ cellPayWayName:String ,_ cellConfirmName:String ,_ rowCount:Int){
        self.cellName = cellName
        self.cellPayWayName = cellPayWayName
        self.cellConfirmName = cellConfirmName
        self.rowCount = rowCount
        self.tableView.loadCell(cellName)
        self.tableView.loadCell(cellPayWayName)
        self.tableView.loadCell(cellConfirmName)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.rowCount
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell:UITableViewCell = tableView.reUseCell(self.cellName)
                return self.callBackBlk!(cell,indexPath) as! UITableViewCell
            }else if(indexPath.section == 1){
                let cell:UITableViewCell = tableView.reUseCell(self.cellPayWayName)
                return self.callBackBlk!(cell,indexPath) as! UITableViewCell
            }else{
                let cell:UITableViewCell = tableView.reUseCell(self.cellConfirmName)
                return self.callBackBlk!(cell,indexPath) as! UITableViewCell
            }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.clickBlck!(indexPath.row)
        }
    }
}
