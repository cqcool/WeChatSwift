//
//  LoginAPI.swift
//  WeChatSwift
//
//  Created by ios_cloud on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

class LoginRequest: DNKRequest {
    
    @objc let account: String
    @objc let device: String = DNKDevice.phoneModel()
    @objc var deviceId: String = ""
    @objc let password: String
    
    init(account: String, password: String) {
        self.account = account 
        self.password = password
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            deviceId = uuid
        }
    }
    
    override func requestUrl() -> String {
        "/user/login"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    } 
}
/// 退出登录
class LogoutRequest: DNKRequest {

    override func requestUrl() -> String {
        "/user/logout"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}

/// 获取临时token
class RefreshTokenRequest: DNKRequest { 
    
    override func requestUrl() -> String {
        "/user/refresh/token"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}

/// 用户信息
class UserInfoRequest: DNKRequest {
    
    override func requestUrl() -> String {
        "/user/userInfo"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}

/// 修改用户信息
class updateInfoRequest: DNKRequest {
    @objc var nickname: String? = nil
    @objc var head: String? = nil
    convenience init(nickname: String) {
        self.init()
        self.nickname = nickname
    }
    convenience init(head: String) {
        self.init()
        self.head = head
    }
    override func requestUrl() -> String {
        "/user/update"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}

/// 配置信息
class ConfigRequest: DNKRequest {
    
    override func requestUrl() -> String {
        "/config/info"
    }
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}
