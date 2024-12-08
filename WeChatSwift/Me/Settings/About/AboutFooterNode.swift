//
//  AboutFooterNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AboutFooterNode: ASDisplayNode {
    
    private let serviseButton = ASButtonNode()
    private let agreementButton = ASButtonNode()
    
    private let andTextNode = ASTextNode()
    
    private let privacyButton = ASButtonNode()
    
    private let customerNode = ASTextNode()
    private let ipcNode = ASTextNode()
    private let ipcImageNode = ASImageNode()
    private let algorithmNode = ASTextNode()
    private let algorithmImageNode = ASImageNode()
    private let copyRightNode = ASTextNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        let serviseText = NSAttributedString(string: "《软件许可及服务协议》", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
        ])
        serviseButton.setAttributedTitle(serviseText, for: .normal)
        
        let agreementText = NSAttributedString(string: "《隐私保护指引摘要》", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
        ])
        agreementButton.setAttributedTitle(agreementText, for: .normal)
        
        andTextNode.attributedText = NSAttributedString(string: "  ｜  ", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.1)
        ])
        
        let privacyText = NSAttributedString(string: "《隐私保护指引》", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
        ])
        privacyButton.setAttributedTitle(privacyText, for: .normal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        customerNode.attributedText = NSAttributedString(string: "客服电话：400 670 0700", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .paragraphStyle: paragraphStyle
        ])
        
        ipcImageNode.image = UIImage(named: "icon_right_arrow")
        ipcNode.attributedText = NSAttributedString(string: "ICP备案信息：粤 B2-20090059-1621A", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .paragraphStyle: paragraphStyle
        ])
        algorithmImageNode.image = UIImage(named: "icon_right_arrow")
        
        algorithmNode.attributedText = NSAttributedString(string: "算法备案信息", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .paragraphStyle: paragraphStyle
        ])
         
        let copyRight = LocalizedString("Setting_Other_AboutMMText")
        copyRightNode.attributedText = NSAttributedString(string: copyRight, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .paragraphStyle: paragraphStyle
        ])
    }
    
    override func didLoad() {
        super.didLoad()
        
        agreementButton.addTarget(self, action: #selector(agreementButtonClicked), forControlEvents: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func agreementButtonClicked() {
        
    }
    
    @objc private func privacyButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.horizontalAlignment = .middle
        stack.verticalAlignment = .center
        stack.children = [agreementButton, andTextNode, privacyButton]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 15)
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        
        let centerSpacer = ASLayoutSpec()
        centerSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 16)
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.flexGrow = 1.0
        
        serviseButton.style.spacingAfter = 10
        stack.style.spacingAfter = 10
        customerNode.style.spacingAfter = 10
        
        ipcImageNode.style.spacingBefore = 5
        ipcImageNode.forcedSize = CGSize(width: 6, height: 10)
        ipcImageNode.contentMode = .center
        let ipcH = ASStackLayoutSpec.horizontal()
        ipcH.horizontalAlignment = .middle
        ipcH.children = [ipcNode, ipcImageNode]
        ipcH.style.spacingAfter = 10
         
        algorithmImageNode.style.spacingBefore = 5
        algorithmImageNode.forcedSize = CGSize(width: 6, height: 10)
        algorithmImageNode.contentMode = .center
        let algorithmH = ASStackLayoutSpec.horizontal()
        algorithmH.horizontalAlignment = .middle
        algorithmH.children = [algorithmNode, algorithmImageNode]
        algorithmH.style.spacingAfter = 10
        
        copyRightNode.style.spacingAfter = 20
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [topSpacer, serviseButton, stack, customerNode, ipcH, algorithmH, copyRightNode, bottomSpacer]
        return layout
    }
}
