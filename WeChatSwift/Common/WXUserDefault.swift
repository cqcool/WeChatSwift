//
//  WXUserDefault.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/25.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

class WXUserDefault {
    
    private static let HEAD_PREFIX_KEY = "HEAD_PREFIX_KEY"
    static func updateHeadPrefix(str: String?) {
        if str == nil {
            UserDefaults.standard.removeObject(forKey: HEAD_PREFIX_KEY)
            return
        }
        UserDefaults.standard.set(str, forKey: HEAD_PREFIX_KEY)
        UserDefaults.standard.synchronize()
    }
    static func headPrefix() -> String? {
        UserDefaults.standard.object(forKey: HEAD_PREFIX_KEY) as? String
    }
    
    private static let CHAT_PREFIX_KEY = "CHAT_PREFIX_KEY"
    static func updateChatPrefix(str: String?) {
        if str == nil {
            UserDefaults.standard.removeObject(forKey: CHAT_PREFIX_KEY)
            return
        }
        UserDefaults.standard.set(str, forKey: CHAT_PREFIX_KEY)
        UserDefaults.standard.synchronize()
    }
    static func chatPrefix() -> String? {
        UserDefaults.standard.object(forKey: CHAT_PREFIX_KEY) as? String
    }
}
