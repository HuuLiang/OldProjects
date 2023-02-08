//
//  CMCConfig.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import XCGLogger
import EZSwiftExtensions
import ObjectMapper

//public typealias ResponseCallback = (_ responseDic: [String: NSObject]?, _ error: NSError?) -> Void
//public typealias ResponseCallback = (_ responseObj: Mappable, _ error: NSError?) -> Void

///public let AFAppDotNetAPIBaseURLString: NSString = "https://test-service-app.ishaohuo.cn/"

enum CMCError: Error, CustomDebugStringConvertible {
    case jsonSerializedFailed
    case responseError(code: Int, message: String)
    case verifyTextFieldError(message: String)
    
    static func converResponseError(error: NSError) -> CMCError {
        return .responseError(code: error.code, message: error.localizedFailureReason ?? "")
    }
    
    var debugDescription: String {
        switch self {
        case .jsonSerializedFailed:
            return "jsonSerializedFailed"
        case .responseError(let code, let message):
            return "responseError code: \(code), msg: \(message)"
        case .verifyTextFieldError(let message):
            return "verifyTextFieldError msg: \(message)"
        }
    }
}

struct CMCConfig {
    /// 友盟推送
    static let UMengPushAppKey = "591e647eb27b0a051d000d1a"
    static let UMengPushAppMasterSecret = "y93ojrapye4ssmtxzxoosu2oeygphtem"
    
    static let CustomServicePhoneNumber = "400-181-3838"
}

struct CMCColor {
    
    static let viewBackgroundColor: UIColor = UIColor(hexString: "EBEBF2")!
    static let loginViewBackgroundColor = UIColor(hexString: "F2F2F2")
    
    static let normalButtonBackgroundColor: UIColor = UIColor(hexString: "9C9C9C")!
    static let hlightedButtonBackgroundColor: UIColor = UIColor(hexString: "FD8027")!
    
   // static let
    
    static let segmentedBorderColor: UIColor = UIColor(hexString: "DDDDDD")!
    
    static let normalLineColor: UIColor  = UIColor(hexString: "DFDFDF")!
    
    static let navbarGradientColor = [UIColor(hexString: "FCAF5B")!.cgColor,
                                      UIColor(hexString: "FB9B42")!.cgColor,
                                      UIColor(hexString: "FA6B1F")!.cgColor]
}

struct PageListModel {
    // 客户端开始编号
    var from: String = "0"
    // 客户端最后一条记录编号
    var last: String = "0"
    // 页码
    var size: Int = 20
    // 最后一页了
    var lastPage: Bool = false
}

/// log config
let log: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
    
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
    
    // Optionally set some configuration options
    systemDestination.outputLevel = .debug
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = true
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    
    // Add the destination to the logger
    log.add(destination: systemDestination)
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " \r\n", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " \r\n", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " \r\n", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " \r\n", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " \r\n", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " \r\n", to: .severe)
    log.formatters = [emojiLogFormatter]
    
    return log
}()
