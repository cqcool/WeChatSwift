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
/// 获取临时token
class RefreshTokenRequest: DNKRequest { 
    
    override func requestUrl() -> String {
        "/user/refresh/token"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}
