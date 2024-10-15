//
//  WeChatCustomNavigationView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
class WeChatUITapGestureRecognizer:UITapGestureRecognizer{
    var data:[AnyObject]?
}


@objc protocol WeChatCustomNavigationHeaderDelegate{
    @objc func leftBarClick()//左侧事件
    @objc func rightBarClick()//右侧事件
}

//自定义导航条头部
class WeChatCustomNavigationHeaderView: UIView {

    //MARKS: Properties
    var count:Int = 0//导航条上label显示数目
    var totalCount:Int = 0//导航条上label显示的总数
    var backImage:UIImage?//左侧返回图片
    var backTitle:String?//左侧返回图片后的文字
    var rightBtn = UIButton()//右侧按钮图标
    var rightBtnText:String?//右侧按钮文字
    var rightBtnImage:UIImage?//右侧按钮图片
    var centerLabelText:String?//中间显示的文字
    var centerLabelTextColor: UIColor = .white//中间显示的文字
    
    var label:UILabel?//中间文字
    var isLayedOut:Bool = false
    var bgColor:UIColor?
    
    let leftOrRightPadding:CGFloat = 10//图片左边空白
    var rightWidth:CGFloat = 30
    var bottomPadding:CGFloat = 5//距离底部空白
    var topPadding:CGFloat = 5
    var rightBtnTextHeight:CGFloat = 0
    var statusFrame:CGRect!
    var leftWidth:CGFloat = 70
    
    var centerLabel = UILabel()
    let fontName:String = "Arial"
    var leftLabelColor:UIColor?
    var rightLabelColor:UIColor?
    
    var delegate:WeChatCustomNavigationHeaderDelegate!
    
    init(frame: CGRect,photoCount count:Int,photoTotalCount totalCount:Int,backImage:UIImage?,backTitle:String?,
        centerLabel centerLabelText:String?,rightButtonText rightBtnText:String?,rightButtonImage rightBtnImage:UIImage?,backgroundColor bgColor:UIColor?) {
        super.init(frame: frame)
            
        //init properties
        self.count = count
        self.totalCount = totalCount
        if backImage != nil {
            self.backImage = backImage
        }
            
        if backTitle != nil {
            self.backTitle = backTitle
        }
            
        if centerLabelText != nil {
            self.centerLabelText = centerLabelText
        }
            
        if rightBtnText != nil {
            self.rightBtnText = rightBtnText
        }
            
        if rightBtnImage != nil {
            self.rightBtnImage = rightBtnImage
        }
            
        if bgColor != nil {
            self.bgColor = bgColor
            self.backgroundColor = self.bgColor
        }else{
            self.backgroundColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha:1)
        }
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.statusFrame = window.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            // 使用 statusBarFrame
        }
    }
    
    init(frame: CGRect,backImage:UIImage?,backTitle:String?,
        centerLabel centerLabelText:String?,rightButtonText rightBtnText:String?,
        rightButtonImage rightBtnImage:UIImage?,backgroundColor bgColor:UIColor?,leftLabelColor:UIColor?,rightLabelColor:UIColor?) {
            super.init(frame: frame)
            if backImage != nil {
                self.backImage = backImage
            }
            
            if backTitle != nil {
                self.backTitle = backTitle
            }
            
            if centerLabelText != nil {
                self.centerLabelText = centerLabelText
            }
            
            if rightBtnText != nil {
                self.rightBtnText = rightBtnText
            }
            
            if rightBtnImage != nil {
                self.rightBtnImage = rightBtnImage
            }
            
            if bgColor != nil {
                self.bgColor = bgColor
                self.backgroundColor = self.bgColor
            }else{
                self.backgroundColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha:1)
            }
            
            if leftLabelColor != nil {
                self.leftLabelColor = leftLabelColor
            }
            
            if rightLabelColor != nil {
                self.rightLabelColor = rightLabelColor
            }
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            self.statusFrame = window.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            // 使用 statusBarFrame
        }
    }


    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createControl()
            isLayedOut = true
        }
    }
    
    //MARKS: 创建组件
    func createControl(){
        //添加左侧View
        let centerHeight = self.bounds.height - bottomPadding - statusFrame.height - topPadding
        let beginY = statusFrame.height + topPadding
//        let centerHeight = 44.0
//        let leftWidth = self.backImage?.size.width ?? self.leftWidth
        let leftView = LeftView(frame: CGRectMake(self.leftOrRightPadding, beginY, leftWidth, centerHeight), labelText: self.backTitle, backImage: self.backImage,leftLabelColor:self.leftLabelColor)
        leftView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: #selector(leftTap(gestrue: ))))
        self.addSubview(leftView)
        
        //添加右侧按钮
        if rightBtnText != nil || rightBtnImage != nil {
            if rightBtnText != nil {
                if self.rightBtnText == "● ● ●"{
                    rightBtn.frame = CGRectMake(self.bounds.width - leftOrRightPadding - rightWidth, beginY, rightWidth, centerHeight)
                    rightBtn.titleLabel?.font = UIFont(name: self.fontName, size: 10)
                } else {
                    rightBtn.frame = CGRectMake(self.bounds.width - leftOrRightPadding - rightWidth - 10, beginY, rightWidth + 10, centerHeight)
                    rightBtn.titleLabel?.font = UIFont(name: self.fontName, size: 16)
                }
                
                if self.rightLabelColor != nil {
                    rightBtn.setTitleColor(self.rightLabelColor, for: .normal)
                }else{
                    rightBtn.setTitleColor(UIColor.white, for: .normal)
                }
                
                rightBtn.setTitle(self.rightBtnText, for: .normal)
                rightBtn.titleLabel?.textAlignment = .center
            }
            
            if rightBtnImage != nil {
                rightBtn.setImage(self.rightBtnImage, for: .normal)
            }
            
            rightBtn.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: #selector(rightTap(gestrue: ))))
            self.addSubview(rightBtn)
        }
        
        //添加中间文字
        if self.centerLabelText != nil {
            let centerLabelWidth = UIScreen.main.bounds.width - self.leftOrRightPadding * 2 - leftView.bounds.width - rightWidth
            let centerLabelX:CGFloat = leftView.frame.width
            
            if count >= 1 && totalCount > 1 && !self.centerLabelText!.contains("\n") {
                centerLabel.frame = CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height)
                var labelText = self.centerLabelText!
                labelText += "\n"
                labelText += "\(count)/\(totalCount)"
                centerLabel.text = labelText
                centerLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
                centerLabel.numberOfLines = 0//允许换行
            }else{
               if self.centerLabelText!.contains("\n") {
                   centerLabel.frame = CGRect(x: centerLabelX, y: statusFrame.height + topPadding, width: centerLabelWidth, height: self.bounds.height - self.bottomPadding - statusFrame.height)
                    centerLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
                    centerLabel.numberOfLines = 0//允许换行
               }else{
                   centerLabel.frame = CGRectMake(centerLabelX, beginY, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height)
                    centerLabel.font = UIFont(name: "Arial-BoldMT", size: 18)
               }
                
                centerLabel.text = self.centerLabelText
            }
            
            centerLabel.textAlignment = .center
            centerLabel.textColor = centerLabelTextColor
            self.addSubview(centerLabel)
        }
    }
    
    //MARKS: 重新给导航条标题设值
    func resetTitle(currentCount:Int){
        if self.centerLabelText!.contains("\n") {
            let strs:[String] = self.centerLabelText!.components(separatedBy: "\n")
            let str = strs[0] + "\n\(currentCount)/\(self.totalCount)"
            self.centerLabel.text = str
            updateConstraints()
        }
    }
    
    //MARKS: 左侧事件
    @objc func leftTap(gestrue: WeChatUITapGestureRecognizer){
        delegate.leftBarClick()
    }
    
    //MARKS: 右侧事件
    @objc func rightTap(gestrue: WeChatUITapGestureRecognizer){
        delegate.rightBarClick()
    }
}

//左侧视图
class LeftView:UIView {
    
    var labelText:String?
    var backImage:UIImage?
    var isLayedOut:Bool = false
    var backImageWidth:CGFloat = 36
    let leftBackTitlePadding:CGFloat = 4//文字左边距离图片空白
    let fontName:String = "Arial"
    var leftLabelColor:UIColor?
    
    init(frame: CGRect,labelText:String?,backImage:UIImage?,leftLabelColor:UIColor?) {
        super.init(frame: frame)
        if labelText != nil {
            if !labelText!.isEmpty {
                self.labelText = labelText
            }
        }
        
        if backImage != nil {
            self.backImage = backImage
        }
        
        if leftLabelColor != nil {
            self.leftLabelColor = leftLabelColor
        }
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createView()
            isLayedOut = true
        }
    }
    
    func createView(){
        var leftBackImageView:UIImageView?
        if self.backImage != nil {
            leftBackImageView = UIImageView(frame: CGRectMake(0, 0, backImageWidth,  backImageWidth))
            leftBackImageView?.contentMode = .scaleAspectFit
            leftBackImageView!.image = self.backImage!
            self.addSubview(leftBackImageView!)
        }
        
        //添加左侧文字
        var backLabel:UILabel?
        if self.labelText != nil {
            if leftBackImageView != nil {
                backLabel = UILabel(frame: CGRectMake(leftBackImageView!.frame.origin.x + backImageWidth, leftBackImageView!.frame.origin.y, self.frame.width - backImageWidth, self.frame.height))
                backLabel?.font = UIFont(name: self.fontName, size: 16)
            }else{
                backLabel = UILabel()
                backLabel?.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
                backLabel?.font = UIFont(name: self.fontName, size: 17)
            }
            
            if self.leftLabelColor != nil {
                backLabel?.textColor = self.leftLabelColor
            }else{
                backLabel?.textColor = UIColor.white
            }
            
            backLabel?.text = self.labelText
            
            self.addSubview(backLabel!)
        }

    }
}
