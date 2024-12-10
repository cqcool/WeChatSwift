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
        pinImageNode.contentMode = .scaleAspectFit
        pinImageNode.forcedSize = CGSize(width: 30, height: 27)
        pinImageNode.style.preferredSize = CGSize(width: 30, height: 27)
        pinImageNode.cornerRadius = 2
        setTotalLabel(color: Colors.black)
        
//        trailingTextNode.attributedText = NSAttributedString(string: "元", attributes: [
//            .font: UIFont.systemFont(ofSize: 17),
//            .foregroundColor: Colors.black
//        ])
         
//        let attributes = [
////            NSAttributedString.Key.font: Fonts.font(.superScriptMedium, fontSize: 17)!,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .medium),
//            NSAttributedString.Key.foregroundColor: ,
//        ]
//        moneyField.attributedPlaceholder = NSAttributedString(string: , attributes: attributes)
        moneyField.attributedPlaceholder = "¥0.00".unitTextAttribute(textColor:  UIColor(hexString: "C5C5C7"), font: Fonts.font(.superScriptRegular, fontSize: 18)!, unitFont: Fonts.font(.superScriptRegular, fontSize: 23)!, unit: "¥", baseline: -4, kern: -3)
        moneyField.dnkDelegate = self
        moneyField.textAlignment = .right
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
        
        pinImageNode.style.spacingBefore = 5
        leadingTextNode.style.spacingBefore = 8
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
    private func setTotalLabel(color: UIColor) {
        leadingTextNode.attributedText = NSAttributedString(string: "总金额", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor:color
        ])
    }
    func updateContent(type: RedPacketError) {
        let color: UIColor = type == .normal ? .black : UIColor(hexString: "E84800")
        setTotalLabel(color: color) 
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
        if !futureString.isEqual(to: "") {
            if futureString.contains(".") && string == "." {
                return false
            }
        }
        futureString.insert(string, at: range.location)
        // 避免输入多个0，eg：000
        
        if !futureString.isEqual(to: "") {
            if futureString.hasPrefix("¥00") {
                return false
            }
        }
            
        var flag = 0;
        let limited = 3;//小数点后需要限制的个数
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
        // 5、红包总金额输入，最多输入7位数加2位小数，红包金额与官方一致，按人头算，比如群里5个人，一个人头200，最多发1000
        if !futureString.contains(".") && futureString.length > 8 {
            return false
        }
        if futureString.contains(".") {
            let components: [String] = futureString.components(separatedBy: ".")
            if (components.first?.count ?? 0) > 8 || (components.last?.count ?? 0) > 2 {
                return false
            }
        }
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = self.money {
//            let moneyFloat = (text as NSString).floatValue
//            textField.text = String(format: "%.2f", moneyFloat)
//        }
//    }
}
