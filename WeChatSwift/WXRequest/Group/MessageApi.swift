//
//  MessageApi.swift
//  WeChatSwift
//
//  Created by ios_cloud on 2024/10/25.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers
///消息已读
class MsgReadRequest: DNKRequest {
    let no: String
    init(no: String) {
        self.no = no
    }
    override func requestUrl() -> String {
        "/group/msg/read"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
    
}

/// 消息列表
@objcMembers
class MessageRequest: DNKRequest {
    /*
     如果我要拿最新的数据，我要传lastAckMsgNo(最新的消息no)，sort，groupNo，go。
     如果我要拿旧数据，传no(最旧的消息no)，sort，groupNo，go。
     */
    /// 最后已读消息
    var lastAckMsgNo: String? = nil
    /// 定位消息no 不传 默认最新的20条
    var no: String? = nil
    /// 查询方向:0时间往前，1、时间往后
    var sort: String? = nil
    /// 会话no
    var groupNo: String
    /// 0默认 1定位前后10条消息
    var go: String? = nil
    var pageSize: String = "100"
    
    init(groupNo: String) {
        self.groupNo = groupNo
    }
    
    override func requestUrl() -> String {
        "/group/msg/list"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}
