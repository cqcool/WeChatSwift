//
//  ZLCustomAlertAction+Color.swift
//  Example
//
//  Created by long on 2022/7/1.
//

import ZLPhotoBrowser
import UIKit

extension ZLCustomAlertAction.Style {
    var color: UIColor {
        switch self {
        case .default, .cancel:
            return UIColor(hex: 0x171717)
        case .tint:
            return UIColor(hex: 0x4F638E)
        case .destructive:
            return UIColor(hex: 0xEB2F58)
        }
    }
}
