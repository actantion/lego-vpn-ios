//
//  ViewController.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
import NetworkExtension
import Eureka


class ViewController: UIViewController {
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnChoseCountry: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestBaidu()
        self.title = "TenonVPN"
        self.btnConnect.layer.masksToBounds = true
        self.btnConnect.layer.cornerRadius = self.btnConnect.frame.width/2
        self.btnAccount.layer.masksToBounds = true
        self.btnAccount.layer.cornerRadius = 20
        self.btnChoseCountry.layer.masksToBounds = true
        self.btnChoseCountry.layer.cornerRadius = 20
        
    }
    @IBAction func clickChoseCountry(_ sender: Any) {
        let choseCountry = ChoseCountryViewController()
//        choseCountry.callBackBlock = (
//            NSLog("123123")
//        )
        self.navigationController?.pushViewController(choseCountry, animated: true)
        
    }
    
    @IBAction func clickAccountSetting(_ sender: Any) {
        NSLog("account setting")
        let acountSet = AcountSetViewController()
        self.navigationController?.pushViewController(acountSet, animated: true)
        
    }
    // 发起一个网络请求 获取系统网络访问权限
    func requestBaidu() {
        let url : URL = URL(string:"https://m.baidu.com")!
        let request : URLRequest = URLRequest(url: url)
        let session : URLSession = URLSession.shared
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
        
        }
        task.resume()
    }
    
    
}
