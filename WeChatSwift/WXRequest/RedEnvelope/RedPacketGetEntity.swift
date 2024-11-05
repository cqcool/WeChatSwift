//
//  RedPacketGetEntity.swift
//  WeChatSwift
//
//  Created by ios_cloud on 2024/10/30.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift


/// 红包信息
@objcMembers
final class RedPacketGetEntity: NSObject, Codable, TableCodable, Named {
    /// 总金额
    var amount: String?

    /// 完成时间(毫秒)
    var completeTime: String?
    /// 自己是否领取(1是,0否)
    var isMyselfReceive: Int?
    ///  自己领取金额
    var myselfReceiveAmount: String?

    // 备注(恭喜发财,大吉大利)
    var name: String?

    // 总数量
    var num: Int?

    // 领取金额
    var receiveAmount: String?

    // 领取数量
    var receiveNum: Int?

    /// 发送者头像
    var senderUserHead: String?

    // 发送者用户id
    var senderUserId: String?

    /// 发送者昵称
    var senderUserNickname: String?

    /// 状态(1进行中,2已完成,3已过期)
    var status: Int?

    /// 类型(1拼手气红包)
    var type: Int?

    // 用户余额
    var userBalance: String?
    
    var groupNo: String?
    
    var orderNumber: String?
    
    var ownerId: String?
    
    enum CodingKeys: String, CodingKey, CodingTableKey {
        
        typealias Root = RedPacketGetEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(orderNumber, isPrimary: true)
        }
        
        case amount
        /// 完成时间(毫秒)
        case completeTime
        /// 自己是否领取(1是,0否)
        case isMyselfReceive
        ///  自己领取金额
        case myselfReceiveAmount
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
        case groupNo
        case orderNumber
        case ownerId
    }
}

extension RedPacketGetEntity {
    static func insertOrReplace(list: [RedPacketGetEntity]) {
        DBManager.share.insertOrReplace(objects: list)
    }
    /// 查找群聊
    static func queryRedPacket(orderNumber: String)-> [RedPacketGetEntity]? {
        DBManager.share.getObjects(tableName: self.tableName,
                                   where: (RedPacketGetEntity.Properties.ownerId == (GlobalManager.manager.personModel?.userId)! &&
                                           RedPacketGetEntity.Properties.orderNumber == orderNumber))
    }
}


@objcMembers
final class FullRedPacketGetEntity: NSObject, Codable {


    /// 总金额
    var amount: String?

    /// 完成时间(毫秒)
    var completeTime: String?
    /// 自己是否领取(1是,0否)
    var isMyselfReceive: Int?
    ///  自己领取金额
    var myselfReceiveAmount: String?

    var getGroupMsg: [String: Any]?

    var detailList: [RedPacketRecordModel]?
    // 备注(恭喜发财,大吉大利)
    var name: String?

    // 总数量
    var num: Int?

    // 领取金额
    var receiveAmount: String?

    // 领取数量
    var receiveNum: Int?

    /// 发送者头像
    var senderUserHead: String?

    // 发送者用户id
    var senderUserId: String?

    /// 发送者昵称
    var senderUserNickname: String?

    /// 状态(1进行中,2已完成,3已过期)
    var status: Int?

    /// 类型(1拼手气红包)
    var type: Int?

    // 用户余额
    var userBalance: String?
    
    var groupNo: String?
    
    var orderNumber: String?
    
    var ownerId: String?
    
    enum CodingKeys: String, CodingKey, CodingTableKey {
        
        typealias Root = RedPacketGetEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(orderNumber, isPrimary: true)
        }
        
        case amount
        /// 完成时间(毫秒)
        case completeTime
        /// 自己是否领取(1是,0否)
        case isMyselfReceive
        ///  自己领取金额
        case myselfReceiveAmount
        // 备注(恭喜发财,大吉大利)
        case name

        // 总数量
        case num

        // 领取金额
        case receiveAmount
        
        case detailList
         

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
        case ownerId
        // 用户余额
        case userBalance
        case groupNo
        case orderNumber
    }

}
