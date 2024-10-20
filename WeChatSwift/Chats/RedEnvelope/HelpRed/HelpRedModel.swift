//
//  HelpRedModel.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/18.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import UIKit

struct HelpRedModel {
    let type:Int
    var image: UIImage
    var name: String
    
    var q1: String
    var q2: String
    var q3: String
    
    init(type: Int, image: UIImage, name: String, q1: String, q2: String, q3: String) {
        self.type = type
        self.image = image
        self.name = name
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
    }
}
