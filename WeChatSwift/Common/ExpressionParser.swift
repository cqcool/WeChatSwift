//
//  ExpressionParser.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

fileprivate struct ExpressionRegexResult {
    
    /// 1：红包icon，2: 蓝色字体，3: 红包文本（可点击）
    var type: Int?
    var range: NSRange
    var text: String
    var expression: String?
    
}

struct RedRegexResult {
    
    /// 1：红包icon，2: 蓝色字体，3: 红包文本（可点击）
    var range: NSRange
    var order: String
}

class ExpressionParser {
    
    static let shared = try? ExpressionParser()
    
    private let emojiRegex: NSRegularExpression
    private let tagRegex: NSRegularExpression
    private let cancelRegex: NSRegularExpression
    private let redRegex: NSRegularExpression
    
    private init() throws {
        emojiRegex = try NSRegularExpression(pattern: emojiPattern, options: [])
        tagRegex = try NSRegularExpression(pattern: tagPattern, options: [])
        cancelRegex = try NSRegularExpression(pattern: cancelPattern, options: [])
        redRegex = try NSRegularExpression(pattern: redPattern, options: [])
    }
    // \\[/?[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]
    private let tagPattern = "<u>(.*?)</u>"
    private let cancelPattern = "<cancel>(.*?)</cancel>"
    private let redPattern = "<red>(.*?)</red>"
    private let emojiPattern = "[\\[/?[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]]?[</?u>]?"
    func attributedText(with attributedText: NSAttributedString) -> NSAttributedString {
        let regexes = parse(text: attributedText.string)
        if regexes.count == 0 {
            return attributedText
        }
        
        let result = NSMutableAttributedString(attributedString: attributedText)
        var offset: Int = 0
        let descender = UIFont.systemFont(ofSize: 17).descender
        for regex in regexes {
            if let expression = regex.expression {
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: expression)
                attachment.bounds = CGRect(x: 0, y: descender, width: 21, height: 21)
                let attachmentText = NSAttributedString(attachment: attachment)
                result.replaceCharacters(in: NSRange(location: offset, length: regex.range.length), with: attachmentText)
                offset += attachmentText.length
            } else {
                offset += regex.range.length
            }
        }
        
        return result
    }
    
    private func parse(text: String) -> [ExpressionRegexResult] {
        guard text.count > 2 else { return [] }
        
        let length = text.count
        let matches = emojiRegex.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        if matches.count == 0 {
            return []
        }
        let expressions = Expression.all
        var resultList: [ExpressionRegexResult] = []
        var offset: Int = 0
        for (index, match) in matches.enumerated() {
            // 处理匹配到之前的
            if match.range.location > offset {
                let range = NSRange(location: offset, length: match.range.location - offset)
                let subText = text.subStringInRange(range)
                resultList.append(ExpressionRegexResult(range: range, text: subText, expression: nil))
            }
            // 处理匹配到的结果
            let innerText = text.subStringInRange(match.range)
            let emoji = expressions.first(where: { $0.text == innerText })
            let result = ExpressionRegexResult(range: match.range, text: innerText, expression: emoji?.icon)
            resultList.append(result)
            offset = match.range.location + match.range.length
            
            // 处理匹配之后的
            if index == matches.count - 1 {
                if length - offset > 0 {
                    let range = NSRange(location: offset, length: length - offset)
                    let subText = text.subStringInRange(range)
                    resultList.append(ExpressionRegexResult(range: range, text: subText, expression: nil))
                }
            }
        }
        return resultList
    }
    func attributedTagText(with attributedText: NSAttributedString) -> NSAttributedString {
        let regexes = parseTag(text: attributedText.string)
        if regexes.count == 0 {
            return attributedText
        }
        
        let result = NSMutableAttributedString(attributedString: attributedText)
        //        var offset: Int = 0
        for matchedText in regexes {
            if let range = result.string.range(of: "<u>\(matchedText)</u>") {
                let nsRange = NSRange(range, in: result.string)
                result.replaceCharacters(in: nsRange, with: matchedText)
                let targetRange = result.string.range(of: "\(matchedText)")
                let nsTargetRange = NSRange(targetRange!, in: result.string)
                result.addAttribute(.foregroundColor, value: Colors.Blue_TEXT, range: nsTargetRange)
            }
        }
        return result
    }
    private func parseTag(text: String) -> [String] {
        guard text.count > 2 else { return [] }
        
        let length = text.count
        let matches = tagRegex.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        if matches.count == 0 {
            return []
        }
        var resultList: [String] = []
        for match in matches {
            if let range = Range(match.range(at: 1), in: text) { 
                resultList.append(String(text[range]))
            }
        }
        return resultList
    }
    
    func attributedCancelTagText(with attributedText: NSAttributedString) -> NSAttributedString {
        let regexes = parseCancelTag(text: attributedText.string)
        if regexes.count == 0 {
            return attributedText
        }
        
        let result = NSMutableAttributedString(attributedString: attributedText)
        //        var offset: Int = 0
        for matchedText in regexes {
            if let range = result.string.range(of: "<cancel>\(matchedText)</cancel>") {
                let nsRange = NSRange(range, in: result.string)
                result.replaceCharacters(in: nsRange, with: matchedText)
                let targetRange = result.string.range(of: "\(matchedText)")
                let nsTargetRange = NSRange(targetRange!, in: result.string)
                result.addAttribute(.foregroundColor, value: Colors.Blue_TEXT, range: nsTargetRange)
            }
        }
        return result
    }
    private func parseCancelTag(text: String) -> [String] {
        guard text.count > 2 else { return [] }
        let length = text.count
        let matches = cancelRegex.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        if matches.count == 0 {
            return []
        }
        var resultList: [String] = []
        for match in matches {
            if let range = Range(match.range(at: 1), in: text) {
                resultList.append(String(text[range]))
            }
        }
        return resultList
    }
    
    func attributedRedPacketText(with attributedText: NSAttributedString) -> (NSAttributedString, RedRegexResult?) {
        
        debugPrint(attributedText.string)
        let redText = "<red-icon>"
        let text = attributedText.string
        if !text.contains(redText) {
            return (attributedText, nil)
        }
        let result = NSMutableAttributedString(attributedString: attributedText)
        if let range = text.range(of: redText) {
            let nsRange = NSRange(range, in: result.string)
            result.replaceCharacters(in: nsRange, with: redText + "  ")
            let descender = UIFont.systemFont(ofSize: 15).descender
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "SystemMessages_HongbaoIcon_14x14_")
            attachment.bounds = CGRect(x: 0, y: descender, width: 18, height: 18)
            let attachmentText = NSAttributedString(attachment: attachment)
            result.replaceCharacters(in: nsRange, with: attachmentText)
        }
        
        let regexes = parseRedTag(text: result.string)
        if regexes.count == 0 {
            return (attributedText, nil)
        }
        var redResult: RedRegexResult? = nil
        for matchedText in regexes {
            if let range = result.string.range(of: "<red>\(matchedText)</red>") {
                let nsRange = NSRange(range, in: result.string)
                result.replaceCharacters(in: nsRange, with: "红包")
                let targetRange = result.string.range(of: "红包")
                let nsTargetRange = NSRange(targetRange!, in: result.string)
                result.addAttribute(.foregroundColor, value: UIColor(hexString: "EF9836"), range: nsTargetRange)
                redResult = RedRegexResult(range: nsTargetRange, order: matchedText)
            }
        }
        return (result, redResult)
    }
    
    private func parseRedTag(text: String) -> [String] {
        guard text.count > 2 else { return [] }
        let length = text.count
        let matches = redRegex.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        if matches.count == 0 {
            return []
        }
        var resultList: [String] = []
        for match in matches {
            if let range = Range(match.range(at: 1), in: text) {
                resultList.append(String(text[range]))
            }
        }
        return resultList
    }
    
}
/*
 使用NSRegularExpression.  matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [NSTextCheckingResult] 匹配出"\"<u>橙色</u>\"邀请你和\"<u>红色</u>\"加入了群聊" 橙色和红色
 
 */

extension String {
    func subStringInRange(_ range: NSRange) -> String {
        let start = self.index(startIndex, offsetBy: range.location)
        let end = self.index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
}
