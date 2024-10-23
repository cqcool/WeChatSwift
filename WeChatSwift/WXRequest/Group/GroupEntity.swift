//
//  GroupEntity.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers
class GroupEntity: NSObject, Codable {
    
    var contentType: Int? = 0//  0,
    var groupNo: Int? = 0//  0,
    var groupType: Int? = 0//  0,
    var head: String? = ""//  "string",
    var isAdmin: Int? = 0//  0,
    var isDel: Int? = 0//  0,
    var isNotify: Int? = 0//  0,
    var isTop: Int? = 0//  0,
    var lastAckMsgNo: Int? = 0//  0,
    var msgNum: Int? = 0//  0,
    var name: String? = ""//  string,
    var newAckMsgDate: String? = ""//  2024-10-23T08:24:27.859Z,
    var newAckMsgInfo: String? = ""//  string,
    var newAckMsgType: Int? = 0//  0,
    var newAckMsgUserId: Int? = 0//  0,
    var newAckMsgUserNickname: String? = ""//  string,
    var unReadNum: Int? = 0//  0,
    var userId: Int? = 0//  0,
    var userMsgType: Int? = 0//  0,
    var userNum: Int? = 0//  0
    
    override class func bg_uniqueKeys() -> [Any] {
        ["groupNo"]
    }
    
    // 注意：json的key和模型属性不同时，可以使用映射
    enum CodingKeys: String, CodingKey {
        case contentType
        case groupNo
        case groupType
        case head
        case isAdmin
        case isDel
        case isNotify
        case isTop
        case lastAckMsgNo
        case msgNum
        case name
        case newAckMsgDate
        case newAckMsgInfo
        case newAckMsgType
        case newAckMsgUserId
        case newAckMsgUserNickname
        case unReadNum
        case userId
        case userMsgType
        case userNum
    }
}
