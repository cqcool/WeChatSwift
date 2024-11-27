//
//  FriendsApi.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/23.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
/// 好友列表
class FriendListRequest: WXRequest {
    override func requestUrl() -> String {
        "/group/friend/list"
    } 
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }

}
