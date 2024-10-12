//
//  String+Util.swift
//  NewSmart
//
//  Created by 陈群 on 2022/11/28.
//

import Foundation
import UIKit

public extension String {
    func addAttributed(font: UIFont, textColor: UIColor, lineSpacing: CGFloat, wordSpacing: Float) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: style,
            .kern: wordSpacing
        ]
        let attributedStrM = NSMutableAttributedString(string: self, attributes: attributes)
        return attributedStrM
    }
    /// 去掉字符串中包含的表情包
    func deleteEmoji() -> String {
        var targetString =  ""
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex,
                                 options: .byComposedCharacterSequences) {
            substring, substringRange, enclosingRange, stop in
            if (substring?.count ?? 0) > 0 &&
                substring!.containEmoji() == false {
                targetString.append(substring!)
            }
        }
        return targetString
    }
    func containEmoji() -> Bool {
        contains { $0.isEmoji}
    }
}

extension String {
    func toDictionary() -> Dictionary<String, Any>? {
        let jsonData = self.data(using: .utf8)
        guard let data = jsonData else {
            return nil;
        }
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return dictionary as? Dictionary<String, Any>
    }
    
    func toHexInt() -> Int {
        var hexValue: UInt = UInt(self, radix: 16) ?? 0
        return Int(hexValue)
    }
}

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}
