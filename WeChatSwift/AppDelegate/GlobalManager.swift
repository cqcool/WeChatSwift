//
//  GlobalManager.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/21.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

@objcMembers
class GlobalManager: NSObject {
    static let manager = GlobalManager()
    
    @objc var isEncry: Bool = false
    
    private override init() {
        
    }
}
