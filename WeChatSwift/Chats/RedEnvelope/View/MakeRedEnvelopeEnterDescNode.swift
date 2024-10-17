//
//  MakeRedEnvelopeEnterDescNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MakeRedEnvelopeEnterDescNode: ASDisplayNode {
    
    private let addEmoticonButton = ASButtonNode()
    private let textNode = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textNode.attributedText = NSAttributedString(string: "恭喜发财，大吉大利", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.5)
        ])
        
        addEmoticonButton.setImage(UIImage(named: "AddExpression_Icon_29x29_"), for: .normal)
        addEmoticonButton.setImage(UIImage(named: "AddExpression_Icon_Pressed_29x29_"), for: .highlighted)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 8
        cornerRoundingType = .defaultSlowCALayer
        
        addEmoticonButton.addTarget(self, action: #selector(handleAddEmoticonButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleAddEmoticonButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        textNode.style.preferredSize = CGSize(width: 170, height: 20)
        textNode.style.layoutPosition = CGPoint(x: 18, y: 22) 
        addEmoticonButton.style.preferredSize = CGSize(width: 29.0, height: 29.0)
        addEmoticonButton.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 29.0 - 20.0, y: 17.5)
        
        let layout = ASAbsoluteLayoutSpec(children: [textNode, addEmoticonButton])
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56.0)
        return layout
    }
    
}
