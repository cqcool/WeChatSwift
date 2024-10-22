//
//  PersonModel.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers

class PersonModel: NSObject, Codable {
    var nickname: String?
    var userId: String?
    var token: String?
    var head: String?
    
//    init(nickname: String, userId: String, token: String, head: String) {
//        self.nickname = nickname
//        self.userId = userId
//        self.token = token
//        self.head = head
//    }
    
    // 注意：json的key和模型属性不同时，可以使用映射
    enum CodingKeys: String, CodingKey {
        case nickname
        case userId
        case token
        case head
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
