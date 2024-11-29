//
//  DBManager.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/25.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift


@objcMembers
class DBManager: NSObject {
    
    static let share = DBManager()
    let db = Database(at:DBManager.dbPath)
    
    static let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/DB/wechat.db"
    override init() {
//        db = createDB()
//        createTable()
    }
    func setup() {
//        db = createDB()
        debugPrint("DB PATH:" + DBManager.dbPath)
        createTable()
    }
    /// 增
    public func insert<T: TableCodable & Named>(objects: [T]) {
        do {
            try db.insert(objects, intoTable: objects.first!.className)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    /// 主键出现冲突，新数据覆盖就数据
    public func insertOrReplace<T: TableCodable & Named>(objects: [T]) {
        do {
            try db.insertOrReplace(objects, intoTable: objects.first!.className)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    /// 改
    public func update<T: TableCodable & Named>(objects: [T]) {
        do {
            try db.update(table: objects.first!.className, on: [], with: objects)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    public func update<T: TableCodable & Named>(object: T, on propertys:[PropertyConvertible], where condition: Condition? = nil){
        do {
            try db.update(table: object.className, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }
    /// 删
    // UserModel.Properties.id.is(model.id))
    public func delete<T: TableCodable & Named>(object: T, where condition: Condition) {
        do {
            try db.delete(fromTable: object.className, where: condition)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    public func deleteTabble(tableName: String) {
        do {
            try db.delete(fromTable: tableName)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    //  where Sample.Properties.identifier < 5 || Sample.Properties.identifier > 10
    //  condition Sample.Properties.identifier.asOrder(by: .descending)
    /// 查
    public func getObjects<T: TableCodable & Named>(tableName: String, where condition: Condition? = nil,  orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (db.getObjects(fromTable: tableName, where: condition, orderBy:orderList))
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
}

extension DBManager {
    
    private func createDB() -> Database {
        return Database(at: DBManager.dbPath)
    }
    private func createTable() {
        do {
            try self.db.create(table: GroupEntity.tableName, of: GroupEntity.self)
            try self.db.create(table: MessageEntity.tableName, of: MessageEntity.self)
            try self.db.create(table: RedPacketGetEntity.tableName, of: RedPacketGetEntity.self)
            try self.db.create(table: GroupSyncEntity.tableName, of: GroupSyncEntity.self)
            
            
        } catch let error {
            debugPrint("初始化数据库及ORM对应关系建立失败\(error.localizedDescription)")
        }
    }
}
