//
//  RedDetailsHeaderNode.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RedDetailsHeaderNode: ASDisplayNode {
    
    let avavarNode = ASNetworkImageNode()
    let senderNameNode = ASTextNode()
    let typeIconNode = ASImageNode()
    let blessingNode = ASTextNode()
    
    let moneyNode = ASTextNode()
    
    let toTipsNode = ASTextNode()
    let toIconNode = ASImageNode()
    
    let backgroundNode = ASDisplayNode()
    let emojiNode = ASImageNode()
    let emojiTipsNode = ASTextNode()
    var resp: FullRedPacketGetEntity? = nil
    
    
    override init() {
        super.init()
        backgroundColor = .white
        
        avavarNode.defaultImage = UIImage(named: "login_defaultAvatar")
        addSubnode(avavarNode)
        senderNameNode.attributedText = "\("xx")发出的红包".addAttributed(font: .systemFont(ofSize: 22, weight: .medium), textColor: .black)
        addSubnode(senderNameNode)
        typeIconNode.image = UIImage(named: "Fighting_Icon")
        addSubnode(typeIconNode)
        blessingNode.attributedText = "恭喜发财，大吉大利".addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(white: 0, alpha: 0.3))
        addSubnode(blessingNode)
        setMoneyContent(str: "0.00 元")
        addSubnode(moneyNode)
        toTipsNode.attributedText = "已存入零钱，可用于发红包".addAttributed(font: .systemFont(ofSize: 14), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        addSubnode(toTipsNode)
        toIconNode.image = UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        addSubnode(toIconNode)
        emojiNode.image = UIImage.SVGImage(named: "icons_outlined_sticker", fillColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        emojiNode.forcedSize = CGSize(width: 18, height: 18)
        emojiNode.contentMode = .scaleAspectFit
        addSubnode(emojiNode)
        emojiTipsNode.attributedText = "回复表情到聊天".addAttributed(font: .systemFont(ofSize: 15), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        addSubnode(emojiTipsNode)
        
        backgroundNode.cornerRadius = 4
        backgroundNode.backgroundColor = UIColor(white: 0.7, alpha: 0.1)
        backgroundNode.cornerRoundingType = .defaultSlowCALayer
        addSubnode(backgroundNode)
    }
    override func didLoad() {
        super.didLoad()
    }
    
    func updateContent(resp: FullRedPacketGetEntity) {
        self.resp = resp
        let headUrl = GlobalManager.headImageUrl(name: resp.senderUserHead ?? "")
        avavarNode.url = headUrl
        setMoneyContent(str: (resp.myselfReceiveAmount ?? "0.00") + " 元")
        senderNameNode.attributedText = "\(resp.senderUserNickname ?? "")发出的红包".addAttributed(font: .systemFont(ofSize: 22, weight: .medium), textColor: .black)
    }
    private func setMoneyContent(str: String) {
        moneyNode.attributedText = (str).unitTextAttribute(textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR, fontSize: 48, unitSize: 16, unit: "元", baseline: 0)
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
        
        blessingNode.style.spacingBefore = 12
        
        moneyNode.style.spacingBefore = 20
        
        let horizontal3 = ASStackLayoutSpec.horizontal()
        horizontal3.style.spacingBefore = 13
        horizontal3.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        horizontal3.horizontalAlignment = .middle
        horizontal3.verticalAlignment = .center
        horizontal3.spacing = 4
        horizontal3.children = [toTipsNode, toIconNode]
        
        let horizontal2 = ASStackLayoutSpec.horizontal()
        horizontal2.style.preferredSize = CGSize(width: 170, height: 49)
        horizontal2.horizontalAlignment = .middle
        horizontal2.verticalAlignment = .center
        horizontal2.spacing = 6
        horizontal2.children = [emojiNode, emojiTipsNode]
        let overlay = ASBackgroundLayoutSpec(child: horizontal2, background: backgroundNode)
        overlay.style.spacingBefore = 35
        
        let layout = ASStackLayoutSpec.vertical()
        layout.horizontalAlignment = .middle
        layout.style.preferredSize = CGSize(width: Constants.screenWidth, height: constrainedSize.max.height)
        if self.resp?.isMyselfReceive == 1 {
            layout.children = [horizontal1, blessingNode, moneyNode, horizontal3, overlay]
        } else {
            layout.children = [horizontal1, blessingNode]
        }
        
        return layout
    }
}
