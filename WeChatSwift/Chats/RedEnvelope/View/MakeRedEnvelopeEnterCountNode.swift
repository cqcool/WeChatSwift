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
    private let spacer = ASDisplayNode()
    
    let countTextField = UITextField()
    
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
        randomArrowNode.forcedSize = CGSize(width: 10, height: 4)
        randomArrowNode.contentMode = .scaleAspectFit
        redPacketNode.image = UIImage(named: "live_red_packet_icon")
        redPacketNode.contentMode = .center
        redPacketNode.forcedSize =  CGSize(width: 18, height: 22)
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
        countTextField.attributedPlaceholder = "填写红包个数".addAttributed(font: .systemFont(ofSize: 17), textColor: UIColor(hexString: "BCBCBE"))
        countTextField.font = UIFont.systemFont(ofSize: 17)
        countTextField.textColor = Colors.black
        countTextField.textAlignment = .right
        countTextField.keyboardType = .numberPad
        countTextField.shouldBeginEditingBlock = {
            self.countKeyboardBlock?()
            return true
        }
        countTextField.textDidChangeBlock = { text in
            self.count = text
            if self.countChangeBlock != nil {
                self.countChangeBlock!(text)
            }
        }
        countAttribute(count: 0)
    }
    @objc func changeRandomAction() {
        randomChangeBlock!()
    }
    override func didLoad() {
        super.didLoad()
        spacer.view.addSubview(countTextField)
        countTextField.snp.makeConstraints { make in
            make.edges.equalTo(spacer.view)
        }
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
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        trailingTextNode.style.spacingBefore = 10
        trailingTextNode.style.spacingAfter = 17
        let countStack = ASStackLayoutSpec.horizontal()
        countStack.alignItems = .center
        countStack.children = [redPacketNode, leadingTextNode, spacer, trailingTextNode]
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
        return countTextField.resignFirstResponder()
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
        
        countTextField.textColor = color
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
