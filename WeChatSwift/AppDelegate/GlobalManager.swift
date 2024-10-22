//
//  GlobalManager.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SwiftyJSON



@objcMembers
class GlobalManager: NSObject {
    static let manager = GlobalManager()
    var appDelegate: AppDelegate!
    
    @objc var isEncry: Bool = false
    private var refreshTokenValue: String? = nil
    @objc var refreshToken: String? {
        get {
            refreshTokenValue
        }
    }
    private var tokenValue: String? = nil
    @objc var token: String? {
        get {
            tokenValue
        }
    }
    
    private var personModelValue: PersonModel? = nil
    @objc var personModel: PersonModel? {
        get {
            personModelValue
        }
    }

    private var isShowLogin: Bool = false
    
    private override init() {
        super.init()
        setup()
    }
    
    func updateRefreshToken(refreshToken: String?) {
        refreshTokenValue = refreshToken
        guard let refreshToken else {
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            return
        }
        UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
    }
    func updateToken(token: String?) {
        tokenValue = token
        guard let token else {
            UserDefaults.standard.removeObject(forKey: "token")
            return
        }
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    func updatePersonModel(model: PersonModel?) {
        personModelValue = model
        if personModel == nil {
            PersonModel.clearPerson()
            return
        }
       PersonModel.savePerson(person: model!)
    }
    func login() {
        isShowLogin = false
        appDelegate.updateAppRoot()
    }
    
    func logout() {
        if isShowLogin {
            return
        }
        isShowLogin = true
        updateRefreshToken(refreshToken: nil)
        updateToken(token: nil)
        appDelegate.updateAppRoot()
    }
    // 刷新token
    func requestRefreshToken() {
        let refreshRquest = RefreshTokenRequest()
        refreshRquest.startWithCompletionBlock { request in
            guard let responseData = request.responseData else {
                return
            }
            let json = try? JSON(data: responseData)
            if let refreshToken = json?["data"]["refreshToken"].string {
                GlobalManager.manager.updateRefreshToken(refreshToken: refreshToken)
                self.refreshUserInfo()
                self.getConfigInfo()
                NotificationCenter.default.post(name: ConstantKey.NSNotificationRefreshToken, object: nil)
            }
        }

    }
}

extension GlobalManager {
    private func setup() {
        refreshTokenValue = getRefreshToken()
        tokenValue = getToken()
        personModelValue = PersonModel.getPerson()
        isShowLogin = (refreshToken != nil) ? false : true 
    }
    
    private func getRefreshToken() -> String? {
        UserDefaults.standard.object(forKey: "refreshToken") as? String
    }
    private func getToken() -> String? {
        UserDefaults.standard.object(forKey: "token") as? String
    }
    
    private func refreshUserInfo() {
        let infoRequest = UserInfoRequest()
        infoRequest.startWithCompletionBlock { request in
            if let resp = try? JSONDecoder().decode(PersonModel.self, from: request.wxResponseData()) {
                 GlobalManager.manager.updatePersonModel(model: resp)
             }
        }
    }
    
    private func getConfigInfo() {
        let request = ConfigRequest()
        request.startWithCompletionBlock { request in
            
//            print(request.responseString)
            
        }
    }
}
