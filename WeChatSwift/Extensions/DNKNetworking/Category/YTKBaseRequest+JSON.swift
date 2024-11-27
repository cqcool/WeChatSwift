//
//  YTKBaseRequest+JSON.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/31.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import YTKNetwork
import SwiftyJSON

extension YTKBaseRequest {
    func wxJSON() -> JSON? {
        if let json = try? JSON(data: wxResponseData()) {
            return json
        }
        return nil
        
    }
}
