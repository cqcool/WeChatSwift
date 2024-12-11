//
//  WXCreate.swift
//  NewSmart
//
//  Created by Aliens on 2022/11/25.
//

import UIKit
@objcMembers
class WXCreate: NSObject {
    public static func label(text: String? = nil, textColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = textColor
        return label
    }

    public static func button(normalTitle: String? = nil, normalColor: UIColor? = nil, normalImg: UIImage? = nil, selectedTitle: String? = nil, selectedColor: UIColor? = nil, selectedImg: UIImage? = nil, highlightedImg: UIImage? = nil, fontSize: CGFloat? = nil, weight: UIFont.Weight = .regular) -> UIButton {
        let button = UIButton(type: .custom)
        // normal
        button.setTitle(normalTitle, for: .normal)
        button.setTitleColor(normalColor, for: .normal)
        button.setImage(normalImg, for: .normal)
        // selected
        button.setTitle(selectedTitle, for: .selected)
        button.setTitleColor(selectedColor, for: .selected)
        button.setImage(selectedImg, for: .selected)
        // highlighted
        button.setImage(highlightedImg, for: .highlighted)
        if let size = fontSize {
            button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
        return button
    }

    /// 快速创建线仕途
    /// - Parameter color: 背景颜色，为nil时，使用默认色
    /// - Returns: lineView
    public static func lineView(_ color: UIColor?) -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = (color != nil) ? color! : Colors.DEFAULT_SEPARTOR_LINE_COLOR
        return lineView
    }

    public static func imageView(normalName: String, highlightedName: String? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: normalName)
        if highlightedName != nil {
            imageView.image = UIImage(named: highlightedName!)
        }
        return imageView
    }
    public static func largeGrayRightDirectionView() -> UIImageView {
        return UIImageView(image: UIImage(named: "icon_arrow_two"))
    }
}
