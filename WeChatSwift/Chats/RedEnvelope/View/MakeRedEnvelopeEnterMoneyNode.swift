//
//  MakeRedEnvelopeEnterMoneyNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MakeRedEnvelopeEnterMoneyNode: ASDisplayNode {
    var countKeyboardBlock: (() -> Void)?
    var moneyChangeBlock: ((_ money: String?) -> Void)?
    var money: String?
    
    private  let pinImageNode = ASImageNode()
    private let leadingTextNode = ASTextNode()
    private let spacer = ASDisplayNode()
//    private let inputTextNode = ASEditableTextNode()
    let moneyField = UITextField()
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
         
        let attributes = [
            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "C5C5C7"),
        ]
        moneyField.attributedPlaceholder = NSAttributedString(string: "¥0.00", attributes: attributes)
        moneyField.dnkDelegate = self
        moneyField.textAlignment = .right
        moneyField.textColor = Colors.black
        moneyField.font = UIFont.systemFont(ofSize: 17)
        moneyField.shouldBeginEditingBlock = {
            self.countKeyboardBlock?()
            return true
        }
        moneyField.textDidChangeBlock = { text in
            self.money = self.moneyField.text
            let tempText = text ?? ""
            if tempText.contains("¥") && tempText.count == 1{
                self.moneyField.text = ""
            }
            if tempText.count > 0 && tempText.contains("¥") == false {
                self.moneyField.text = "¥" + tempText
            }
            if tempText.contains("¥") {
                self.money = tempText.subStringInRange(NSMakeRange(1, tempText.count - 1))
            }
            self.moneyChangeBlock?(self.money)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 8
        cornerRoundingType = .defaultSlowCALayer
        
        spacer.view.addSubview(moneyField)
        moneyField.snp.makeConstraints { make in
            make.edges.equalTo(spacer.view)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        pinImageNode.style.spacingBefore = 8
        leadingTextNode.style.spacingBefore = 10
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        
        trailingTextNode.style.spacingBefore = 10
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [pinImageNode, leadingTextNode, spacer, trailingTextNode]
        
        let insets = UIEdgeInsets(top: 17.5, left: 10, bottom: 17.5, right: 10)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return moneyField.resignFirstResponder()
    }
    
    func updateContent(type: RedPacketError) {
        let color: UIColor = type == .normal ? .black : UIColor(hexString: "E84800")
        leadingTextNode.attributedText = NSAttributedString(string: "总金额", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: color
        ])
        moneyField.textColor = color
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .right
//        let text = inputTextNode.textView.text ?? ""
//        inputTextNode.attributedText = NSAttributedString(string: text,
//                                                          attributes: [
//            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
//            NSAttributedString.Key.foregroundColor: color,
//            NSAttributedString.Key.paragraphStyle: paragraphStyle
//        ])
    }
}

extension MakeRedEnvelopeEnterMoneyNode: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let futureString = NSMutableString(string: textField.text ?? "")
        futureString.insert(string, at: range.location)
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
}
