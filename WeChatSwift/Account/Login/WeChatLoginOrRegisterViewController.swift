//
//  FirstLoginOrRegisterViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//第一次打开显示登陆或注册按钮
class WeChatLoginOrRegisterViewController: UIViewController {

    let leftOrRightPadding:CGFloat = 20
    var buttonWidth:CGFloat = 0
    let buttonHeight:CGFloat = 48
    var buttonBeginY:CGFloat = 0
    
    var loginViewController:WeChatLoginViewController?
    var registerViewController:WeChatRegisterViewController?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent  // 这里可以设置为.lightContent或.darkContent
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intFrame()
    }
    func intFrame(){
        let view = UIView(frame:self.view.frame)
        let imageView = UIImageView(image: UIImage(named: "firstStart")!)
        imageView.frame = view.frame
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        let labelWidth = 60.0
        let labelX = view.frame.width - labelWidth - 10.0
        let labelY = Constants.statusBarHeight + 20
        let simpleChineseLbl = UILabel(frame: CGRect(x: labelX, y: labelY, width: labelWidth, height: 20))
        simpleChineseLbl.text = "简体中文"
        simpleChineseLbl.textColor = UIColor(white: 1, alpha: 0.5)
        simpleChineseLbl.font = .systemFont(ofSize: 14)
        view.addSubview(simpleChineseLbl)
        
        self.buttonWidth = 160//(view.frame.width - 20 * 3) / 2
        self.buttonBeginY = view.frame.height - Constants.bottomInset - self.leftOrRightPadding - buttonHeight
        
        let loginButton = createButton(title: "登录", beginX: self.leftOrRightPadding, bgColor: UIColor(white: 0.5, alpha: 0.1), textColor: UIColor(white: 1, alpha: 0.6))
        let registerButton = createButton(title: "注册", beginX: view.frame.width - self.leftOrRightPadding - self.buttonWidth, bgColor: UIColor(hexString: "05BC5E"), textColor: UIColor.white)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: UIControl.Event.touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(view)
    }
    
    //MARKS: 注册按钮事件
    @objc func loginButtonClick(){
        if self.loginViewController == nil {
            self.loginViewController = WeChatLoginViewController()
        }
        self.loginViewController?.modalPresentationStyle = .fullScreen
        self.present(self.loginViewController!, animated: true, completion: nil)
    }
    
    //MAKRS: 登陆按钮事件
    @objc func registerButtonClick(){
        if self.registerViewController == nil {
            self.registerViewController = WeChatRegisterViewController()
        }
        self.registerViewController?.modalPresentationStyle = .fullScreen
        self.present(self.registerViewController!, animated: true, completion: nil)
    }
    
    
    func createButton(title:String,beginX:CGFloat,bgColor:UIColor,textColor:UIColor) -> UIButton{
        let button = UIButton(type: .custom)
        button.frame = CGRectMake(beginX, buttonBeginY, buttonWidth, buttonHeight)
        button.setTitle(title, for: .normal)
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }
}
