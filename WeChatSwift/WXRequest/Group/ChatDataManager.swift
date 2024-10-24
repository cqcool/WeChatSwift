//
//  TimingGroupManager.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SwiftyJSON
import MJExtension
import BGFMDB

protocol ChatDataDelegate {
    
    func willLoadAllChat()
    
    func didLoadAllChat()
    
    func updateGroupList(list: [GroupEntity])
}
class ChatDataManager {
    private var timer: DispatchSourceTimer?
    
    private var delegates: [ChatDataDelegate] = []
    
    private var nextId: String? = nil
    /// 下个时间(根据上次返回请求)
    private var nextTime: String? = nil
    
    private var giveUpOne: Bool = false
    
    func startLoadData() {
        nextId = getNextId()
        nextTime = getNextTime()
        
        nextId = nil
        nextTime = nil
        
        if nextId == nil ||
            nextTime == nil {
            notify_willLoadAllChat()
            loadChatData(isLoop: true)
            return
        }
        startTimer()
    }
    func stopLoad() {
        stopTimer()
    }
    
    private func startTimer() {
        // 创建一个立即执行，每1秒重复的定时器
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.setEventHandler {
            self.timerAction()
        }
        // 设置定时器立即执行，并且在1秒后重复执行
        timer?.schedule(deadline: .now(), repeating: .seconds(100))
        // 启动定时器
        timer?.activate()
        
    }
    private func timerAction() {
        if giveUpOne {
            giveUpOne = false
            return
        }
        loadChatData(isLoop: false)
    }
    
    func addDelegate(delegate: ChatDataDelegate) {
        delegates.append(delegate)
    }
    
    private func notify_willLoadAllChat() {
        for d in self.delegates {
            d.willLoadAllChat()
        }
    }
    private func notify_didLoadAllChat() {
        for d in self.delegates {
            d.didLoadAllChat()
        }
    }
    private func notify_updateGroupList(list: [GroupEntity]) {
        for d in self.delegates {
            d.updateGroupList(list: list)
        }
    }
}

extension ChatDataManager {
    private func getNextId() -> String? {
        UserDefaults.standard.object(forKey: "NextId") as? String
    }
    private func getNextTime() -> String? {
        UserDefaults.standard.object(forKey: "NextTime") as? String
    }
    private func saveNext(id: String?, time: String?) {
        guard let id,
              let time else {
            return
        }
        UserDefaults.standard.setValue(id, forKey: "NextId")
        UserDefaults.standard.setValue(time, forKey: "NextTime")
    }
    private func stopTimer() {
        // 停止计时器
        nextId = nil
        nextTime = nil
        timer?.cancel()
        timer = nil
        delegates = []
    }
    private func loadChatData(isLoop: Bool) {
        let request = GroupListRequest()
        request.nextId = self.nextId
        request.nextTime = self.nextTime
        request.startWithCompletionBlock { request in
            if let json = try? JSON(data: request.wxResponseData()){
                self.nextId = json["nextId"].string
                self.nextTime = json["nextTime"].string
                self.saveNext(id: self.nextId, time: self.nextTime)
                guard let groupList = json["groupList"].arrayObject,
                      groupList.count > 0 else {
                    if isLoop {
                        
                        self.notify_didLoadAllChat()
                        self.giveUpOne = true
                        self.startTimer()
                    }
                    return
                }
                
                if let jsonData = (groupList as NSArray).mj_JSONData() {
                    do {
                        let resp = try JSONDecoder().decode([GroupEntity].self, from: jsonData)
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
        }
    }
}
