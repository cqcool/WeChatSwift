//
//  RedDetailsCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class RedDetailsCellNode: ASCellNode {
    
    private let iconNode = ASNetworkImageNode()
    private let nameNode = ASTextNode()
    private let timeNode = ASTextNode()
    private let moneyNode = ASTextNode()
    private let bestLabelNode = ASTextNode()
    private let besticonNode = ASImageNode()
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init( isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        
        automaticallyManagesSubnodes = true
        
        iconNode.defaultImage = UIImage(named: "login_defaultAvatar")
        iconNode.style.preferredSize = CGSizeMake(44, 44)
        iconNode.cornerRadius = 6
        
        nameNode.attributedText = "xx".addAttributed(font: .systemFont(ofSize: 17), textColor: .black)
        timeNode.attributedText = "00:00".addAttributed(font: .systemFont(ofSize: 15), textColor: Colors.DEFAULT_TEXT_GRAY_COLOR)
        
        moneyNode.attributedText = "0.00元".unitTextAttribute(fontSize: 17, unitSize: 17, unit: "元")
        bestLabelNode.attributedText = "手气最佳".addAttributed(font: .systemFont(ofSize: 15), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR)
        
        besticonNode.image = UIImage(named: "LuckyMoney_WinnerIcon")
        besticonNode.style.preferredSize = CGSize(width: 16, height: 16)
        
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.spacingBefore = 18
        
        
        let horizontal1 = ASStackLayoutSpec.horizontal()
//        horizontal1.style.spacingBefore = 10
//        horizontal1.style.spacingAfter = 0
        horizontal1.justifyContent = .spaceBetween
//        horizontal1.alignContent = .spaceBetween
        horizontal1.children = [nameNode, moneyNode]
//        horizontal1.style.preferredSize = CGSize
        
        let horizontal3 = ASStackLayoutSpec.horizontal()
        horizontal3.spacing = 0
        horizontal3.verticalAlignment = .center
        horizontal3.children = [besticonNode, bestLabelNode]
        
        let horizontal2 = ASStackLayoutSpec.horizontal()
        horizontal2.justifyContent = .spaceBetween
//        horizontal2.style.spacingBefore = 10
//        horizontal2.style.spacingAfter = 15
        besticonNode.style.spacingAfter = 4
        bestLabelNode.style.spacingBefore = 4
        if isLastCell {
            horizontal2.children = [timeNode, horizontal3]
        } else {
            horizontal2.children = [timeNode]
        }
        
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.children = [horizontal1, horizontal2]
        vertical.style.spacingBefore = 10
        vertical.style.spacingAfter = 15
        vertical.style.flexGrow = 1
        vertical.spacing = 8
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 72)
        horizontal.children = [iconNode, vertical]
        horizontal.verticalAlignment = .center
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 15, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 15, y: 72 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [horizontal, lineNode])
    }
}
