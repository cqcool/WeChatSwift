//
//  MyProfileSection.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/14.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct MyProfileSection {
    var items: [MyProfileModel]
}

struct MyProfileModel {
    
    enum MyProfileType {
        case avatar
        case name
        case takeShot
        case wechatNo
        case qrCode
        case more
        case bells
        case wechatPoint
        case address
    }
    
    var type: MyProfileType
    var title: String
    var value: String? = nil
    var avatarUrl: String? = nil
    var image: UIImage?
    
    init(type: MyProfileType, title: String) {
        self.type = type
        self.title = title
    }
}

extension MyProfileModel: WXTableCellModel {
    
    var wx_image: UIImage? { return image }
    var wx_imageURL: URL? {
        GlobalManager.headImageUrl(name: GlobalManager.manager.personModel?.head)
    }
    var wx_title: String { return title }
    
    var wx_accessoryNode: ASDisplayNode? {
        if type == .qrCode {
            let imageNode = ASImageNode()
            imageNode.image = UIImage.SVGImage(named: "icons_outlined_qr-code")
            imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.DEFAULT_TEXT_GRAY_COLOR)
            imageNode.style.preferredSize = CGSize(width: 20, height: 20)
            return imageNode
        }
        if type == .avatar {
            let imageNode = ASNetworkImageNode()
            imageNode.defaultImage = UIImage(named: "login_defaultAvatar")
            imageNode.style.preferredSize = CGSize(width: 62, height: 62)
            imageNode.cornerRadius = 6
            if image != nil {
                imageNode.image = image
            } else {
                guard let url = wx_imageURL else { return imageNode }
                imageNode.url = url
            }
            return imageNode
        }
        guard let value = value else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: value, attributes: attributes)
        return textNode
    }
}
