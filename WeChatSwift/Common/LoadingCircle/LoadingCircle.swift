//
//  LoadingCircle.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/24.
//  Copyright © 2024 alexiscn. All rights reserved.
// https://www.jianshu.com/p/f3754aa9dbcd

import Foundation

class LoadingCircle: UIView {
    private let circleLayer = CALayer()
    private lazy var bezierPath = UIBezierPath()
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer();
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.white.cgColor;
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.lineDashPhase = 0.8
        return shapeLayer
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
//        gradientLayer.shadowPath = bezierPath.cgPath
        gradientLayer.startPoint = CGPointMake(1, 0)
        gradientLayer.endPoint = CGPointMake(0, 0)
        gradientLayer.colors = [circleColor.cgColor, UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)]
        return gradientLayer
    }()
    private lazy var gradientLayer1: CAGradientLayer = {
        let gradientLayer1 = CAGradientLayer()
//        gradientLayer1.shadowPath = bezierPath.cgPath
        gradientLayer1.startPoint = CGPointMake(0,1)
        gradientLayer1.endPoint = CGPointMake(1, 1)
        gradientLayer1.colors = [UIColor(red: 255, green: 255, blue: 255, alpha: 0.5).cgColor, UIColor.white.cgColor]
        return gradientLayer1
    }()
    private var circleWidth: CGFloat = 4
    private var circleColor: UIColor = .black
    
    convenience init(circleWidth: CGFloat, circleColor: UIColor) {
        self.init(frame: CGRectZero)
        self.circleWidth = circleWidth
        self.circleColor = circleColor
    }
    
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
        
        circleLayer.frame = bounds
        circleLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(circleLayer)

        bezierPath.addArc(withCenter: CGPoint(x: width/2, y: width/2), radius: (width-circleWidth)/2, startAngle: 0, endAngle: Double.pi*2, clockwise: true)
        shapeLayer.lineWidth = circleWidth
//        shapeLayer.path = bezierPath.cgPath
//        circleLayer.mask = shapeLayer
        gradientLayer.frame = CGRectMake(0, 0, width, width/2)
        gradientLayer1.frame = CGRectMake(0, width/2, width, width/2)
        circleLayer.addSublayer(gradientLayer)
        circleLayer.addSublayer(gradientLayer1)
    }
    func start() {
        return
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2.0*Double.pi
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 1;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        circleLayer.add(rotationAnimation, forKey: "rotationAnnimation")
        print(frame)
        print("LoadingCircle")
    }
    
    func stop() {
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
    }
}
