
//
//  AccountLoginUsersViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import SnapKit
import WXActionSheet

//登陆页面
class AccountLoginUsersViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    var avatarView = UIImageView()
    var accountTextField: UITextField!
    var phoneLabel: UILabel!
    var smsBtn: UIButton!
    var continueBtn: UIButton!
    var btmVerticalStack = UIStackView()
     
    
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
        
        layoutContentView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        formatePhoneNumber(number: GlobalManager.manager.personModel?.account as? NSString)
        avatarView.pin_setPlaceholder(with: UIImage(named: "login_defaultAvatar"))
        let headUrl = GlobalManager.headImageUrl(name: GlobalManager.manager.personModel?.head)
        if headUrl != nil {
            avatarView.pin_setImage(from: headUrl)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(popupAlertView(_:)), name: NSNotification.Name("showAlertViewOnLoginUI"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loginAction() {
        view.endEditing(true)
        
//        let popupView = JFPopupView.popup.alert {[
//            .subTitle("帐号或密码错误，请重新填写。"),
//            .subTitleColor(.black),
//            .showCancel(false),
//            .withoutAnimation(true),
//            .confirmAction([
//                .text("确定"),
//                .textColor(UIColor(hexString: "576B95")),
//                .tapActionCallback({
//                })
//            ])
//        ]}
//        popupView?.config.bgColor = UIColor(white: 0, alpha: 0.6)
    }
     
    @objc func popupAlertView(_ notification: Notification) {
        if let msg = notification.userInfo?["msg"] as? String {
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
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
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
     
    @objc func moreAction() {
        view.endEditing(true)
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "登录其他账号", handler: { _ in
            let vc = WeChatLoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        actionSheet.add(WXActionSheetItem(title: "前往安全中心", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "反馈问题", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "注册", handler: { _ in
            
        }))
        
        actionSheet.show()
    }
    @objc func smsLoginAction() {
        view.endEditing(true)
    }
    
    func formatePhoneNumber(number: NSString?) {
        if number == nil {
            phoneLabel.text = " "
            return
        }
        var strs: [NSString] = ["+86"]
        strs.append(number!.substring(with: NSMakeRange(0, 3)) as NSString)
        strs.append(number!.substring(with: NSMakeRange(3, 4)) as NSString)
        strs.append(number!.substring(with: NSMakeRange(7, 4)) as NSString)
        phoneLabel.text = (strs as NSArray).componentsJoined(by: " ")
    }
    private func layoutContentView() {
          
        avatarView.layer.cornerRadius = 6
        avatarView.layer.masksToBounds = true
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 65, height: 65))
            make.top.equalToSuperview().offset(Constants.statusBarHeight + 44 + 10)
            make.centerX.equalToSuperview()
        }
        phoneLabel = DNKCreate.label(text: "+86 xxx xxxx xxxx", textColor: .black, fontSize: 21, weight: .medium)
        contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let pswView = UIView()
        contentView.addSubview(pswView)
        pswView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(phoneLabel.snp.bottom).offset(48)
        }
        createPswView(pswView)
        btmVerticalStack.axis = .vertical
        btmVerticalStack.alignment = .center
        contentView.addSubview(btmVerticalStack)
        btmVerticalStack.snp.makeConstraints { make in
            make.bottom.equalTo( -10)
            make.left.right.equalToSuperview()
        }
        
        continueBtn = DNKCreate.button(normalTitle: "登录", normalColor: .white)
        continueBtn.titleLabel?.font = .systemFont(ofSize: 16)
        continueBtn.backgroundColor = UIColor(hexString: "07C160")
        continueBtn.layer.cornerRadius = 8
        continueBtn.constant(width: 185)
        continueBtn.constant(height: 50)
        continueBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
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
        let findBtn = DNKCreate.button(normalTitle: "找回密码", normalColor: UIColor(hexString: "566B94"), fontSize: 14, weight: .medium)
        
        let btmLine1 = DNKCreate.lineView(nil)
        btmLine1.constant(width: 0.5)
        btmLine1.constant(height: 10)
        btmLine1.backgroundColor = UIColor(hexString: "ADADAD")
        btmLine1.setContentHuggingPriority(.required, for: .horizontal)
        let freezeBtn = DNKCreate.button(normalTitle: "紧急冻结", normalColor: UIColor(hexString: "566B94"), fontSize: 14, weight: .medium)
        
        let btmLine = DNKCreate.lineView(nil)
        btmLine.constant(width: 0.5)
        btmLine.constant(height: 10)
        btmLine.backgroundColor = UIColor(hexString: "ADADAD")
        btmLine.setContentHuggingPriority(.required, for: .horizontal)
        let moreBtn = DNKCreate.button(normalTitle: "更多选项", normalColor: UIColor(hexString: "566B94"), fontSize: 14, weight: .medium)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        horizontalStack.addArrangedSubview(findBtn)
        horizontalStack.addArrangedSubview(btmLine1)
        horizontalStack.addArrangedSubview(freezeBtn)
        horizontalStack.addArrangedSubview(btmLine)
        horizontalStack.addArrangedSubview(moreBtn)
    }
    
    private func createPswView(_ phoneView: UIView) {
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
            make.height.equalTo(56)
        }
        let pswTitleLabel = DNKCreate.label(text: "密码", textColor: .black, fontSize: 17)
        oneView.addSubview(pswTitleLabel)
        pswTitleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        accountTextField = UITextField()
        oneView.addSubview(accountTextField)
        accountTextField.clearButtonMode = .whileEditing
        accountTextField.placeholder = "请填写微信密码"
        accountTextField.keyboardType = .numberPad
        accountTextField.snp.makeConstraints { make in
            make.left.equalTo(pswTitleLabel.snp.right).offset(10)
            make.top.right.bottom.equalToSuperview()
        }
        
        let twoLineView = UIView()
        phoneView.addSubview(twoLineView)
        twoLineView.backgroundColor = UIColor(hexString: "E5E5E5")
        twoLineView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        smsBtn = DNKCreate.button(normalTitle: "用短信验证码登录", normalColor: UIColor(hexString: "576B95"))
        smsBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        smsBtn.addTarget(self, action: #selector(smsLoginAction), for: .touchUpInside)
        phoneView.addSubview(smsBtn)
        smsBtn.snp.makeConstraints { make in
            make.top.equalTo(twoLineView.snp.bottom).offset(13)
            make.left.bottom.equalToSuperview()
        }
    }
}

extension AccountLoginUsersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
  

