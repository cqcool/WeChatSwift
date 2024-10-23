//
//  ModifyNameViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/15.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import UIKit
import SnapKit

//登陆页面
class ModifyNameViewController: UIViewController {
    var navigationView: WeChatCustomNavigationHeaderView!
    let scrollView = UIScrollView()
    let contentView = UIView()
    var textField: UITextField!
    var name: String?
    var confirmBlock: ((_ name: String) -> Void)?
    
    override func viewDidLoad() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationView = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0, Constants.screenWidth, Constants.statusBarHeight+52), backImage: nil, backTitle: "取消", centerLabel: "设置名字", rightButtonText: "完成", rightButtonImage: nil, backgroundColor: .clear, leftLabelColor: .black, rightLabelColor: .white)
        navigationView.bottomPadding = 7
        navigationView.topPadding = 7
        navigationView.centerLabelTextColor = .black
        navigationView.rightWidth = 53
        navigationView.rightBtn.layer.cornerRadius = 6
        navigationView.rightBtn.layer.masksToBounds = true
        navigationView.rightBtn.isEnabled = false
        navigationView.rightBtn.titleLabel?.font = UIFont(name: navigationView.fontName, size: 14)
        navigationView.rightBtn.setTitleColor(UIColor(white: 1, alpha:1), for: .normal)
        navigationView.rightBtn.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .disabled)
        navigationView.delegate = self
        navigationView.rightBtn.isEnabled = false
        view.addSubview(navigationView)
        
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom )
        }
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(view.bounds.height - Constants.statusBarHeight - 44)
        }
       
        
        layoutContentView()
        updateFinishView()
        textField.textDidChangeBlock = {
            guard let text = $0 else {
                self.navigationView.rightBtn.isEnabled = false
                self.updateFinishView()
                return
            }
            if text.isEmpty ||
                (self.name ?? "") == text {
                self.navigationView.rightBtn.isEnabled = false
            } else {
                self.navigationView.rightBtn.isEnabled = true
            }
            self.updateFinishView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
     
    private func layoutContentView() {
        let phoneView = UIView()
        contentView.addSubview(phoneView)
        phoneView.backgroundColor = .white
        phoneView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(60)
        }
        textField = UITextField()
        phoneView.addSubview(textField)
        textField.clearButtonMode = .whileEditing
        textField.textLength = 16
        textField.text = name
        textField.textColor = .black
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
       
    }
    private func updateFinishView() {
        let isEnabled = navigationView.rightBtn.isEnabled
        navigationView.rightBtn.backgroundColor = isEnabled ? UIColor(hexString: "07C160") : UIColor(hexString: "E1E0E0")
    }
     
}

extension ModifyNameViewController: WeChatCustomNavigationHeaderDelegate {
    func leftBarClick() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func rightBarClick() {
        view.endEditing(true)
        guard let name = textField.text else {
            return
        }
        let request = updateInfoRequest(nickname: name)
        request.start(withNetworkingHUD: true, showFailureHUD: true) { request in
            
            let personModel = PersonModel.getPerson()
            personModel?.updateNickName(nameText: name) 
            NotificationCenter.default.post(name: ConstantKey.NSNotificationPersonToken, object: nil)
            if let confirmBlock = self.confirmBlock {
               confirmBlock(name)
            }
            self.dismiss(animated: true)
        }
    }
}
 
