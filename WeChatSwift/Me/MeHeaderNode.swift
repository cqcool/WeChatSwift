//
//  MeHeaderNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MeHeaderNode: ASButtonNode {
    
    let avatarNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let qrCodeNode = ASImageNode()
    
    private let arrowNode = ASImageNode()
    
    private let statusBgNode = ASDisplayNode()
    private let statusIconNode = ASImageNode()
    private let statusTextNode = ASTextNode()
    private let statusRefreshNode = ASImageNode()
    
    override init() {
        super.init()
        
        avatarNode.cornerRadius = 10
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.defaultImage = UIImage(named: "login_defaultAvatar")
        qrCodeNode.image = UIImage.SVGImage(named: "icons_outlined_qr-code")
        qrCodeNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.DEFAULT_TEXT_GRAY_COLOR)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        
        statusIconNode.image = UIImage(named: "icon_me_status_add")

        
        statusTextNode.attributedText = "状态".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: UIColor(white: 0, alpha: 0.5))
        statusRefreshNode.image = UIImage(named: "icon_me_status_refresh")
    }
    func reloadContent() {
        if let person = GlobalManager.manager.personModel {
            nameNode.attributedText = NSAttributedString(string: person.nickname ?? "未设置名称", attributes: [
                .font: UIFont.systemFont(ofSize: 21, weight: .medium),
                .foregroundColor: UIColor.black
            ])
            descNode.attributedText = NSAttributedString(string: "微信号：\(person.wechatId ?? " ")", attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor(white: 0, alpha: 0.5)
                ])
        }
    }
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        nameNode.style.flexGrow = 1.0
        descNode.style.flexGrow = 1.0
        
        avatarNode.style.preferredSize = CGSize(width: 64, height: 64)
        avatarNode.style.spacingBefore = 16
        qrCodeNode.style.preferredSize = CGSize(width: 18, height: 18)
        qrCodeNode.style.spacingAfter = 12
        qrCodeNode.style.spacingBefore = 8
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 16
        
        statusBgNode.cornerRadius = 12
        statusBgNode.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        statusBgNode.borderWidth = 0.5
        
        statusIconNode.forcedSize = CGSize(width: 11, height: 11)
        statusIconNode.contentMode = . center
        statusIconNode.style.spacingBefore = 6.0
        statusTextNode.style.spacingBefore = 2.0
        let statusHorizatal = ASStackLayoutSpec.horizontal()
        statusHorizatal.style.preferredSize = CGSize(width: 63, height: 24)
        statusHorizatal.verticalAlignment = .center
        statusHorizatal.children = [statusIconNode, statusTextNode]
        
        let statusBgSpce = ASBackgroundLayoutSpec(child: statusHorizatal, background: statusBgNode)
        statusBgSpce.style.spacingBefore = 64.0 + 16.0 + 20.0
        
        statusRefreshNode.forcedSize = CGSize(width: 24, height: 24)
        statusRefreshNode.contentMode = . center
        let refreshHorizatal = ASStackLayoutSpec.horizontal()
//        refreshHorizatal.style.spacingBefore = 4
        refreshHorizatal.style.preferredSize = CGSize(width: 24, height: 24)
        refreshHorizatal.verticalAlignment = .center
        refreshHorizatal.children = [statusRefreshNode]
        
        let statusTotalHorizal = ASStackLayoutSpec.horizontal()
        statusTotalHorizal.children = [statusBgSpce, refreshHorizatal]
         
        
        let descStack = ASStackLayoutSpec.horizontal()
        descStack.alignItems = .center
        descStack.style.flexGrow = 1.0
        descStack.children = [descNode, qrCodeNode, arrowNode]
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.style.flexGrow = 1.0
        infoStack.children = [nameNode, descStack]
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.alignItems = .center
        horizontalStack.spacing = 20
        horizontalStack.children = [avatarNode, infoStack]
        
        let totalVStack = ASStackLayoutSpec.vertical()
//        totalVStack.style.flexGrow = 1.0
        totalVStack.children = [horizontalStack, statusTotalHorizal]
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [totalVStack, spacer ]
        
        return layout
    }
    
}
