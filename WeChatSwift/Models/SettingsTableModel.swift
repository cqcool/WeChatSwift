//
//  SettingsTableModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct SettingsTableGroupModel {
    var models: [SettingsTableModel]
}

struct SettingsTableModel {
    var type: SettingsType
    
    var title: String
    
    var leftImage: UIImage?
    
    var value: String? = nil
    
    init(type: SettingsType, title: String) {
        self.type = type
        self.title = title
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForValue() -> NSAttributedString? {
        guard let value = value else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        return NSAttributedString(string: value, attributes: attributes)
    }
}

extension SettingsTableModel: WCTableCellModel {
    
    var wc_title: String { return title }
    
    var wc_image: UIImage? { return nil }
    
    var wc_accessoryNode: ASDisplayNode? {
        guard let value = value else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: value, attributes: attributes)
        return textNode
    }
    
    var wc_cellStyle: WCTableCellStyle {
        switch type {
        case .switchAccount, .logout:
            return .centerButton
        default:
            return .default
        }
    }
}

enum SettingsType {
    case accountAndSecurity
    case teenagers
    case care
    case newMessageNotification
    case chat
    case privacy
    case general
    case helpAndFeedback
    case about
    case plugins
    case switchAccount
    case logout
    case friend
    case personal
    case personalCollection
    case third
}


struct SettingGeneralGroup {
    var items: [SettingGeneral]
}

enum SettingGeneral {
    case language
    case font
    case backgroundImage
    case emoticon
    case files
    case earmode
    case discover
    case plugins
    case backup
    case storage
    case clearChatHistory
    
    var title: String {
        switch self {
        case .language:
            return LocalizedString("Setting_Language")
        case .font:
            return LocalizedString("Setting_FontSize")
        case .backgroundImage:
            return LocalizedString("Setting_ChatBackgroundConfig")
        case .emoticon:
            return LocalizedString("EmoticonManageTitle")
        case .files:
            return LocalizedString("Setting_Photos_And_Videos_And_Files")
        case .earmode:
            return LocalizedString("EARPIECE_AUTOSWITCH")
        case .discover:
            return LocalizedString("Setting_DiscoverEntranceTitle")
        case .plugins:
            return LocalizedString("Setting_PluginsTitle")
        case .backup:
            return LocalizedString("Setting_ChatLog")
        case .storage:
            return LocalizedString("Setting_StorageUsageVC_Title")
        case .clearChatHistory:
            return LocalizedString("Setting_ClearLocalData")
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

extension SettingGeneral: WCTableCellModel {
    
    var wc_image: UIImage? { return nil }
    
    var wc_title: String { return title }
    
    var wc_showSwitch: Bool {
        return self == .earmode
    }
    
    var wc_switchValue: Bool {
        return true
    }
    
    var wc_cellStyle: WCTableCellStyle {
        if self == .clearChatHistory {
            return .centerButton
        }
        return .default
    }
}


struct SettingPluginSection {
    var title: String
    var items: [SettingPluginItem]
}

enum SettingPluginItem: WCTableCellModel {
    case groupMessageAssistant
    case news
    case weSport
    case qqMail
    
    var wc_title: String {
        switch self {
        case .groupMessageAssistant:
            return "群发助手"
        case .news:
            return "腾讯新闻"
        case .weSport:
            return "微信运动"
        case .qqMail:
            return "QQ邮箱提醒"
        }
    }
    
    var wc_image: UIImage? {
        switch self {
        case .groupMessageAssistant:
            return UIImage(named: "Plugins_groupsms_29x29_")
        case .news:
            return UIImage(named: "Plugins_News_29x29_")
        case .weSport:
            return UIImage(named: "Plugins_WeSport_29x29_")
        case .qqMail:
            return UIImage(named: "Plugins_QQMail_29x29_")
        }
    }
}


struct SettingAutoDownloadSection {
    var title: String
    var items: [SettingAutoDownloadModel]
}

enum SettingAutoDownloadModel: WCTableCellModel {
    case automaticallyDownload(Bool)
    case photoSaveToPhone(Bool)
    case videoSaveToPhone(Bool)
    case automaticallyPlayWWAN(Bool)
    
    var wc_title: String {
        switch self {
        case .automaticallyDownload(_):
            return "自动下载"
        case .photoSaveToPhone(_):
            return "照片"
        case .videoSaveToPhone(_):
            return "视频"
        case .automaticallyPlayWWAN(_):
            return "移动网络下视频自动播放"
        }
    }
    
    var wc_showSwitch: Bool {
        return true
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .automaticallyDownload(let isOn):
            return isOn
        case .photoSaveToPhone(let isOn):
            return isOn
        case .videoSaveToPhone(let isOn):
            return isOn
        case .automaticallyPlayWWAN(let isOn):
            return isOn
        }
    }
}
