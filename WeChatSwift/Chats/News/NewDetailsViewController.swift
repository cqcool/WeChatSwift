//
//  NewDetailsViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/20.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import WebKit

class NewDetailsViewController: UIViewController {
    
//    private let webView = WKWebView()
    private let bottomView = UIView()
    private var plBtn: UIButton! = nil
    private var zanBtn: UIButton! = nil
    private var zhuanBtn: UIButton! = nil
    
    var link: String? = nil
    var webView : WKWebView! = nil
    private var popupView:JFPopupView?
    
    override func viewDidLoad() {
        
        navigationItem.title = "腾讯新闻"
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(Constants.bottomInset + 60)
        }
        
//        let downBtn = DNKCreate.button(normalTitle: "下载腾讯新闻", normalColor: .white, normalImg: UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: .white))
//        bottomView.addSubview(downBtn)
//        downBtn.backgroundColor = UIColor(hexString: "4373F6")
//        downBtn.layer.cornerRadius = 25
//        downBtn.layer.masksToBounds = true
//        downBtn.adjustContentSpace(6, imageInLeft: false)
//        downBtn.snp.makeConstraints { make in
//            make.top.equalTo(10)
//            make.size.equalTo(CGSizeMake(164, 50))
//            make.right.equalTo(-20)
//        }
//        plBtn = DNKCreate.button(normalTitle: "10", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
//        bottomView.addSubview(plBtn)
//        plBtn.adjustContentSpace(4, imageInLeft: true)
//        plBtn.snp.makeConstraints { make in
////            make.size.equalTo(CGSizeMake(168, 50))
//            make.centerY.equalTo(downBtn.snp.centerY)
//            make.left.equalTo(25)
//            make.size.equalTo(CGSizeMake(40, 40))
//        }
//        zanBtn = DNKCreate.button(normalTitle: "0", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
//        bottomView.addSubview(zanBtn)
//        zanBtn.adjustContentSpace(4, imageInLeft: true)
//        zanBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(downBtn.snp.centerY)
//            make.left.equalTo(plBtn.snp.right).offset(15)
//            make.size.equalTo(plBtn.snp.size)
//        }
//        zhuanBtn = DNKCreate.button(normalTitle: "0", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
//        bottomView.addSubview(zhuanBtn)
//        zhuanBtn.adjustContentSpace(4, imageInLeft: true)
//        zhuanBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(downBtn.snp.centerY)
//            make.left.equalTo(zanBtn.snp.right).offset(15)
//            make.size.equalTo(plBtn.snp.size)
//        }
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
//            make.bottom.equalTo(bottomView.snp.top)
        }
        if let linkUrl = link,
           let url = URL(string: linkUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func handleMoreButtonClicked() {
//        if popupView != nil {
//            return
//        }
        popupView = JFPopupView.popup.custom(with: JFPopupConfig.bottomSheet) { mainContainer in
            let card = UIView()
            card.backgroundColor =  UIColor(hexString: "F6F6F6")
            card.frame = CGRectMake(0, 0, Constants.screenWidth, Constants.bottomInset + 420)
            self.roundCorners(card: card, corners: [.topLeft, .topRight], radius: 8)
            
            let titleLabele = DNKCreate.label(text:"网页由 view.inews.qq.com 提供", textColor: UIColor(white: 0, alpha: 0.6), fontSize: 13)
            card.addSubview(titleLabele)
            titleLabele.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
            }
            let title1 = ["转发给朋友", "分享到朋友\n圈", "收藏", "在浏览器打\n开"]
            let icon1 = ["zhuan_fa", "friends_circle", "favorite", "safari"]
            var i = 0
            var tempView: UIView? = nil
            while i < title1.count {
                let btn = self.makeNewsButton(icon: icon1[i], title: title1[i])
                card.addSubview(btn)
                btn.snp.makeConstraints { make in
                    make.top.equalTo(titleLabele.snp.bottom).offset(30)
                    if tempView == nil {
                        make.left.equalToSuperview().offset(15)
                    } else {
                        make.left.equalTo(tempView!.snp.right).offset(15)
                    }
//                    make.height.equalTo(102.0+8+16)
                }
                tempView = btn
                i += 1
            }
            
            
            
            
            
            let title2 = ["投诉", "复制链接", "刷新", "查找页面内容", "全文翻译"]
            let icon2 = ["icon_download", "icon_lookup", "favorite", "icon_refresh", "icon_font", "icon_fanyi"]
            i = 0
            tempView = nil
//            let tipsLabele = DNKCreate.label(text:"根据国家监管要求，请确认你曾在微信支付留存的手机号151******52当前是否为你本人使用。请在2024-09-17前处理，以正常使用微信支付。", textColor: UIColor(white: 0, alpha: 0.8), fontSize: 16, weight: .medium)
//            card.addSubview(tipsLabele)
//            tipsLabele.numberOfLines = -1
//            tipsLabele.snp.makeConstraints { make in
//                make.top.equalTo(titleLabele.snp.bottom).offset(20)
//                make.centerX.equalToSuperview()
//                make.left.equalTo(25)
//                make.right.equalTo(-25)
//            }
//            let buttonWidth = 120.0
//            let buttonHeight = 50.0
//            let spacing = 15.0
//            let localtion = (Constants.screenWidth - 2*buttonWidth - spacing) / 2
//            let lateButton = DNKCreate.button(normalTitle: "稍后处理", normalColor: .black, fontSize: 16)
//            card.addSubview(lateButton)
//            lateButton.addTarget(self, action: #selector(self.lateButtonAction), for: UIControl.Event.touchUpInside)
//            lateButton.layer.cornerRadius = 6
//            lateButton.layer.masksToBounds = true
//            lateButton.backgroundColor = UIColor(white: 0, alpha: 0.1)
//            lateButton.snp.makeConstraints { make in
//                make.height.equalTo(buttonHeight)
//                make.width.equalTo(buttonWidth)
//                make.top.equalTo(tipsLabele.snp.bottom).offset(50)
//                make.left.equalToSuperview().offset(localtion)
//            }
//            let nowButton = DNKCreate.button(normalTitle: "立即处理", normalColor: .white, fontSize: 16)
//            card.addSubview(nowButton)
//            nowButton.backgroundColor = Colors.Green_standrad
//            nowButton.layer.cornerRadius = 6
//            nowButton.layer.masksToBounds = true
//            nowButton.snp.makeConstraints { make in
//                make.height.equalTo(buttonHeight)
//                make.width.equalTo(buttonWidth)
//                make.top.equalTo(lateButton.snp.top)
//                make.left.equalTo(lateButton.snp.right).offset(spacing)
//            }
            // 立即处理
            return card
        }
        popupView?.config.bgColor = UIColor(white: 0, alpha: 0.6)
    }
    private func roundCorners(card: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: card.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        card.layer.mask = mask
    }
    private func makeNewsButton(icon: String, title: String) -> UIView {
        let itemView = UIView()
        let imageView = DNKCreate.imageView(normalName: icon)
        itemView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSizeMake(60, 60))
            make.left.right.equalToSuperview()
        }
        let titleLabel = DNKCreate.label(text: title, textColor: UIColor(white: 0, alpha: 0.4), fontSize: 10)
        itemView.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        return itemView
    }
    
 
}
