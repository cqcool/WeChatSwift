//
//  ChatRoomDataSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

final class ChatRoomDataSource {
    
    private let dateFormatter = ChatRoomDateFormatter()
    
    var messages: [Message] = []
    
    private var currentPage = 0
    
    private let sessionID: String
    
    private let lock = DispatchSemaphore(value: 1)
    
    weak var tableNode: ASTableNode?
    
    init(sessionID: String) {
        self.sessionID = sessionID
        
        //        let user = MockFactory.shared.user(with: sessionID)!
        
        //        formatTime()
    }
    
    func numberOfRows() -> Int {
        return messages.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Message {
        return messages[indexPath.row]
    }
    
    func append(_ message: Message, scrollToLastMessage: Bool = true) {
        let _ = lock.wait(timeout: .distantFuture)
        messages.append(message)
        formatTime()
        tableNode?.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .none)
        if scrollToLastMessage {
            let last = messages.count - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                tableNode?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        lock.signal()
    }
    func appendMsgList(_ msgList: [MessageEntity], scrollToLastMessage: Bool = true, lookUpHistory: Bool = false, showMsgTime: Bool) {
        let _ = lock.wait(timeout: .distantFuture)
        formatTime()
        var messageList: [Message] = []
        for messageEntity in msgList.reversed() {
            if messageEntity.type == 6 {
                continue
            }
            let message = messageEntity.toMessage()
            messageList.append(message)
        }
        if showMsgTime  {
            dateFormatter.chatFormatTime(messageList: messageList)
        }
        for message in messageList {
            if lookUpHistory {
                messages.insert(message, at: 0)
                tableNode?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            } else {
                messages.append(message)
                tableNode?.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .none)
            }
        }
        if scrollToLastMessage {
            let last = messages.count - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                tableNode?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        lock.signal()
        
    }
    
    func appendOmissionMsgList(_ msgList: [MessageEntity], latestNo: String, oldNo: String) {
        formatTime()
        let _ = lock.wait(timeout: .distantFuture)
        for messageEntity in msgList {
            if messages.firstIndex(where: { $0.entity?.no == messageEntity.no }) != nil {
                break
            }
            let message = messageEntity.toMessage()
            dateFormatter.chatSingleFormatTime(message: message)
            if let oldIndex = messages.firstIndex(where: { $0.entity?.no == oldNo }) {
                messages.insert(message, at: oldIndex)
                tableNode?.insertRows(at: [IndexPath(row: oldIndex, section: 0)], with: .none)
            }
        }
        lock.signal()
        
    }
    
    func formatTime() {
        dateFormatter.chatFormatTime(messageList: messages)
    }
    
}

