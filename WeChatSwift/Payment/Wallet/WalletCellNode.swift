//
//  WalletCellNode.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/9.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class WalletCellNode: ASCellNode {
    private let iconNode = ASNetworkImageNode()
    private let titleNode = ASTextNode()
    private let additionalNode = ASTextNode()
    private let arrowNode = ASImageNode()
    private let valueNode = ASTextNode()
    private let lineNode = ASDisplayNode()
    private let model: WalletModel
    private let isLastCell: Bool
    
    init(model: WalletModel, isLastCell: Bool) {
        self.model = model
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
//        if model.wx_imageURL != nil {
//            iconNode.url = model.wx_imageURL
//        } else {
        iconNode.image = model.image
//        }
        titleNode.attributedText = model.wx_attributedStringForTitle()
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        if let additional = model.wx_attributedStringForAdditional() {
            additionalNode.attributedText = additional
        }
        if let value = model.attributedStringForValue() {
            valueNode.attributedText = value
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        if model.wx_cellStyle == .centerButton || model.wx_cellStyle == .destructiveButton {
            let stack = ASStackLayoutSpec.horizontal()
            stack.horizontalAlignment = .middle
            stack.verticalAlignment = .center
            stack.children = [titleNode]
            stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
            return stack
        }
        
        var elements: [ASLayoutElement] = []
        var leading: CGFloat = 0.0
        
        // Append Image
        if model.wx_image != nil || model.wx_imageURL != nil  {
            iconNode.style.spacingBefore = 16
            iconNode.style.preferredSize = model.wx_imageLayoutSize
            elements.append(iconNode)
            if !isLastCell {
                leading += 16.0 + model.wx_imageLayoutSize.width
            }
        }
        
        // Append Title
        titleNode.style.spacingBefore = 16.0
        elements.append(titleNode)
        leading += 16.0
        if model.wx_attributedStringForAdditional() != nil {
            additionalNode.style.spacingBefore = 10.0
//            additionalNode.attributedText = additional
            elements.append(additionalNode)
        }
        
        // Append Spacer
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        elements.append(spacer)
        
        if model.attributedStringForValue() != nil {
//            valueNode.attributedText = value
            elements.append(valueNode)
        }
        // Append Arrow
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingBefore = 10
        arrowNode.style.spacingAfter = 16
        elements.append(arrowNode)
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = elements
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
//        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - leading, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: leading, y: 56 - Constants.lineHeight)
    
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
