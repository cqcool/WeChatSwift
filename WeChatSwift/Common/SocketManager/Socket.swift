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
        // https://gitcode.com/gh_mirrors/so/socket.io-client-swift/overview?utm_source=artical_gitcode&index=bottom&type=card&&isLogin=1
        socketManager = SocketManager(socketURL: URL(string: Socket.url)!, config:  [.log(true), .compress])
        client = socketManager.defaultSocket
        client.on(clientEvent: .error) { data, ack in
            debugPrint("Socket error")
        }
        client.on(clientEvent: .connect) { data, ack in
            debugPrint("Socket connected")
        }
        client.on(clientEvent: .disconnect) { data, ack in
            debugPrint("Socket disconnect")
        }
        // 发送会话消息
        client.on("sendGroupMsg") { data, ack in
            if let message = data.first as? String {
                print("新消息收到: \(message)")
            }
        }
    }
    
    func connect() {
        debugPrint("to connect")
        client.connect()
    }
    
    func disconnect() {
        
    }
    
    func sendData() {
        //        client.emit1
    }
    
}
