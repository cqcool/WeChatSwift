//
//  MessageEntity.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift
import SocketIO


@objcMembers
final class MessageEntity: NSObject, Codable, TableCodable, Named {
    var content: String? = nil //string
    /// 类型(0文字,1图文,2视频,3超链接,4文件,5语音,6GIF,7红包,8新闻)
    var contentType: Int? = nil//0,
    /// 发布时间
    var createTime: TimeInterval?
    var groupNo: String? = nil//0,
    /// 会话类别 1私聊 2群组
    var groupType: Int? = nil//0,
    var head: String? = nil //string
    var isAllDel: Int? = nil//0,
    /// 0 下架 1 上架
    var isUp: Int? = nil//0,
    /// 链接内容(json格式)
    var linkContent: String? = nil //string
    var nickname: String? = nil //string
    var no: String? = nil//0,
    /// 订单号
    var orderNumber: String? = nil //string
    /// 类型(0文字,1图片,2视频,3超链接,4文件,5语音,6GIF)
    var referContent: String? = nil //string
    var referContentType: Int? = nil//0,
    /// 链接内容(json格式)
    var referLinkContent: String? = nil //string
    var referMsgNo: String? = nil//0,
    var referUserHead: String? = nil //string
    var referUserId: String? = nil//0,
    /// 被指向的用户昵称
    var referUserNickname: String? = nil //string
    /// 展示时间
    var showTime: TimeInterval? = nil //2024-10-23T08:45:36.828Z
    /// 对应用户id(删除消息用)
    var toUserId: String? = nil//0,
    /// 类型(0 通知消息 1正常消息,2回复消息,3删除单条消息4删除所有消息,5系统通知消息,6会话变更消息
    var type: Int? = nil//0,
    /// 用户id
    var userId: String? = nil//0
    var ownerId: String?
    
    var appId: String? = nil//0
    var lastNo: String? = nil//0
    /// integer groupIsChange;//群状态是否改变(1是,0否) -> 收到消息查询group/info接口
    var groupIsChange: Int? = 0//0
    enum CodingKeys: String, CodingTableKey {
        
        nonisolated(unsafe) static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(no, isPrimary: true, isNotNull: false)
            BindColumnConstraint(createTime, isPrimary: false, orderBy: .ascending)
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
        case ownerId
    }
}

extension MessageEntity {
    static func insert(list: [MessageEntity]) {
        DBManager.share.insert(objects: list)
    }
    static func insertOrReplace(list: [MessageEntity]) {
        DBManager.share.insertOrReplace(objects: list)
    }
    
    static func queryMessag(groupNo: String) -> [MessageEntity]? {
        DBManager.share.getObjects(tableName: self.tableName,
                                   where: (MessageEntity.Properties.groupNo == groupNo &&
                                                                                        MessageEntity.Properties.ownerId == (GlobalManager.manager.personModel?.userId)!))
    }
}

extension MessageEntity: SocketData {
    func socketRepresentation() throws -> SocketData {
        guard let dic = mj_JSONObject() as? [String: Any] else {
            return [:]
        }
        return dic
    }
    static func buildMessage(content: String, groupNo: String, groupType: Int, lastNo: String?) -> MessageEntity {
        let message = MessageEntity()
        message.groupNo = groupNo
        message.groupType = groupType
        message.type = 1
        message.contentType = 0
        message.content = content
        message.appId = "\(NSString.currentSecondTimestamp())"
        message.lastNo = lastNo
        let personModel = GlobalManager.manager.personModel
        message.ownerId = personModel?.userId 
        message.userId = personModel?.userId
        message.head = personModel?.head
        message.nickname = personModel?.nickname
        return message
    }
    
}

