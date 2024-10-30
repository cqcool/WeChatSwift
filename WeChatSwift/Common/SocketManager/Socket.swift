//
//  Socket.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/30.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SocketIO


class Socket: NSObject {
    static let shared = Socket()
    private var socketManager: SocketManager! = nil
    private var client: SocketIOClient! = nil
    private static let url = "http://47.237.119.236:6002"
    override init() {
        socketManager = SocketManager(socketURL: URL(string: Socket.url)!)
        client = socketManager.defaultSocket
        
        client.on(clientEvent: .connect) { data, ack in
            debugPrint("Socket connected")
        }
        // 发送会话消息
        client.on("sendGroupMsg") { data, ack in
            if let message = data.first as? String {
                print("新消息收到: \(message)")
            }
        }
    }
    
    func connect() {
        client.connect()
    }
    
    func disconnect() {
        
    }
    
    func sendData() {
        //        client.emit1
    }
    
}
