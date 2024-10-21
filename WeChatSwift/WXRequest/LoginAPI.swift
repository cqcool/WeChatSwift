//
//  LoginAPI.swift
//  WeChatSwift
//
//  Created by ios_cloud on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

class LoginRequest: DNKRequest {
    
    @objc let account: String = "18259895600"
    @objc let device: String = "iPhone mini"
    @objc let deviceId: String = "111222333xxidls3"
    @objc let password: String = "Wx123456"
    
    
    override func requestUrl() -> String {
        "/user/login"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}
