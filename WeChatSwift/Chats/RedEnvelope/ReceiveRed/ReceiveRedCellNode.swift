//
//  ReceiveRedCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/18.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ReceiveRedCellNode: ASCellNode {
    private let nameNode = ASTextNode()
    private let pinImageNode = ASImageNode()
    private let timeNode = ASTextNode()
    private let moneyNode = ASTextNode()
    private let lineNode = ASDisplayNode()
    private let isLastCell: Bool
    
    init(model: RedPacketRecordModel, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        nameNode.attributedText = (model.nickname ?? "").addAttributed(font: .systemFont(ofSize: 17), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        pinImageNode.image = UIImage(named: "LuckyMoney_PinIcon")
        pinImageNode.style.preferredSize = CGSize(width: 15, height: 15)
        timeNode.attributedText = (model.receiveTime ?? "x月x日").addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(white: 0, alpha: 0.7), lineSpacing: 0, wordSpacing: 0)
        moneyNode.attributedText = ((model.amount ?? "0.00" + "元")).addAttributed(font: .systemFont(ofSize: 17), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing = 15.0
        let oneLeftHorizontal = ASStackLayoutSpec.horizontal()
        oneLeftHorizontal.children = [nameNode, pinImageNode]
        oneLeftHorizontal.style.spacingBefore = spacing
        oneLeftHorizontal.spacing = 4
        oneLeftHorizontal.verticalAlignment = .center
         
        moneyNode.style.spacingAfter = spacing
        let oneHorizontal = ASStackLayoutSpec.horizontal()
        oneHorizontal.children = [oneLeftHorizontal, moneyNode]
        oneHorizontal.justifyContent = .spaceBetween
        
        
        timeNode.style.spacingBefore = spacing
        let twoHorizontal = ASStackLayoutSpec.horizontal()
        twoHorizontal.children = [timeNode]
        
        let stack = ASStackLayoutSpec.vertical()
        stack.verticalAlignment = .center
        stack.spacing = 6
        stack.children = [oneHorizontal, twoHorizontal]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 65)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - spacing * 2.0, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: spacing, y: 65 - Constants.lineHeight)
    
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
