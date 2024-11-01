//
//  Socket.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/30.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON


class Socket: NSObject {
    static let shared = Socket()
    private var socketManager: SocketManager? = nil
    private var client: SocketIOClient? = nil
    private static let url = "ws://47.237.119.236:6002"
    override init() {
        // https://gitcode.com/gh_mirrors/so/socket.io-client-swift/overview?utm_source=artical_gitcode&index=bottom&type=card&&isLogin=1
        
        super.init()
        // https://github.com/socketio/socket.io-client-swift/blob/master/Usage%20Docs/Compatibility.md

    }
   
    func addHandlers() {
        client?.on(clientEvent: .error) { data, ack in
            debugPrint("WX Socket error: \(data)")
        }
        client?.on(clientEvent: .connect) { data, ack in
            debugPrint("WX Socket connected: \(data) ack: \(ack)")
            
            self.joinGroup()
        }
        client?.on(clientEvent: .disconnect) { data, ack in
            debugPrint("WX Socket disconnect")
        }
        // 收到会话消息
        client?.on("sendGroupMsg") { data, ack in
            if let message = data.first as? String {
                print("WX Socket 新消息收到: \(message)")
            }
        }
        // 发送内部消息
        client?.on("sendInternalMsg") { data, ack in
            if let message = data.first as? String {
                self.handleInternalMsg(content: message)
                print("WX Socket 新消息收到: \(message)")
                
            }
        }
        // 上线
        client?.on("joinGroup") { data, ack in
            if let message = data.first as? String {
                print("WX Socket did joinGroup: \(message)")
            }
        }
    }
    func connect() {
        if socketManager != nil {
            return
        }
        var extraHeaders:[String: String] = [:]
        extraHeaders["t"] = GlobalManager.manager.token!
        extraHeaders["h"] = "011001010001"
        extraHeaders["isEnabled"] = GlobalManager.manager.isEncry ? "true": "false"
        extraHeaders["t1"] = GlobalManager.manager.refreshToken!
        socketManager = SocketManager(socketURL: URL(string: Socket.url)!,
                                      config:  [.version(.two),
                                                .extraHeaders(extraHeaders),
                                                .reconnects(true)/*, .log(true)*/])
        client = socketManager?.defaultSocket
        addHandlers()
        client?.connect()
    }
    
    func disconnect() {
        
    }
    
    func sendData(message: MessageEntity) {
        client?.emitWithAck("sendGroupMsg", message)
    }
    
    func leaveGroup() {
        if client == nil {
            return
        }
        client?.emit("leaveGroup") {
            
            debugPrint("WX Socket did leaveGroup")
        }
    }
    func joinGroup() {
        client?.emit("joinGroup") {
            
            debugPrint("WX Socket did JoinGroup")
        }
    }
    
    
}

private extension Socket {
    /*
     {"code":200,"data":"{\"balance\":null,\"type\":2,\"userId\":517105663}","msg":"system.success.200","sign":"UUmz6gF9X9Ev6522OgKR8180"}
    
     */
    func handleInternalMsg(content: String) {
        guard let json =  try? JSON(data: content.data(using: .utf8)!) else {
            return
        }
        if json["code"].intValue != 200 {
            return
        }
        guard let dataString = json["data"].string,
        let data = try? JSON(data: dataString.data(using: .utf8)!) else {
            return
        }
        // type 1余额变动,2账号封号
        let type = data["type"].int ?? 0
        if type == 1 {
            let balance = data["balance"].stringValue
            let personModel = GlobalManager.manager.personModel
            personModel?.balance = balance
            GlobalManager.manager.updatePersonModel(model: personModel)
            return
        }
        if type == 2 {
            GlobalManager.manager.logout()
            return
        }
    }
}
