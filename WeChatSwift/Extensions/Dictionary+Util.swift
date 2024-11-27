//
//  Dictionary+Util.swift
//  NewSmart
//
//  Created by Aliens on 2023/10/19.
//

import Foundation

extension Dictionary {
    func toData() -> Data? {
         return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    func toJSON() -> String? {
        if let data = self.toData() {
            let jsonString = String(data: data, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

extension Array {
    func toData() -> Data? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            return data
        } catch {
            print("Error converting array to data: \(error)")
            return nil
        }
    }
}
