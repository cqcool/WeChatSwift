//
//  UIView+Constraint.swift
//  WeChatSwift
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func constant(height: CGFloat) {
        layoutAttribute(attribute: .height, constant: height)
    }
    func constant(width: CGFloat) {
        layoutAttribute(attribute: .width, constant: width)
    }
    
    private func layoutAttribute(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        removeAttribute(attribute: attribute)
        let constraint = NSLayoutConstraint.init(item: self,
                                                 attribute: attribute,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: constant)
        addConstraint(constraint)
    }
    
    private func removeAttribute(attribute: NSLayoutConstraint.Attribute) {
        for constraint in constraints.reversed() {
            if constraint.firstAttribute == attribute {
                removeConstraint(constraint)
            }
        }
    }
}
