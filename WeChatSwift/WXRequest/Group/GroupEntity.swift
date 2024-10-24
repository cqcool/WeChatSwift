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
    
//    var pk: Int?
    var contentType: Int?//  0,
    var groupNo: String?
    var groupType: Int?
    var head: String?
    var isAdmin: Int?
    var isDel: Int?
    var isNotify: Int?
    var isTop: Int?
    var lastAckMsgNo: String?
    var msgNum: Int?
    var name: String?
    var newAckMsgDate: Int?
    var newAckMsgInfo: String?
    var newAckMsgType: Int?
    var newAckMsgUserId: String?
    var newAckMsgUserNickname: String?
    var unReadNum: String?
    var userId:String?
    var userMsgType: Int?
    var userNum: Int?
    
    // 注意：json的key和模型属性不同时，可以使用映射
    enum CodingKeys: String, CodingKey {
//        case pk
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
    
    override class func bg_uniqueKeys() -> [Any] {
        ["groupNo"]
    }
}

extension GroupEntity {
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15.5),
            .foregroundColor: Colors.black
        ]
        return NSAttributedString(string: name ?? "未命名", attributes: attributes)
    }
    
    func attributedStringForSubTitle() -> NSAttributedString {
        if newAckMsgType == 0 ||
            newAckMsgType == 1 ||
            newAckMsgType == 2 {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor(hexString: "9B9B9B")
            ]
            return NSAttributedString(string: "[\(String(describing: msgNum))条] \(String(describing: newAckMsgUserNickname)): \(newAckMsgInfo ?? "")", attributes: attributes)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.Red
        ]
        return NSAttributedString(string: "[\(newAckMsgInfo ?? "通知消息")]", attributes: attributes)
    }
    
    func attributedStringForTime() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAUTL_TABLE_INTROL_COLOR
        ]
        return NSAttributedString(string: "12:40", attributes: attributes)
    }
}
