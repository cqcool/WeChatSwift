//
//  UploadApi.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/22.
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

class UploadRequest: DNKRequest {
    
    let prefixType: PrefixType
    let number: Int
    let type: UploadType
    
    init(prefixType: PrefixType, number: Int, type: UploadType) {
        self.prefixType = prefixType
        self.number = number
        self.type = type
    }
    
    override func requestUrl() -> String {
        "/upload"
    }
    override func requestMethod() -> YTKRequestMethod {
        .GET
    }
 
}
