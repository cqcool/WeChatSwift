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

protocol TimingGroupDelegate {
    func updateGroupList(list: [GroupEntity])
}
class TimingGroupManager {
    var timer: DispatchSourceTimer?
    private var nextId: String? = nil
    
    private var delegates: [TimingGroupDelegate] = []
    
    /// 下个时间(根据上次返回请求)
    private var nextTime: String? = nil
    
    func startTimer() {
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
    func timerAction() {
        
        // 这里放置每次定时器触发时想要执行的代码
        let request = GroupListRequest()
        //        request.nextId = self.nextId
        //        request.nextTime = self.nextTime
        request.startWithCompletionBlock { request in
            if let json = try? JSON(data: request.wxResponseData()){
                self.nextId = json["nextId"].string
                self.nextTime = json["nextTime"].string
                if let groupList = json["groupList"].arrayObject,
                   let jsonData = (groupList as NSArray).mj_JSONData() {
                   
                    do {
                        let resp = try JSONDecoder().decode([GroupEntity].self, from: jsonData)
                        for d in self.delegates {
                            d.updateGroupList(list: resp)
                        }
//                        GroupEntity.bg_saveOrUpdate(resp)
                        print("Timer tick")
                    }  catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }
    }
    
    func addDelegate(delegate: TimingGroupDelegate) {
        delegates.append(delegate)
    }
    
    
    func stopTimer() {
        // 停止计时器
        nextId = nil
        nextTime = nil
        timer?.cancel()
        timer = nil
        delegates = []
    }

}
/*
 "nextId":"1197","groupList":[{"isNotify":1,"name":"联动","groupNo":"717922244344553472","lastAckMsgNo":"0","groupType":1,"newAckMsgInfo":"","newAckMsgType":null,"isAdmin":0,"isTop":0,"isDel":0,"newAckMsgDate":1728991653496,"head":"14f3d28a1195489bb23cfa1cd6690901","contentType":null,"userNum":null,"userMsgType":1,"unReadNum":"0","newAckMsgUserId":null,"msgNum":0,"newAckMsgUserNickname":"","userId":"517105663"}
 
 {"isNotify":1,"name":"ι","groupNo":"717922244365524992","lastAckMsgNo":"0","groupType":1,"newAckMsgInfo":"","newAckMsgType":null,"isAdmin":0,"isTop":0,"isDel":0,"newAckMsgDate":1728991653496,"head":"2b8be912306842f296839be63cea5de5.webp","contentType":null,"userNum":null,"userMsgType":1,"unReadNum":"0","newAckMsgUserId":null,"msgNum":0,"newAckMsgUserNickname":"","userId":"593043048"}
 */

