//
//  SmallChangeCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/9.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SmallChangeCellNode: ASCellNode {
    private let iconNode = ASNetworkImageNode()
    private let myChangeNode = ASTextNode()
    private let smallChangeNode = ASTextNode()
    private let tipsNode = ASTextNode()
    private let tipsArrowNode = ASImageNode()
    private let topUpNode = ASButtonNode()
    private let withdrawNode = ASButtonNode()
    private let commonNode = ASTextNode()
    private let ownerNode = ASTextNode()
    
    init(model: String) {
        super.init()
        automaticallyManagesSubnodes = true
//        if model.wc_imageURL != nil {
//            iconNode.url = model.wc_imageURL
//        } else {
        iconNode.image = UIImage(named: "kinda_balance_entry_logo")
//        }
        myChangeNode.attributedText = NSAttributedString(string: "我的零钱", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 1)
            ])
        smallChangeNode.attributedText = smallChangeAttributeText(value:model)
        tipsNode.attributedText = NSAttributedString(string: "转入零钱通，能赚又能花 ", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: Colors.Orange_100
            ])
        
        topUpNode.setTitle("充值", with: .systemFont(ofSize: 17), with: .white, for: .normal)
        topUpNode.backgroundColor = UIColor(hexString: "07C05F")
        topUpNode.style.minSize = CGSize(width: 184, height: 50)
        topUpNode.cornerRadius = 8
        topUpNode.clipsToBounds = true
        topUpNode.contentHorizontalAlignment = .middle
        topUpNode.backgroundColor = UIColor(hexString: "07C05F")
        
        withdrawNode.setTitle("提现", with: .systemFont(ofSize: 17), with: .black, for: .normal)
        withdrawNode.backgroundColor = UIColor(hexString: "07C05F")
        withdrawNode.style.minSize = CGSize(width: 184, height: 50)
        withdrawNode.cornerRadius = 8
        withdrawNode.clipsToBounds = true
        withdrawNode.contentHorizontalAlignment = .middle
        withdrawNode.backgroundColor = UIColor(hexString: "F1F2F1")

        
        tipsArrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: Colors.Orange_100)
//        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        commonNode.attributedText = NSAttributedString(string: "常见问题", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .foregroundColor: UIColor(hexString: "566B94"),
            ])
        ownerNode.attributedText = NSAttributedString(string: "本服务由财付通提供", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
            ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.verticalAlignment = .top
        verticalStack.horizontalAlignment = .middle
        verticalStack.style.preferredSize = CGSize(width: Constants.screenWidth, height: Constants.screenHeight - Constants.statusBarHeight-44 - Constants.bottomInset - 10)
        iconNode.style.spacingBefore = 60
        iconNode.style.preferredSize = CGSize(width: 82, height: 82)
        verticalStack.children?.append(iconNode)
        myChangeNode.style.spacingBefore = 40
        verticalStack.children?.append(myChangeNode)
        smallChangeNode.style.spacingBefore = 12
        
        
        verticalStack.children?.append(smallChangeNode)
        let stack = ASStackLayoutSpec.horizontal()
        stack.style.spacingBefore = 22
        stack.alignItems = .center
        stack.children = [tipsNode, tipsArrowNode]
        verticalStack.children?.append(stack)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        verticalStack.children?.append(spacer)
        // 充值
        verticalStack.children?.append(topUpNode)
        withdrawNode.style.spacingBefore = 20
        withdrawNode.style.spacingAfter = 60
        verticalStack.children?.append(withdrawNode)
        commonNode.style.spacingAfter = 10
        verticalStack.children?.append(commonNode)
        ownerNode.style.spacingAfter = 25
        verticalStack.children?.append(ownerNode)
        return verticalStack
    }
    private func smallChangeAttributeText(value: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        // 设置文本顶部对齐
        paragraphStyle.lineSpacing = 2
        let unit = "¥"
        let text = unit+value
        let mutableAttribtue = NSMutableAttributedString(string: text, attributes: [
            .font: Fonts.font(.superScriptMedium, fontSize: 50)!,
            .foregroundColor: UIColor(white: 0, alpha: 1),
            .paragraphStyle: paragraphStyle,
            .baselineOffset: -12
            ])
//        if let range = text.range(of: unit) {
//            let nsRange = NSRange(range, in: text)
//            mutableAttribtue.setAttributes([.font: UIFont.systemFont(ofSize: 30, weight: .bold),], range: nsRange)
//        }
        return mutableAttribtue
    }
}
