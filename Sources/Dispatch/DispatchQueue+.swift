import Foundation
import Dispatch

extension DispatchQueue {
    public static var isMain: Bool {
        struct Static {
            static let key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return nil != getSpecific(key: Static.key)
    }

    public static func `is`(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer {
            queue.setSpecific(key: key, value: nil)
        }

        return nil != getSpecific(key: key)
    }

    public static func once(token: String, block: () -> Void) {
        struct Static {
            static var onceTracker = [String]()
        }

        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }

        if !Static.onceTracker.contains(token) {
            Static.onceTracker.append(token)
            block()
        }
    }

    public func safeAsync(execute block: @escaping () -> Void) {
        if self == .main && Thread.isMainThread {
            block()
        } else {
            async(execute: block)
        }
    }

    public func delay(timeInterval: DispatchTimeInterval, execute work: DispatchWorkItem) {
        asyncAfter(deadline: .now() + timeInterval, execute: work)
    }

    public func async(execute asyncTask: @escaping (@escaping () -> Void) -> Void) {
        precondition(self != .main)

        async {
            let semaphore = DispatchSemaphore(value: 0)
            autoreleasepool {
                asyncTask {
                    semaphore.signal()
                }
            }
            semaphore.wait()
        }
    }
}
