//
//  ContactSettingModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

struct ContactSettingSection {
    var title: String?
    var items: [ContactSettingModel]
}

struct ContactSettingModel: WXTableCellModel {
    
    enum ContactSettingType {
        case remakAndTag
        case recommendToFriend
        case markAsStarFriend(Bool)
        case momentForbidden(Bool)
        case momentIgnore(Bool)
        case addToBlackList(Bool)
        case report
        case delete
    }
    
    var type: ContactSettingType
    
    var wx_title: String = ""
    
    var wx_showSwitch: Bool {
        switch type {
        case .markAsStarFriend(_), .momentForbidden(_), .momentIgnore(_), .addToBlackList(_):
            return true
        default:
            return false
        }
    }
    
    var wx_switchValue: Bool {
        switch type {
        case .markAsStarFriend(let isOn):
            return isOn
        case .momentForbidden(let isOn):
            return isOn
        case .momentIgnore(let isOn):
            return isOn
        case .addToBlackList(let isOn):
            return isOn
        default:
            return false
        }
    }
    
    var wx_cellStyle: WCTableCellStyle {
        switch type {
        case .delete:
            return .destructiveButton
        default:
            return .default
        }
    }
}
