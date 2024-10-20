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
        
        let downBtn = DNKCreate.button(normalTitle: "下载腾讯新闻", normalColor: .white, normalImg: UIImage.SVGImage(named: "icons_outlined_arrow", fillColor: .white))
        bottomView.addSubview(downBtn)
        downBtn.backgroundColor = UIColor(hexString: "4373F6")
        downBtn.layer.cornerRadius = 25
        downBtn.layer.masksToBounds = true
        downBtn.adjustContentSpace(6, imageInLeft: false)
        downBtn.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.size.equalTo(CGSizeMake(164, 50))
            make.right.equalTo(-20)
        }
        plBtn = DNKCreate.button(normalTitle: "10", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
        bottomView.addSubview(plBtn)
        plBtn.adjustContentSpace(4, imageInLeft: true)
        plBtn.snp.makeConstraints { make in
//            make.size.equalTo(CGSizeMake(168, 50))
            make.centerY.equalTo(downBtn.snp.centerY)
            make.left.equalTo(25)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        zanBtn = DNKCreate.button(normalTitle: "0", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
        bottomView.addSubview(zanBtn)
        zanBtn.adjustContentSpace(4, imageInLeft: true)
        zanBtn.snp.makeConstraints { make in
            make.centerY.equalTo(downBtn.snp.centerY)
            make.left.equalTo(plBtn.snp.right).offset(15)
            make.size.equalTo(plBtn.snp.size)
        }
        zhuanBtn = DNKCreate.button(normalTitle: "0", normalColor: Colors.DEFAULT_TEXT_GRAY_COLOR, normalImg: UIImage(named: "AlbumLikeSmall_18x18_"), fontSize: 15)
        bottomView.addSubview(zhuanBtn)
        zhuanBtn.adjustContentSpace(4, imageInLeft: true)
        zhuanBtn.snp.makeConstraints { make in
            make.centerY.equalTo(downBtn.snp.centerY)
            make.left.equalTo(zanBtn.snp.right).offset(15)
            make.size.equalTo(plBtn.snp.size)
        }
    }
    
    @objc func handleMoreButtonClicked() {
        
    }
}
