//
//  NewsCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/20.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NewsCellNode: UICollectionViewCell {
    
    var timeNode: UILabel!
    var topIconNode = UIImageView()
    var topTipsNode: UILabel!
    
    var news1Node: UILabel!
    var news1IconNode = UIImageView()
    var line1Node = UILabel()
    var news2Node: UILabel!
    var news2IconNode = UIImageView()
    var line2Node = UILabel()
    var news3Node: UILabel!
    var news3IconNode = UIImageView()
    
    var moreNewsContentView = UIView()
    
    var links: [String] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeNode = DNKCreate.label(textColor: Colors.DEFAULT_TEXT_DARK_COLOR, fontSize: 15)
       
        topTipsNode = DNKCreate.label(textColor: .white, fontSize: 19, weight: .bold)
        topTipsNode.numberOfLines = 2
//        news1Node = DNKCreate.label(textColor: .black, fontSize: 17)
//        news1Node.numberOfLines = 2
//        news2Node = DNKCreate.label(textColor: .black, fontSize: 17)
//        news2Node.numberOfLines = 2
//        news3Node = DNKCreate.label(textColor: .black, fontSize: 17)
//        news3Node.numberOfLines = 2
//        line1Node.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
//        line2Node.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(timeNode)
        timeNode.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        let cardView = UIView()
        contentView.addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.layer.masksToBounds = true
        cardView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
//            make.height.equalTo(390)
            make.top.equalTo(timeNode.snp.bottom)
        }
        topIconNode.backgroundColor = UIColor(white: 0, alpha: 0.1)
        cardView.addSubview(topIconNode)
        topIconNode.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        cardView.addSubview(topTipsNode)
        topTipsNode.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(topIconNode.snp.bottom).offset(-10)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func cellForModel(model: MessageEntity) {
        links = []
        timeNode.text = NSString.timeText(withTimestamp: Int(model.createTime ?? 0), formatter: "HH:mm")
        if let list = try? JSON(data: (model.linkContent! as NSString).mj_JSONData()).arrayValue {
            if let news = list.first {
                links.append(news["link"].stringValue)
                topTipsNode.text = news["title"].stringValue
                topIconNode.pin_setImage(from: GlobalManager.chatImageUrl(name: news["image"].stringValue))
                timeNode.textAlignment = .center
                contentView.addSubview(moreNewsContentView)
                moreNewsContentView.snp.makeConstraints { make in
                    make.top.equalTo(topIconNode.snp.bottom).offset(10)
                    make.left.equalTo(topTipsNode.snp.left)
                    make.right.equalTo(topTipsNode.snp.right)
                    make.bottom.equalTo(-20)
                }
            }
            makeNewsContentView(list: list)
        }
        
    }
        
    func makeNewsContentView(list: [JSON]) {
            
            var tempView: UIView?
            var i = 1
        while i < list.count {
            let news = list[i]
            links.append(news["link"].stringValue)
                let newView = UIView()
                moreNewsContentView.addSubview(newView)
                newView.snp.makeConstraints { make in
                    make.height.equalTo(74)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    if tempView == nil {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(tempView!.snp.bottom)
                    }
                }
                let newIcon = UIImageView()
            newIcon.pin_setImage(from: GlobalManager.chatImageUrl(name: news["image"].stringValue))
                newView.addSubview(newIcon)
                newIcon.backgroundColor =  UIColor(white: 0, alpha: 0.1)
                newIcon.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 56, height: 56))
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview()
                }
                let text = news["title"].stringValue
                let newLabel = DNKCreate.label(text: text, textColor: .black, fontSize: 17)
                newView.addSubview(newLabel)
                newLabel.numberOfLines = 2
                newLabel.textAlignment = .left
                newLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-20)
                    make.right.equalTo(newIcon.snp.left).offset(-25)
                }
                
            if i != (list.count - 1) {
                    let lineView = UIView()
                    newView.addSubview(lineView)
                    lineView.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
                    lineView.snp.makeConstraints { make in
                        make.height.equalTo(0.5)
                        make.left.bottom.equalToSuperview()
                        make.right.equalTo(newLabel.snp.right)
                    }
                }
                tempView = newView
                i += 1
            }
        }
}
