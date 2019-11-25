//
//  XXMainThreadMonitor.swift
//  XXPerformanceMonitor
//
//  Created by Huang,Jie on 2019/11/11.
//  Copyright © 2019 HJTXX. All rights reserved.
//

import UIKit

class XXMainThreadMonitor: NSObject {
    private let pingThread: XXPingMainThread

    public init(_ threshold: CGFloat, _ catchHandler: @escaping () -> Void) {
        pingThread = XXPingMainThread(threshold, catchHandler)
        pingThread.start()
        super.init()
    }

    deinit {
        pingThread.cancel()
    }
}

private final class XXPingMainThread: Thread {
    private let threshold: CGFloat
    private let catchHandler: () -> Void
    private let semaphore = DispatchSemaphore(value: 0)

    private let lockObj = NSObject()
    private var _isResponse = true
    private var isResponse: Bool {
        get {
            objc_sync_enter(lockObj)
            let result = _isResponse
            objc_sync_exit(lockObj)
            return result
        }

        set {
            objc_sync_enter(lockObj)
            _isResponse = newValue
            objc_sync_exit(lockObj)
        }
    }

    init(_ t: CGFloat, _ handler: @escaping () -> Void) {
        threshold = t
        catchHandler = handler
        super.init()
    }

    override func main() {
        while !isCancelled {
            autoreleasepool {
                isResponse = false
                DispatchQueue.main.async {
                    self.isResponse = true
                    self.semaphore.signal()
                }

                Thread.sleep(forTimeInterval: TimeInterval(threshold))
                if !isResponse {
                    catchHandler()
                }

                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            }
        }
    }
}

