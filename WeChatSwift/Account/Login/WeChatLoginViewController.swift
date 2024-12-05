//
//  WeChatLoginViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

//登陆页面
class WeChatLoginViewController: UIViewController {
    var navigationView: WeChatCustomNavigationHeaderView!
    let scrollView = UIScrollView()
    let contentView = UIView()
    var titleLabel: UILabel!
    var countryLabel: UILabel!
    var accountTextField: UITextField!
    var arrowImgView: UIImageView!
    var phoneLabel: UILabel!
    var loginWayBtn: UIButton!
    var phoneTipLabel: UILabel!
    var continueBtn: UIButton!
    var phoneTextField: UITextField!
    var btmVerticalStack = UIStackView()
    var loginType: LoginTye = .phone
    
    var phoneText: String?
    var accountText: String?
    var pswText: String?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(view.bounds.height - Constants.statusBarHeight - 44)
        }
        navigationView = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0, Constants.screenWidth, Constants.statusBarHeight+44), backImage: UIImage(named: "close_trusted_friend_tips_hl"), backTitle: nil, centerLabel: nil, rightButtonText: nil, rightButtonImage: nil, backgroundColor: UIColor(white: 1, alpha: 0.9), leftLabelColor: nil, rightLabelColor: nil)
        navigationView.delegate = self
        view.addSubview(navigationView)
        
        layoutContentView()
        updateContent()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        accountTextField.textDidChangeBlock = {
            self.accountText = $0
        }
        phoneTextField.textDidChangeBlock = { text in
            if self.loginType == .phone {
                self.phoneText = text
            } else {
                self.pswText = text
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loginAction() {
        view.endEditing(true)
        if loginType == .phone {
            return
        }
        guard let phone = accountTextField.text else {
            WXProgressHUD.brieflyProgressMsg("请填写微信号/QQ号/邮箱")
            return
        }
        
        guard let pswText = self.pswText else {
            WXProgressHUD.brieflyProgressMsg("请填写密码")
            return
        }
        WXProgressHUD.showProgress()
        let psw = pswText.md5Encrpt().lowercased()
        let loginRequest = LoginRequest(account: phone, password: psw)
        let chainRequest = YTKChainRequest()
        chainRequest.delegate = self
        chainRequest.add(loginRequest) { _, request in
            if request.apiSuccess() {
                if let json = try? JSON(data: request.wxResponseData()) {
                    if let token = json["token"].string {
                        GlobalManager.manager.updateToken(token: token)
                    }
                    if let refreshToken = json["refreshToken"]["refreshToken"].string {
                        GlobalManager.manager.updateRefreshToken(refreshToken: refreshToken)
                        let timeout = json["refreshToken"]["timeOut"].int ?? -1
                        GlobalManager.manager.timingManager.updateTokenTimeout(timeout: timeout)
                    }
                }
            }
        }
        
        let infoRequest = UserInfoRequest()
        chainRequest.add(infoRequest) { _, request in
            if request.apiSuccess() {
                GlobalManager.manager.getConfigInfo { error in
                    WXProgressHUD.hiddenProgressHUD()
                    do {
                        let resp = try JSONDecoder().decode(PersonModel.self, from: request.wxResponseData())
                        GlobalManager.manager.updatePersonModel(model: resp)
                        GlobalManager.manager.login(isLogin: true)
                        
                    } catch {
                        debugPrint(error)
                    } 
                }
            }
        }
        
        
        chainRequest.start()
    }
    @objc func changeLoginType() {
        view.endEditing(true)
        loginType = loginType == .phone ? .other : .phone
        updateContent()
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        // 处理键盘将要显示的逻辑
        if let userInfo = notification.userInfo,
           let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            btmVerticalStack.snp.updateConstraints { (make) in
                make.bottom.equalTo(-291.0 + Constants.bottomInset+68)
            }
            print("height: \(intersection.height)")
            
            print(userInfo)
            /*
             let frame = value.cgRectValue
             btmVerticalStack.snp.updateConstraints { (make) in
             make.bottom.equalTo(-frame.height + Constants.bottomInset+68)
             }
             */
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 处理键盘将要隐藏的逻辑
        if let userInfo = notification.userInfo,
           //           let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            //
            //            let frame = value.cgRectValue
            //            let intersection = frame.intersection(self.view.frame)
            btmVerticalStack.snp.updateConstraints { (make) in
                make.bottom.equalTo(-20)
            }
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    private func updateContent() {
        phoneTextField.text = nil
        accountTextField.text = nil
        if loginType == .phone {
            phoneTextField.text = phoneText
            titleLabel.text = "手机号登录"
            countryLabel.text = "国家/地区    中国大陆"
            phoneLabelAttributeText(value: "手机号           +86")
            loginWayBtn.setTitle("用微信号/QQ号/邮箱登录", for: .normal)
            phoneTipLabel.text = "上述手机号仅用于登录验证"
            continueBtn.setTitle("同意并继续", for: .normal)
            phoneTextField.placeholder = "请填写手机号码"
            phoneTextField.keyboardType = .numberPad
            phoneTextField.isSecureTextEntry = false
            accountTextField.isHidden = true
            arrowImgView.isHidden = false
            phoneLabel.snp.updateConstraints { make in
                make.width.equalTo(132)
            }
            countryLabel.snp.updateConstraints { make in
                make.width.equalTo(170)
            }
        } else {
            accountTextField.text = accountText
            phoneTextField.text = pswText
            titleLabel.text = "微信号/QQ号/邮箱登录"
            countryLabel.text = "帐号"
            phoneLabelAttributeText(value: "密码")
            loginWayBtn.setTitle("用手机号登录", for: .normal)
            phoneTipLabel.text = "上述微信号/QQ号/邮箱仅用于登录验证"
            continueBtn.setTitle("同意并登录", for: .normal)
            let inputAccessoryView =  UIView(frame: CGRectMake(0, 0, view.bounds.width, 10))
            inputAccessoryView.backgroundColor = .red
            phoneTextField.isSecureTextEntry = true
            phoneTextField.placeholder = "请填写密码"
            phoneTextField.keyboardType = .asciiCapable
            phoneTextField.autocapitalizationType = .none
            phoneTextField.autocorrectionType = .no
            phoneTextField.spellCheckingType = .no
            //            phoneTextField.returnKeyType = .go
            
            accountTextField.isHidden = false
            accountTextField.autocapitalizationType = .none
            accountTextField.autocorrectionType = .no
            accountTextField.spellCheckingType = .no
            accountTextField.keyboardType = .asciiCapable
            //            accountTextField.returnKeyType = .next
            arrowImgView.isHidden = true
            phoneLabel.snp.updateConstraints { make in
                make.width.equalTo(50)
            }
            countryLabel.snp.updateConstraints { make in
                make.width.equalTo(50)
            }
            
#if DEBUG
            accountTextField.text = "18259890000"
            phoneTextField.text = "Wx123456"
            pswText = "Wx123456"
#endif
        }
        view.layoutIfNeeded()
    }
    
    private func phoneLabelAttributeText(value: String) {
        let mutableAttribtue = value.addAttributed(font: .systemFont(ofSize: 17), textColor: .black, lineSpacing: 0, wordSpacing: 0).mutableCopy() as! NSMutableAttributedString
        
        let text = "+86"
        if value.contains(text) {
            if let range = value.range(of: text) {
                let nsRange = NSRange(range, in: value)
                mutableAttribtue.addAttribute(.foregroundColor, value:  UIColor(white: 0, alpha: 0.5), range: nsRange)
            }
        }
        phoneLabel.attributedText = mutableAttribtue
    }
    private func layoutContentView() {
        titleLabel = WXCreate.label(text: "手机号登录", textColor: .black, fontSize: 22, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.statusBarHeight + 44 + 10)
            make.centerX.equalToSuperview()
        }
        let phoneView = UIView()
        contentView.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        createPhoneView(phoneView)
        btmVerticalStack.axis = .vertical
        btmVerticalStack.alignment = .center
        contentView.addSubview(btmVerticalStack)
        btmVerticalStack.snp.makeConstraints { make in
            make.bottom.equalTo( -20)
            make.left.right.equalToSuperview()
        }
        phoneTipLabel = WXCreate.label(text: "上述手机号仅用于登录验证", textColor: UIColor(white: 0, alpha: 0.3), fontSize: 14)
        btmVerticalStack.addArrangedSubview(phoneTipLabel)
        
        continueBtn = WXCreate.button(normalTitle: "同意并继续", normalColor: .white)
        continueBtn.titleLabel?.font = .systemFont(ofSize: 16)
        continueBtn.backgroundColor = UIColor(hexString: "07C160")
        continueBtn.layer.cornerRadius = 8
        continueBtn.constant(width: 185)
        continueBtn.constant(height: 50)
        continueBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        btmVerticalStack.setCustomSpacing(20, after: phoneTipLabel)
        btmVerticalStack.addArrangedSubview(continueBtn)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .equalCentering
        btmVerticalStack.addArrangedSubview(horizontalStack)
        btmVerticalStack.setCustomSpacing(50, after: continueBtn)
        horizontalStack.spacing = 10
        horizontalStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        let findBtn = WXCreate.button(normalTitle: "找回密码", normalColor: UIColor(hexString: "566B94"), fontSize: 14, weight: .medium)
        
        let btmLine = WXCreate.lineView(nil)
        btmLine.constant(width: 0.5)
        btmLine.constant(height: 10)
        btmLine.backgroundColor = UIColor(hexString: "ADADAD")
        btmLine.setContentHuggingPriority(.required, for: .horizontal)
        let moreBtn = WXCreate.button(normalTitle: "更多选项", normalColor: UIColor(hexString: "566B94"), fontSize: 14, weight: .medium)
        horizontalStack.addArrangedSubview(findBtn)
        horizontalStack.addArrangedSubview(btmLine)
        horizontalStack.addArrangedSubview(moreBtn)
    }
    
    private func createPhoneView(_ phoneView: UIView) {
        let oneLineView = UIView()
        phoneView.addSubview(oneLineView)
        oneLineView.backgroundColor = UIColor(hexString: "E5E5E5")
        oneLineView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        let oneView = UIView()
        phoneView.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneLineView.snp.bottom)
            make.height.equalTo(58)
        }
        countryLabel = WXCreate.label(text: "国家/地区    中国大陆", textColor: .black, fontSize: 17)
        oneView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(170)
        }
        accountTextField = UITextField()
        oneView.addSubview(accountTextField)
        //        accountTextField.delegate = self
        accountTextField.clearButtonMode = .whileEditing
        accountTextField.placeholder = "微信号/QQ号/邮箱"
        accountTextField.isHidden = true
        accountTextField.textLength = 60
        accountTextField.filterEmoji = true
        accountTextField.snp.makeConstraints { make in
            make.left.equalTo(countryLabel.snp.right).offset(10)
            make.top.right.bottom.equalToSuperview()
        }
        //        let contryLabel2 = DNKCreate.label(text: "中国大陆", textColor: .black, fontSize: 17)
        //        oneView.addSubview(contryLabel2)
        //        contryLabel2.snp.makeConstraints { make in
        //            make.top.bottom.equalToSuperview()
        //            make.left.equalTo(contryLabel.snp.right).offset(20)
        //            make.width.equalTo(80)
        //        }
        arrowImgView = WXCreate.imageView(normalName: "AlbumTimeLineTipArrowHL_15x15_")
        oneView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.right.equalTo(oneView.snp.right)
            make.centerY.equalToSuperview()
        }
        
        let twoLineView = UIView()
        phoneView.addSubview(twoLineView)
        twoLineView.backgroundColor = UIColor(hexString: "E5E5E5")
        twoLineView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        // 手机号
        let twoView = UIView()
        phoneView.addSubview(twoView)
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoLineView.snp.bottom)
            make.height.equalTo(56)
        }
        phoneLabel = WXCreate.label(text: "手机号    +86", textColor: .black, fontSize: 17)
        twoView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(170)
        }
        //        let countryCodeLabel = DNKCreate.label(text: "+86", textColor: UIColor(white: 0, alpha: 0.5), fontSize: 17)
        //        twoView.addSubview(countryCodeLabel)
        //        countryCodeLabel.snp.makeConstraints { make in
        //            make.top.bottom.equalToSuperview()
        //            make.left.equalTo(phoneLabel.snp.right).offset(20)
        //            make.width.equalTo(40)
        //        }
        phoneTextField = UITextField()
        twoView.addSubview(phoneTextField)
        phoneTextField.placeholder = "请填写手机号码"
        phoneTextField.keyboardType = .numberPad
        phoneTextField.textLength = 16
        phoneTextField.filterEmoji = true
        phoneTextField.clearButtonMode = .whileEditing
        //        phoneTextField.delegate = self
        phoneTextField.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.right).offset(10)
            make.top.right.bottom.equalToSuperview()
        }
        
        let lineView3 = UIView()
        phoneView.addSubview(lineView3)
        lineView3.backgroundColor = UIColor(hexString: "E5E5E5")
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        loginWayBtn = WXCreate.button(normalTitle: "用微信号/QQ号/邮箱登录", normalColor: UIColor(hexString: "576B95"))
        loginWayBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        loginWayBtn.addTarget(self, action: #selector(changeLoginType), for: .touchUpInside)
        phoneView.addSubview(loginWayBtn)
        loginWayBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(13)
            make.left.bottom.equalToSuperview()
        }
    }
    
    private func showPopupAlert(msg: String) {
        let popupView = JFPopupView.popup.alert {[
            .subTitle(msg),
            .subTitleColor(.black),
            .showCancel(false),
            .withoutAnimation(true),
            .confirmAction([
                .text("确定"),
                .textColor(UIColor(hexString: "576B95")),
                .tapActionCallback({
                })
            ])
        ]}
        popupView?.config.bgColor = UIColor(white: 0, alpha: 0.6)
    }
}

extension WeChatLoginViewController: YTKChainRequestDelegate {
    func chainRequestFailed(_ chainRequest: YTKChainRequest, failedBaseRequest request: YTKBaseRequest) {
        if request is LoginRequest {
            WXProgressHUD.hiddenProgressHUD()
            self.showPopupAlert(msg: request.apiMessage())
            return
        }
        
        if request is UserInfoRequest {
            WXProgressHUD.hiddenProgressHUD()
            GlobalManager.manager.updateRefreshToken(refreshToken: nil)
            GlobalManager.manager.updateToken(token: nil)
            self.showPopupAlert(msg: request.apiMessage())
        }
    }
}
extension WeChatLoginViewController: WeChatCustomNavigationHeaderDelegate {
    func leftBarClick() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func rightBarClick() {
        
    }
    
    
}

extension WeChatLoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


enum LoginTye {
    case phone
    case other
}

