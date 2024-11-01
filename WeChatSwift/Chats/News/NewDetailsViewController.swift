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
        bottomView.backgroundColor = UIColor(hexString: "F6F6F6")
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(Constants.bottomInset)
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
        if let linkUrl = self.link,
           let url = URL(string: linkUrl) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    @objc func cancelAction() {
        popupView?.dismissPopupView(completion: { _ in
            
        })
    }
    @objc func handleMoreButtonClicked() {
//        if popupView != nil {
//            return
//        }
        popupView = JFPopupView.popup.custom(with: JFPopupConfig.bottomSheet) { [self] mainContainer in
            let card = UIView()
            card.backgroundColor =  UIColor(hexString: "F6F6F6")
            card.frame = CGRectMake(0, 0, Constants.screenWidth, Constants.bottomInset + 320)
            self.roundCorners(card: card, corners: [.topLeft, .topRight], radius: 12)
            
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
             
            
            let scrollView = UIScrollView()
            card.addSubview(scrollView)
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(tempView!.snp.bottom).offset(25)
                make.left.right.equalToSuperview()
            }
            let contentView = UIView()
            scrollView.addSubview(contentView)
            scrollView.showsHorizontalScrollIndicator = false
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalToSuperview()
            }
            let title2 = ["保存为图片", "投诉", "复制链接", "刷新", "全文翻译", "查找页面内容", "调整字体"]
            let icon2 = ["icon_download", "icon_warm", "icon_link", "icon_refresh", "icon_fanyi", "icon_lookup", "icon_font"]
            i = 0
            tempView = nil
            while i < title2.count {
                let btn = self.makeNewsButton(icon: icon2[i], title: title2[i])
                contentView.addSubview(btn)
                btn.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    if tempView == nil {
                        make.left.equalToSuperview().offset(15)
                    } else {
                        make.left.equalTo(tempView!.snp.right).offset(15)
                    }
                    if i == title2.count - 1 {
                        make.right.equalToSuperview().offset(-15)
                    }
                }
                tempView = btn
                i += 1
            }
            
            let lineView = UIView()
            card.addSubview(lineView)
            lineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            lineView.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.bottom).offset(15)
                make.left.right.equalToSuperview()
                make.height.equalTo(0.3)
            }
            let cancelBtn = DNKCreate.button(normalTitle: "取消", normalColor: Colors.Blue_TEXT, fontSize: 16)
            card.addSubview(cancelBtn)
            cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            cancelBtn.snp.makeConstraints { make in
                make.top.equalTo(lineView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
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
            make.left.greaterThanOrEqualTo(1)
            make.right.greaterThanOrEqualTo(-1)
//            make.left.right.greaterThanOrEqualTo(0)
        }
        let titleLabel = DNKCreate.label(text: title, textColor: UIColor(white: 0, alpha: 0.4), fontSize: 10)
        itemView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        return itemView
    }
    
 
}
