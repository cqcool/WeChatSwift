//
//  RedPacketContentNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RedPacketContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    private let statusNode = ASTextNode()
    private let desNode = ASTextNode()
    private let lineNode = ASDisplayNode()
    
    private let redPacket: RedPacketMessage
    
    init(message: Message, redPacket: RedPacketMessage) {
        self.redPacket = redPacket
        super.init(message: message)
        
        addSubnode(bubbleNode)
        addSubnode(titleNode)
        
        let isOpen = redPacket.status == 0
        iconNode.image = UIImage(named: isOpen ? "ChatRoom_close" : "ChatRoom_open")
        iconNode.style.preferredSize = CGSize(width: 40, height: 40)
        titleNode.attributedText = (redPacket.name ?? "恭喜发财，大吉大利").addAttributed(font: UIFont.boldSystemFont(ofSize: 18), textColor: .black)
        desNode.attributedText = "微信红包".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: .black)
        lineNode.backgroundColor = .black
        statusNode.attributedText = "已领取".addAttributed(font: UIFont.systemFont(ofSize: 14), textColor: .black)
        
        addSubnode(iconNode)
        addSubnode(statusNode)
        addSubnode(desNode)
        addSubnode(lineNode)
    }
    
    func bubbleIcon() -> String {
        let isOpen = redPacket.status == 0
        return isOpen ? "ChatRoom_Bubble_Text_Receiver_Origin_57x40_" : "ChatRoom_Bubble_Text_Receiver_Origin_57x40_"
//        return isOpen ? "chat_room_red_owner_nor" : "chat_room_red_sel"
//        if message.isOutgoing {
//            return isOpen ? "ChatRoom_Bubble_HB_Sender_57x40_" : "chat_room_red_owner_nor"
//        }
//        return isOpen ? "chat_room_red_other_sel" : "ChatRoom_Bubble_HB_Receiver_Handled_57x40_"
    }
    
    override func didLoad() {
        super.didLoad()
        bubbleNode.image = UIImage(named: bubbleIcon())
        bubbleNode.style.flexShrink = 1
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let topVerticalStack = ASStackLayoutSpec.vertical()
        topVerticalStack.style.spacingBefore = 8
        topVerticalStack.verticalAlignment = .center
        titleNode.style.spacingBefore = 4.0
        topVerticalStack.children?.append(titleNode)
        if redPacket.status == 1 {
            statusNode.style.spacingBefore = 12
            topVerticalStack.children?.append(statusNode)
        }
        let horizotalStack = ASStackLayoutSpec.horizontal()
        horizotalStack.children = [iconNode, topVerticalStack]
        
        let insets: UIEdgeInsets
        if message.isOutgoing {
            lineNode.style.preferredSize = CGSize(width:Constants.screenWidth - 104.0 - 12.0 - 15.0, height: 0.5)
            insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 15)
        } else {
            lineNode.style.preferredSize = CGSize(width:Constants.screenWidth - 104.0 - 17.0 - 12.0 - 10.0, height: 0.5)
            insets = UIEdgeInsets(top: 10, left: 17, bottom: 6, right: 12)
        }
        lineNode.style.spacingBefore = 12
        desNode.style.spacingBefore = 6
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.children = [horizotalStack, lineNode, desNode]
        
        
        let insetsLayout = ASInsetLayoutSpec(insets: insets, child: verticalStack)
        let spec = ASBackgroundLayoutSpec()
            spec.background = bubbleNode
        
        spec.child = insetsLayout
        return spec
        
//        titleNode.style.preferredSize = CGSize(width: 140, height: 80)
        
//        bubbleNode.style.flexGrow = 1.0
//        bubbleNode.style.flexShrink = 1.0
//        bubbleNode.style.preferredSize = CGSize(width: 240, height: 80)
//        bubbleNode.contentMode = .scaleAspectFit
//        let insets: UIEdgeInsets
//        if message.isOutgoing {
//            insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 15)
//        } else {
//            insets = UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 12)
//        }
//       
//        
//        let insetsLayout = ASInsetLayoutSpec(insets: insets, child: bubbleNode)
//        let spec = ASBackgroundLayoutSpec()
////        spec.background = bubbleNode
//        
//        spec.child = insetsLayout
//        return spec
    }
}
