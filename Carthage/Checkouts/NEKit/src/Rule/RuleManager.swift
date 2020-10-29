import Foundation

/// The class managing rules.
open class RuleManager {
    /// The current used `RuleManager`, there is only one manager should be used at a time.
    ///
    /// - note: This should be set before any DNS or connect sessions.
//    public static var currentManager: RuleManager = RuleManager(fromRules: [], ssRule: DirectRule(), appendDirect: true)
    public static var currentManager: RuleManager = RuleManager(fromRules: [], appendDirect: true)

    /// The rule list.
    var rules: [Rule] = []
    var ssRule: Rule? = nil

    open var observer: Observer<RuleMatchEvent>?

    /**
     Create a new `RuleManager` from the given rules.

     - parameter rules:        The rules.
     - parameter appendDirect: Whether to append a `DirectRule` at the end of the list so any request does not match with any rule go directly.
     */
//    public init(fromRules rules: [Rule], ssRule: Rule, appendDirect: Bool = false) {
    public init(fromRules rules: [Rule], appendDirect: Bool = false) {
        self.rules = rules
        if appendDirect ||  self.rules.count == 0 {
            self.rules.append(DirectRule())
        }

        observer = ObserverFactory.currentFactory?.getObserverForRuleManager(self)
    }

    /**
     Match DNS request to all rules.

     - parameter session: The DNS session to match.
     - parameter type:    What kind of information is available.
     */
    func matchDNS(_ session: DNSSession, type: DNSSessionMatchType) {
        for (i, rule) in rules[session.indexToMatch..<rules.count].enumerated() {
            let result = rule.matchDNS(session, type: type)

            observer?.signal(.dnsRuleMatched(session, rule: rule, type: type, result: result))

            switch result {
            case .fake, .real, .unknown:
                session.matchedRule = rule
                session.matchResult = result
                session.indexToMatch = i + session.indexToMatch // add the offset
                return
            case .pass:
                break
            }
        }
    }

    /**
     Match connect session to all rules.

     - parameter session: connect session to match.

     - returns: The matched configured adapter.
     */
    func match(_ session: ConnectSession) -> AdapterFactory! {
//        let userDefaults = UserDefaults(suiteName: "group.com.tenon.tenonvpn.groups")
//        let global_mode: UInt32 = UInt32(userDefaults?.string(forKey: "global_mode") ?? "0") ?? 0
//        if (global_mode == 1) {
//            session.matchedRule = self.ssRule
//            observer?.signal(.ruleMatched(session, rule: session.matchedRule!))
//            return session.matchedRule!.match(session)
//        }
//
        if session.matchedRule != nil {
            observer?.signal(.ruleMatched(session, rule: session.matchedRule!))
            return session.matchedRule!.match(session)
        }

        for rule in rules {
            if let adapterFactory = rule.match(session) {
                observer?.signal(.ruleMatched(session, rule: rule))

                session.matchedRule = rule
                return adapterFactory
            } else {
                observer?.signal(.ruleDidNotMatch(session, rule: rule))
            }
        }
        return nil // this should never happens
    }
}
