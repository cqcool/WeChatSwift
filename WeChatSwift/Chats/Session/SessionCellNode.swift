//
//  SessionCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SessionCellNode: ASCellNode {
    
    private let session: GroupEntity
    
    private let avatarNode = ASNetworkImageNode()
    
    private let badgeNode = BadgeNode()
    
    private let titleNode = ASTextNode()
    
    private let draftNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    private let timeNode = ASTextNode()
    
    private let muteNode = ASImageNode()
    
    private let hairlineNode = ASDisplayNode()
    
    init(session: GroupEntity) {
        self.session = session
        super.init()
        
        automaticallyManagesSubnodes = true
        
        avatarNode.cornerRadius = 4.0
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.defaultImage = UIImage.as_imageNamed("DefaultHead_48x48_")
//        if session.avatarImage != nil {
//            avatarNode.image = session.avatarImage
//        } else {
            avatarNode.url = GlobalManager.headImageUrl(name: session.head)
//        }
        
        titleNode.attributedText = session.attributedStringForTitle()
        titleNode.maximumNumberOfLines = 1
        
        timeNode.attributedText = session.attributedStringForTime()
        
        draftNode.attributedText = NSAttributedString(string: "草稿", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#B71414")
        ]) 
        subTitleNode.attributedText = session.attributedStringForSubTitle()
        subTitleNode.maximumNumberOfLines = 1
        
        muteNode.image = UIImage.as_imageNamed("chatNotPush_15x15_")
        muteNode.style.spacingAfter = 16
        muteNode.style.preferredSize = CGSize(width: 15, height: 15)
        
        hairlineNode.backgroundColor = UIColor(white: 0, alpha: 0.15)
        hairlineNode.style.preferredSize = CGSize(width: 9, height: Constants.lineHeight)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = false/*session.stickTop*/ ? UIColor(hexString: "#F2F2F2") : UIColor(hexString: "#FEFFFF")
        badgeNode.update(count: Int(session.unReadNum ?? "0")!, showDot: false/*session.showUnreadAsRedDot*/)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let unReadNum = (session.unReadNum ?? "0").isEmpty ? 0 : Int(session.unReadNum!)!
        var badgeSize = CGSizeZero
        if unReadNum < 99 {
            badgeSize = CGSize(width: 30, height: 30)
        } else {
            badgeSize = CGSize(width: 40, height: 30)
        }
        badgeNode.style.preferredSize = badgeSize
        avatarNode.style.preferredSize = CGSize(width: 48.0, height: 48.0)
        
        let avatarLayout: ASLayoutSpec
        if unReadNum > 0 {
            avatarNode.style.layoutPosition = CGPoint(x: 16.0, y: 12.0)
            badgeNode.style.layoutPosition = CGPoint(x: 47, y: -1)
            avatarLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: ASAbsoluteLayoutSpec(children: [avatarNode, badgeNode]))
        } else {
            avatarLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 12), child: avatarNode)
        }
        avatarLayout.style.preferredSize = CGSize(width: 72.0, height: 76.0)
        
        titleNode.style.flexGrow = 1.0
        titleNode.style.flexShrink = 1.0
        titleNode.style.spacingAfter = 15
        timeNode.style.spacingAfter = 16
        subTitleNode.style.flexGrow = 1.0
        subTitleNode.style.flexShrink = 1.0
        subTitleNode.style.spacingAfter = 12
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.alignItems = .center
        topStack.children = [titleNode, timeNode]
        
        var bottomElements: [ASLayoutElement] = []
        if false/*session.showDrafts*/ {
            bottomElements.append(draftNode)
        }
        bottomElements.append(subTitleNode)
        if false/*session.muted*/ {
            bottomElements.append(muteNode)
        }
        let bottomStack = ASStackLayoutSpec.horizontal()
        bottomStack.children = bottomElements
        
        let stack = ASStackLayoutSpec.vertical()
        stack.style.flexGrow = 1.0
        stack.style.flexShrink = 1.0
        stack.spacing = 6
        stack.children = [topStack, bottomStack]
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.alignItems = .center
        layout.children = [avatarLayout, stack]
        layout.style.preferredSize = CGSize(width: Constants.screenWidth, height: 72)
        
        let abs = ASAbsoluteLayoutSpec(children: [layout, hairlineNode])
        hairlineNode.style.layoutPosition = CGPoint(x: 76, y: 72 - Constants.lineHeight)
        hairlineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 76, height: Constants.lineHeight)
        return abs
    }
}
