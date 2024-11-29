//
//  AppConfiguration.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/9/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum AppConfiguration: String {
    case debug
    case inhouse
    case release
    case dev
    
    static func current() -> AppConfiguration {
        #if DEBUG
        return .debug
        #elseif INHOUSE
        return .inhouse
        #else
        return .release
        #endif
    }
    
}

@objcMembers
class AppConfig: NSObject {
#if DEBUG
    static var type: AppConfiguration = .debug
#else
    static var type: AppConfiguration = .inhouse
#endif
    class func baseUrl() -> String {
        if (type == .debug) {
            return "http://47.237.154.200:6001"
        }
        if (type == .inhouse) {
            return "https://ap.x3yd.com"
        }
        return ""
    }
    class func socketUrl() -> String {
        if (type == .debug) {
            return "ws://47.237.154.200:6002"
        }
        if (type == .inhouse) {
            return "https://we.x3yd.com"
        }
        return ""
    }
}
