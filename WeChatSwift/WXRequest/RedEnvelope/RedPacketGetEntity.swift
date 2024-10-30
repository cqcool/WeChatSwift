//
//  RedPacketGetEntity.swift
//  WeChatSwift
//
//  Created by ios_cloud on 2024/10/30.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift


@objcMembers
/// 红包领取记录
final class RedPacketGetEntity: NSObject, Codable, TableCodable, Named {
    
    var orderNumber: String?
    /// 状态(1进行中,2已完成,3已过期, 自定义：4已领取)
    var status: String?
    ///  领取金额
    var amount: String?
    ///  头像
    var head: String?
    
    enum CodingKeys: String, CodingKey, CodingTableKey {
        
        typealias Root = RedPacketGetEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(orderNumber, isPrimary: true)
        }
        
        case orderNumber
        case status
        case amount
        case head
        
    }
}

@objcMembers
class RedPacketGetModel: NSObject, Codable {
    /// 总金额
    var amount: String?

    /// 完成时间(毫秒)
    var completeTime: String?
    /// 自己是否领取(1是,0否)
    var isMyselfReceive: String?
    ///  自己领取金额
    var myselfReceiveAmount: String?

    var detailList: [RedPacketRecordModel]?
    
    var getGroupMsg: String?


    // 备注(恭喜发财,大吉大利)
    var name: String?

    // 总数量
    var num: String?

    // 领取金额
    var receiveAmount: Int?

    // 领取数量
    var receiveNum: String?

    /// 发送者头像
    var senderUserHead: String?

    // 发送者用户id
    var senderUserId: String?

    /// 发送者昵称
    var senderUserNickname: String?

    /// 状态(1进行中,2已完成,3已过期)
    var status: String?

    /// 类型(1拼手气红包)
    var type: String?

    // 用户余额
    var userBalance: String?
    
    enum CodingKeys: String, CodingKey {
        
        case amount
        /// 完成时间(毫秒)
        case completeTime
        /// 自己是否领取(1是,0否)
        case isMyselfReceive
        ///  自己领取金额
        case myselfReceiveAmount

        case detailList
        
        case getGroupMsg
        // 备注(恭喜发财,大吉大利)
        case name

        // 总数量
        case num

        // 领取金额
        case receiveAmount

        // 领取数量
        case receiveNum

        /// 发送者头像
        case senderUserHead

        // 发送者用户id
        case senderUserId

        /// 发送者昵称
        case senderUserNickname

        /// 状态(1进行中,2已完成,3已过期)
        case status

        /// 类型(1拼手气红包)
        case type

        // 用户余额
        case userBalance
    }
}
