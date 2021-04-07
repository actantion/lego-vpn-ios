import Foundation
import Resolver

struct GlobalIntializer {
    private static let _initialized: Bool = {
        Resolver.queue = QueueFactory.getQueue()
        Utils.StartFreeTimeTimer()
        return true
    }()

    static func initalize() {
        _ = _initialized
    }
}
