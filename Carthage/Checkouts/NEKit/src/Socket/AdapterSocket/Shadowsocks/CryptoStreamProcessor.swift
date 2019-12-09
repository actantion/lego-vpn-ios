import Foundation

extension ShadowsocksAdapter {
    public static let kChangeLocalPublicKey = "kChangeLocalPublicKey"
    public class CryptoStreamProcessor {
        public class Factory {
            let password: String
            let algorithm: CryptoAlgorithm
            let key: Data

            public init(password: String, algorithm: CryptoAlgorithm) {
                self.password = password
                self.algorithm = algorithm
                key = CryptoHelper.getKey(password, methodType: algorithm)
            }

            public func build(in_pubkey: String, in_method: String) -> CryptoStreamProcessor {
                let array : Array = in_method.components(separatedBy: ",")
                var vpn_ip = UInt32(array[1]) as! UInt32
                var vpn_port = UInt16(array[2]) as! UInt16
                var smart_route = Bool(array[3]) as! Bool
                return CryptoStreamProcessor(
                    key: key,
                    algorithm: algorithm,
                    pubkey: in_pubkey,
                    method: array[0],
                    choose_vpn_ip: vpn_ip,
                    choose_vpn_port: vpn_port,
                    use_smart_route: smart_route)
            }
        }

        public weak var inputStreamProcessor: StreamObfuscater.StreamObfuscaterBase!
        public weak var outputStreamProcessor: ProtocolObfuscater.ProtocolObfuscaterBase!

        var readIV: Data!
        let key: Data
        let algorithm: CryptoAlgorithm

        var sendKey = false
        var local_public_key = "555555555555555555555555555555555"
        var method = "aes-256-cfb"
        
        var choose_vpn_node_int_ip: UInt32 = 0
        var choose_vpn_node_port: UInt16 = 0
        var use_smart_route: Bool = false

        var buffer = Buffer(capacity: 0)

        var get_cryptor_times = 0
        
        lazy var writeIV: Data = {
            [unowned self] in
            CryptoHelper.getIV(self.algorithm)
            }()
        lazy var ivLength: Int = {
            [unowned self] in
            CryptoHelper.getIVLength(self.algorithm)
            }()
        lazy var encryptor: StreamCryptoProtocol = {
            [unowned self] in
            self.getCrypto(.encrypt)
            }()
        lazy var decryptor: StreamCryptoProtocol = {
            [unowned self] in
            self.getCrypto(.decrypt)
            }()

        init(
                key: Data,
                algorithm: CryptoAlgorithm,
                pubkey: String,
                method: String,
                choose_vpn_ip: UInt32,
                choose_vpn_port: UInt16,
                use_smart_route: Bool) {
            //self.key = key
            self.algorithm = algorithm
            self.local_public_key = pubkey
            self.method = method
            self.choose_vpn_node_int_ip = choose_vpn_ip
            self.choose_vpn_node_port = choose_vpn_port
            self.use_smart_route = use_smart_route
            self.key = key
        }

        func changeLocalPublicKey(local_pubkey: String) {
            local_public_key = local_pubkey;
        }
        
        func encrypt(data: inout Data) {
            return encryptor.update(&data)
        }

        func decrypt(data: inout Data) {
            return decryptor.update(&data)
        }

        public func input(data: Data) throws {
            var data = data
            if data.count == 3 {
                let tmp_data = String(data: data, encoding: String.Encoding.utf8) as String?
                if tmp_data == "bwo" || tmp_data == "cni" || tmp_data == "oul" {
                    let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
                    userDefaults?.set(tmp_data, forKey: "vpnsvr_status")
                    _exit(1)
                }
            }
          
            if readIV == nil {
                buffer.append(data: data)
                readIV = buffer.get(length: ivLength)
                guard readIV != nil else {
                    try inputStreamProcessor!.input(data: Data())
                    return
                }

                data = buffer.get() ?? Data()
                buffer.release()
            }

            decrypt(data: &data)
            try inputStreamProcessor!.input(data: data)
        }
        
        private func StrIpToUint32(ip: String) -> UInt32 {
            var addr = in_addr()
            if inet_pton(AF_INET, ip, &addr) == 1 {
                let ipAddress = addr.s_addr
                return ipAddress
            } else {
                return 0
            }
        }

        private func relayData(withData data: Data) -> Data {
            let method = "ios"
            var start_pos = 0
            if (self.use_smart_route) {
                start_pos = 6
            }
            
            let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
            let ex_route_ip: UInt32 = UInt32(userDefaults?.string(forKey: "ex_route_ip_int") ?? "0") ?? 0
            let ex_route_port: UInt16 = UInt16(userDefaults?.string(forKey: "ex_route_port_int") ?? "0") ?? 0
            if (ex_route_ip > 0) {
                start_pos += 6;
            }
            
            let public_len = 66
            let length = start_pos + public_len + 1 + method.utf8.count + data.count
            var response = Data(count: length)
            if (self.use_smart_route) {
                if (ex_route_ip > 0) {
                    var beip = ex_route_ip
                    withUnsafeBytes(of: &beip) {
                        response.replaceSubrange(0..<4, with: $0)
                    }
                    
                    var beport = UInt16(ex_route_port).bigEndian
                    withUnsafeBytes(of: &beport) {
                        response.replaceSubrange(4..<6, with: $0)
                    }
                    
                    var beip1 = UInt32(self.choose_vpn_node_int_ip)
                    withUnsafeBytes(of: &beip1) {
                        response.replaceSubrange(6..<10, with: $0)
                    }
                    
                    var beport1 = UInt16(self.choose_vpn_node_port).bigEndian
                    withUnsafeBytes(of: &beport1) {
                        response.replaceSubrange(10..<12, with: $0)
                    }
                } else {
                    var beip = UInt32(self.choose_vpn_node_int_ip)
                    withUnsafeBytes(of: &beip) {
                        response.replaceSubrange(0..<4, with: $0)
                    }
                    
                    var beport = UInt16(self.choose_vpn_node_port).bigEndian
                    withUnsafeBytes(of: &beport) {
                        response.replaceSubrange(4..<6, with: $0)
                    }
                }                
            }
            
            response.replaceSubrange(start_pos..<(start_pos + public_len), with: self.local_public_key.utf8)
            response[start_pos + public_len] = UInt8(method.utf8.count)
            response.replaceSubrange(
                (start_pos + public_len + 1)..<(start_pos + public_len + 1 + method.utf8.count),
                with: method.utf8)
            response.replaceSubrange((start_pos + public_len + 1 + method.utf8.count)..<length, with: data)
            return response
        }

        
        public func output(data: Data) {
            var data = data
            encrypt(data: &data)
            //assert(false, "fuck it")
            if sendKey {
                return outputStreamProcessor!.output(data: data)
            } else {
                sendKey = true
                var out = Data(capacity: data.count + writeIV.count)
                out.append(writeIV)
                out.append(data)
                
                return outputStreamProcessor!.output(data: relayData(withData: out))
            }
        }

        private func getCrypto(_ operation: CryptoOperation) -> StreamCryptoProtocol {
            switch algorithm {
            case .AES128CFB, .AES192CFB, .AES256CFB:
                switch operation {
                case .decrypt:
                    return CCCrypto(operation: .decrypt, mode: .cfb, algorithm: .aes, initialVector: readIV, key: key)
                case .encrypt:
                    return CCCrypto(operation: .encrypt, mode: .cfb, algorithm: .aes, initialVector: writeIV, key: key)
                }
            case .CHACHA20:
                switch operation {
                case .decrypt:
                    return SodiumStreamCrypto(key: key, iv: readIV, algorithm: .chacha20)
                case .encrypt:
                    return SodiumStreamCrypto(key: key, iv: writeIV, algorithm: .chacha20)
                }
            case .SALSA20:
                switch operation {
                case .decrypt:
                    return SodiumStreamCrypto(key: key, iv: readIV, algorithm: .salsa20)
                case .encrypt:
                    return SodiumStreamCrypto(key: key, iv: writeIV, algorithm: .salsa20)
                }
            case .RC4MD5:
                var combinedKey = Data(capacity: key.count + ivLength)
                combinedKey.append(key)
                switch operation {
                case .decrypt:
                    combinedKey.append(readIV)
                    return CCCrypto(operation: .decrypt, mode: .rc4, algorithm: .rc4, initialVector: nil, key: MD5Hash.final(combinedKey))
                case .encrypt:
                    combinedKey.append(writeIV)
                    return CCCrypto(operation: .encrypt, mode: .rc4, algorithm: .rc4, initialVector: nil, key: MD5Hash.final(combinedKey))
                }
            }
        }
    }
}
