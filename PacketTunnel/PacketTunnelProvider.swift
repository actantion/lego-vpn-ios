//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//

import NetworkExtension
import NEKit
import CocoaLumberjackSwift
import Yaml

class PacketTunnelProvider: NEPacketTunnelProvider {
    var interface: TUNInterface!
    var enablePacketProcessing = true
    
    var proxyPort: Int!
    
    var proxyServer: ProxyServer!
    
    var lastPath:NWPath?
    
    var started:Bool = false
    
    let queue = DispatchQueue(label: "update_route_and_vpn_nodes1")
    var stop_queue = false;
    var domainKeyWords = [String]()
    var domainNotKeyWords = [String]()
    var checked_use_global_mode: Bool = false;
    var prev_use_global_mode: Bool = false;
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        stop_queue = false
        DDLog.removeAllLoggers()
        DDLog.add(DDOSLogger.sharedInstance, with: DDLogLevel.info)
        ObserverFactory.currentFactory = DebugObserverFactory()
        NSLog("-------------")
        
        domainKeyWords.append("google")
        domainKeyWords.append("youtube")
        domainKeyWords.append("facebook")
        domainKeyWords.append("wikipedia")
        domainKeyWords.append("twitter")
        domainKeyWords.append("live")
        domainKeyWords.append("yahoo")
        domainKeyWords.append("reddit")
        domainKeyWords.append("netflix")
        domainKeyWords.append("blogspot")
        domainKeyWords.append("bing")
        domainKeyWords.append("instagram")
        domainKeyWords.append("zoom")
        domainKeyWords.append("twitch")
        domainKeyWords.append("fc2")
        domainKeyWords.append("xhamster")
        domainKeyWords.append("tumblr")
        domainKeyWords.append("pinterest")
        domainKeyWords.append("amazon")
        domainKeyWords.append("pornhub")
        domainKeyWords.append("xvideos")
        domainKeyWords.append("imgur")
        domainKeyWords.append("thepiratebay")
        domainKeyWords.append("whatsapp")
        domainKeyWords.append("amazonaws")
        domainKeyWords.append("dailymotion")
        domainKeyWords.append("medium")
        domainKeyWords.append("quora")
        domainKeyWords.append("bbc")
        domainKeyWords.append("nytimes")
        domainKeyWords.append("vimeo")
        domainKeyWords.append("theguardian")
        domainKeyWords.append("slideshare")
        domainKeyWords.append("deviantart")
        domainKeyWords.append("telegram")
        domainKeyWords.append("soundcloud")
        domainKeyWords.append("washingtonpost")
        domainKeyWords.append("slack")
        domainKeyWords.append("nicovideo")
        domainKeyWords.append("archive")
        domainKeyWords.append("scribd")
        domainKeyWords.append("line")
        domainKeyWords.append("mega")
        domainKeyWords.append("xing")
        domainKeyWords.append("hardsextube")
        domainKeyWords.append("drtuber")
        domainKeyWords.append("wikimedia")
        domainKeyWords.append("bloomberg")
        domainKeyWords.append("e-hentai")
        domainKeyWords.append("goodreads")
        domainKeyWords.append("flickr")
        domainKeyWords.append("huffpost")
        domainKeyWords.append("duckduckgo")
        domainKeyWords.append("wattpad")
        domainKeyWords.append("spiegel")
        domainKeyWords.append("independent")
        domainKeyWords.append("wsj")
        domainKeyWords.append("Feedly")
        domainKeyWords.append("yomiuri")
        domainKeyWords.append("reuters")
        domainKeyWords.append("PChome")
        domainKeyWords.append("nikkeibp")
        domainKeyWords.append("nbcnews")
        domainKeyWords.append("disqus")
        domainKeyWords.append("badoo")
        domainKeyWords.append("exhentai")
        domainKeyWords.append("eporner")
        domainKeyWords.append("appledaily")
        domainKeyWords.append("nintendo")
        domainKeyWords.append("technorati")
        domainKeyWords.append("archiveofourown")
        domainKeyWords.append("pixiv")
        domainKeyWords.append("viber")
        domainKeyWords.append("nordvpn")
        domainKeyWords.append("scmp")
        domainKeyWords.append("plurk")
        domainKeyWords.append("economist")
        domainKeyWords.append("rfi")
        domainKeyWords.append("change")
        domainKeyWords.append("smh")
        domainKeyWords.append("Internet")
        domainKeyWords.append("voanews")
        domainKeyWords.append("inoreader")
        domainKeyWords.append("nbc")
        domainKeyWords.append("rfa")
        domainKeyWords.append("pbworks")
        domainKeyWords.append("straitstimes")
        domainKeyWords.append("theepochtimes")
        domainKeyWords.append("moegirl")
        domainKeyWords.append("sony")
        domainKeyWords.append("aljazeera")
        domainKeyWords.append("worldcat")
        domainKeyWords.append("tapatalk")
        domainKeyWords.append("hbo")
        domainKeyWords.append("Flipboard")
        domainKeyWords.append("wikiquote")
        domainKeyWords.append("minghui")
        domainKeyWords.append("ndr")
        domainKeyWords.append("boxun")
        domainKeyWords.append("akinator")
        domainKeyWords.append("wikiversity")
        domainKeyWords.append("ntdtv")
        domainKeyWords.append("1688")
        domainKeyWords.append("Shield")
        domainKeyWords.append("tvb")
        domainKeyWords.append("getlantern")
        domainKeyWords.append("hrw")
        domainKeyWords.append("wikileaks")
        domainKeyWords.append("theinitium")
        domainKeyWords.append("sonymusic")
        domainKeyWords.append("kadokawa")
        domainKeyWords.append("shadowsocks")
        domainKeyWords.append("openvpn")
        domainKeyWords.append("gab")
        domainKeyWords.append("allmovie")
        domainKeyWords.append("amnesty")
        domainKeyWords.append("rferl")
        domainKeyWords.append("wikinews")
        domainKeyWords.append("torproject")
        domainKeyWords.append("rsf")
        domainKeyWords.append("tvr")
        domainKeyWords.append("livestation")
        domainKeyWords.append("akamai")
        domainKeyWords.append("greatfire")
        domainKeyWords.append("falundafa")
        domainKeyWords.append("dalailama")
        domainKeyWords.append("americanbar")
        domainKeyWords.append("freetibet")
        domainKeyWords.append("tibet")
        domainKeyWords.append("rri")
        domainKeyWords.append("sluggn")
        domainKeyWords.append("citizenpowerforchina")
        domainKeyWords.append("spotify")
        domainKeyWords.append("pandora")
        domainKeyWords.append("imdb")
        domainKeyWords.append("hulu")
        domainKeyWords.append("steampowered")
        domainKeyWords.append("blizzard")
        domainKeyWords.append("tripadvisor")
        domainKeyWords.append("airbnb")
        domainKeyWords.append("ted")
        domainKeyWords.append("udemy")
        domainKeyWords.append("coursera")
        domainKeyWords.append("snapchat")
        domainKeyWords.append("linkddin")
        domainKeyWords.append("wikihow")
        domainKeyWords.append("wikioedia")
        domainKeyWords.append("ebay")
        domainKeyWords.append("paypal")
        domainKeyWords.append("blogger")
        domainKeyWords.append("wordpress")
        domainKeyWords.append("pixabay")
        domainKeyWords.append("nationalgeographic")
        domainKeyWords.append("smallpdf")
        domainKeyWords.append("stackoverflow")
        domainKeyWords.append("github")
        domainKeyWords.append("digitalocean")
        domainKeyWords.append("godaddy")
        
        domainNotKeyWords.append("weixin")
        domainNotKeyWords.append("qq")
        
        guard let conf = (protocolConfiguration as! NETunnelProviderProtocol).providerConfiguration else{
            NSLog("[ERROR] No ProtocolConfiguration Found")
            exit(EXIT_FAILURE)
        }
        
        
        let ss_adder = conf["ss_address"] as! String
        NSLog(ss_adder)
        
        let ss_port = conf["ss_port"] as! Int
        let method = conf["ss_method"] as! String
        NSLog(method)
        
        let password = conf["ss_password"] as!String
        let pubkey = conf["ss_pubkey"] as! String
        let method1 = conf["ss_method1"] as! String
        let local_country = conf["local_country"] as! String
        let choosed_country = conf["choosed_country"] as! String
        let use_smart_route = conf["use_smart_route"] as! Bool
        let route_nodes = conf["route_nodes"] as! String
        let vpn_nodes = conf["vpn_nodes"] as! String
        let use_global_mode = conf["use_global_mode"] as! Bool
        // Proxy Adapter
        // SSR Httpsimple
        //        let obfuscater = ShadowsocksAdapter.ProtocolObfuscater.HTTPProtocolObfuscater.Factory(hosts:["intl.aliyun.com","cdn.aliyun.com"], customHeader:nil)
        
        
        // Origin
        let obfuscater = ShadowsocksAdapter.ProtocolObfuscater.OriginProtocolObfuscater.Factory()
        let algorithm:CryptoAlgorithm
        
        switch method{
        case "aes-128-cfb":algorithm = .AES128CFB
        case "aes-192-cfb":algorithm = .AES192CFB
        case "aes-256-cfb":algorithm = .AES256CFB
        case "chacha20":algorithm = .CHACHA20
        case "salsa20":algorithm = .SALSA20
        case "rc4-md5":algorithm = .RC4MD5
        default:
            fatalError("Undefined algorithm!")
        }

        ShadowsocksAdapter.SetLocalCountry(l_c: local_country)
        ShadowsocksAdapter.SetChoosedCountry(c_c: choosed_country)
        ShadowsocksAdapter.SetUseSmartRoute(smart: use_smart_route)
        ShadowsocksAdapter.SetRouteNodes(tmp_route_nodes: route_nodes)
        ShadowsocksAdapter.SetVpnNodes(tmp_vpn_nodes: vpn_nodes)
        ShadowsocksAdapter.SetPublicKey(pubkey: pubkey)
        ShadowsocksAdapter.ChooseVpnNode()
        
        self.checked_use_global_mode = true
        self.prev_use_global_mode = use_global_mode
        
        let cryptor = ShadowsocksAdapter.CryptoStreamProcessor.Factory(password: password, algorithm: algorithm)
        let ssAdapterFactory = ShadowsocksAdapterFactory(serverHost: ss_adder, serverPort: ss_port, pk: pubkey, m: method1, protocolObfuscaterFactory:obfuscater, cryptorFactory: cryptor, streamObfuscaterFactory: ShadowsocksAdapter.StreamObfuscater.OriginStreamObfuscater.Factory())
        
        self.queue.async {

            while (!self.stop_queue) {
                guard let conf = (self.protocolConfiguration as! NETunnelProviderProtocol).providerConfiguration else{
                    NSLog("[ERROR] No ProtocolConfiguration Found")
                    exit(EXIT_FAILURE)
                }

                if conf["route_nodes"] != nil {
                    let route_str = conf["route_nodes"] as! String
                    ShadowsocksAdapter.SetRouteNodes(tmp_route_nodes: route_str)
                }

                if conf["vpn_nodes"] != nil {
                    let vpn_str = conf["vpn_nodes"] as! String
                    ShadowsocksAdapter.SetVpnNodes(tmp_vpn_nodes: vpn_str)
                }
                
                if conf["local_country"] != nil {
                    let country = conf["local_country"] as! String
                    ShadowsocksAdapter.SetLocalCountry(l_c: country)
                }
                
//                let use_global_mode = conf["use_global_mode"] as! Bool
//                if (self.checked_use_global_mode) {
//                    if (self.prev_use_global_mode != use_global_mode) {
//                        exit(EXIT_FAILURE)
//                    }
//                }

                Thread.sleep(forTimeInterval: 1)
            }
        }

        let directAdapterFactory:NEKit.AdapterFactory
        if use_global_mode {
            directAdapterFactory = ssAdapterFactory
        } else {
            directAdapterFactory = DirectAdapterFactory()
        }

        //Get lists from conf
        let yaml_str = conf["ymal_conf"] as!String
        let value = try! Yaml.load(yaml_str)
        
        var UserRules:[NEKit.Rule] = []
        
        for each in (value["rule"].array! ){
            let adapter:NEKit.AdapterFactory
            if each["adapter"].string! == "direct"{
                adapter = directAdapterFactory
            }else{
                adapter = ssAdapterFactory
            }

            let ruleType = each["type"].string!
            switch ruleType {
            case "domainlist":
                var rule_array : [NEKit.DomainListRule.MatchCriterion] = []
                for dom in each["criteria"].array!{
                    let raw_dom = dom.string!
                    let index = raw_dom.index(raw_dom.startIndex, offsetBy: 1)
                    let index2 = raw_dom.index(raw_dom.startIndex, offsetBy: 2)
                    let typeStr = raw_dom[...index]
                    let url = raw_dom[index2...]

                    if typeStr == "s"{
                        rule_array.append(DomainListRule.MatchCriterion.suffix(String(url)))
                    }else if typeStr == "k"{
                        rule_array.append(DomainListRule.MatchCriterion.keyword(String(url)))
                    }else if typeStr == "p"{
                        rule_array.append(DomainListRule.MatchCriterion.prefix(String(url)))
                    }else if typeStr == "r"{
                        // ToDo:
                        // shoud be complete
                    }
                }
                UserRules.append(DomainListRule(adapterFactory: adapter, criteria: rule_array))


            case "iplist":
                let ipArray = each["criteria"].array!.map{$0.string!}
                UserRules.append(try! IPRangeListRule(adapterFactory: adapter, ranges: ipArray))
            default:
                break
            }
        }


        var rule_array : [NEKit.DomainListRule.MatchCriterion] = []
        for item in domainKeyWords {
            rule_array.append(DomainListRule.MatchCriterion.keyword(String(item)))
        }

        UserRules.append(DomainListRule(adapterFactory: ssAdapterFactory, criteria: rule_array))

        let lowerStr = local_country.lowercased()
        domainNotKeyWords.append(lowerStr)

        var not_rule_array : [NEKit.DomainListRule.MatchCriterion] = []
        for item in domainNotKeyWords {
            not_rule_array.append(DomainListRule.MatchCriterion.keyword(String(item)))
        }

        UserRules.append(DomainListRule(adapterFactory: directAdapterFactory, criteria: not_rule_array))

        // Rules

        UserRules.append(try! IPRangeListRule(adapterFactory: directAdapterFactory, ranges: ["42.51.39.113/32","42.51.33.89/32","42.51.41.173/32","113.17.169.103/32","113.17.169.105/32","113.17.169.106/32","113.17.169.93/32","113.17.169.94/32","113.17.169.95/32","216.108.227.52/32","216.108.231.102/32","216.108.231.103/32","216.108.231.105/32","216.108.231.19/32","3.12.73.217/32","3.137.186.226/32","3.22.68.200/32","3.138.121.98/32","18.188.190.127/32", "54.198.157.144/32", "3.81.161.170/32", "35.153.74.125/32"]))


        let chinaRule = CountryRule(countryCode: local_country, match: true, adapterFactory: directAdapterFactory)
        let unKnowLoc = CountryRule(countryCode: "--", match: true, adapterFactory: ssAdapterFactory)
        let dnsFailRule = DNSFailRule(adapterFactory: ssAdapterFactory)
        
        let allRule = AllRule(adapterFactory: ssAdapterFactory)
        UserRules.append(contentsOf: [chinaRule, unKnowLoc, dnsFailRule, allRule])
        
        let manager = RuleManager(fromRules: UserRules, appendDirect: false)
        
        RuleManager.currentManager = manager
        proxyPort = 9090
        
        // the `tunnelRemoteAddress` is meaningless because we are not creating a tunnel.
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        networkSettings.mtu = 1500
        
        let ipv4Settings = NEIPv4Settings(addresses: ["192.0.6.1"], subnetMasks: ["255.255.255.0"])
        if enablePacketProcessing {
            ipv4Settings.includedRoutes = [NEIPv4Route.default()]
            ipv4Settings.excludedRoutes = [
                NEIPv4Route(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
                NEIPv4Route(destinationAddress: "100.64.0.0", subnetMask: "255.192.0.0"),
                NEIPv4Route(destinationAddress: "127.0.0.0", subnetMask: "255.0.0.0"),
                NEIPv4Route(destinationAddress: "169.254.0.0", subnetMask: "255.255.0.0"),
                NEIPv4Route(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
                NEIPv4Route(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
                NEIPv4Route(destinationAddress: "17.0.0.0", subnetMask: "255.0.0.0"),
            
            ]
        }
        networkSettings.ipv4Settings = ipv4Settings
        
        let proxySettings = NEProxySettings()
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.excludeSimpleHostnames = true
        // This will match all domains
        proxySettings.matchDomains = [""]
        proxySettings.exceptionList = []
        networkSettings.proxySettings = proxySettings
        
        if enablePacketProcessing {
            let DNSSettings = NEDNSSettings(servers: ["8.8.8.8"])
            DNSSettings.matchDomains = [""]
            DNSSettings.matchDomainsNoSearch = false
            networkSettings.dnsSettings = DNSSettings
        }
        
        setTunnelNetworkSettings(networkSettings) {
            error in
            guard error == nil else {
                DDLogError("Encountered an error setting up the network: \(error.debugDescription)")
                completionHandler(error)
                return
            }
            
            
            if !self.started{
                self.proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: NEKit.Port(port: UInt16(self.proxyPort)))
                try! self.proxyServer.start()
                self.addObserver(self, forKeyPath: "defaultPath", options: .initial, context: nil)
            }else{
                self.proxyServer.stop()
                try! self.proxyServer.start()
            }
            
            completionHandler(nil)
            
            
            if self.enablePacketProcessing {
                if self.started{
                    self.interface.stop()
                }
                
                self.interface = TUNInterface(packetFlow: self.packetFlow)
                
                
//                let fakeIPPool = try! IPPool(range: IPRange(startIP: IPAddress(fromString: "198.168.1.1")!, endIP: IPAddress(fromString: "198.168.255.255")!))
                
//
//                let dnsServer = DNSServer(address: IPAddress(fromString: "8.8.8.8")!, port: NEKit.Port(port: 53), fakeIPPool: fakeIPPool)
//                let resolver = UDPDNSResolver(address: IPAddress(fromString: "114.114.114.114")!, port: NEKit.Port(port: 53))
//                dnsServer.registerResolver(resolver)
//                self.interface.register(stack: dnsServer)
//
//                DNSServer.currentServer = dnsServer
//
//                let udpStack = UDPDirectStack()
//                self.interface.register(stack: udpStack)
                let tcpStack = TCPStack.stack
                tcpStack.proxyServer = self.proxyServer
                self.interface.register(stack:tcpStack)
                self.interface.start()
            }
            self.started = true
        }
        
    }
    
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        self.stop_queue = true;
        if enablePacketProcessing {
            interface.stop()
            interface = nil
            DNSServer.currentServer = nil
        }
        
        if(proxyServer != nil){
            proxyServer.stop()
            proxyServer = nil
            RawSocketFactory.TunnelProvider = nil
        }
        completionHandler()
        
        exit(EXIT_SUCCESS)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "defaultPath" {
            if self.defaultPath?.status == .satisfied && self.defaultPath != lastPath{
                if(lastPath == nil){
                    lastPath = self.defaultPath
                }else{
                    NSLog("received network change notifcation")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.startTunnel(options: nil){ _ in }
                    }
                }
            }else{
                lastPath = defaultPath
            }
        }
    }
}
