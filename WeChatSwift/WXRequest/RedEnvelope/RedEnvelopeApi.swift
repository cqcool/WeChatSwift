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
class RedPacketVerifyRequest: DNKRequest {
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

@objcMembers
/// 红包支付
class RedPacketPayRquest: DNKRequest {
    /*
     "amount": 0,
      "groupNo": 0,
      "name": "string",
      "num": 0,
      "payPassword": "string",
      "type": 0
     */
    /// 金额
    let amount: String
    /// 会话no
    let groupNo: String
 
    /// 备注(恭喜发财,大吉大利)
    let name: String
    /// 红包个数
    let num: String

    /// 支付密码
    let payPassword: String

    /// 类型(1拼手气红包)
    let type: String
    init(amount: String, groupNo: String, name: String = "恭喜发财,大吉大利", num: String, payPassword: String, type: String = "1") {
        self.amount = amount
        self.groupNo = groupNo
        self.name = name
        self.num = num
        self.payPassword = payPassword
        self.type = type
    }
    override func requestUrl() -> String {
        "/group/redPacket/pay"
    }
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}
