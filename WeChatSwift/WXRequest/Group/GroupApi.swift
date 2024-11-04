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

/// 群信息
@objcMembers
class GroupInfoRequest: DNKRequest {
    var groupNo: String? = nil
    init(groupNo: String?) {
        self.groupNo = groupNo
    }
    
    override func requestUrl() -> String {
        "/group/info"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}

