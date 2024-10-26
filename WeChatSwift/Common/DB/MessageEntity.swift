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
final class MessageEntity: NSObject, Codable, TableCodable, Named {
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
    /*
     {"referContent":"","referUserHead":"","nickname":"一二三四五六七八九十十一十二十三","linkContent":"{\"name\":\"恭喜发财，大吉大利\",\"orderNumber\":\"RP202410246829772967533\",\"type\":1}","referContentType":null,"isUp":1,"toUserId":null,"orderNumber":"RP202410246829772967533","isAllDel":0,"type":1,"groupNo":"712557675480748032","groupType":2,"no":"721199312935194624","referUserId":null,"showTime":null,"contentType":7,"head":"fc8976205c794d92b8678dbeb324d930.webp","referLinkContent":"","referMsgNo":null,"referUserNickname":"","createTime":1729772967533,"content":"","userId":"865021641"}
     */
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

extension MessageEntity {
    static func insert(list: [MessageEntity]) {
        DBManager.share.insert(objects: list)
    }
}
