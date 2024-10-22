//
//  Dictionary+Util.swift
//  NewSmart
//
//  Created by 陈群 on 2023/10/19.
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
