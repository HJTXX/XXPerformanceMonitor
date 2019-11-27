## XXPerformanceMonitor
![pod](https://img.shields.io/badge/pod-v1.0.2-yellow) ![platforms](https://img.shields.io/badge/platforms-iOS-brightgreen) ![support](https://img.shields.io/badge/support-iOS%209%2B-informational) ![lisence](https://img.shields.io/badge/lisence-MIT-lightgrey)

 Swift版轻量卡顿监控工具，支持主线程和子线程，一句代码即可轻松集成。

## 上手指南
根据项目需要，在合适的地方启动，一般无特殊要求可以放在`AppDelegate`的`didFinishLaunching`中。
一句代码即可启动主线程监控：
```
XXPerformanceMonitor.sharedInstance.startMonitorMain()
```
如果想要监听子线程队列，只需将其加入到监控器中：
```
let testQueue = OperationQueue()
XXPerformanceMonitor.sharedInstance.addMonitorChild(testQueue)
```
如果想停止监听，可以直接调用如下方法，关闭所有监控：
```
XXPerformanceMonitor.sharedInstance.clean()
```
同时也提供了单独移除子线程监控的方法：
```
XXPerformanceMonitor.sharedInstance.removeMonitorChild(testQueue)
```
并且提供了代理方法供外部获取卡顿信息：
```
public protocol XXPerformanceMonitorDelegate: class {
    func handleThread(reason: String, domain: XXPerformanceMonitorDomain)
}
```
更多详细请移步[天罗地网？ iOS卡顿监控实战](https://juejin.im/post/5db65fe0e51d452a1e58f37c)

## 安装
1. Cocoapods

```
pod 'XXPerformanceMonitor'
```

2. 下载源码，将Source文件夹添加到工程中。

## 其他
本库没有引入其他三方库，请放心使用。

有Bug或建议，欢迎issue。

如果使用还算顺畅，欢迎star ：）