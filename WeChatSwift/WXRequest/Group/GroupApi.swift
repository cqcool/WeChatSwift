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
    let groupNo: String? = nil
    let limit: String = "100"
    /// 下个id(根据上次返回请求)
    let nextId: String? = nil

    /// 下个时间(根据上次返回请求)
    let nextTime: String? = nil
    
    override func requestUrl() -> String {
        "group/list/sync"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }

}
