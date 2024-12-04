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
//    private let imgView = UIImageView()
//    private let spacer = ASDisplayNode()
    private let redPacket: RedPacketMessage
    
    init(message: Message, redPacket: RedPacketMessage) {
        self.redPacket = redPacket
        super.init(message: message)
        
        addSubnode(bubbleNode)
        addSubnode(titleNode)
        
        let isOpen = redPacket.entity == nil
        iconNode.image = UIImage(named: isOpen ? "ChatRoom_close" : "ChatRoom_open")
        iconNode.style.preferredSize = CGSize(width: 40, height: 40)
        titleNode.attributedText = (redPacket.name ?? "恭喜发财，大吉大利").addAttributed(font: UIFont.boldSystemFont(ofSize: 18), textColor: .white)
        desNode.attributedText = "微信红包".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: .white)
        lineNode.backgroundColor = UIColor(white: 1, alpha: 0.5)
        statusNode.attributedText = "已领取".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: .white)
        
        addSubnode(iconNode)
        addSubnode(statusNode)
        addSubnode(desNode)
        addSubnode(lineNode)
         
//        spacer.backgroundColor = .red
//        spacer.style.flexGrow = 1
//        spacer.style.flexShrink = 1
//        bubbleNode.style.flexGrow = 1
    }
    
    func bubbleIcon() -> String {
        let isOpen = redPacket.entity != nil
        if message.isOutgoing {
            return isOpen ? "ChatRoom_Bubble_HB_Sender_Handled_57x40_" : "ChatRoom_Bubble_HB_Sender_57x40_"
        }
        return isOpen ? "ChatRoom_Bubble_HB_Receiver_Handled_57x40_" : "ChatRoom_Bubble_Text_Receiver_Origin_57x40_"
    }
    override func layout() {
        super.layout()
        // 假设你已经有了一个UIImage对象
        let image = UIImage(named: bubbleIcon())
        let height = (image?.size.height)!
        let width = (image?.size.width)!
        // 设置图片的四个角不进行拉伸，四个角的宽度和高度
        let capInsets = UIEdgeInsets(top: 30, left: 30, bottom:10, right: 30)
        // 设置拉伸模式，这里使用.stretched
        let resizingMode = UIImage.ResizingMode.stretch
        // 创建拉伸后的图片
        let resizedImage = image?.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode)
        bubbleNode.image = resizedImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let topVerticalStack = ASStackLayoutSpec.vertical()
        topVerticalStack.style.spacingBefore = 8
        topVerticalStack.verticalAlignment = .center
        topVerticalStack.children?.append(titleNode)
        if redPacket.entity != nil {
            if redPacket.entity?.isMyselfReceive == 1 {
                statusNode.attributedText = "已领取".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: .white)
            } else if redPacket.entity?.status == 2 {
                statusNode.attributedText = "已被领完".addAttributed(font: UIFont.systemFont(ofSize: 13), textColor: .white)
            }
            statusNode.style.spacingBefore = 4
            topVerticalStack.children?.append(statusNode)
        }
        let horizotalStack = ASStackLayoutSpec.horizontal()
        horizotalStack.verticalAlignment = .center
        horizotalStack.children = [iconNode, topVerticalStack]
        
        let insets: UIEdgeInsets
        if message.isOutgoing {
            lineNode.style.preferredSize = CGSize(width:Constants.screenWidth - 104.0 - 12.0 - 15.0, height: 0.1)
//            insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 15)
            insets = UIEdgeInsets(top: 12, left: 12, bottom: 6, right: 15)
        } else {
            lineNode.style.preferredSize = CGSize(width:Constants.screenWidth - 104.0 - 17.0 - 12.0 - 10.0, height: 0.1)
//            insets = UIEdgeInsets(top: 10, left: 17, bottom: 6, right: 12)
            insets = UIEdgeInsets(top: 12, left: 17, bottom: 4, right: 12)
        }
        lineNode.style.spacingBefore = 18
        desNode.style.spacingBefore = 6
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.children = [horizotalStack, lineNode, desNode]
        
        let insetsLayout = ASInsetLayoutSpec(insets: insets, child: verticalStack)
        
        let spec = ASBackgroundLayoutSpec()
            spec.background = bubbleNode
        
        spec.child = insetsLayout
        return spec
    }
}
