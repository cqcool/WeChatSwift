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
    var account: String?
    /// 状态(1进行中,2已完成,3已过期, 自定义：4已领取)
    var status: String?
    
    enum CodingKeys: String, CodingKey, CodingTableKey {
        
        typealias Root = RedPacketGetEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(orderNumber, isPrimary: true)
            BindColumnConstraint(account, isPrimary: true)
        }
        
        case orderNumber
        case account
        
    }
}
