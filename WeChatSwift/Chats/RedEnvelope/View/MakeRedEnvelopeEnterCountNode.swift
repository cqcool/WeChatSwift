//
//  MakeRedEnvelopeEnterCountNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class MakeRedEnvelopeEnterCountNode: ASDisplayNode {
    
    var countKeyboardBlock: (() -> Void)?
    var countChangeBlock: ((_ money: String?) -> Void)?
    var randomChangeBlock: (() -> Void)?
    var count: String?
    
    private let randomTextNode = ASTextNode()
    private let randomArrowNode = ASImageNode()
    private let leadingTextNode = ASTextNode()
    private let cardNode = ASDisplayNode()
    private let redPacketNode = ASImageNode()
    
    let inputTextNode = ASEditableTextNode()
    
    private let trailingTextNode = ASTextNode()
    
    private let countTextNode = ASTextNode()
    
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        randomTextNode.attributedText = NSAttributedString(string: "拼手气红包", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: Colors.DEFAULT_TEXT_YELLOW_COLOR
        ])
        randomTextNode.addTarget(self, action: #selector(changeRandomAction), forControlEvents: .touchUpInside)
        randomArrowNode.image = UIImage(named: "LuckyMoney_ChangeArrow")
        
        redPacketNode.image = UIImage(named: "live_red_packet_icon")
        leadingTextNode.attributedText = NSAttributedString(string: "红包个数", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
        
        cardNode.backgroundColor = .white
        cardNode.cornerRadius = 8
        cardNode.cornerRoundingType = .defaultSlowCALayer
        
        trailingTextNode.attributedText = NSAttributedString(string: "个", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor:UIColor(hexString: "BCBCBE"),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        inputTextNode.keyboardType = .numberPad
        inputTextNode.delegate = self
        inputTextNode.attributedPlaceholderText = NSAttributedString(string: "填写红包个数", attributes: attributes)
        inputTextNode.typingAttributes = [
            NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor.rawValue: Colors.black,
            NSAttributedString.Key.paragraphStyle.rawValue: paragraphStyle
        ]
        countAttribute(count: 0)
    }
    @objc func changeRandomAction() {
        randomChangeBlock!()
    }
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        randomTextNode.style.spacingBefore = 20
        randomArrowNode.style.spacingBefore = 2
        randomArrowNode.style.maxSize = CGSize(width: 18, height: 18)
        randomArrowNode.style.minSize = CGSize(width: 18, height: 18)
        let randomStack = ASStackLayoutSpec.horizontal()
        randomStack.alignContent = .center
        randomStack.verticalAlignment = .center
        randomStack.style.spacingBefore = 10
        randomStack.children = [randomTextNode, randomArrowNode]
        
        redPacketNode.style.spacingBefore = 18
        leadingTextNode.style.spacingBefore = 6
        inputTextNode.style.flexGrow = 1.0
        inputTextNode.style.flexShrink = 1.0
        trailingTextNode.style.spacingBefore = 10
        trailingTextNode.style.spacingAfter = 17
        let countStack = ASStackLayoutSpec.horizontal()
        countStack.alignItems = .center
        countStack.children = [redPacketNode, leadingTextNode, inputTextNode, trailingTextNode]
        countStack.style.preferredSize = CGSizeMake(constrainedSize.max.width, 55)
        countStack.style.spacingBefore = 5
        
        cardNode.style.flexGrow = 1.0
        cardNode.style.flexShrink = 1.0
        let overlay = ASBackgroundLayoutSpec(child: countStack, background: cardNode)
        
        let countTextStack = ASStackLayoutSpec.horizontal()
        countTextNode.style.spacingBefore = 18
        countTextStack.alignItems = .center
        countTextStack.children = [countTextNode]
        
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.children = [randomStack, overlay, countTextStack]
        verticalStack.spacing = 10
        return ASInsetLayoutSpec(insets: .zero, child: verticalStack)
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return inputTextNode.resignFirstResponder()
    }
    
    func updateContent(type: RedPacketError) {
        let color: UIColor = type == .normal ? .black : UIColor(hexString: "E84800")
        leadingTextNode.attributedText = NSAttributedString(string: "红包个数", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: color
        ])
        trailingTextNode.attributedText = NSAttributedString(string: "个", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: color
        ])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let text = inputTextNode.textView.text ?? ""
        inputTextNode.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    func updateNumberOfPersons(count: Int) {
        countAttribute(count: count)
    }
    private func countAttribute(count: Int) {
        let text = "本群共\(count)人"
        countTextNode.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "878788")
        ])
    }
}

extension MakeRedEnvelopeEnterCountNode: ASEditableTextNodeDelegate {
    func editableTextNodeShouldBeginEditing(_ editableTextNode: ASEditableTextNode) -> Bool {
        countKeyboardBlock?()
        return true
    }
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
        let text = editableTextNode.textView.text
        updateInput(text: text ?? "")
        count = editableTextNode.textView.text
        if let countChangeBlock {
            countChangeBlock(count)
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
