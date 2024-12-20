//
//  Message.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import WCDBSwift
import PINRemoteImage
import SwiftyJSON

public class Message {
    
        var localMsgID: String = ""
    
        var serverMsgID: String = ""
    
        var type: Int = 0
    
        var chatID: String = ""
    
    var senderID: String = ""
    
    var content: MessageContent = .none
    
    var time: TimeInterval = 0
    
    var _formattedTime: String?
    var entity: MessageEntity?
    var no: String?
    
}

public extension Message {
    
    var isOutgoing: Bool { return senderID == GlobalManager.manager.personModel?.userId }
    
    func attributedStringForTime() -> NSAttributedString? {
        guard let timeString = _formattedTime else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: timeString, attributes: attributes)
    }
    func updateRedPacket() {
        switch content {
        case .redPacket(var msg):
            if let orderNumber = msg.orderNumber,
               let entity = RedPacketGetEntity.queryRedPacket(orderNumber: orderNumber)?.first {
                msg.status = entity.status ?? 1
                msg.entity = entity
            }
            content = .redPacket(msg)
            break
            
        default: break
        }
        
    }
}


extension MessageEntity {
    func toMessage() -> Message {
        let msg = Message()
        msg.entity = self
        msg.senderID = userId ?? ""
        msg.content = messageContent()
        msg.time = showTime ?? (createTime ?? 0)
        msg.no = no
        return msg
    }
    private func messageContent() -> MessageContent {
        guard let typeInt = contentType else {
            return .none
        }
        switch (typeInt) {
        case 0: return .text(content ?? "")
        case 7:
            if let data = linkContent?.data(using: .utf8),
               let json = try? JSON(data: data) {
                var redMsg = RedPacketMessage()
                redMsg.name = json["name"].string
                redMsg.orderNumber = json["orderNumber"].string
                redMsg.type = json["type"].string
                redMsg.nickName = nickname
                redMsg.head = head
                redMsg.groupNo = groupNo
                
                if let orderNumber = redMsg.orderNumber,
                   let entity = RedPacketGetEntity.queryRedPacket(orderNumber: orderNumber)?.first {
                    redMsg.status = entity.status ?? 1
                    redMsg.entity = entity
                }
                return .redPacket(redMsg)
            }
            return .none 
        default:
            return .none
        }
    }
}


public enum MessageContent {
    case none
    case text(String)
    case image(ImageMessage)
    case video(VideoMessage)
    case location(LocationMessage)
    case link(AppURLMessage)
    case voice(VoiceMessage)
    case redPacket(RedPacketMessage)
    case emoticon(EmoticonMessage)
    case game(GameMessage)
    
    var sessionContent: String {
        switch self {
        case .text(let body):
            return body
        case .image(_):
            return "[图片]"
        case .voice(_):
            return "[语音]"
        default:
            return ""
        }
    }
}

// MARK: - ImageMessage
public struct ImageMessage {
    
    var url: URL? = nil
    
    var image: UIImage? = nil
    
    var size: CGSize = .zero
    
    public init(image: UIImage?, size: CGSize) {
        self.image = image
        self.size = size
    }
    
    public init(url: URL?, size: CGSize) {
        self.url = url
        self.size = size
    }
}

public struct VideoMessage {
    
    var url: URL? = nil
    
    var thumb: UIImage? = nil
    
    var size: CGSize = .zero
    
    var fileSize: Int = 0
    
    var duration: Float = 0.0
    
    func attributedStringForVideoLength() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: Colors.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let length = Constants.formatDuration(TimeInterval(duration))
        return NSAttributedString(string: length, attributes: attributes)
    }
}

// MARK: - VoiceMessage
public struct VoiceMessage {
    
    var duration: Int = 1
    
    func attributedStringForDuration() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        let text = String(format: "%d\"", duration)
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - RedPacketMessage
public struct RedPacketMessage: Codable {
    
    var name: String?
    var orderNumber: String?
    /// 1：拼手气红包
    var type: String?
    /// 状态(1进行中,2已完成,3已过期)
    var status: Int = 1
    
    var nickName: String?
    var head: String?
    var groupNo: String?
    
    var entity: RedPacketGetEntity?
    
    enum CodingKeys: String, CodingKey {
        case name
        case orderNumber
        case type
    }
}

// MARK: - AppURLMessage
public struct AppURLMessage {
    
    var URL: URL?
    
    var title: String?
    
    var subTitle: String?
    
    var thumbImage: UIImage?
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForSubTitle() -> NSAttributedString? {
        guard let subTitle = subTitle else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: subTitle, attributes: attributes)
        
    }
}

// MARK: - LocationMessage
public struct LocationMessage {
    
    var coordinate: CLLocationCoordinate2D
    
    var thumbImage: UIImage?
    
    var title: String?
    
    var subTitle: String?
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForDesc() -> NSAttributedString? {
        guard let desc = subTitle else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: desc, attributes: attributes)
    }
}

// MARK: - EmoticonMessage
public struct EmoticonMessage {
    var md5: String
    var packageID: String
    var title: String?
    
    var url: URL? {
        let folder = NSHomeDirectory().appending("/Documents/emoticons/pics/")
        let filename = folder.appending("\(md5).pic")
        return URL(fileURLWithPath: filename)
    }
}

// MARK: - GameMessage
public struct GameMessage {
    
    enum GameType: Int {
        case dice
        case jsb
        
        var values: [Int] {
            switch self {
            case .dice:
                return [1, 2, 3, 4, 5, 6]
            case .jsb:
                return [1, 2, 3]
            }
        }
        
        var animationImages: [UIImage] {
            var images: [UIImage] = []
            switch self {
            case .dice:
                for index in 0 ... 3 {
                    images.append(UIImage.as_imageNamed("dice_Action_\(index)_100x100_")!)
                }
            case .jsb: // 剪刀(J)、石头(S)、布(B)
                images.append(UIImage.as_imageNamed("JSB_J.pic")!)
                images.append(UIImage.as_imageNamed("JSB_S.pic")!)
                images.append(UIImage.as_imageNamed("JSB_B.pic")!)
            }
            return images
        }
        
        var animationDuration: TimeInterval {
            switch self {
            case .dice:
                return 0.4
            case .jsb:
                return 0.5
            }
        }
        
        func imageFor(value: Int?) -> UIImage? {
            guard let value = value, value > 0 else {
                return nil
            }
            switch self {
            case .dice:
                return UIImage.as_imageNamed("dic_\(value).pic")
            case .jsb:
                let map = ["JSB_J.pic", "JSB_S.pic", "JSB_B.pic"]
                let name = map[value - 1]
                return UIImage.as_imageNamed(name)
            }
        }
    }
    
    var gameType: GameType
    
    var played: Bool = false
    
    /// when has value
    var value: Int?
    
    init(gameType: GameType) {
        self.gameType = gameType
    }
    
}
