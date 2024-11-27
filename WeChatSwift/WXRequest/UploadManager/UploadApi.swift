//
//  UploadApi.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/22.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

enum PrefixType: Int {
    case common = 1
    case chat = 2
    case avatar = 3
}

enum UploadType: Int {
    case image = 1
    case video
    case file
    case voice
    case gif
}
@objcMembers
class UploadRequest: WXRequest {
    
    var prefixType: String = ""
    var number: String? = ""
    var type: String? = ""
    
    convenience init(prefixType: PrefixType, number: String, type: UploadType) {
        self.init()
        self.prefixType = "\(prefixType.rawValue)"
        self.number = number
        self.type = "\(type.rawValue)"
    }
    
    override func requestUrl() -> String {
        "/upload"
    }
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
 
}
