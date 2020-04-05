import Foundation
import CommonCrypto

/// This adapter connects to remote through Shadowsocks proxy.
public class ShadowsocksAdapter: AdapterSocket {
    enum ShadowsocksAdapterStatus {
        case invalid,
        connecting,
        connected,
        forwarding,
        stopped
    }

    enum EncryptMethod: String {
        case AES128CFB = "AES-128-CFB", AES192CFB = "AES-192-CFB", AES256CFB = "AES-256-CFB"

        static let allValues: [EncryptMethod] = [.AES128CFB, .AES192CFB, .AES256CFB]
    }

    public let host: String
    public let port: Int

    var internalStatus: ShadowsocksAdapterStatus = .invalid

    private let protocolObfuscater: ProtocolObfuscater.ProtocolObfuscaterBase
    private var cryptor: CryptoStreamProcessor
    private let streamObfuscator: StreamObfuscater.StreamObfuscaterBase
    private static var route_nodes: String?
    private static var vpn_nodes: String?
    private static var route_nodes_lock = NSLock()
    private static var ex_route_nodes_lock = NSLock()
    private static var vpn_nodes_lock = NSLock()
    
    private static var local_country: String = "CN"
    private static var choosed_country: String = "US"
    private static var use_smart_route: Bool = true
    private static var public_key: String = ""
    private static var item_lock = NSLock()
    
    private static var route_map = [String: String]()
    private static var vpn_map = [String: String]()
    
    private static var default_route = [String](arrayLiteral: "US", "IN", "GB", "SG")
    
    private static var choosed_vpn_ip = ""
    private static var choosed_vpn_port = 0
    private static var seckey = ""
    
    private static var connect_times: Int = 0
    private static var connect_times_lock = NSLock()
    
    private var old_sec_key: String;
    
    
    public static func add_connect_times() -> Int {
        connect_times_lock.lock()
        connect_times += 1
        connect_times_lock.unlock()
        return connect_times
    }
    
    public static func reset_connect_times() {
        connect_times_lock.lock()
        connect_times = 0
        connect_times_lock.unlock()
    }
    
    public static func get_connect_times() -> Int {
        return connect_times
    }
    
    public static func SetPublicKey(pubkey: String) {
        item_lock.lock()
        public_key = pubkey
        item_lock.unlock()
    }
    
    public static func GetPublicKey() -> String {
        item_lock.lock()
        let tmp_str = public_key
        item_lock.unlock()
        return tmp_str
    }
    
    public static func SetLocalCountry(l_c: String) {
        item_lock.lock()
        local_country = l_c
        item_lock.unlock()
    }
    
    public static func GetLocalCountry() -> String {
        item_lock.lock()
        let tmp_str = local_country
        item_lock.unlock()
        return tmp_str
    }
    
    public static func GetSeckey() -> String {
        return seckey
    }
    
    public static func SetChoosedCountry(c_c: String) {
        item_lock.lock()
        choosed_country = c_c
        item_lock.unlock()
    }
    
    public static func GetChoosedCountry() -> String {
        item_lock.lock()
        let tmp_str = choosed_country
        item_lock.unlock()
        return tmp_str
    }
    
    public static func SetUseSmartRoute(smart: Bool) {
        use_smart_route = smart
    }
    
    public static func GetUseSmartRoute() -> Bool{
        return use_smart_route
    }
    
    public static func GetRouteNode() -> (String, Int) {
        var res = GetOneRouteNode(country: local_country)
        if res.0.isEmpty || res.1 <= 0 {
            res = GetOneRouteNode(country: choosed_country)
            if res.0.isEmpty || res.1 <= 0 {
                for country in default_route {
                    res = GetOneRouteNode(country: country)
                    if !res.0.isEmpty && res.1 > 0 {
                        break
                    }
                }
            }
        }
        return res
    }
    
    public static func GetVpnNode() -> (String, Int) {
        return (choosed_vpn_ip, choosed_vpn_port)
    }
    
    static func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
    public static func ChooseVpnNode() {
        GetOneVpnNode(country: choosed_country)
    }
    
    public static func GetOneVpnNode(country: String) {
        vpn_nodes_lock.lock()
        if vpn_map[country] != nil {
            let nodes: String = vpn_map[country]!
            
            let node_arr: Array = nodes.components(separatedBy: ",")
            if (node_arr.count > 0) {
                let rand_pos = randomCustom(min: 0, max: node_arr.count)
                let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
                if (node_info_arr.count >= 6) {
                    choosed_vpn_ip = String(node_info_arr[0])
                    choosed_vpn_port = Int(String(node_info_arr[1])) ?? 0
                    seckey = String(node_info_arr[3])
                }
            }
        }
        vpn_nodes_lock.unlock()
    }
    
    public static func GetOneRouteNode(country: String) -> (String, Int) {
        var route_ip: String = ""
        var route_port: Int = 0
        route_nodes_lock.lock()
        if route_map[country] != nil {
            let nodes: String = route_map[country]!
            
            let node_arr: Array = nodes.components(separatedBy: ",")
            if (node_arr.count > 0) {
                let rand_pos = randomCustom(min: 0, max: node_arr.count)
                let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
                if (node_info_arr.count >= 6) {
                    route_ip = String(node_info_arr[0])
                    route_port = Int(String(node_info_arr[2])) ?? 0
                }
            }
        }
        route_nodes_lock.unlock()
        return (route_ip, route_port)
    }
    
    public static func SetRouteNodes(tmp_route_nodes: String) {
        if (tmp_route_nodes.isEmpty) {
            return
        }
        
        route_nodes_lock.lock()
        let country_split = tmp_route_nodes.split(separator: "`")
        for item in country_split {
            let item_split = item.split(separator: ";")
            if (item_split.count == 2) {
                route_map[String(item_split[0])] = String(item_split[1]) as String
            }
        }
        route_nodes_lock.unlock()
    }
    
    public static func SetVpnNodes(tmp_vpn_nodes: String) {
        vpn_nodes_lock.lock()
        let country_split = tmp_vpn_nodes.split(separator: "`")
        for item in country_split {
            let item_split = item.split(separator: ";")
            if (item_split.count == 2) {
                vpn_map[String(item_split[0])] = String(item_split[1]) as String
            }
        }
        vpn_nodes_lock.unlock()
    }
    
    public static func GetVpnNodes() -> String {
        vpn_nodes_lock.lock()
        guard let tmp_str = vpn_nodes else { return "" }
        vpn_nodes_lock.unlock()
        return tmp_str
    }

    public init(host: String, port: Int, protocolObfuscater: ProtocolObfuscater.ProtocolObfuscaterBase, cryptor: CryptoStreamProcessor, streamObfuscator: StreamObfuscater.StreamObfuscaterBase) {
        self.host = host
        self.port = port
        self.protocolObfuscater = protocolObfuscater
        self.cryptor = cryptor
        self.streamObfuscator = streamObfuscator
        self.old_sec_key = ""
        super.init()

        protocolObfuscater.inputStreamProcessor = cryptor
        protocolObfuscater.outputStreamProcessor = self

        cryptor.inputStreamProcessor = streamObfuscator
        cryptor.outputStreamProcessor = protocolObfuscater

        streamObfuscator.inputStreamProcessor = self
        streamObfuscator.outputStreamProcessor = cryptor
    }

    override public func openSocketWith(session: ConnectSession) {
        super.openSocketWith(session: session)
        
//        let connect_times_now = ShadowsocksAdapter.add_connect_times()
//        if connect_times_now > 6 {
//            exit(0)
//        }
        
        do {
            internalStatus = .connecting
            if (ShadowsocksAdapter.use_smart_route) {
                let res = ShadowsocksAdapter.GetRouteNode()
                if !res.0.isEmpty && res.1 > 0 {
                    try socket.connectTo(host: res.0, port: res.1 , enableTLS: false, tlsSettings: nil)
                } else {
                    try socket.connectTo(host: host, port: port, enableTLS: false, tlsSettings: nil)
                }
            } else {
                try socket.connectTo(host: host, port: port, enableTLS: false, tlsSettings: nil)
            }
        } catch let error {
            observer?.signal(.errorOccured(error, on: self))
            disconnect()
        }
    }

    override public func didConnectWith(socket: RawTCPSocketProtocol) {
        super.didConnectWith(socket: socket)

        internalStatus = .connected

        protocolObfuscater.start()
    }

    override public func didRead(data: Data, from socket: RawTCPSocketProtocol) {
        super.didRead(data: data, from: socket)
        
        do {
            try protocolObfuscater.input(data: data)
            ShadowsocksAdapter.reset_connect_times()
        } catch {
            disconnect()
        }
    }

    public override func write(data: Data) {
        streamObfuscator.output(data: data)
    }

    public func write(rawData: Data) {
        super.write(data: rawData)
    }

    public func input(data: Data) {
        delegate?.didRead(data: data, from: self)
    }

    public func output(data: Data) {
        write(rawData: data)
    }

    override public func didWrite(data: Data?, by socket: RawTCPSocketProtocol) {
        super.didWrite(data: data, by: socket)

        protocolObfuscater.didWrite()

        switch internalStatus {
        case .forwarding:
            delegate?.didWrite(data: data, by: self)
        default:
            return
        }
    }

    func becomeReadyToForward() {
        internalStatus = .forwarding
        observer?.signal(.readyForForward(self))
        delegate?.didBecomeReadyToForwardWith(socket: self)
    }
}
