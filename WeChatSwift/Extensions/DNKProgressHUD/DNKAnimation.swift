//
//  DNKAnimation.swift
//  NewSmart
//
//  Created by 张伟凌 on 2024/1/29.
//

import Foundation
import UIKit

extension UIView {
    
    /// show a bounce animation for the view when this function is called
    ///
    /// 实现淡出淡入的效果：
    ///
    ///     addBounceAnimation(initialScale: 0, peakScale: 0.5)
    ///
    /// 实现弹跳效果：
    ///
    ///     addBouceAnimation(initialScale: 0.9, peakScale: 1.1)
    ///
    /// - Parameters:
    ///   - initialScale: 动画开始时的视图缩放比例
    ///   - peakScale: 动画过程中的视图缩放比例，大于1就可以实现弹跳效果
    @objc
    func addBounceAnimation(initialScale: Double, peakScale: Double) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [initialScale, peakScale, 1]
        bounceAnimation.keyTimes = [0.0, 0.5, 1]
        bounceAnimation.duration = 0.15
        bounceAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        self.layer.add(bounceAnimation, forKey: "bounce")
    }

}
