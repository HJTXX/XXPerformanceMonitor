//
//  ViewController.swift
//  XXPerformanceMonitor
//
//  Created by Huang,Jie on 2019/11/11.
//  Copyright © 2019 HJTXX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let testQueue1 = OperationQueue()
    private let testQueue2 = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["启动线程监控", "阻塞主线程", "子线程1-添加", "子线程1-移除", "子线程2-添加", "子线程2-移除"]
        for i in 0..<titles.count {
            let btn = UIButton(frame: CGRect(x: (Int(view.frame.width) - 200) / 2, y: 100 + i * 70, width: 200, height: 50))
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.backgroundColor = .red
            btn.addTarget(self, action: #selector(onTestClick(_:)), for: .touchUpInside)
            view.addSubview(btn)
        }

        testQueue1.name = "1"
        testQueue2.name = "2"

        XXPerformanceMonitor.sharedInstance.delegate = self
    }

    @objc func onTestClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            NSLog("启动主线程监控")
            XXPerformanceMonitor.sharedInstance.startMonitorMain()
        case 1:
            NSLog("开始阻塞主线程 \(Date().timeIntervalSince1970)")
            Thread.sleep(forTimeInterval: 6)
            NSLog("结束阻塞主线程 \(Date().timeIntervalSince1970)")
        case 2:
            NSLog("添加子线程1 \(Date().timeIntervalSince1970)")
            XXPerformanceMonitor.sharedInstance.addMonitorChild(testQueue1)
            testQueue1.addOperation {
                Thread.sleep(forTimeInterval: 6)
            }
        case 3:
            NSLog("移除子线程1 \(Date().timeIntervalSince1970)")
            XXPerformanceMonitor.sharedInstance.removeMonitorChild(testQueue1)
        case 4:
            NSLog("添加子线程2 \(Date().timeIntervalSince1970)")
            XXPerformanceMonitor.sharedInstance.addMonitorChild(testQueue2)
            testQueue2.addOperation {
                Thread.sleep(forTimeInterval: 6)
            }
        case 5:
            NSLog("移除子线程2 \(Date().timeIntervalSince1970)")
            XXPerformanceMonitor.sharedInstance.removeMonitorChild(testQueue2)
        default:
            break
        }
    }
}

extension ViewController: XXPerformanceMonitorDelegate {
    func handleThread(reason: String, domain: XXPerformanceMonitorDomain) {
        NSLog("\(domain): \(reason) \(Date().timeIntervalSince1970)")
    }
}

