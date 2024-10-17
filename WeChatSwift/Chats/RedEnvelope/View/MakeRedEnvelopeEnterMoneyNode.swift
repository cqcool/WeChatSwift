//
//  MakeRedEnvelopeEnterMoneyNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MakeRedEnvelopeEnterMoneyNode: ASDisplayNode {
    
    var moneyChangeBlock: ((_ money: String?) -> Void)?
    var money: String?
    
    private  let pinImageNode = ASImageNode()
    private let leadingTextNode = ASTextNode()
    
    private let inputTextNode = ASEditableTextNode()
    
    private let trailingTextNode = ASTextNode()
    
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        pinImageNode.image = UIImage(named: "pin")
        
        leadingTextNode.attributedText = NSAttributedString(string: "总金额", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
        
//        trailingTextNode.attributedText = NSAttributedString(string: "元", attributes: [
//            .font: UIFont.systemFont(ofSize: 17),
//            .foregroundColor: Colors.black
//        ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes = [
            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "C5C5C7"),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        inputTextNode.keyboardType = .decimalPad
        inputTextNode.delegate = self
        inputTextNode.attributedPlaceholderText = NSAttributedString(string: "¥0.00", attributes: attributes)
        inputTextNode.typingAttributes = [
            NSAttributedString.Key.font.rawValue: Fonts.font(.superScriptMedium, fontSize: 17)!,
            NSAttributedString.Key.foregroundColor.rawValue: Colors.black,
            NSAttributedString.Key.paragraphStyle.rawValue: paragraphStyle
        ]
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 8
        cornerRoundingType = .defaultSlowCALayer
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        pinImageNode.style.spacingBefore = 8
        leadingTextNode.style.spacingBefore = 10
        inputTextNode.style.flexGrow = 1.0
        inputTextNode.style.flexShrink = 1.0
        
        trailingTextNode.style.spacingBefore = 10
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [pinImageNode, leadingTextNode, inputTextNode, trailingTextNode]
        
        let insets = UIEdgeInsets(top: 17.5, left: 10, bottom: 17.5, right: 10)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return inputTextNode.resignFirstResponder()
    }
    
    func updateContent(type: RedPacketError) {
        let color: UIColor = type == .normal ? .black : UIColor(hexString: "E84800")
        leadingTextNode.attributedText = NSAttributedString(string: "总金额", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: color
        ])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let text = inputTextNode.textView.text ?? ""
        inputTextNode.attributedText = NSAttributedString(string: text,
                                                          attributes: [
            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
    }
}

extension MakeRedEnvelopeEnterMoneyNode: ASEditableTextNodeDelegate {
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let futureString = NSMutableString(string: editableTextNode.textView.text ?? "")
        futureString.insert(text, at: range.location)
        var flag = 0;
        let limited = 2;//小数点后需要限制的个数
        if !futureString.isEqual(to: "") {
            for i in stride(from: (futureString.length - 1), through: 0, by: -1) {
                let char = Character(UnicodeScalar(futureString.character(at: i))!)
                if char == "." {
                    if flag > limited {
                        return false
                    }
                    break
                }
                flag += 1
            }
        }
        return true
    }
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        
        var text = editableTextNode.textView.text ?? ""
        if text.contains("¥") && text.count == 1{
            updateInput(text: "")
        }
        if text.count > 0 && text.contains("¥") == false {
            updateInput(text: "¥" + text)
        }
        text = editableTextNode.textView.text ?? ""
        if text.contains("¥") {
            money = text.subStringInRange(NSMakeRange(1, text.count - 1))
        }
        if let moneyChangeBlock {
            moneyChangeBlock(money)
        }
    }
    
    private func updateInput(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        inputTextNode.attributedText = NSAttributedString(string: text,
                                                          attributes: [
            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
            NSAttributedString.Key.foregroundColor: Colors.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
    }
}
