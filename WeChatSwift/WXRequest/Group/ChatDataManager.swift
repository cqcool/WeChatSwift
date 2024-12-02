//
//  TimingGroupManager.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SwiftyJSON
import MJExtension 

protocol ChatDataDelegate {
    
    func willLoadAllChat()
    
    func didLoadAllChat(error: NSError?)
    
    func updateGroupList(list: [GroupEntity])
}
class ChatDataManager {
    private var timer: DispatchSourceTimer?
    
    private var delegates: [ChatDataDelegate] = []
    
    private var nextId: String? = nil
    /// 下个时间(根据上次返回请求)
    private var nextTime: String? = nil
    
    private var isLoading: Bool = false
    
    private var loadChatsTime = -1
    
    private var tokenTimeout: Int = 10
    
    @objc var isRefreshToken: Bool = true
    
    private let lock = NSLock()
    
    private var requestList: [YTKBaseRequest] = []
    private var onceUpdateUserInfo: Bool = false
    init() {
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshTokenEvent), name: ConstantKey.NSNotificationRefreshToken, object: nil)
    }
    
    func loadLocalData() {
        if let list = GroupEntity.queryGroupChats() {
            notify_updateGroupList(list: list)
        }
    }
    
    func startLoadData() {
        if let syncEntity = GroupSyncEntity.query() {
            nextId = syncEntity.nextId
            nextTime = syncEntity.nextTime
        }
        if nextId == nil ||
            nextTime == nil {
            notify_willLoadAllChat()
            loadChatData(isLoop: true)
        }
        startTimer()
    }
    func stopLoad() {
        // 停止计时器
        nextId = nil
        nextTime = nil
        timer?.cancel()
        timer = nil
        delegates = []
        tokenTimeout = 10
        requestList.removeAll()
        isRefreshToken = false
    }
    
    @objc func refreshTokenEvent() {
        lock.lock()
        isRefreshToken = false
        lock.unlock()
        if requestList.count == 0 {
            return
        }
        while (requestList.count > 0) {
            let request = requestList.first
            request?.start()
            requestList.remove(at: 0) 
        }
    }
    
    func appendRequest(_ request: YTKBaseRequest) {
        if let index = requestList.firstIndex(where: { $0.requestUrl() == request.requestUrl()}) {
            requestList[index] = request
            return
        }
        requestList.append(request)
    }
    private func startTimer() {
        // 创建一个立即执行，每1秒重复的定时器
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.setEventHandler {
            self.timerAction()
        }
        // 设置定时器立即执行，并且在1秒后重复执行
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 启动定时器
        timer?.activate()
        
    }
    private func timerAction() {
        
        tokenTimeout -= 1
        if tokenTimeout == 0 {
            lock.lock()
            isRefreshToken = true
            lock.unlock()
            requestRefreshToken()
        }
        
        if !isLoading {
            loadChatsTime += 1
            if loadChatsTime % 3 == 0 {
                loadChatData(isLoop: false)
            }
        }
    }
    
    func addDelegate(delegate: ChatDataDelegate) {
        delegates.append(delegate)
    }
    
    private func notify_willLoadAllChat() {
        for d in self.delegates {
            d.willLoadAllChat()
        }
    }
    private func notify_didLoadAllChat(error: NSError?) {
        for d in self.delegates {
            d.didLoadAllChat(error: error)
        }
    }
    private func notify_updateGroupList(list: [GroupEntity]) {
        for d in self.delegates {
            d.updateGroupList(list: list)
        }
    }
    
    func updateTokenTimeout(timeout: Int) {
        if timeout == -1 {
            // 说明刷新token失败，10s后重刷
            tokenTimeout = 10
            return
        }
        if timeout > 0 {
            // 提前30s刷新
            tokenTimeout = timeout / 1000 - 30
        }
    }
}

extension ChatDataManager {
    private func saveNext(id: String?, time: String?) {
        guard let id,
              let time else {
            return
        }
        let syncEntity = GroupSyncEntity()
        syncEntity.nextId = id
        syncEntity.nextTime = time
        syncEntity.userId = GlobalManager.manager.personModel?.userId
        GroupSyncEntity.insertOrReplace(entity: syncEntity)
    }
    private func loadChatData(isLoop: Bool) {
        self.isLoading = true
        let request = GroupListRequest()
        request.nextId = self.nextId
        request.nextTime = self.nextTime
        request.startWithCompletionBlock { request in
            self.isLoading = false
            if let json = try? JSON(data: request.wxResponseData()){
                let nextId = json["nextId"].string
                let nextTime = json["nextTime"].string
                guard let groupList = json["groupList"].arrayObject,
                      groupList.count > 0 else {
                    // 首次安装加载所有会话
                    if isLoop {
                        self.notify_didLoadAllChat(error: nil)
                    }
                    return
                }
                self.nextId = nextId
                self.nextTime = nextTime
                self.saveNext(id: self.nextId, time: self.nextTime)
                
                if let jsonData = (groupList as NSArray).mj_JSONData() {
                    do {
                        let resp = try JSONDecoder().decode([GroupEntity].self, from: jsonData)
                        let personModel = GlobalManager.manager.personModel
                        resp.forEach { $0.ownerId = personModel?.userId}
                        GroupEntity.insertOrReplace(list: resp)
                        let list = resp.filter { group in
                            if group.userMsgType == 2 || group.userMsgType == 3 {
                                return true
                            }
                            return group.groupType == 2 ? true : false
                        }
                        self.notify_updateGroupList(list: list)
                        if isLoop {
                            self.loadChatData(isLoop: true)
                        }
                    }  catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        } failure: {
            self.isLoading = false
            self.notify_didLoadAllChat(error: $0.dnkError() as NSError)
        }
    }
    
    private func requestRefreshToken() {
        let refreshRquest = RefreshTokenRequest()
        refreshRquest.startWithCompletionBlock { request in
            if request.apiSuccess() {
                do {
                    let json = try JSON(data:  request.wxResponseData())
                    if let refreshToken = json["refreshToken"].string {
                        GlobalManager.manager.updateRefreshToken(refreshToken: refreshToken)
                        let timeout = Int(json["timeOut"].stringValue) ?? -1
                        self.updateTokenTimeout(timeout: timeout)
                        if self.onceUpdateUserInfo == false {
                            self.onceUpdateUserInfo = true
                            GlobalManager.manager.refreshUserInfo() {_ in
                                
                            }
                            GlobalManager.manager.getConfigInfo()
                            Socket.shared.connect()
                        } else {
                            Socket.shared.updateSocketConfig()
                        }
//                        self.finishRefreshToken = true
//                        NotificationCenter.default.post(name: ConstantKey.NSNotificationRefreshToken, object: nil)
                        self.refreshTokenEvent()
                    }
                } catch {
                    debugPrint(error)
                }
                return
            }
            let errorCode = request.apiCode()
            if errorCode == NetworkCode.TOKEN_ERROR.rawValue ||
                errorCode == NetworkCode.ERROR_USER_STATUS.rawValue {
                return
            }
            self.updateTokenTimeout(timeout: -1)
        }
    }
}
