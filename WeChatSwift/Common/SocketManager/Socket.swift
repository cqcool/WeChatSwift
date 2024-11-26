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

protocol SocketDelegate: NSObject {
    /// 发送消息，接收到ack回调，更新信息
    func updateLatestMessageEntity(entity: MessageEntity, latestNo: String?, oldNo: String?, isReadMoreHisoty: Bool)
    /// 收到最新消息
    func receiveLatestMessageEntity(groupNo: String, entity: MessageEntity)
}


class Socket: NSObject {
    static let shared = Socket()
    private var socketManager: SocketManager? = nil
    private var client: SocketIOClient? = nil
    private static let url = AppConfig.socketUrl()
    var delegate: SocketDelegate? = nil
    override init() {
        // https://gitcode.com/gh_mirrors/so/socket.io-client-swift/overview?utm_source=artical_gitcode&index=bottom&type=card&&isLogin=1
        
        super.init()
        // https://github.com/socketio/socket.io-client-swift/blob/master/Usage%20Docs/Compatibility.md
    }
    
    func addHandlers() {
        client?.on(clientEvent: .error) { data, ack in
            debugPrint("WX Socket error: \(data)")
            //            DNKProgressHUD.brieflyProgressMsg("WX Socket error: \(data)")
        }
        client?.on(clientEvent: .connect) { data, ack in
            debugPrint("WX Socket connected: \(data) ack: \(ack)")
            
            self.joinGroup()
        }
        client?.on(clientEvent: .disconnect) { data, ack in
            debugPrint("WX Socket disconnect")
        }
        //        // 收到会话消息
        //        client?.on("sendGroupMsg") { data, ack in
        //            if let message = data.first as? String {
        //                print("WX Socket 新消息收到: \(message)")
        //            }
        //        }
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
        
        client?.on("sendGroupMsg", callback: { data, ack in
            debugPrint("WX Socket sendGroupMsg: \(String(describing: data.first))")
            if let content = data.first as? String {
                guard let json =  try? JSON(data: content.data(using: .utf8)!) else {
                    return
                }
                
                if json["code"].intValue != 200 {
                    return
                }
                guard let dataString = json["data"].string,
                      let contentData = dataString.data(using: .utf8) else {
                    return
                }
                do {
                    let resp = try JSONDecoder().decode(MessageEntity.self, from: contentData)
                    self.delegate?.receiveLatestMessageEntity(groupNo: resp.groupNo!, entity: resp)
                } catch {
                    debugPrint("WX Socket sendGroupMsg Error: \(String(describing: error.localizedDescription))")
                }
            }
            
        });
    }
    func connect() {
        if client?.status == .connected {
            return
        }
        var extraHeaders:[String: String] = [:]
        extraHeaders["t"] = GlobalManager.manager.token!
        extraHeaders["h"] = GlobalManager.h()
        extraHeaders["isEnabled"] = GlobalManager.manager.isEncry ? "true": "false"
        extraHeaders["t1"] = GlobalManager.manager.refreshToken!
        socketManager = SocketManager(socketURL: URL(string: Socket.url)!,
                                      config:  socketConfig())
        client = socketManager?.defaultSocket
        addHandlers()
        client?.connect()
    }
    private func socketConfig() -> SocketIOClientConfiguration {
        var extraHeaders:[String: String] = [:]
        extraHeaders["t"] = GlobalManager.manager.token!
        extraHeaders["h"] = GlobalManager.h()
        extraHeaders["isEnabled"] = GlobalManager.manager.isEncry ? "true": "false"
        extraHeaders["t1"] = GlobalManager.manager.refreshToken!
        return [.version(.two),
                .extraHeaders(extraHeaders),
                .reconnects(true)]
    }
    func updateSocketConfig() {
        if client?.status == .connected {
            socketManager?.config = socketConfig()
        }
    }
    
    func disconnect() {
        client?.disconnect()
        socketManager?.disconnect()
        socketManager = nil
    }
    
    func sendData(message: MessageEntity) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // 如果你希望输出的JSON字符串是格式化过的
            let jsonData = try encoder.encode(message)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                debugPrint("Send Message JSON: " + jsonString)
                client?.emitWithAck("sendGroupMsg", with: [jsonString]).timingOut(after: 5, callback: { data in
                    if let content = data.first as? String {
                        self.handleAckMessage(message: message, content: content)
                        debugPrint("WX Socket ack Data: \(content)")
                        
                    }
                })
            }
        } catch {
            print(error.localizedDescription)
        }
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
    
    func handleAckMessage(message: MessageEntity, content: String) {
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
        // ack 响应的lastNo 和 本地的lastNo不一致时，则需要拉取最新数据，直至与本地的上一条no一样
        let oldLastNo = message.lastNo
        let lastNo = data["lastNo"].string
        message.no = String(data["no"].intValue)
        message.showTime = TimeInterval(data["showTime"].intValue)
        
        delegate?.updateLatestMessageEntity(entity: message, latestNo: lastNo, oldNo: oldLastNo, isReadMoreHisoty: lastNo == oldLastNo)
    }
}
