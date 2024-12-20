//
//  GlobalManager.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SwiftyJSON



@objcMembers
class GlobalManager: NSObject {
    static let manager = GlobalManager()
    var appDelegate: AppDelegate!
    private var timingManagerPrivate = ChatDataManager()
    
    var timingManager: ChatDataManager {
        get {
            timingManagerPrivate
        }
    }
    
    @objc var isEncry: Bool = true
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
    
    var isShowLogin: Bool = false
    
    private override init() {
        super.init()
    }
    
    private var headPrefix: String? = nil
    private var chatPrefix: String? = nil
    
    var change_rate: String? = ""
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
    func login(isLogin: Bool) {
        isShowLogin = false
        appDelegate.updateAppRoot()
        
        if isLogin {
            Socket.shared.connect()
            finishRefreshToken = true
//            NotificationCenter.default.post(name: ConstantKey.NSNotificationRefreshToken, object: nil)
        }
    }
    
    func logout() {
        self.timingManagerPrivate.stopLoad()
        if isShowLogin {
            return
        }
        Socket.shared.leaveGroup()
        Socket.shared.disconnect()
        
        isShowLogin = true
        updateRefreshToken(refreshToken: nil)
        updateToken(token: nil)
        appDelegate.updateAppRoot()
    }
    //    func cleanLocalData() {
    //        DBManager.share.deleteTabble(tableName: GroupEntity.tableName)
    //        DBManager.share.deleteTabble(tableName: MessageEntity.tableName)
    //        DBManager.share.deleteTabble(tableName: RedPacketGetEntity.tableName)
    //    }
    // 刷新token
    func immediateRefreshToken() {
        timingManager.updateTokenTimeout(timeout: 0)
    }
    func isRefreshTokenNow() -> Bool {
        return timingManager.isRefreshingToken
    }
    func appendWaitRequest(_ request: YTKBaseRequest) {
        timingManager
            .appendRequest(request)
    }
    var finishRefreshToken: Bool = false
    

    private var hString: String? = nil
    static func h() -> String {
        guard let h = self.manager.hString else {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                let v = appVersion.replacingOccurrences(of: ".", with: "")
                self.manager.hString = "01100" + v + "0001"
                return self.manager.hString!
            }
            return ""
        }
        return h
    }
}

extension GlobalManager {
    func setup() {
        refreshTokenValue = getRefreshToken()
        tokenValue = getToken()
        personModelValue = PersonModel.getPerson()
        isShowLogin = (refreshToken != nil) ? false : true
        self.headPrefix = WXUserDefault.headPrefix()
        self.chatPrefix = WXUserDefault.chatPrefix()
//        if refreshTokenValue != nil {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//                
//                self.requestRefreshToken()
//            }
//        }
    }
    
    private func getRefreshToken() -> String? {
        UserDefaults.standard.object(forKey: "refreshToken") as? String
    }
    private func getToken() -> String? {
        UserDefaults.standard.object(forKey: "token") as? String
    }
    
    func refreshUserInfo(completed: @escaping ((_: Error?)->())) {
        let infoRequest = UserInfoRequest()
        infoRequest.startWithCompletionBlock { request in
            if let resp = try? JSONDecoder().decode(PersonModel.self, from: request.wxResponseData()) {
                GlobalManager.manager.updatePersonModel(model: resp)
            }
            completed(nil)
        } failure: { request in
            completed(request.error)
        }
    }
    
    static func headImageUrl(name: String?) -> URL? {
        guard let headPrefix = self.manager.headPrefix else {
            return nil
        }
        guard let fileName = name else {
            return nil
        }
        return URL(string: headPrefix + fileName)
    }
    static func chatImageUrl(name: String?) -> URL? {
//        if name?.hasPrefix("http://") ?? false ||
//            name?.hasPrefix("https://") ?? false {
//            return URL(string: name!)
//        }
        guard let chatPrefix = self.manager.chatPrefix else {
            return nil
        }
        guard let fileName = name else {
            return nil
        }
        return URL(string: chatPrefix + fileName)
    }
    func getConfigInfo(result: ((NSError?)->Void)? = nil) {
        let request = ConfigRequest()
        request.startWithCompletionBlock { request in
            if let json = try? JSON(data: request.wxResponseData()) {
                let configs: Array<JSON> = json["configs"].arrayValue
                for config in configs {
                    if let attribute = config["attribute"].string,
                       attribute == "url_prefix",
                       let values = config["values"].string as? NSString {
                        if let valuesDic = values.mj_JSONObject() as? [NSString: NSString] {
                            let headPrefix = valuesDic["head"] as? String
                            if self.headPrefix != headPrefix {
                                NotificationCenter.default.post(name: ConstantKey.NSNotificationConfigUpdate, object: nil)
                                self.headPrefix = headPrefix
                                WXUserDefault.updateHeadPrefix(str: headPrefix)
                                continue
                            }
                            let chatPrefix = valuesDic["chat"] as? String
                            if self.chatPrefix != chatPrefix {
                                NotificationCenter.default.post(name: ConstantKey.NSNotificationConfigUpdate, object: nil)
                                self.chatPrefix = chatPrefix
                                WXUserDefault.updateChatPrefix(str: chatPrefix)
                                continue
                            }
                        }
                        continue
                    }
                    
                    if let attribute = config["attribute"].string,
                       attribute == "change_rate",
                       let values = config["values"].string {
                        self.change_rate = values
                        continue
                    }
                }
                result?(nil)
            }
        } failure: { request in
            result?(request.error as NSError?)
        }
    }
}
