import Foundation

extension Date {
    var milliStamp : UInt64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return UInt64(millisecond)
    }
}

var timerQueue = DispatchQueue.global()
var timer = DispatchSource.makeTimerSource(queue: timerQueue)
public struct Utils {
    public static func StartFreeTimeTimer() -> Void {
        timer.schedule(deadline: .now(), repeating: 1)
        timer.setEventHandler { [] in
            let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn")
            var mLeftFreeUseTimeMilli: Int64 = Int64(userDefaults?.integer(forKey: "mLeftFreeUseTimeMilli") ?? 0)
            if (mLeftFreeUseTimeMilli >= 1000) {
                mLeftFreeUseTimeMilli -= 1000
                userDefaults?.set(mLeftFreeUseTimeMilli, forKey: "mLeftFreeUseTimeMilli")
            } else {
                exit(0)
            }

            let nowDayTm: Int64 = Int64(Date().milliStamp) / (24 * 3600 * 1000)
            var mTodayFreeDayTm = Int64(userDefaults?.integer(forKey: "mTodayFreeDayTm") ?? 0)
            if (mTodayFreeDayTm != nowDayTm) {
                mLeftFreeUseTimeMilli = 3600 * 1000;
                mTodayFreeDayTm = nowDayTm
                userDefaults?.set(mTodayFreeDayTm, forKey: "mTodayFreeDayTm")
                userDefaults?.set(mLeftFreeUseTimeMilli, forKey: "mLeftFreeUseTimeMilli")
            }

        }
        timer.resume()

    }

    
    public struct HTTPData {
        public static let DoubleCRLF = "\r\n\r\n".data(using: String.Encoding.utf8)!
        public static let CRLF = "\r\n".data(using: String.Encoding.utf8)!
        public static let ConnectSuccessResponse = "HTTP/1.1 200 Connection Established\r\n\r\n".data(using: String.Encoding.utf8)!
    }

    public struct DNS {
        // swiftlint:disable:next nesting
        public enum QueryType {
            // swiftlint:disable:next type_name
            case a, aaaa, unspec
        }

        public static func resolve(_ name: String, type: QueryType = .unspec) -> String {
            let remoteHostEnt = gethostbyname2((name as NSString).utf8String, AF_INET)

            if remoteHostEnt == nil {
                return ""
            }

            let remoteAddr = UnsafeMutableRawPointer(remoteHostEnt?.pointee.h_addr_list[0])

            var output = [Int8](repeating: 0, count: Int(INET6_ADDRSTRLEN))
            inet_ntop(AF_INET, remoteAddr, &output, socklen_t(INET6_ADDRSTRLEN))
            return NSString(utf8String: output)! as String
        }
    }

    // swiftlint:disable:next type_name
    public struct IP {
        public static func isIPv4(_ ipAddress: String) -> Bool {
            if IPv4ToInt(ipAddress) != nil {
                return true
            } else {
                return false
            }
        }

        public static func isIPv6(_ ipAddress: String) -> Bool {
            let utf8Str = (ipAddress as NSString).utf8String
            var dst = [UInt8](repeating: 0, count: 16)
            return inet_pton(AF_INET6, utf8Str, &dst) == 1
        }

        public static func isIP(_ ipAddress: String) -> Bool {
            return isIPv4(ipAddress) || isIPv6(ipAddress)
        }

        public static func IPv4ToInt(_ ipAddress: String) -> UInt32? {
            let utf8Str = (ipAddress as NSString).utf8String
            var dst = in_addr(s_addr: 0)
            if inet_pton(AF_INET, utf8Str, &(dst.s_addr)) == 1 {
                return UInt32(dst.s_addr)
            } else {
                return nil
            }
        }

        public static func IPv4ToBytes(_ ipAddress: String) -> [UInt8]? {
            if let ipv4int = IPv4ToInt(ipAddress) {
                return Utils.toByteArray(ipv4int).reversed()
            } else {
                return nil
            }
        }

        public static func IPv6ToBytes(_ ipAddress: String) -> [UInt8]? {
            let utf8Str = (ipAddress as NSString).utf8String
            var dst = [UInt8](repeating: 0, count: 16)
            if inet_pton(AF_INET6, utf8Str, &dst) == 1 {
                return Utils.toByteArray(dst).reversed()
            } else {
                return nil
            }
        }
    }

    struct GeoIPLookup {

        static func Lookup(_ ipAddress: String) -> String? {
            if Utils.IP.isIP(ipAddress) {
                guard let result = GeoIP.LookUp(ipAddress) else {
                    return "--"
                }
                return result.isoCode
            } else {
                return nil
            }
        }
    }

    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) {
            Array($0)
        }
    }

    struct Random {
        static func fill(data: inout Data, from: Int = 0, to: Int = -1) {
            let c = data.count
            data.withUnsafeMutableBytes {
                arc4random_buf($0.baseAddress!.advanced(by: from), to == -1 ? c - from : to - from)
            }
        }

        static func fill(data: inout Data, from: Int = 0, length: Int) {
            fill(data: &data, from: from, to: from + length)
        }
    }
}
