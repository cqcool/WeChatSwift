//
//  RedEnvelope.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/28.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

/// 红包校验
@objcMembers
class RedPacketVerify: DNKRequest {
    /// 金额
    let amount: String
    /// 会话no
    let groupNo: String

    /// 红包个数
    let num: String

    /// 类型(1拼手气红包)
    let type: String
    init(amount: String, groupNo: String, num: String, type: String) {
        self.amount = amount
        self.groupNo = groupNo
        self.num = num
        self.type = type
    }

    
    override func requestUrl() -> String {
        "/group/redPacket/verify"
    }
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }

}
