//
//  MemberModel.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/25.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers
class MemberModel: NSObject, Codable {
    var head: String?
    /// 是否管理员 0 否 1是
    var isAdmin: Int? = 0
    /// 是否已经入群 0 否 1是
    var isJoin: Int? = 0
    /// 是否禁言(0否,1是)
    var isMute: Int? = 0
    var nickname: String?
    /// 用户id
    var userId: String?
    ///  用户消息类型(1正常,2微信团队,3腾讯新闻)
    var userMsgType: Int? = 1

    enum CodingKeys: String, CodingKey {
        case head
        case isAdmin
        case isJoin
        case isMute
        case nickname
        case userId
        case userMsgType
    }
}

extension MemberModel {
    func toContact() -> Contact {
        let t = Contact()
        t.name = nickname ?? ""
        t.avatarURL = GlobalManager.headImageUrl(name: head)
        t.wxid = userId
        t.member = self
        return t
    }
}
