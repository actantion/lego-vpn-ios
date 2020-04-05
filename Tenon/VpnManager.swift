//
//  VpnManager.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//

let kProxyServiceVPNStatusNotification = "kProxyServiceVPNStatusNotification"

import Foundation

import NetworkExtension

struct userConfig {
    let ip = "ip"
    let port = "port"
    let password = "password"
    let algorithm = "algorithm"
}

enum VPNStatus {
    case off
    case connecting
    case on
    case disconnecting
}


class VpnManager{
    public var ip_address: String = ""
    public var port: Int = 0
    public var password: String = ""
    public var algorithm: String = ""
    public var public_key: String = "public_key"
    public var enc_method: String = "enc_method"
    public var route_nodes: String = ""
    public var ex_route_nodes: String = ""
    public var vpn_nodes: String = ""
    public var local_country: String = ""
    public var choosed_country: String = ""
    public var use_smart_route: Bool = true
    public var default_routing_map: Dictionary<String, String> = [:]
    
    private var nodes_lock = NSLock()
    
    static let shared = VpnManager()
    var observerAdded: Bool = false

    let queue = DispatchQueue(label: "update_route_and_vpn_nodes")
    var stop_queue = false;
    
    fileprivate(set) var vpnStatus = VPNStatus.off {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        }
    }
    
    init() {
        loadProviderManager{
            guard let manager = $0 else{return}
            self.updateVPNStatus(manager)
        }
        addVPNStatusObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func SetRouteNodes(nodes_str: String) {
        nodes_lock.lock()
        route_nodes = nodes_str
        nodes_lock.unlock()
    }
    
    func SetExRouteNodes(nodes_str: String) {
        nodes_lock.lock()
        ex_route_nodes = nodes_str
        nodes_lock.unlock()
    }
    
    func SetVpnNodes(nodes_str: String) {
        nodes_lock.lock()
        vpn_nodes = nodes_str
        nodes_lock.unlock()
    }
    
    func addVPNStatusObserver() {
        guard !observerAdded else{
            return
        }
        loadProviderManager { [unowned self] (manager) -> Void in
            if let manager = manager {
                self.observerAdded = true
                NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: manager.connection, queue: OperationQueue.main, using: { [unowned self] (notification) -> Void in
                    self.updateVPNStatus(manager)
                    
                    print("notification get vpn status changed: ")
                    })
            }
        }
    }
    
    
    func updateVPNStatus(_ manager: NEVPNManager) {
        switch manager.connection.status {
        case .connected:
            self.vpnStatus = .on
        case .connecting, .reasserting:
            self.vpnStatus = .connecting
        case .disconnecting:
            self.vpnStatus = .disconnecting
        case .disconnected, .invalid:
            self.vpnStatus = .off
        @unknown default: break
            
        }
        print("get vpn status changed: \(self.vpnStatus)")
    }
}

// load VPN Profiles
extension VpnManager{
    fileprivate func createProviderManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        let conf = NETunnelProviderProtocol()
        conf.serverAddress = "TenonVPN"
        manager.protocolConfiguration = conf
        manager.localizedDescription = "TenonVPN"
        return manager
    }
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    func loadAndCreatePrividerManager(_ complete: @escaping (NETunnelProviderManager?) -> Void ){
        NETunnelProviderManager.loadAllFromPreferences{ (managers, error) in
            guard let managers = managers else{return}
            let manager: NETunnelProviderManager
            if managers.count > 0 {
                manager = managers[0]
                self.delDupConfig(managers)
            }else{
                manager = self.createProviderManager()
            }
            
            manager.isEnabled = true
            self.setRulerConfig(manager)
            manager.saveToPreferences{
                if ($0 != nil){
//                    complete(nil);
//                    return;
                }
                manager.loadFromPreferences{
                    if $0 != nil{
                        print($0.debugDescription)
                        complete(nil);return;
                    }
                    self.addVPNStatusObserver()
                    complete(manager)
                }
            }
            
            self.queue.async {
                while (!self.stop_queue) {
                    if VpnManager.shared.vpnStatus == .on {
                        var conf = [String:AnyObject]()
                        conf["ss_address"] = self.ip_address as AnyObject?
                        conf["ss_port"] = self.port as AnyObject?
                        conf["ss_method"] = self.algorithm as AnyObject?
                        conf["ss_password"] = self.password as AnyObject?
                        conf["ss_pubkey"] = self.public_key as AnyObject?
                        conf["ss_method1"] = self.enc_method as AnyObject?
                        conf["ymal_conf"] = self.getRuleConf() as AnyObject?
                        conf["local_country"] = self.local_country as AnyObject?
                        conf["choosed_country"] = self.choosed_country as AnyObject?
                        conf["use_smart_route"] = self.use_smart_route as AnyObject?
                        do {
                            self.nodes_lock.lock()
                            conf["route_nodes"] = self.route_nodes as AnyObject?
                            conf["vpn_nodes"] = self.vpn_nodes as AnyObject?
                            conf["ex_route_nodes"] = self.ex_route_nodes as AnyObject?
                            self.nodes_lock.unlock()
                        }
                        
                        let orignConf = manager.protocolConfiguration as! NETunnelProviderProtocol
                        orignConf.providerConfiguration = conf
                        manager.protocolConfiguration = orignConf
                        manager.saveToPreferences{
                            if ($0 != nil){
            //                    complete(nil);
            //                    return;
                            }
                            manager.loadFromPreferences{
                                if $0 != nil{
                                    print($0.debugDescription)
                                    complete(nil);return;
                                }
                                self.addVPNStatusObserver()
                                complete(manager)
                            }
                        }
                                    
                    }
                    
                    sleep(3)
                }
            }
        }
    }
    
    func loadProviderManager(_ complete: @escaping (NETunnelProviderManager?) -> Void){
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if let managers = managers {
                if managers.count > 0 {
                    let manager = managers[0]
                    complete(manager)
                    return
                }
            }
            complete(nil)
        }
    }
    
    
    func delDupConfig(_ arrays:[NETunnelProviderManager]){
        if (arrays.count)>1{
            for i in 0 ..< arrays.count{
                print("Del DUP Profiles")
                arrays[i].removeFromPreferences(completionHandler: { (error) in
                    if(error != nil){print(error.debugDescription)}
                })
            }
        }
    }
}

// Actions
extension VpnManager{
    func connect(){
        self.stop_queue = false
        self.loadAndCreatePrividerManager { (manager) in
            guard let manager = manager else{return}
            do{
                try manager.connection.startVPNTunnel(options: [:])
                
            }catch let err{
                print(err)
            }
        }
    }
    
    func disconnect(){
        self.stop_queue = true;
        loadProviderManager{
            $0?.connection.stopVPNTunnel()
        }
    }
    
}

// Generate and Load ConfigFile
extension VpnManager{
    fileprivate func getRuleConf() -> String{
        let Path = Bundle.main.path(forResource: "NEKitRule", ofType: "conf")
        let Data = try? Foundation.Data(contentsOf: URL(fileURLWithPath: Path!))
        let str = String(data: Data!, encoding: String.Encoding.utf8)!
        return str
    }
    
    fileprivate func setRulerConfig(_ manager:NETunnelProviderManager){
        var conf = [String:AnyObject]()
        conf["ss_address"] = ip_address as AnyObject?
        conf["ss_port"] = port as AnyObject?
        conf["ss_method"] = algorithm as AnyObject? 
        conf["ss_password"] = password as AnyObject?
        conf["ss_pubkey"] = public_key as AnyObject?
        conf["ss_method1"] = enc_method as AnyObject?
        conf["ymal_conf"] = getRuleConf() as AnyObject?
        conf["local_country"] = local_country as AnyObject?
        conf["choosed_country"] = choosed_country as AnyObject?
        conf["use_smart_route"] = use_smart_route as AnyObject?
        let orignConf = manager.protocolConfiguration as! NETunnelProviderProtocol
        conf["route_nodes"] = self.route_nodes as AnyObject?
        conf["vpn_nodes"] = self.vpn_nodes as AnyObject?
        conf["ex_route_nodes"] = self.ex_route_nodes as AnyObject?
                
        orignConf.providerConfiguration = conf
        manager.protocolConfiguration = orignConf
        print(ip_address,port,algorithm,password)
    }
}
