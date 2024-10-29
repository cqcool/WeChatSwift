//
//  RedPacketRecordModel.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/29.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

/*
 
 /// 总最佳个数
 var countBestNum: String?
/// 总收到金额
 var countReceiveAmount: String?
 

 /// 总收到个数
 var countReceiveNum: String?
 var detailList: Any?
 */
@objcMembers
class RedPacketRecordModel: NSObject, Codable {

    /// 领取金额
    var amount: String?
 

    /// 是否最佳
    var isBest: Int?
///  昵称
    var nickname: String?
    /// 领取时间
    var receiveTime: String?

    ///  类型(1拼手气红包)
    var type: Int?
    
    enum CodingKeys: String, CodingKey {
        typealias Root = RedPacketRecordModel
        
        case amount
        case isBest
        case nickname
        case receiveTime
        case type
    }
}
