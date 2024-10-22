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
    private var personModelValue: PersonModel? = nil
    @objc var personModel: PersonModel? {
        get {
            personModelValue
        }
    }
    
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
    
    func updatePersonModel(model: PersonModel?) {
        personModelValue = model
        if personModel == nil {
            PersonModel.clearPerson()
            return
        }
       PersonModel.savePerson(person: model!)
    }
    func login() {
        appDelegate.updateAppRoot()
    }
    
    func logout() {
        updateRefreshToken(refreshToken: nil)
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
            }
        } failure: { request in
            
        }

    }
}

extension GlobalManager {
    private func setup() {
        refreshTokenValue = getRefreshToken()
        personModelValue = PersonModel.getPerson()
    }
    
    private func getRefreshToken() -> String? {
        UserDefaults.standard.object(forKey: "refreshToken") as? String
    }
    
}
