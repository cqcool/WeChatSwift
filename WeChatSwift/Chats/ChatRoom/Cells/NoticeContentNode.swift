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
    weak var delegate: NoticeContentNodeDelegate?
    private var redResult: RedRegexResult? = nil
    
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
        var attributeStr = ExpressionParser.shared?.attributedTagText(with: attributedText)
        attributeStr = ExpressionParser.shared?.attributedCancelTagText(with: attributeStr ?? NSAttributedString(string: ""))
        let (attributed, red) = ExpressionParser.shared!.attributedRedPacketText(with: attributeStr ?? NSAttributedString(string: ""))
        textNode.attributedText = attributed
        redResult = red
    }
    
    override func didLoad() {
        super.didLoad()
        if let result = redResult {
            textNode.isUserInteractionEnabled = true
            textNode.isEnabled = true
            textNode.delegate = self
//            textNode.highlightStyle = .light
//            textNode.layer.as_allowsHighlightDrawing = true
//            textNode.highlightRange = result.range
            
             let str = (textNode.attributedText?.string as! NSString).substring(with: result.range)
            debugPrint("hilight text: \(str)")
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = UIEdgeInsets(top: 1.5, left: 30, bottom: 1.5, right: 30)
        let textSpec = ASInsetLayoutSpec(insets: insets, child: textNode)
        
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textSpec)
    }
    
}
extension NoticeContentNode: ASTextNodeDelegate {
    
    func textNode(_ textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
        return true
    }
    
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        delegate?.textContentNode(self, tappedLinkAttribute: attribute, value: (value as? URL)?.absoluteString, at: point, textRange: textRange)
    }
}

protocol NoticeContentNodeDelegate: class {
    func textContentNode(_ textNode: NoticeContentNode, tappedLinkAttribute attribute: String!, value: String!, at point: CGPoint, textRange: NSRange)
}
