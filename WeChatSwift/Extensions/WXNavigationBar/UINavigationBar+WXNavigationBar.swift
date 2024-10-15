//
//  UINavigationBar+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/27.
//

import UIKit

typealias NavigationBarFrameDidUpdated = (CGRect) -> Void

extension UINavigationBar {
    
    private struct AssociatedKeys {
        static var frameDidUpdated = "frameDidUpdated"
        static var interceptTouchEvents = "interceptTouchEvents"
    }
    
    static let swizzleNavigationBarOnce: Void = {
        let cls = UINavigationBar.self
        swizzleMethod(cls, #selector(UINavigationBar.layoutSubviews), #selector(UINavigationBar.wx_layoutSubviews))
        swizzleMethod(cls, #selector(UINavigationBar.hitTest(_:with:)), #selector(UINavigationBar.wx_hitTest(_:with:)))
    }()
    
    var frameDidUpdated: NavigationBarFrameDidUpdated? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.frameDidUpdated) as? NavigationBarFrameDidUpdated }
        set { objc_setAssociatedObject(self, &AssociatedKeys.frameDidUpdated, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    @objc private func wx_layoutSubviews() {
        frameDidUpdated?(frame)
        wx_layoutSubviews()
    }
    
    @objc open var interceptTouchEvents: Bool {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.interceptTouchEvents) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.interceptTouchEvents, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    @objc private func wx_hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if interceptTouchEvents {
            return nil
        } else {
            return wx_hitTest(point, with: event)
        }
    }
}
