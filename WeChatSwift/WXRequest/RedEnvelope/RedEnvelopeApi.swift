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


@objcMembers
/// 红包收到记录
class RedPacketRecordRquest: DNKRequest {
    
    let page: String
    let year: String
    
    init(page: String, year: String) {
        self.page = page
        self.year = year
    }
    override func requestUrl() -> String {
        "/group/redPacket/receiveRecord"
    }
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
}

/*
 amount    number
 总金额

 completeTime    integer($int64)
 完成时间(毫秒)

 detailList    [
 领取列表

 RedPacketGetDetailVO{
 amount    number
 领取金额

 head    string
 头像

 isBest    integer($int32)
 是否最佳

 nickname    string
 昵称

 receiveTime    string($date-time)
 领取时间

 }]
 getGroupMsg    消息主体{...}
 isMyselfReceive    integer($int32)
 自己是否领取(1是,0否)

 myselfReceiveAmount    number
 自己领取金额

 name    string
 备注(恭喜发财,大吉大利)

 num    integer($int32)
 总数量

 receiveAmount    number
 领取金额

 receiveNum    integer($int32)
 领取数量

 senderUserHead    string
 发送者头像

 senderUserId    integer($int64)
 发送者用户id

 senderUserNickname    string
 发送者昵称

 status    integer($int32)
 状态(1进行中,2已完成,3已过期)

 type    integer($int32)
 类型(1拼手气红包)

 userBalance    number
 用户余额
 */
/// 红包领取
class RedPacketGetRequest: DNKRequest {
    
    /// 会话no
    var groupNo: String

    /// 是否领取(1是,0查看他们手气
    var isGet: String
    /// 订单号
    var orderNumber: String
    init(groupNo: String, isGet: String, orderNumber: String) {
        self.groupNo = groupNo
        self.isGet = isGet
        self.orderNumber = orderNumber
    }
    
    override func requestUrl() -> String {
        "/group/redPacket/get"
    }
    override func requestMethod() -> YTKRequestMethod {
        .POST
    }
}
