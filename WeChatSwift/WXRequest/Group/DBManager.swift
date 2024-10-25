//
//  DBManager.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/25.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

class DBManager {
    
    static let share = DBManager()
    var db: Database? = nil
    
    private static let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "DB/wechat.db"
    init() {
        db = createDB()
    }
    
    private func createDB() -> Database {
        return Database(at: DBManager.dbPath)
    }
    private func createTable() {
//        try db?.run(transaction: { _ in
//            se
//        })
    }
}
