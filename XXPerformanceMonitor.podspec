Pod::Spec.new do |spec|

  spec.name         = "XXPerformanceMonitor"
  spec.version      = "1.0.0"
  spec.summary      = "Swift版轻量卡顿监控工具，支持主线程和子线程，一句代码即可轻松集成"
  spec.homepage     = "https://github.com/HJTXX/XXPerformanceMonitor"
  spec.license      = "MIT"
  spec.author       = { "huangjie13" => "517050790@qq.com" }
  
  spec.source       = { :git => "https://github.com/HJTXX/XXPerformanceMonitor.git", :tag => spec.version }
  spec.source_files  = "XXPerformanceMonitor/Source/*.swift"
  spec.platform      = :ios, '9.0'
  spec.swift_version = '5.0'
  spec.requires_arc = true

end
