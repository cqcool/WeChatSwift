//
//  GroupEntity.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

@objcMembers
final class GroupEntity: NSObject, Codable, TableCodable, Named {
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
    var newAckMsgDate: TimeInterval?
    var newAckMsgInfo: String?
    var newAckMsgNo: String?
    /// 类型：0通知消息 1聊天消息,2回复消息,3删除个人消息,4删除所有消息,5系统(私聊群聊)通知消息,6群变更消息
    var newAckMsgType: Int?
    var newAckMsgUserId: String?
    var newAckMsgUserNickname: String?
    var unReadNum: String?
    /// 好友id
    var userId:String?
    /// 用户消息类型(1正常,2微信团队,3腾讯新闻)
    var userMsgType: Int?
    /// 成员数量(原先memberNum)
    var userNum: Int?
    /// 群介绍
    var intro: String?
    /// 群状态 0正常 1解散 2封禁
    var status: Int = 0
    
    var ownerId: String?
    
    var _formattedTime: String?
    
    /*
     对于变量名与表的字段名不一样的情况，可以使用别名进行映射，如 case identifier = "id"
     对于不需要写入数据库的字段，则不需要在 CodingKeys 内定义，如 debugDescription
     */
    enum CodingKeys: String, CodingKey, CodingTableKey {
        typealias Root = GroupEntity
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(groupNo, isPrimary: true)
            BindColumnConstraint(newAckMsgDate, isPrimary: false, orderBy: .descending)
        }
        case contentType
        case groupNo
        case groupType
        case head
        case isAdmin
        case isDel
        case isNotify
        case isTop
        case lastAckMsgNo
        case newAckMsgNo
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
        case ownerId
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
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 14),
//                .foregroundColor: UIColor(hexString: "9B9B9B")
//            ]
            var content: String = ""
            if msgType != 0,
                let unRead = Int(unReadNum ?? "0"), unRead > 1 {
                content = "[\(String(describing: unRead))条]"
            }
            if userMsgType == 1 &&
                (msgType == 1 || msgType == 2) &&
                newAckMsgUserId != GlobalManager.manager.personModel?.userId {
                content.append("\(newAckMsgUserNickname ?? ""): ")
            }
            content.append("\(newAckMsgInfo ?? "")")
            let font = UIFont.systemFont(ofSize: 14)
            let textColor = UIColor(hexString: "9B9B9B")
            let attributedText = NSMutableAttributedString(string: content, attributes: [
                .font: font,
                .foregroundColor: textColor
                ])
            var attributeStr = ExpressionParser.shared!.attributedTagText(with: attributedText)
            attributeStr = ExpressionParser.shared!.attributedCancelTagText(with: attributeStr)
            let (attributed, _) = ExpressionParser.shared!.attributedRedPacketText(with: attributeStr)
            if let attr = attributed.mutableCopy() as? NSMutableAttributedString {
                attr.addAttributes([.font: font, .foregroundColor: textColor], range: NSMakeRange(0, attr.length))
                return attr
            }
            return NSAttributedString(string: "")
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
        return NSAttributedString(string: _formattedTime ?? "", attributes: attributes)
    }
    
    func toContact() -> Contact {
        let contact = Contact()
        contact.avatarURL = GlobalManager.headImageUrl(name: head)
        contact.name = name ?? "未命名"
        contact.gender = .male
        contact.wxid = userId
        contact.group = self
        let str = NSMutableString(string: contact.name!) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) && CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
            contact.letter = String(((str as NSString) as String).first!).uppercased()
        }
        return contact
    }
    /// 群组转 私聊好友
    func toMember() ->MemberModel {
        let member = MemberModel()
        member.head = head
        member.isAdmin = isAdmin
        member.nickname = name
        member.userId = groupNo
        member.userMsgType = userMsgType
        return member
    }
}

extension GroupEntity {
    static func insert(list: [GroupEntity]) {
        DBManager.share.insert(objects: list)
    }
    static func insertOrReplace(list: [GroupEntity]) {
        DBManager.share.insertOrReplace(objects: list)
    }
    
    static func updateName(group: GroupEntity) {
        DBManager.share.update(object: group, on: [GroupEntity.Properties.name], where: GroupEntity.Properties.groupNo == group.groupNo ?? "")
    }
    static func updateUnreadNum(group: GroupEntity) {
        DBManager.share.update(object: group, on: [GroupEntity.Properties.unReadNum], where: GroupEntity.Properties.groupNo == group.groupNo ?? "")
    }
    static func updateGroup(group: GroupEntity) {
        DBManager.share.insertOrReplace(objects: [group])
    }
    /// 查找群聊
    static func queryGroupChats()-> [GroupEntity]? {
        DBManager.share.getObjects(tableName: self.tableName,
                                   where: (GroupEntity.Properties.ownerId == (GlobalManager.manager.personModel?.userId)! &&
                                   ((GroupEntity.Properties.userMsgType == 2 || GroupEntity.Properties.userMsgType == 3) ||
                                    GroupEntity.Properties.groupType == 2)))
    }
    
    /// 查找群聊
    static func queryFriends()-> [GroupEntity]? {
        DBManager.share.getObjects(tableName: self.tableName,
                                   where: (GroupEntity.Properties.ownerId == (GlobalManager.manager.personModel?.userId)! &&
                                           (GroupEntity.Properties.userMsgType == 2  ||
                                           GroupEntity.Properties.groupType == 1)))
    }
    
}
