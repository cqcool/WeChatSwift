//
//  Discover.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct DiscoverSection {
    var models: [DiscoverModel] = []
}

struct DiscoverModel {
    
    enum DiscoverType: Int {
        case moment
        case scan
        case shake
        case news
        case search
        case nearby
        case shop
        case game
        case miniProgram
        case video
        case liveProadcast
    }
    
    var type: DiscoverType
    var image: UIImage?
    var title: String
    var unread: Bool = false
    var unreadCount: Int = 0
    var enabled: Bool = true
    
    init(type: DiscoverType, title: String, icon: String, color: UIColor? = nil) {
        self.type = type
        self.title = title
        self.image = UIImage(named: icon)
        self.unread = false
        self.unreadCount = 0
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.foregroundColor: Colors.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

extension DiscoverModel: WXTableCellModel {
    
    var wx_title: String { return title }
    
    var wx_image: UIImage? { return image }
    
    var wx_badgeCount: Int { return unreadCount }
}
