//
//  SelectSessionModel.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class SelectSessionModel: WCTableCellModel {
    
    private let session: GroupEntity
    
    init(session: GroupEntity) {
        self.session = session
    }
    
    var wc_title: String {
        return session.name ?? "未命名"
    }
    
}
