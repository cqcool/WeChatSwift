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
    /// 类型(0文字,1图文,2视频,3超链接,4文件,5语音,6GIF,7红包,8新闻)
    var contentType: Int? = 0//0,
    /// 发布时间
    var createTime: Int?
    var groupNo: String? = ""//0,
    /// 会话类别 1私聊 2群组
    var groupType: Int? = 0//0,
    var head: String? = "" //string
    var isAllDel: Int? = 0//0,
    /// 0 下架 1 上架
    var isUp: Int? = 0//0,
    /// 链接内容(json格式)
    var linkContent: String? = "" //string
    var nickname: String? = "" //string
    var no: String? = ""//0,
    /// 订单号
    var orderNumber: String? = "" //string
    /// 类型(0文字,1图片,2视频,3超链接,4文件,5语音,6GIF)
    var referContent: String? = "" //string
    var referContentType: Int? = 0//0,
    /// 链接内容(json格式)
    var referLinkContent: String? = "" //string
    var referMsgNo: Int? = 0//0,
    var referUserHead: String? = "" //string
    var referUserId: String? = ""//0,
    /// 被指向的用户昵称
    var referUserNickname: String? = "" //string
    /// 展示时间
    var showTime: Int? = 0 //2024-10-23T08:45:36.828Z
    /// 对应用户id(删除消息用)
    var toUserId: String? = ""//0,
    /// 类型(0 通知消息 1正常消息,2回复消息,3删除单条消息4删除所有消息,5系统通知消息,6会话变更消息
    var type: Int? = 0//0,
    /// 用户id
    var userId: String? = ""//0
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

