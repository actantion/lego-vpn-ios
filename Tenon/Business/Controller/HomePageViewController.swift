//
//  HomePageViewController.swift
//  TenonVPN
//
//  Created by friend on 2019/9/6.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var tfIpAddress: UITextField!
    @IBOutlet weak var tfPort: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCrypto: UITextField!
    let defaultStand = UserDefaults.init(suiteName: "group.com.zly.BearSS")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func clickConnect(_ sender: Any) {
        exit(0)
//        VpnManager.shared.ip_address = "162.245.239.74"//self.tfIpAddress.text ?? ""
//        VpnManager.shared.port = 23459//Int(self.tfPort.text ?? "0")!
//        VpnManager.shared.password = "dongtaiwang.com"//self.tfPassword.text ?? ""
//        VpnManager.shared.algorithm = "AES256CFB"//self.tfCrypto.text ?? "AES256CFB"
        VpnManager.shared.ip_address = "167.71.113.28"
        VpnManager.shared.port = 10190
        VpnManager.shared.password = "password"
        VpnManager.shared.algorithm = "AES256CFB";
        
        if VpnManager.shared.vpnStatus == .on{
            VpnManager.shared.disconnect()
        }
        else{
            VpnManager.shared.connect()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
