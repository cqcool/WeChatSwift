//
//  ChatRoomListItemModel.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class ChatRoomListItemModel: WXTableCellModel {
    
    var roomId: String
    
    var avatar: String?
    
    var roomName: String
    
    init(roomId: String, roomName: String) {
        self.roomId = roomId
        self.roomName = roomName
    }
    
    var wx_title: String {
        return roomName
    }
}
