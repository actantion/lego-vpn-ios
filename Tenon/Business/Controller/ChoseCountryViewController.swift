//
//  ChoseCountryViewController.swift
//  TenonVPN
//
//  Created by friend on 2019/9/6.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

typealias  block = (String,String,String) -> ()
class ChoseCountryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var callBackBlk : block?
    var countryCode:[String] = ["United States", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "United Kingdom"]
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addNavigationView()
        self.tableView.delegate = self
        
        
        self.tableView.dataSource = self
        self.tableView.loadCell("CountryTableViewCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.countryCode.count
    }
    // - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountryTableViewCell! = tableView.reUseCell("CountryTableViewCell") as? CountryTableViewCell
        cell.lbCountryName.text = self.countryCode[indexPath.row]
        cell.lbNodeCount.text = "998"
        cell.imgIcon.image = UIImage(named:self.iCon[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callBackBlk!(self.countryCode[indexPath.row],self.iCon[indexPath.row],"156")
        self.navigationController?.popViewController(animated: true)
    }
}
