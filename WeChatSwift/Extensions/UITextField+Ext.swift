//
//  UITextField+Ext.swift
//  NewSmart
//
//  Created by 陈群 on 2023/11/26.
//

import Foundation
import UIKit

private var UITextFieldManager: Void?

@objc extension UITextField {
    /// 文本长度，默认0，不限制
     var textLength: Int {
        get {
            self.manager().textLength
        }
        set {
            self.manager().textLength = newValue
        }
    }
    /// 是否过滤emoji, 默认false，不过滤器
    var filterEmoji: Bool {
        get {
            self.manager().filterEmoji
        }
        set {
            self.manager().filterEmoji = newValue
        }
    }
    /// 是否可编辑textField， 默认true
    var enableEditing: Bool {
        get {
            self.manager().enableEditing
        }
        set {
            self.manager().enableEditing = newValue
        }
    }
    var textDidChangeBlock: ((String?)->Void)? {
        get {
            self.manager().textDidChangeBlock
        }
        set {
            self.manager().textDidChangeBlock = newValue
        }
    }
    
    var shouldBeginEditingBlock: (()->Bool)? {
        get {
            self.manager().shouldBeginEditingBlock
        }
        set {
            self.manager().shouldBeginEditingBlock = newValue
        }
    }
    var dnkDelegate: (any UITextFieldDelegate)? {
        get {
            self.manager().dnkDelegate
        }
        set {
            self.manager().dnkDelegate = newValue
        }
    }
    
    private func manager() -> DNKTextFieldManager {
        if let manager = objc_getAssociatedObject(self, &UITextFieldManager) {
            return manager as! DNKTextFieldManager
        }
        let manager = DNKTextFieldManager()
        self.delegate = manager
        objc_setAssociatedObject(self, &UITextFieldManager, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return manager
    }

}

class DNKTextFieldManager : NSObject {
    var textLength: Int = 0
    var filterEmoji: Bool = false
    var enableEditing: Bool = true
    var textDidChangeBlock: ((String?)->Void)?
    var shouldBeginEditingBlock: (()->Bool)?
    var dnkDelegate: (any UITextFieldDelegate)?
    
    override init() {
        super.init()
    }
}

extension DNKTextFieldManager : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if dnkDelegate != nil &&{
//            return dnkDelegate!.textFieldShouldBeginEditing!(textField)
//        }
        if let block = shouldBeginEditingBlock {
            return block()
        }
        return enableEditing
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if dnkDelegate != nil {
            dnkDelegate!.textFieldDidChangeSelection?(textField)
        }
        textDidChangeBlock?(textField.text)
        if let markedRange = textField.markedTextRange,
           textField.position(from: markedRange.start, offset: 0) != nil {
            return
        }
        if filterEmoji {
            textField.text = textField.text?.deleteEmoji()
        }
        if let string = textField.text,
            textLength > 0  {
            if string.count > textLength {
                textField.text = String(string[string.startIndex ... string.index(string.startIndex, offsetBy: textLength-1)]);
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if dnkDelegate != nil {
            return dnkDelegate!.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}
