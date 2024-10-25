//
//  GroupApi.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

// 发现页红点
class UnreadMsgRequest: DNKRequest {
    override func requestUrl() -> String {
        "/group/foundPageIsRead"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
    
}

/// 会话-列表同步
@objcMembers
class GroupListRequest: DNKRequest {
    var groupNo: String? = nil
    var limit: String = "100"
    /// 下个id(根据上次返回请求)
    var nextId: String? = nil
    
    /// 下个时间(根据上次返回请求)
    var nextTime: String? = nil
    
    override func requestUrl() -> String {
        "group/list/sync"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
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

/// 群成员列表
@objcMembers
class GroupMembersRequest: DNKRequest {
    var groupNo: String? = nil
    
    init(groupNo: String?) {
        self.groupNo = groupNo
    }
    
    override func requestUrl() -> String {
        "/group/member/list"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}

/// 群信息修改
@objcMembers
class UpdateGroupRequest: DNKRequest {
    var groupNo: String? = nil
    var head: String? = nil
    var intro: String? = nil
    var name: String? = nil
    init(groupNo: String?) {
        self.groupNo = groupNo
    }
    
    override func requestUrl() -> String {
        "/group/updateInfo"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}
