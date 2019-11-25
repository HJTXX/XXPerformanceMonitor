//
//  XXPerformanceMonitor.swift
//  XXPerformanceMonitor
//
//  Created by Huang,Jie on 2019/11/11.
//  Copyright © 2019 HJTXX. All rights reserved.
//

import UIKit

public enum XXPerformanceMonitorDomain: String {
    case mainThread  = "HJTXX.MainThreadMonitoring"
    case childThread = "HJTXX.ChildThreadMonitoring"
}

public protocol XXPerformanceMonitorDelegate: class {
    func handleThread(reason: String, domain: XXPerformanceMonitorDomain)
}

public final class XXPerformanceMonitor: NSObject {
    public static let sharedInstance = XXPerformanceMonitor()
    public var mainThreadThreshold: CGFloat = 2
    public var childThreadThreshold: CGFloat = 2
    public weak var delegate: XXPerformanceMonitorDelegate?

    private var mainThreadMonitor: XXMainThreadMonitor?
    private var childThreadMonitor: XXChildThreadMonitor?

    public func startMonitorMain() {
        guard mainThreadMonitor == nil else { return }

        mainThreadMonitor = XXMainThreadMonitor(mainThreadThreshold) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.handleThread(reason: "👮‍♀️ MainThreadMonitor 👮‍♀️：主线程卡顿超过\(strongSelf.mainThreadThreshold)S", domain: .mainThread)
        }
    }

    public func addMonitorChild(_ queue: OperationQueue) {
        if childThreadMonitor == nil {
            childThreadMonitor = XXChildThreadMonitor(childThreadThreshold) { [weak self] (queue) in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.handleThread(reason: "👮‍♀️ ChildThreadMonitor 👮‍♀️：子线程【\(queue.name ?? "")】卡顿超过\(strongSelf.childThreadThreshold)S", domain: .childThread)
            }
        }

        childThreadMonitor?.addQueue(queue)
    }

    public func removeMonitorChild(_ queue: OperationQueue) {
        childThreadMonitor?.removeQueue(queue)
        if let queuesCount = childThreadMonitor?.queues.count, queuesCount <= 0 {
            childThreadMonitor = nil
        }
    }

    public func clean() {
        mainThreadMonitor = nil
        childThreadMonitor = nil
    }
}
