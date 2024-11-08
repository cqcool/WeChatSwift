//
//  GroupSyncEntity.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/11/8.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift


@objcMembers
final class GroupSyncEntity: NSObject, Codable, TableCodable, Named {
    
    /// 下个id(根据上次返回请求)
    var nextId: String? = nil
    /// 下个时间(根据上次返回请求)
    var nextTime: String? = nil
    var userId: String?
    
    enum CodingKeys: String, CodingKey, CodingTableKey {
        typealias Root = GroupSyncEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(userId, isPrimary: true)
        }
        
        case nextId
        case nextTime
        case userId
    }
}


extension GroupSyncEntity {
    static func insertOrReplace(entity: GroupSyncEntity) {
        DBManager.share.insertOrReplace(objects: [entity])
    }
    /// 查找群聊
    static func query()-> GroupSyncEntity? {
        DBManager.share.getObjects(tableName: self.tableName,
                                   where: (
                                    GroupSyncEntity.Properties.userId == (GlobalManager.manager.personModel?.userId)!))?.first
    }
}
