//
//  HelpRedCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/18.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HelpRedCellNode: ASCellNode {
    private let iconNode = ASImageNode()
    private let iconTextNode = ASTextNode()
    private let arrowNode = ASImageNode()
    private let question1Node = ASTextNode()
    private let question2Node = ASTextNode()
    private let question3Node = ASTextNode()
    private let lineNode = ASDisplayNode()
    private let isLastCell: Bool
    
    init(model: HelpRedModel, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        iconNode.image = model.image
        iconNode.style.preferredSize = CGSize(width: 45, height: 45)
        arrowNode.image = UIImage(named: "AlbumTimeLineTipArrow_15x15_")
        iconTextNode.attributedText = model.name.addAttributed(font: .systemFont(ofSize: 14), textColor: UIColor(white: 0, alpha: 0.4), lineSpacing: 0, wordSpacing: 0)
        question1Node.attributedText = model.q1.addAttributed(font: .systemFont(ofSize: 16), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        question1Node.maximumNumberOfLines = 1
        question2Node.maximumNumberOfLines = 1
        question3Node.maximumNumberOfLines = 1
        question2Node.attributedText = model.q2.addAttributed(font: .systemFont(ofSize: 16), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        question3Node.attributedText = model.q3.addAttributed(font: .systemFont(ofSize: 16), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cellHeight = 130.0
        let cellItemHeight = (cellHeight - 3) / 3
        let leftSpace = 112.0
        let spacing = 18.0
        let questionWidth = constrainedSize.max.width - leftSpace - spacing
        let topSpace = 10.0
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.style.preferredSize = CGSize(width: constrainedSize.max.width, height: cellHeight)
        
        let oneHorizontal = ASStackLayoutSpec.horizontal()
        oneHorizontal.children = [iconTextNode, arrowNode]
        
        let oneVertical = ASStackLayoutSpec.vertical()
        oneVertical.spacing = 10
        oneVertical.style.preferredSize = CGSize(width: leftSpace, height: cellHeight)
        oneVertical.horizontalAlignment = .middle
        oneVertical.verticalAlignment = .center
        oneVertical.children = [iconNode, oneHorizontal]
        
        question1Node.style.preferredSize = CGSize(width: questionWidth, height: cellItemHeight)
        question1Node.style.layoutPosition = CGPoint(x: 0, y: topSpace)
        let lineNode1 = ASDisplayNode()
        lineNode1.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        lineNode1.style.preferredSize = CGSize(width: questionWidth, height: Constants.lineHeight)
        lineNode1.style.layoutPosition = CGPoint(x: 0, y: cellItemHeight-1)
        
        question2Node.style.preferredSize = CGSize(width: questionWidth, height: cellItemHeight)
        question2Node.style.layoutPosition = CGPoint(x: 0, y: cellItemHeight + topSpace)
        let lineNode2 = ASDisplayNode()
        lineNode2.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        lineNode2.style.preferredSize = CGSize(width: questionWidth, height: Constants.lineHeight)
        lineNode2.style.layoutPosition = CGPoint(x: 0, y: (cellItemHeight-1)*2)
        
        question3Node.style.preferredSize = CGSize(width: questionWidth, height: cellItemHeight)
        question3Node.style.layoutPosition = CGPoint(x: 0, y: (cellItemHeight + 6)*2)
     
        let solute = ASAbsoluteLayoutSpec(children: [question1Node, lineNode1, question2Node, lineNode2, question3Node])
        horizontal.children = [oneVertical, solute]
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - spacing * 2.0, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: spacing, y: cellHeight - Constants.lineHeight)
    
        return ASAbsoluteLayoutSpec(children: [horizontal, lineNode])
    }
}
