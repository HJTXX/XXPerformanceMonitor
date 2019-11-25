//
//  XXChildThreadMonitor.swift
//  XXPerformanceMonitor
//
//  Created by Huang,Jie on 2019/11/11.
//  Copyright © 2019 HJTXX. All rights reserved.
//

import UIKit

class XXChildThreadMonitor: NSObject {
    private let pingThread: XXPingChildThread
    var queues: [OperationQueue] {
        return pingThread.queues
    }

    public init(_ threshold: CGFloat, catchHandler: @escaping (OperationQueue) -> Void) {
        pingThread = XXPingChildThread(threshold, handler: catchHandler)
        pingThread.start()
        super.init()
    }

    func addQueue(_ queue: OperationQueue) {
        pingThread.addQueue(queue)
    }

    func removeQueue(_ queue: OperationQueue) {
        pingThread.removeQueue(queue)
    }

    deinit {
        pingThread.cancel()
    }
}

private final class XXPingChildThread: Thread {
    private let threshold: CGFloat
    private let catchHandler: (OperationQueue) -> Void
    private(set) var queues: [OperationQueue] = [] // 需要监测的queue
    private(set) var executingOperations: [OperationQueue: Operation] = [:] // 各queue正在执行的operation

    init(_ t: CGFloat, handler: @escaping (OperationQueue) -> Void) {
        threshold = t
        catchHandler = handler
        super.init()
    }

    func addQueue(_ queue: OperationQueue) {
        if queues.contains(queue) {
            executingOperations.removeValue(forKey: queue) // 重复添加，重新开始
        } else {
            queues.append(queue)
        }
    }

    func removeQueue(_ queue: OperationQueue) {
        queues = queues.filter{ $0 != queue }
    }

    override func main() {
        while !isCancelled {
            autoreleasepool {
                var isNewOperations: [OperationQueue: Bool] = [:]
                queues.forEach { (queue) in
                    if executingOperations[queue] == nil &&
                        queue.operations.first?.isExecuting == true {
                        executingOperations[queue] = queue.operations.first
                        isNewOperations[queue] = true
                    }
                }

                Thread.sleep(forTimeInterval: TimeInterval(threshold))

                queues.forEach { (queue) in
                    if executingOperations[queue]?.isExecuting == true {
                        if isNewOperations[queue] == true {
                            catchHandler(queue)
                        }
                    } else {
                        executingOperations[queue] = nil
                    }
                }
            }
        }
    }
}
