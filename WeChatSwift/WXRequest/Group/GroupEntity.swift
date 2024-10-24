//
//  GroupEntity.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

@objcMembers
final class GroupEntity: NSObject, Codable, TableCodable {
//    var pk: Int?
    var contentType: Int?//  0,
    var groupNo: String?
    /// 类别： 1、私聊；2、群聊
    var groupType: Int?
    var head: String?
    /// 是否管理员 0否 1是
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
    /// 用户消息类型(1正常,2微信团队,3腾讯新闻)
    var userMsgType: Int?
    /// 成员数量(原先memberNum)
    var userNum: Int?
    /// 群介绍
    var intro: String?
    /// 群状态 0正常 1解散 2封禁
    var status: Int = 0
    
    
    // 注意：json的key和模型属性不同时，可以使用映射
    enum CodingKeys: String, CodingKey, CodingTableKey {
        typealias Root = GroupEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(groupNo, isPrimary: true)
            BindColumnConstraint(newAckMsgDate, isPrimary: false, orderBy: .descending)
        }
        
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
        guard let msgType = newAckMsgType else {
            return NSAttributedString(string: "")
        }
        if msgType == 0 ||
            msgType == 1 ||
            msgType == 2 {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor(hexString: "9B9B9B")
            ]
            if let unRead = Int(unReadNum ?? "0"), unRead > 0 {
                return NSAttributedString(string: "[\(String(describing: unRead))条] \(String(describing: newAckMsgUserNickname ?? "")): \(newAckMsgInfo ?? "")", attributes: attributes)
            }
            return NSAttributedString(string: "\(newAckMsgUserNickname ?? ""): \(newAckMsgInfo ?? "")", attributes: attributes)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.Red
        ]
        let msg = (newAckMsgInfo ?? "").isEmpty ? "通知消息" : newAckMsgInfo!
        return NSAttributedString(string: "[\(msg)]", attributes: attributes)
    }
    
    func attributedStringForTime() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAUTL_TABLE_INTROL_COLOR
        ]
        return NSAttributedString(string: "12:40", attributes: attributes)
    }
}
