//
//  LoadingCircle.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/24.
//  Copyright © 2024 alexiscn. All rights reserved.
// https://www.jianshu.com/p/f3754aa9dbcd

import Foundation

@objcMembers
class LoadingCircle: UIView {
    private let circleLayer = CALayer()
    private lazy var bezierPath = UIBezierPath()
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer();
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = circleColor.cgColor;
        shapeLayer.strokeStart = 0
        shapeLayer.lineJoin = .round
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.lineDashPhase = 0.8
        return shapeLayer
    }()
     
    private lazy var maskLayer: CALayer = {
       let image = UIImage(named: "angle-mask")!
       let layer = CALayer()
        layer.contents = image.cgImage
        return layer
        
    }()
//    fileprivate lazy var circleHUDView: UIView = { view in
//        view.frame = CGRect(
//            x: 0,
//            y: 0,
//            width: 65,
//            height: 65
//        )
//        let lineWidth: CGFloat = 3
//        let lineMargin: CGFloat = lineWidth / 2
//        let arcCenter = CGPoint(x: view.width / 2 - lineMargin, y: view.height / 2 - lineMargin)
//        let smoothedPath = UIBezierPath(
//            arcCenter: arcCenter,
//            radius: view.width / 2 - lineWidth,
//            startAngle: 0,
//            endAngle: CGFloat(Double.pi * 2),
//            clockwise: true
//        )
//        
//        let layer: CAShapeLayer = {
//            $0.contentsScale = UIScreen.main.scale
//            $0.frame = CGRect(x: lineMargin, y: lineMargin, width: arcCenter.x * 2, height: arcCenter.y * 2)
//            $0.fillColor = UIColor.clear.cgColor
//            $0.strokeColor = UIColor.white.cgColor
//            $0.lineWidth = 3
//            $0.lineCap = CAShapeLayerLineCap.round
//            $0.lineJoin = CAShapeLayerLineJoin.bevel
//            $0.path = smoothedPath.cgPath
//            $0.mask = CALayer()
//            $0.mask?.contents = UIImage(named: "angle-mask")!
//            $0.mask?.frame = $0.bounds
//            return $0
//        }(CAShapeLayer())
//        
//        let animation: CABasicAnimation = {
//            $0.fromValue = 0
//            $0.toValue = (Double.pi * 2)
//            $0.duration = 1
//            $0.isRemovedOnCompletion = false
//            $0.repeatCount = Float(Int.max)
//            $0.autoreverses = false
//            return $0
//        }(CABasicAnimation(keyPath: "transform.rotation"))
//        
//        layer.add(animation, forKey: "rotate")
//        
//        view.layer.addSublayer(layer)
//        return view
//    }(UIView())
    
    
    private var circleWidth: CGFloat = 4
    private var circleColor: UIColor = .black
    
    convenience init(circleWidth: CGFloat, circleColor: UIColor) {
        self.init(frame: CGRectZero)
        self.circleWidth = circleWidth
        self.circleColor = circleColor    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = CGRectGetWidth(frame)
        if width == 0 {
            return
        }
        bezierPath.addArc(withCenter: CGPoint(x: width/2, y: width/2), radius: (width-circleWidth)/2, startAngle: 0, endAngle: Double.pi*2, clockwise: true)
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        shapeLayer.lineWidth = circleWidth
        shapeLayer.path = bezierPath.cgPath
        maskLayer.frame = bounds
        shapeLayer.mask = maskLayer
        
        circleLayer.frame = bounds
        circleLayer.addSublayer(shapeLayer)
        layer.addSublayer(circleLayer)

        
        
//        circleLayer.addSublayer(maskLayer)
    }
    func start() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2.0*Double.pi
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 1;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        circleLayer.add(rotationAnimation, forKey: "rotationAnnimation")
    }
    
    func stop() {
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
    }
}
