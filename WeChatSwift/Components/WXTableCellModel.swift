//
//  WXTableCellModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit


/// Style of WCTableCell
///
/// - `default`: Normal Cell Style
/// - centerButton: Center Text Button
/// - destructiveButton: Center Text Destructive Button
enum WCTableCellStyle {
    case `default`
    case centerButton
    case destructiveButton
}

protocol WXTableCellModel {
    
    /// Icon Image, default nil
    var wx_image: UIImage? { get }
    
    var wx_imageURL: URL? { get }
    
    var wx_imageLayoutSize: CGSize { get }
    
    var wx_imageCornerRadius: CGFloat { get }
    
    var wx_title: String { get }
    
    var wx_badgeCount: Int { get }
    
    var wx_accessoryNode: ASDisplayNode? { get }
    
    var wx_showArrow: Bool { get }
    
    var wx_showSwitch: Bool { get }
    
    var wx_switchValue: Bool { get }
    
    var wx_cellStyle: WCTableCellStyle { get }
}

extension WXTableCellModel {
    
    var wx_image: UIImage? { return nil }
    
    var wx_imageURL: URL? { return nil }
    
    var wx_badgeCount: Int { return 0 }
    
    var wx_imageLayoutSize: CGSize { return CGSize(width: 24.0, height: 24.0) }
    
    var wx_imageCornerRadius: CGFloat { return 0.0 }
    
    var wx_accessoryNode: ASDisplayNode? { return nil }
    
    var wx_showArrow: Bool { return true }
    
    var wx_showSwitch: Bool { return false }
    
    var wx_switchValue: Bool { return false }
    
    var wx_cellStyle: WCTableCellStyle { return .default }
    
    func wx_attributedStringForTitle() -> NSAttributedString {
        
        switch self.wx_cellStyle {
        case .destructiveButton:
            return NSAttributedString(string: wx_title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: Colors.Red,
                ])
        default:
            return NSAttributedString(string: wx_title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor(white: 0, alpha: 0.9)
                ])
        }
    }
}
