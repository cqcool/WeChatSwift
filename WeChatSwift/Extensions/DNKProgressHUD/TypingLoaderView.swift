//
//  TypingLoaderView.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/12/11.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
@objcMembers
final class TypingLoaderView: UIView{
    private var dotsSuperView: UIView
    private var dotsBackgroundColor: UIColor
    let dotsWidth = 8
    init(color: UIColor = .white, superView: UIView) {
        dotsBackgroundColor = color
        dotsSuperView = superView
        super.init(frame: .zero)
        backgroundColor = .red
        showAnimatingDots() // We will come to this later
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDot() -> CALayer{
        let dot = CALayer()
        dot.frame = CGRect(x: 1, y: 1, width: dotsWidth, height: dotsWidth)
        dot.cornerRadius = dot.frame.width / 2
        dot.backgroundColor = dotsBackgroundColor.cgColor
        return dot
    }
    func addReplicatorFor(shape: CALayer, noOfInstances: Int, instanceDelay: CFTimeInterval, superView: UIView){
        let layer = CAReplicatorLayer()
        layer.frame = CGRect(x: 0, y: 0, width: dotsWidth * 5, height: dotsWidth * 2)
        layer.contentsGravity = CALayerContentsGravity.center
        layer.addSublayer(shape)
        layer.instanceCount = noOfInstances
        layer.instanceTransform = CATransform3DMakeTranslation(15, 0, 0)
        layer.instanceDelay = instanceDelay
        layer.position = superView.center
        self.layer.addSublayer(layer)
    }
    func showAnimatingDots() {
        let fromScale: CATransform3D = CATransform3DMakeScale(1, 1, 1)
        let toScale: CATransform3D = CATransform3DMakeScale(1.4, 1.4, 1)
        var animationDelay: CFTimeInterval
        let noOfInstances: Int = 3
        //step1: Create dot
        let dot = createDot()
        //step2: add animations for dot- Opacity, y position and transform
        dot.addAnimationToLayer(withKeyPath: .opacity, from: CGFloat(1.0), to: CGFloat(0.2), duration: 1, repeatCount: .infinity)
//        dot.addAnimationToLayer(withKeyPath: .yPosition, from: dot.position.y, to: dot.position.y + 3, duration: 1.2, repeatCount: Float.infinity)
        let transformDuration:CFTimeInterval = 0.6
//        dot.addAnimationToLayer(withKeyPath: .transform, from: fromScale, to: toScale, duration: transformDuration, repeatCount: Float.infinity)
        dot.transform = toScale
        animationDelay = transformDuration / Double(noOfInstances)
        //step3: replicate dots to 3
        addReplicatorFor(shape: dot, noOfInstances: noOfInstances, instanceDelay: animationDelay, superView: dotsSuperView)
        dotsSuperView.addSubview(self)
    }
//    func createTypingLoader(withColor color: UIColor = .white, xMargin: CGFloat = 0){
//        let dotsContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 20)) // modify x and y according to super view
//        let dotsView = TypingLoaderView(color: color, superView: dotsContainerView) // assuming dotsView is a property of ViewController
//        self.view.addSubview(dotsContainerView) // self.view is assuming viewController for this demo
//    }
    func removeLoader(){
        self.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
}
extension CALayer {
    func addAnimationToLayer(withKeyPath keyPath: AnimationKeyPath, from: Any, to: Any, duration: CFTimeInterval,  repeatCount: Float) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: keyPath.rawValue)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.repeatCount = repeatCount
        self.add(animation, forKey: keyPath.rawValue)
    }
}
// define a enum to maintain the types of animation (optional)
enum AnimationKeyPath: String{
    case yPosition = "position.y"
    case transform = "transform"
    case opacity = "opacity"
}
