//
//  RedEnvelopView.swift
//  redenvelop
//
//  Created by chaostong on 2019/8/30.
//  Copyright © 2019 chaostong. All rights reserved.
//

import Foundation
import UIKit

class RedEnvelopView: UIViewController {
    
    lazy var redHeight = (UIScreen.main.bounds.height - 88 - 44) - 200
    lazy var redWidth = UIScreen.main.bounds.width - 32*2
    
    var callBackClosure: (() -> ())? = nil
    var detailsClosure: ((_ entity: RedPacketGetEntity?) -> ())? = nil
    var updateDBClosure: ((_ isFlag: Bool) -> ())? = nil
    var openImageView = UIImageView()
    var redMsg: RedPacketMessage! = nil
    lazy var alertWindow: UIWindow = {
        let alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindow.Level.alert
        alertWindow.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController = self
        return alertWindow
    }()
    
    lazy var backgroundTop: UIImageView = {
        let image = UIImage(named: "redenvelop_top")!
        let capInsets = UIEdgeInsets(top: 50, left: 50, bottom: 80, right: 50)//创建屏蔽区域，也就是上面下面10和左右20是不可拉伸的。
        let resizableImage = image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch) 
        let height = redHeight / 4.0 * 3.0
        let iv = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: redWidth, height: height))
//        iv.con
        iv.clipsToBounds = true
        iv.image = resizableImage
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var backgroundBottom: UIImageView = {
        let image = UIImage(named: "WCPayFaceHBCoverLower")!
        let capInsets = UIEdgeInsets(top: 90, left: 20, bottom: 10, right: 10)//创建屏蔽区域，也就是上面下面10和左右20是不可拉伸的。
        let resizableImage = image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        
//        let width = UIScreen.main.bounds.width - 32*2
//        let height = width * (image.size.height / image.size.width)
        let height = redHeight / 4.0
        let iv = UIImageView.init(frame: CGRect.init(x: 0, y: self.backgroundTop.frame.height - 60, width: redWidth, height: height + 60.0))
        iv.image = resizableImage
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var backgroundImageView: UIView = {
        
        let image = UIImage.init(named: "redpacket_bg")!
        let width = UIScreen.main.bounds.width - 32*2
//        let height = (UIScreen.main.bounds.height - 88 - 44) - 120  //width * (image.size.height / image.size.width)
        let iv = UIView.init(frame: CGRect.init(x: 32, y: (UIScreen.main.bounds.height - redHeight)/2.0 - 35, width: redWidth, height: redHeight))
        iv.layer.cornerRadius = 8
//        iv.layer.masksToBounds = true
//        iv.image = image
        
        iv.transform = CGAffineTransform.init(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: 0.15, animations: {
            iv.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.15, animations: {
                iv.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            }, completion: { (finsh) in
                UIView.animate(withDuration: 0.15, animations: {
                    iv.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                })
            })
        })
        return iv
    }()
    
    lazy var openButton: UIButton = {
        
        
        let width = 100.0
        let btn = UIButton.init(frame: CGRect.init(x: self.backgroundImageView.frame.size.width/2.0-width/2.0 - 10.0, y: CGRectGetMaxY(backgroundTop.frame)-width/2.0-15.0, width: width, height: width))
        btn.addTarget(self, action: #selector(openRedPacketAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "redpacket_open_btn"), for: .normal)
        
        // 假设你有一组图片的数组
        let imageNames = ["coin1", "coin2", "coin3", "coin4", "coin5", "coin6"]
        // 创建图片数组
        let images = imageNames.compactMap { UIImage(named: $0) }
        // 设置动画的持续时间
        let duration = 0.5
        // 创建动画图片
        let animatedImage = UIImage.animatedImage(with: images, duration: duration)
        // 创建一个UIImageView来显示动画
        openImageView.image = animatedImage
        openImageView.frame = btn.frame
        openImageView.isHidden = true
         
        // 将imageView添加到视图控制器的view中
//        self.view.addSubview(imageView)
//        btn.layer.zPosition = 100
        return btn
    }()
    
    let avatarView = UIImageView()
    let contentView = UIView()
    let nickLabel = UILabel()
    let tipsLabel = UILabel()
    let detailBtn = UIButton()
    let closeBtn = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertWindow.addSubview(self.view)
        self.alertWindow.addSubview(backgroundImageView)
        
        backgroundImageView.addSubview(backgroundTop)
        backgroundImageView.insertSubview(backgroundBottom, belowSubview: backgroundTop)
        backgroundImageView.addSubview(openButton)
        backgroundImageView.addSubview(openImageView)
        backgroundTop.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(avatarView)
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        avatarView.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(25, 25))
            make.top.left.bottom.equalToSuperview()
        }
        
        nickLabel.textColor = Colors.DEFAULT_RED_YELLOW_COLOR
        nickLabel.font = .systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(nickLabel)
        nickLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.avatarView.snp.right).offset(7)
        }
        tipsLabel.textAlignment = .center
        tipsLabel.numberOfLines = 2
        tipsLabel.textColor = Colors.DEFAULT_RED_YELLOW_COLOR
        tipsLabel.font = .systemFont(ofSize: 25)
        backgroundTop.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(contentView.snp.bottom).offset(25)
        }
        detailBtn.clipsToBounds = true
        detailBtn.enlargeEdge = 6
        detailBtn.setTitle("查看领取详情", for: .normal)
        detailBtn.titleLabel?.font = .systemFont(ofSize: 15)
        detailBtn.setTitleColor(Colors.DEFAULT_RED_YELLOW_COLOR, for: .normal)
        detailBtn.image(UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: Colors.DEFAULT_RED_YELLOW_COLOR), .normal)
        detailBtn.adjustContentSpace(2, imageInLeft: false)
        detailBtn.isHidden = true
        backgroundBottom.addSubview(detailBtn)
        detailBtn.addTarget(self, action: #selector(detailsAction), for: .touchUpInside)
        detailBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
       
        closeBtn.image(UIImage(named: "HongBao_Close_Image"), .normal)
        self.alertWindow.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeViewAction), for: .touchUpInside)
        closeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(48, 48))
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.bottom).offset(25)
        }
        
//        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(closeViewAction))
//        tapGes.delegate = self
//        self.view.addGestureRecognizer(tapGes)

    }
     
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func detailsAction() {
        detailsClosure?(nil)
        closeViewAction()
    }
    @objc func closeViewAction() {
        closeBtn.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundImageView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            self.alertWindow.alpha = 0
        }) { (finished) in
            self.alertWindow.removeFromSuperview()
            self.alertWindow.rootViewController = nil
        }
    }
    
    
    @objc func openRedPacketAction() {
        openButton.isHidden = true
        openImageView.isHidden = false
//        openImageView.startAnimating()
        let request = RedPacketGetRequest(groupNo: redMsg.groupNo ?? "", isGet: "1", orderNumber: redMsg.orderNumber ?? "")
        request.start(withNetworkingHUD: false, showFailureHUD: true) { request in
            do {
                let resp = try JSONDecoder().decode(RedPacketGetEntity.self, from: request.wxResponseData())
                resp.groupNo = self.redMsg.groupNo!
                resp.orderNumber = self.redMsg.orderNumber!
                resp.ownerId = GlobalManager.manager.personModel?.userId
                RedPacketGetEntity.insertOrReplace(list: [resp])
                self.updateDBClosure?(true)
                self.openImageView.isHidden = true
                if (resp.status == 3 ||
                    resp.status == 2) &&
                    (resp.isMyselfReceive ?? 0) == 0 {
                    self.updateRedContent(model: resp, msg: nil)
                    return
                }
                self.detailsClosure?(resp)
                self.closeViewAction()
            }  catch {
                print("Error decoding JSON: \(error)")
            }
        } failure: { request in
            self.openImageView.stopAnimating()
            self.openButton.isHidden = false
            self.openImageView.isHidden = true
        }
    }
    
    func closeRedPacket() {
        UIView.animate(withDuration: 0.5, animations: {
            self.openButton.isHidden = true
            self.backgroundTop.center.y -= self.view.bounds.height
            self.backgroundBottom.center.y += self.view.bounds.height
        }) { (finished) in
            self.alertWindow.removeFromSuperview()
            self.alertWindow.rootViewController = nil
        }
    }
    
//    func confirmViewRotateInfo() -> CAKeyframeAnimation {
//        let theAnimation = CAKeyframeAnimation(keyPath: "transform")
//        theAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeRotation(0, 0, 0.5, 0)),
//        NSValue.init(caTransform3D: CATransform3DMakeRotation(3.13, 0, 0.5, 0)),
//        NSValue.init(caTransform3D: CATransform3DMakeRotation(6.28, 0, 0.5, 0))]
//        theAnimation.isCumulative = true
//        theAnimation.duration = 0.4
//        theAnimation.repeatCount = 3
//        theAnimation.isRemovedOnCompletion = true
//        theAnimation.fillMode = .forwards
//        theAnimation.delegate = self
//        return theAnimation
//    }
    
}
extension RedEnvelopView {
    
    func updateRedContent(model: RedPacketGetEntity?, msg: RedPacketMessage?) {
        backgroundTop.isHidden = false
        backgroundBottom.isHidden = false
        
        let headUrl = GlobalManager.headImageUrl(name:  model?.senderUserHead ?? (msg?.head ?? ""))
        avatarView.pin_setImage(from: headUrl, placeholderImage: UIImage(named: "login_defaultAvatar"))
        nickLabel.text = (model?.senderUserNickname ?? (msg?.nickName ?? "")) + "发出的红包"
        
        guard let model else {
            self.redMsg = msg
            tipsLabel.isHidden = true
            openButton.isHidden = false
            detailBtn.isHidden = true
            return
        } 

        // 自己已经领取了
        if (model.isMyselfReceive ?? 0) == 1 {
            openButton.isHidden = true
            openImageView.isHidden = true
            detailBtn.isHidden = false
            tipsLabel.attributedText = ((model.myselfReceiveAmount ?? "0.00") + "元").unitTextAttribute(textColor: Colors.DEFAULT_RED_YELLOW_COLOR, fontSize: 33, unitSize: 15, unit: "元", baseline: 0)
            return
        }
        guard let status = model.status else {
            return
        }
        // 状态(1进行中,2已完成,3已过期)
        if status == 2 {
            openButton.isHidden = true
            openImageView.isHidden = true
            tipsLabel.isHidden = false
            tipsLabel.text = "手慢了，红包派完了"
            detailBtn.isHidden = false
        } else if status == 3 {
            openButton.isHidden = true
            openImageView.isHidden = true
            tipsLabel.isHidden = false
            tipsLabel.text = "该红包已超过24小时，如已领取，可在“红包记录”中查看。"
            detailBtn.isHidden = true
        } else {
                tipsLabel.isHidden = true
                openButton.isHidden = false
                openImageView.isHidden = false
                detailBtn.isHidden = true
        }
    }
}

//extension RedEnvelopView: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if openButton.point(inside: touch.location(in: openButton), with: nil) {
//            openRedPacketAction()
//            return false
//        }
//        return !backgroundImageView.point(inside: touch.location(in: backgroundImageView), with: nil)
//    }
//}
//ios 8 适配
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
//// CAAnimationDelegate is not available before iOS 10 SDK
//@interface WSRedPacketView ()<UIGestureRecognizerDelegate>
//#else
extension RedEnvelopView: CAAnimationDelegate {
    func animationDidStop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.openButton.isHidden = true
            self.backgroundTop.center.y -= self.view.bounds.height
            self.backgroundBottom.center.y += self.view.bounds.height
        }) { (finished) in
            self.alertWindow.isHidden = true
            self.alertWindow.removeFromSuperview()
            self.alertWindow.rootViewController = nil
        }
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
