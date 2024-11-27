//
//  PersonModel.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers

class PersonModel: NSObject, Codable {
    var account: String?
    var balance: String?
    /// 零钱通收益率
    var changeRate: String?
    var nickname: String?
    var userId: String?
    var token: String?
    var head: String?
    var wechatId: String?
     
    // 注意：json的key和模型属性不同时，可以使用映射
    enum CodingKeys: String, CodingKey {
        case account
        case balance
        case nickname
        case userId
        case token
        case head
        case wechatId
    }
    
    func updateHead(headText: String) {
        self.head = headText
        GlobalManager.manager.updatePersonModel(model: self)
    }
    func updateNickName(nameText: String) {
        self.nickname = nameText
        GlobalManager.manager.updatePersonModel(model: self)
    }
    
    static func savePerson(person: PersonModel) {
        
        if let jsonData = try? JSONEncoder().encode(person) {
            // 将JSON数据转换为String
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            // 存储JSON字符串
            UserDefaults.standard.set(jsonString, forKey: "myPersonKey")
        }
    }
    static func getPerson() -> PersonModel? {
        if let jsonString = UserDefaults.standard.string(forKey: "myPersonKey"),
           let jsonData = jsonString.data(using: .utf8),
           let personData = try? JSONDecoder().decode(PersonModel.self, from: jsonData) {
            
            return personData
        }
        return nil
    }
    static func clearPerson() {
        UserDefaults.standard.removeObject(forKey: "myPersonKey")
    }
}
