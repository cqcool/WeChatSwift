//
//  NoticeContentNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class NoticeContentNode: MessageContentNode {
    private let textNode = ASTextNode()
    
    init(message: Message, text: String) {
        super.init(message: message)
        
        addSubnode(textNode)
        
        let textFont = UIFont.systemFont(ofSize: 15)
        let lineHeight = textFont.lineHeight
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: textFont,
            .foregroundColor: UIColor(white: 0, alpha: 0.4),
            .paragraphStyle: paragraphStyle
            ])
        textNode.attributedText = ExpressionParser.shared?.attributedTagText(with: attributedText)
    }
    
    override func didLoad() {
        super.didLoad()
        textNode.isUserInteractionEnabled = true
//        textNode.delegate = self
        textNode.highlightStyle = .light
        textNode.layer.as_allowsHighlightDrawing = true
//        for link in links {
//            textNode.highlightRange = link.range
//        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = UIEdgeInsets(top: 1.5, left: 30, bottom: 1.5, right: 30)
        let textSpec = ASInsetLayoutSpec(insets: insets, child: textNode)
        
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textSpec)
    }
    
}
