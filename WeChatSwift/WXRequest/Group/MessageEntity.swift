//
//  MessageEntity.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift


@objcMembers
final class MessageEntity: NSObject, Codable, TableCodable {
    var content: String? = "" //string
    var contentType: Int? = 0//0,
    var createTime: String? = "" //2024-10-23T08:45:36.828Z
    var groupNo: Int? = 0//0,
    var groupType: Int? = 0//0,
    var head: String? = "" //string
    var isAllDel: Int? = 0//0,
    var isUp: Int? = 0//0,
    var linkContent: String? = "" //string
    var nickname: String? = "" //string
    var no: Int? = 0//0,
    var orderNumber: String? = "" //string
    var referContent: String? = "" //string
    var referContentType: Int? = 0//0,
    var referLinkContent: String? = "" //string
    var referMsgNo: Int? = 0//0,
    var referUserHead: String? = "" //string
    var referUserId: Int? = 0//0,
    var referUserNickname: String? = "" //string
    var showTime: String? = "" //2024-10-23T08:45:36.828Z
    var toUserId: Int? = 0//0,
    var type: Int? = 0//0,
    var userId: Int? = 0//0
    
    enum CodingKeys: String, CodingTableKey {

        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(no, isPrimary: true)
            BindColumnConstraint(createTime, isPrimary: false, orderBy: .descending)
        }
        
        typealias Root = MessageEntity
        case content
        case contentType
        case createTime
        case groupNo
        case groupType
        case head
        case isAllDel
        case isUp
        case linkContent
        case nickname
        case no
        case orderNumber
        case referContent
        case referContentType
        case referLinkContent
        case referMsgNo
        case referUserHead
        case referUserId
        case referUserNickname
        case showTime
        case toUserId
        case type
        case userId
         
    }
}
