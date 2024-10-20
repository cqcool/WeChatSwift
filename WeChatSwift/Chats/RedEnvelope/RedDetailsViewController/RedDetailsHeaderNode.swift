//
//  RedDetailsHeaderNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RedDetailsHeaderNode: ASButtonNode {
    
    let avavarNode = ASNetworkImageNode()
    let senderNameNode = ASTextNode()
    let typeIconNode = ASImageNode()
    let blessingNode = ASTextNode()
    
    let moneyNode = ASTextNode()
    
    let toTipsNode = ASTextNode()
    let toIconNode = ASImageNode()
    
    let emojiNode = ASImageNode()
    let emojiTipsNode = ASTextNode()
    
    
    override init() {
        super.init()
        backgroundColor = .white
        
        avavarNode.defaultImage = UIImage(named: "login_defaultAvatar")
        senderNameNode.attributedText = "\("xx")发出的红包".addAttributed(font: .systemFont(ofSize: 22, weight: .medium), textColor: .black)
        typeIconNode.image = UIImage(named: "Fighting_Icon")
        
        blessingNode.attributedText = "恭喜发财，大吉大利".addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(white: 0, alpha: 0.3))
        
        moneyNode.attributedText = "0.00元".unitTextAttribute(textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR, fontSize: 40, unitSize: 16, unit: "元", baseline: 0)
        
        toTipsNode.attributedText = "已存入零钱，可用于发红包".addAttributed(font: .systemFont(ofSize: 18), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        toIconNode.image = UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        
        emojiNode.image = UIImage.SVGImage(named: "icons_outlined_sticker", fillColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        emojiTipsNode.attributedText = "回复表情到聊天".addAttributed(font: .systemFont(ofSize: 15), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
    }
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avavarNode.cornerRadius = 4
        avavarNode.style.preferredSize = CGSize(width: 25, height: 25)
        senderNameNode.style.spacingBefore = 8
        typeIconNode.style.spacingBefore = 4
        let horizontal1 = ASStackLayoutSpec.horizontal()
        horizontal1.style.spacingBefore = 78
        horizontal1.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 25)
        horizontal1.horizontalAlignment = .middle
        horizontal1.verticalAlignment = .center
        horizontal1.children = [avavarNode, senderNameNode, typeIconNode]
        
        blessingNode.style.spacingBefore = 20
        
        moneyNode.style.spacingBefore = 30
        
        let horizontal3 = ASStackLayoutSpec.horizontal()
        horizontal3.style.spacingBefore = 15
        horizontal3.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        horizontal3.horizontalAlignment = .middle
        horizontal3.verticalAlignment = .center
        horizontal3.spacing = 4
        horizontal3.children = [toTipsNode, toIconNode]
        
        let backgroundNode = ASDisplayNode()
        backgroundNode.cornerRadius = 8
        backgroundNode.backgroundColor = UIColor(white: 0.6, alpha: 0.1)
        let horizontal2 = ASStackLayoutSpec.horizontal()
                
                horizontal2.style.preferredSize = CGSize(width: 170, height: 49)
        horizontal2.horizontalAlignment = .middle
        horizontal2.verticalAlignment = .center
        horizontal2.spacing = 6
        horizontal2.children = [emojiNode, emojiTipsNode]
        let bgLayout = ASBackgroundLayoutSpec(child: horizontal2, background: backgroundNode)
        bgLayout.style.spacingBefore = 35
//        bgLayout.style.spacingBefore = 35
//        bgLayout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 49)
        
        
        
        let layout = ASStackLayoutSpec.vertical()
        layout.horizontalAlignment = .middle
        layout.style.preferredSize = CGSize(width: Constants.screenWidth, height: constrainedSize.max.height)
        layout.children = [horizontal1, blessingNode, moneyNode, horizontal3, bgLayout]
        
        return layout
    }
}
