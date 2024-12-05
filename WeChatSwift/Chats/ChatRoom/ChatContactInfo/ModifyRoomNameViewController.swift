//
//  ModifyRoomNameViewController.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/18.
//  Copyright © 2024 alexiscn. All rights reserved.
//


import AsyncDisplayKit

//登陆页面
class ModifyRoomNameViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var titleLabel: UILabel!
    var tipsLabel: UILabel!
    var iconView: UIImageView!
    var textField: UITextField!
    var confirmButton: UIButton!
     
    var group: GroupEntity!
    
    var confirmBlock: ((String?)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        view.addSubview(scrollView)
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        if group.name == nil {
            textField.placeholder = "未命名"
        } else {
            textField.text = group.name
        }
        
        textField.textDidChangeBlock = { text in
            if text == self.group.name {
                self.confirmButton.isEnabled = false
            } else {
                self.confirmButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 处理键盘将要显示的逻辑
        if let userInfo = notification.userInfo,
           let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            confirmButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(-intersection.height)
            }
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
            confirmButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-30)
            }
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func confirmAction() {
        let request = UpdateGroupRequest(groupNo: group.groupNo)
        let text = textField.text
        request.name = text ?? ""
        request.start(withNetworkingHUD: true, showFailureHUD: true) { [weak self] _ in
            self?.group.name = text
            if (self != nil) {
                GroupEntity.updateName(group: self!.group)
            }
            self?.confirmBlock?(text)
            NotificationCenter.default.post(name: ConstantKey.NSNotificationUpdateGroup, object: nil)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupViews() {
        scrollView.alwaysBounceVertical = true
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(view.bounds.height - Constants.statusBarHeight - 44 - Constants.bottomInset)
        }
        titleLabel = WXCreate.label(text: "修改群聊名称", textColor: .black, fontSize: 22, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(35)
        }
        tipsLabel = WXCreate.label(text: "修改群聊名称后，将在群内通知其他成员。", textColor: .black, fontSize: 17)
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        let spacing = 30
        let line1 = UIView()
        contentView.addSubview(line1)
        line1.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        line1.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(35)
            make.left.equalTo(spacing)
            make.right.equalTo(-spacing)
            make.height.equalTo(0.5)
        }
        
        iconView = WXCreate.imageView(normalName: "login_defaultAvatar")
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(6)
            make.left.equalTo(spacing)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        let line2 = UIView()
        contentView.addSubview(line2)
        line2.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        line2.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(6)
            make.left.equalTo(spacing)
            make.right.equalTo(-spacing)
            make.height.equalTo(0.5)
        }
        
        textField = UITextField()
        contentView.addSubview(textField)
        textField.clearButtonMode = .whileEditing
        textField.textLength = 16
        textField.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom)
            make.bottom.equalTo(line2.snp.top)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalTo(-spacing - 10)
        }
        
        confirmButton = WXCreate.button(normalTitle: "确定", normalColor: .white)
        contentView.addSubview(confirmButton)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17)
        confirmButton.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .disabled)
        confirmButton.setBackgroundImage(UIImage(color: UIColor(white: 0.8, alpha: 0.2)), for: .disabled)
        confirmButton.setBackgroundImage(UIImage(color: Colors.Green_standrad), for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 186, height: 50))
            make.bottom.equalToSuperview().offset(-Constants.bottomInset - 30)
        }
        
    }
}


