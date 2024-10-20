//
//  NewsCellNode.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/20.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import UIKit

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
        topIconNode.backgroundColor = .blue
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
    func cellForModel(model: AnyObject?) {
        
        topTipsNode.text = "台湾厂商回应黎巴嫩寻呼机爆炸事件：系代理商生产疑出货后被台湾厂商回应黎巴嫩寻呼机爆炸事件：台湾厂商回应黎巴嫩寻呼机爆炸事件："
        timeNode.text = "09:09"
        timeNode.textAlignment = .center
        contentView.addSubview(moreNewsContentView)
        moreNewsContentView.snp.makeConstraints { make in
            make.top.equalTo(topIconNode.snp.bottom).offset(10)
            make.left.equalTo(topTipsNode.snp.left)
            make.right.equalTo(topTipsNode.snp.right)
            make.bottom.equalTo(-20)
        }
        makeNewsContentView()
    }
        
        func makeNewsContentView() {
            
            var tempView: UIView?
            var i = 0
            while i < 3 {
                
                let newView = UIView()
                moreNewsContentView.addSubview(newView)
                newView.snp.makeConstraints { make in
                    make.height.equalTo(74)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    if i == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(tempView!.snp.bottom)
                    }
                }
                let newIcon = UIImageView()
                newView.addSubview(newIcon)
                newIcon.backgroundColor = .blue
                newIcon.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 56, height: 56))
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview()
                }
                let text = "台湾厂商回应黎巴嫩寻呼机爆炸事件：系代理商生产疑出货后被台湾厂商回应黎巴嫩寻呼机爆炸事件：台湾厂商回应黎巴嫩寻呼机爆炸事件："
                let newLabel = DNKCreate.label(text: text, textColor: .black, fontSize: 17)
                newView.addSubview(newLabel)
                newLabel.numberOfLines = 2
                newLabel.textAlignment = .left
                newLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-20)
                    make.right.equalTo(newIcon.snp.left).offset(-25)
                }
                
                if i != 2 {
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
