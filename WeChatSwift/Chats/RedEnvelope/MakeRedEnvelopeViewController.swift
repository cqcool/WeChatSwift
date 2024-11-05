//
//  MakeRedEnvelopeViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet
import KeenKeyboard

enum RedPacketError: String {
    case beyond200 = "单个红包金额不可超过200元"
    case greaterThan0 = "未填写「总金额」"
    case beyondPersons = "红包个数不可超过当前群聊人数"
    case normal = "success"
    
}

enum RedAlertType: String {
    case inspect = "为保障资金安全，本次交易需确认 为账户实名人本人操作。请点击“核验身份”以继续交易。"
    case violation = "当前交易涉嫌违规，暂无法完成支 付，请注意合法使用支付账户，否 则将升级限制措施。如有疑问，可点击“了解详情”查看说明。"
    case pswError = "支付密码错误，请重试"
    case confirmPhone = ""
    
}

class MakeRedEnvelopeViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private let errorTextNode: ASTextNode
    private let errorNode: ASDisplayNode
    
    private let enterCountNode: MakeRedEnvelopeEnterCountNode
    private let enterMoneyNode: MakeRedEnvelopeEnterMoneyNode
    private let enterDescNode: MakeRedEnvelopeEnterDescNode
    private let enterCoverNode: MakeRedEnvelopeEnterCoverNode
    
    private let moneyTextNode: ASTextNode
    
    private let redEnvelopeButton: ASButtonNode
    private let tipsTextNode: ASTextNode
    
    private var isShowErrorTips = false
    private var popupView:JFPopupView?
    private var payView: UIView?
    private var backView: UIView?
    //    private var pswTextField: UITextField?
    private var codeUnit: KeenCodeUnit!
    /// 1: 支付密码键盘， 2: 数量 3: 金额
    private var keyboardType: Int = 2
    
    var numberOfPerson: Int = 0
    var redPackeyMoney: String? = ""
    var moneyLabel: UILabel?
    var payTFHeight: CGFloat = 44
    var payTFWidth: CGFloat = 40
    var session: GroupEntity! = nil
    private var keyboard: KeenKeyboard?
    var style: KeenKeyboardAtrributes.Style = .number
    
    private var keyboardHeight: CGFloat = 216 + .safeAreaBottomHeight
    private var payViewHeight: CGFloat = 360
    
    var sendRedPacketBlock: ((_ messageEntnity: MessageEntity) ->())?
    
    override init() {
        
        errorNode = ASDisplayNode()
        errorNode.backgroundColor = UIColor(hexString: "EBCD9A")
        errorNode.frame = CGRect(x: 0, y: -35.0, width: Constants.screenWidth, height: 35)
        errorTextNode = ASTextNode()
        errorTextNode.frame = CGRectMake(0, 9, Constants.screenWidth, 16)
        errorNode.addSubnode(errorTextNode)
        
        enterCountNode = MakeRedEnvelopeEnterCountNode()
        enterCountNode.frame = CGRect(x: 24.0, y: 4, width: Constants.screenWidth - 48, height: 140)
        
        enterMoneyNode = MakeRedEnvelopeEnterMoneyNode()
        enterMoneyNode.frame = CGRect(x: 24.0, y:CGRectGetMaxY(enterCountNode.frame), width: Constants.screenWidth - 48, height: 56.0)
        
        
        enterDescNode = MakeRedEnvelopeEnterDescNode()
        enterDescNode.frame = CGRect(x: 24.0, y: CGRectGetMaxY(enterMoneyNode.frame)+17, width: Constants.screenWidth - 48.0, height: 64.0)
        
        enterCoverNode = MakeRedEnvelopeEnterCoverNode()
        enterCoverNode.frame = CGRect(x: 24.0, y: CGRectGetMaxY(enterDescNode.frame)+17, width: Constants.screenWidth - 48.0, height: 64.0)
        
        moneyTextNode = ASTextNode()
        moneyTextNode.frame = CGRect(x: 0, y: CGRectGetMaxY(enterCoverNode.frame) + 60, width: Constants.screenWidth, height: 56)
        
        redEnvelopeButton = ASButtonNode()
        redEnvelopeButton.isUserInteractionEnabled = true
        redEnvelopeButton.frame = CGRect(x: (Constants.screenWidth - 184.0)/2.0, y: CGRectGetMaxY(moneyTextNode.frame) + 30, width: 184.0, height: 48.0)
        redEnvelopeButton.setAttributedTitle(NSAttributedString(string: "塞钱进红包", attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]), for: .normal)
        let normalBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#EA5F39"), traitCollection: ASPrimitiveTraitCollectionMakeDefault())
        let highlightBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#D6522E"), traitCollection: ASPrimitiveTraitCollectionMakeDefault())
        let disableBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#E9C0B6"), traitCollection: ASPrimitiveTraitCollectionMakeDefault())
        
        redEnvelopeButton.setBackgroundImage(normalBackground, for: .normal)
        redEnvelopeButton.setBackgroundImage(highlightBackground, for: .highlighted)
        redEnvelopeButton.setBackgroundImage(disableBackground, for: .disabled)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let navigationHeight = Constants.statusBarHeight + 44
        tipsTextNode = ASTextNode()
        tipsTextNode.frame = CGRect(x: 0, y: Constants.screenHeight - navigationHeight - Constants.bottomInset-37, width: Constants.screenWidth, height: 17)
        tipsTextNode.attributedText = NSAttributedString(string: "可直接使用收到的零钱发红包", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "5D5F5D"),
            .paragraphStyle: paragraphStyle
        ])
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        node.addSubnode(errorNode)
        
        tableNode.addSubnode(enterCountNode)
        tableNode.addSubnode(enterMoneyNode)
        tableNode.addSubnode(enterDescNode)
        tableNode.addSubnode(enterCoverNode)
        tableNode.addSubnode(moneyTextNode)
        tableNode.addSubnode(redEnvelopeButton)
        tableNode.addSubnode(tipsTextNode)
        
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "发红包"
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "close_trusted_friend_tips_hl"), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        

        numberOfPerson = Int(exactly: session.userNum ?? 0)!
        redEnvelopeButton.addTarget(self, action: #selector(sendRedPacket), forControlEvents: .touchUpInside)
        enterCountNode.updateNumberOfPersons(count: numberOfPerson)
        enterCountNode.countKeyboardBlock = {
            if self.keyboardType == 1{
                self.keyboard = nil
            }
            self.keyboardType = 2
            self.style = .number
            self.enterCountNode.countTextField.bindCustomKeyboard(delegate: self)
//            if self.keyboard == nil {
////                self.enterMoneyNode.moneyField.bindCustomKeyboard(delegate: self)
//            }
            if (self.keyboard != nil) {
                self.keyboard?.reloadKeyboardStyle(style: self.style)
            }
        }
        enterCountNode.countChangeBlock = { count in
            self.checkRedPacket()
        }
        enterCountNode.randomChangeBlock = {
            self.view.endEditing(true)
            let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
            actionSheet.add(WXActionSheetItem(title: "拼手气红包", handler: { _ in
                
            }))
            actionSheet.add(WXActionSheetItem(title: "普通红包", handler: { _ in
                
            }))
            actionSheet.add(WXActionSheetItem(title: "专属红包", handler: { _ in
                
            }))
            actionSheet.titleView = nil
            actionSheet.show()
        }
        
        enterMoneyNode.moneyChangeBlock = { money in
            self.checkRedPacket()
            self.moneyAttribute(money: money ?? "0.00")
        }
        enterMoneyNode.countKeyboardBlock = {
            if self.keyboardType == 1 {
                self.keyboard = nil
            }
            self.keyboardType = 3
            self.style = .decimal
//            if self.keyboard == nil {
////                self.enterCountNode.countTextField.bindCustomKeyboard(delegate: self)
//            }
            self.enterMoneyNode.moneyField.bindCustomKeyboard(delegate: self)
            if (self.keyboard != nil) {
                self.keyboard?.reloadKeyboardStyle(style: self.style)
            }
        }
        
        moneyAttribute(money: "0.00")
        
        buildPayView()
    }
    private func checkRedPacket() {
        var type = validateRedMoeny(checkZero: false)
        enterMoneyNode.updateContent(type: type)
        if type != .normal {
            showError(type: type)
            return
        }
        type = validateNumberOfPerson()
        enterCountNode.updateContent(type: type)
        if type != .normal {
            showError(type: type)
            return
        }
        hideError()
    }
    private func validateRedMoeny(checkZero: Bool) -> RedPacketError {
        guard let money = enterMoneyNode.money,
              !money.isEmpty else {
            return .normal
        }
        let moneyFloat = (money as NSString).floatValue
        if moneyFloat > 200.0 {
            return .beyond200
        }
        if moneyFloat == 0.0 && checkZero {
            return .greaterThan0
        }
        return .normal
    }
    
    private func validateNumberOfPerson() -> RedPacketError {
        guard let count = enterCountNode.count else {
            return .normal
        }
        let countFloat = (count as NSString).intValue
        if countFloat > numberOfPerson {
            return .beyondPersons
        }
        return .normal
    }
    // 1: ，2: 红包个数超出
    private func showError(type: RedPacketError) {
        let alignmentStyle = NSMutableParagraphStyle()
        alignmentStyle.alignment = .center
        let attributedText = NSAttributedString(string: type.rawValue, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#EA5F39"),
            .paragraphStyle: alignmentStyle
        ])
        errorTextNode.attributedText = attributedText
        if isShowErrorTips {
            return
        }
        let barY = CGRectGetMaxY(wx_navigationBar.frame)
        isShowErrorTips = true
        var rect = self.errorNode.frame
        rect.origin.y = barY
        var tableRect = tableNode.frame
        tableRect.origin.y = barY + 35
        UIView.animate(withDuration: 0.25) {
            self.errorNode.frame = rect
            self.tableNode.frame = tableRect
        }
    }
    
    private func hideError() {
        if !isShowErrorTips {
            return
        }
        isShowErrorTips = false
        var rect = self.errorNode.frame
        rect.origin.y = -35.0
        var tableRect = tableNode.frame
        tableRect.origin.y = 0
        UIView.animate(withDuration: 0.25) {
            self.errorNode.frame = rect
            self.tableNode.frame = tableRect
        }
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
//        enterCountNode.resignFirstResponder()
//        enterCountNode.resignFirstResponder()
//        enterDescNode.resignFirstResponder()
//        enterMoneyNode.resignFirstResponder()
//        resignFirstResponder()
    }
    
    private func moneyAttribute(money: String) {
        let moneyFloat = (money as NSString).floatValue
        redPackeyMoney = String(format: "%.2f", moneyFloat)
        let text = "￥" + (redPackeyMoney ?? "0.00")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        moneyTextNode.attributedText = NSAttributedString(string: text, attributes: [
            .font: Fonts.font(.superScriptMedium, fontSize: 50)!,
            .foregroundColor: UIColor(hexString: "#303030"),
            .paragraphStyle: paragraphStyle
        ])
    }
    
    private func alertType(type: RedAlertType) {
        if type == .inspect {
            alert(type: type, cancel: "暂不核验", confirm: "核验身份")
            return
        }
        if type == .violation {
            alert(type: type, cancel: "关闭", confirm: "了解详情")
            return
        }
        if type == .confirmPhone {
            confirmPhone()
            return
        }
        if type == .pswError {
            alert(type: type, cancel: "忘记密码", confirm: "重试")
            return
        }
    }
    
    private func alert(type: RedAlertType, cancel: String, confirm: String) {
        let popupView = JFPopupView.popup.alert {[
            .subTitle(type.rawValue),
            .subTitleColor(.black),
            .showCancel(true),
            .withoutAnimation(true),
            .cancelAction([
                .text(cancel),
                .textColor(.black),
                .tapActionCallback({
                })
            ]),
            .confirmAction([
                .enable(false),
                .text(confirm),
                .textColor(UIColor(hexString: "576B95")),
                .tapActionCallback({
                })
            ]),
        ]}
        popupView?.config.bgColor = UIColor(white: 0, alpha: 0.6)
    }
    private func confirmPhone() {
        popupView = JFPopupView.popup.custom(with: JFPopupConfig.bottomSheet) { mainContainer in
            let card = UIView()
            card.backgroundColor = .white
            card.frame = CGRectMake(0, 0, Constants.screenWidth, Constants.bottomInset + 420)
            self.roundCorners(card: card, corners: [.topLeft, .topRight], radius: 8)
            
            let iconView = UIImageView(image: UIImage(named: "Card_Security_Icon"))
            card.addSubview(iconView)
            iconView.snp.makeConstraints { make in
                make.height.equalTo(45)
                make.width.equalTo(35)
                make.top.equalTo(55)
                make.centerX.equalToSuperview()
            }
            let titleLabele = DNKCreate.label(text:"手机号信息确认", textColor: .black, fontSize: 20, weight: .medium)
            card.addSubview(titleLabele)
            titleLabele.snp.makeConstraints { make in
                make.top.equalTo(iconView.snp.bottom).offset(35)
                make.centerX.equalToSuperview()
            }
            let tipsLabele = DNKCreate.label(text:"根据国家监管要求，请确认你曾在微信支付留存的手机号151******52当前是否为你本人使用。请在2024-09-17前处理，以正常使用微信支付。", textColor: UIColor(white: 0, alpha: 0.8), fontSize: 16, weight: .medium)
            card.addSubview(tipsLabele)
            tipsLabele.numberOfLines = -1
            tipsLabele.snp.makeConstraints { make in
                make.top.equalTo(titleLabele.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.left.equalTo(25)
                make.right.equalTo(-25)
            }
            let buttonWidth = 120.0
            let buttonHeight = 50.0
            let spacing = 15.0
            let localtion = (Constants.screenWidth - 2*buttonWidth - spacing) / 2
            let lateButton = DNKCreate.button(normalTitle: "稍后处理", normalColor: .black, fontSize: 16)
            card.addSubview(lateButton)
            lateButton.addTarget(self, action: #selector(self.lateButtonAction), for: UIControl.Event.touchUpInside)
            lateButton.layer.cornerRadius = 6
            lateButton.layer.masksToBounds = true
            lateButton.backgroundColor = UIColor(white: 0, alpha: 0.1)
            lateButton.snp.makeConstraints { make in
                make.height.equalTo(buttonHeight)
                make.width.equalTo(buttonWidth)
                make.top.equalTo(tipsLabele.snp.bottom).offset(50)
                make.left.equalToSuperview().offset(localtion)
            }
            let nowButton = DNKCreate.button(normalTitle: "立即处理", normalColor: .white, fontSize: 16)
            card.addSubview(nowButton)
            nowButton.backgroundColor = Colors.Green_standrad
            nowButton.layer.cornerRadius = 6
            nowButton.layer.masksToBounds = true
            nowButton.snp.makeConstraints { make in
                make.height.equalTo(buttonHeight)
                make.width.equalTo(buttonWidth)
                make.top.equalTo(lateButton.snp.top)
                make.left.equalTo(lateButton.snp.right).offset(spacing)
            }
            // 立即处理
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func buildPayView() {
        backView = UIView()
        backView?.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backView?.frame = CGRectMake(0, 0, Constants.screenWidth, Constants.screenHeight)
        backView?.isHidden = true
        node.view.addSubview(backView!)
        
        payView = UIView()
        node.view.addSubview(payView!)
        payView?.backgroundColor = .white
        payView?.frame = CGRectMake(0, Constants.screenHeight, Constants.screenWidth, payViewHeight + keyboardHeight)
        roundCorners(card: payView!, corners: [.topLeft, .topRight], radius: 8)
        
        let closeImgView = UIImageView(image: UIImage(named: "close_trusted_friend_tips_hl"))
        payView?.addSubview(closeImgView)
        closeImgView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        let closeButton = UIButton()
        payView?.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closePayView), for: .touchUpInside)
        closeButton.snp.makeConstraints { make in
            make.edges.equalTo(closeImgView).offset(8)
        }
        
        let payTitleLabel = DNKCreate.label(text: "微信红包", textColor: .black, fontSize: 20)
        payView?.addSubview(payTitleLabel)
        payTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        let moneyLabel = UILabel()
        payView?.addSubview(moneyLabel)
        moneyLabel.attributedText = ("¥" + "10.00").moneyUnitAttribute(textColor: .black, fontSize: 32, unitSize: 25)
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(payTitleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        //        pswTextField = UITextField()
        //        payView?.addSubview(pswTextField!)
        //        pswTextField?.snp.makeConstraints({ make in
        //            make.center.equalToSuperview()
        //        })
        
        
        let btmContentView = UIView()
        payView?.addSubview(btmContentView)
        btmContentView.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(27)
            make.left.bottom.right.equalToSuperview()
        }
        let offsetX = 25.0
        let lineView = UIView()
        btmContentView.addSubview(lineView)
        lineView.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.right.equalToSuperview().offset(-offsetX)
            make.height.equalTo(0.5)
            make.top.equalToSuperview()
        }
        
        let payWayLabel = DNKCreate.label(text: "付款方式", textColor: UIColor(white: 0, alpha: 0.6), fontSize: 15)
        btmContentView.addSubview(payWayLabel)
        payWayLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(25)
            make.left.equalTo(lineView.snp.left)
        }
        let arrowView = UIImageView()
        btmContentView.addSubview(arrowView)
        arrowView.image = UIImage(named: "AlbumPackDown_30x7_")
        arrowView.snp.makeConstraints { make in
            make.right.equalTo(lineView.snp.right)
            make.size.equalTo(CGSize(width: 18, height: 9))
            make.centerY.equalTo(payWayLabel.snp.centerY)
        }
        let changeLabel = DNKCreate.label(text: "更改", textColor: UIColor(white: 0, alpha: 0.6), fontSize: 15)
        btmContentView.addSubview(changeLabel)
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(payWayLabel.snp.top)
            make.right.equalTo(arrowView.snp.left).offset(-4)
            make.centerY.equalTo(payWayLabel.snp.centerY)
        }
        let wayView = UIView()
        btmContentView.addSubview(wayView)
        wayView.layer.cornerRadius = 6
        wayView.layer.masksToBounds = true
        wayView.backgroundColor = UIColor(hexString: "FEF9E5")
        wayView.snp.makeConstraints { make in
            make.top.equalTo(payWayLabel.snp.bottom).offset(10)
            make.left.right.equalTo(lineView)
            make.height.equalTo(50)
        }
        let balanceView = UIImageView()
        wayView.addSubview(balanceView)
        balanceView.image = UIImage(named: "WeChatOutAccountIcon")
        balanceView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        let balanceLabel = DNKCreate.label(text: "零钱", textColor: UIColor(white: 0, alpha: 0.8), fontSize: 17)
        wayView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        let selectView = UIImageView()
        wayView.addSubview(selectView)
        selectView.image = UIImage(named: "icon_selected")
        selectView.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
        let rect = CGRect(x: 0, y: payViewHeight-23-44, width: CGFloat.screenWidth, height: 44)
        
        codeUnit = KeenCodeUnit(
            frame: rect,
            delegate: self
        ).addViewTo(payView!)
    }
    func confirmPay() {
        popupView = JFPopupView.popup.custom(with: JFPopupConfig.bottomSheet) { mainContainer in
            let backView = UIView()
            backView.backgroundColor = .clear
            backView.frame = CGRectMake(0, 0, Constants.screenWidth, Constants.screenHeight)
            
            let card = UIView()
            card.backgroundColor = .white
            card.frame = CGRectMake(0, 350, Constants.screenWidth, 420)
            self.roundCorners(card: card, corners: [.topLeft, .topRight], radius: 8)
            
            //            let iconView = UIImageView(image: UIImage(named: "Card_Security_Icon"))
            //            card.addSubview(iconView)
            //            iconView.snp.makeConstraints { make in
            //                make.height.equalTo(45)
            //                make.width.equalTo(35)
            //                make.top.equalTo(55)
            //                make.centerX.equalToSuperview()
            //            }
            //            let titleLabele = DNKCreate.label(text:"手机号信息确认", textColor: .black, fontSize: 20, weight: .medium)
            //            card.addSubview(titleLabele)
            //            titleLabele.snp.makeConstraints { make in
            //                make.top.equalTo(iconView.snp.bottom).offset(35)
            //                make.centerX.equalToSuperview()
            //            }
            //            let tipsLabele = DNKCreate.label(text:"根据国家监管要求，请确认你曾在微信支付留存的手机号151******52当前是否为你本人使用。请在2024-09-17前处理，以正常使用微信支付。", textColor: UIColor(white: 0, alpha: 0.8), fontSize: 16, weight: .medium)
            //            card.addSubview(tipsLabele)
            //            tipsLabele.numberOfLines = -1
            //            tipsLabele.snp.makeConstraints { make in
            //                make.top.equalTo(titleLabele.snp.bottom).offset(20)
            //                make.centerX.equalToSuperview()
            //                make.left.equalTo(25)
            //                make.right.equalTo(-25)
            //            }
            //            let buttonWidth = 120.0
            //            let buttonHeight = 50.0
            //            let spacing = 15.0
            //            let localtion = (Constants.screenWidth - 2*buttonWidth - spacing) / 2
            //            let lateButton = DNKCreate.button(normalTitle: "稍后处理", normalColor: .black, fontSize: 16)
            //            card.addSubview(lateButton)
            //            lateButton.addTarget(self, action: #selector(self.lateButtonAction), for: UIControl.Event.touchUpInside)
            //            lateButton.layer.cornerRadius = 6
            //            lateButton.layer.masksToBounds = true
            //            lateButton.backgroundColor = UIColor(white: 0, alpha: 0.1)
            //            lateButton.snp.makeConstraints { make in
            //                make.height.equalTo(buttonHeight)
            //                make.width.equalTo(buttonWidth)
            //                make.top.equalTo(tipsLabele.snp.bottom).offset(50)
            //                make.left.equalToSuperview().offset(localtion)
            //            }
            //            let nowButton = DNKCreate.button(normalTitle: "立即处理", normalColor: .white, fontSize: 16)
            //            card.addSubview(nowButton)
            //            nowButton.backgroundColor = Colors.Green_standrad
            //            nowButton.layer.cornerRadius = 6
            //            nowButton.layer.masksToBounds = true
            //            nowButton.snp.makeConstraints { make in
            //                make.height.equalTo(buttonHeight)
            //                make.width.equalTo(buttonWidth)
            //                make.top.equalTo(lateButton.snp.top)
            //                make.left.equalTo(lateButton.snp.right).offset(spacing)
            //            }
            // 立即处理
            return backView
        }
        popupView?.config.bgColor = UIColor(white: 0, alpha: 0.6)
    }
}

// MARK: - Event Handlers
extension MakeRedEnvelopeViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleMoreButtonClicked() {
        dismissKeyboard()
        
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "红包记录", handler: { _ in
            self.navigationController?.pushViewController(ReceiveRedViewContrroler(), animated: true)
        }))
        actionSheet.add(WXActionSheetItem(title: "帮助中心", handler: { _ in
            self.navigationController?.pushViewController(HelpRedViewController(), animated: true)
        }))
        actionSheet.show()
    }
    
    @objc func sendRedPacket() {
        self.keyboard = nil
        dismissKeyboard()
        let type = validateRedMoeny(checkZero: true)
        if type != .normal {
            showError(type: type)
            return
        }
        moneyLabel?.attributedText = ("¥" + redPackeyMoney!).moneyUnitAttribute(textColor: .black, fontSize: 25)
        let request = RedPacketVerifyRequest(amount: redPackeyMoney!, groupNo: session.groupNo!, num: enterCountNode.count!, type: "1")
        request.start(withNetworkingHUD: true, showFailureHUD: true) { request in
            self.keyboardType = 1
            self.codeUnit.textFiled.bindCustomKeyboard(delegate: self)
            self.codeUnit.textFiled.becomeFirstResponder()
            var rect = self.payView!.frame
            rect.origin.y = Constants.screenHeight - self.payViewHeight - self.keyboardHeight
            UIView.animate(withDuration: 0.25) {
                self.backView?.isHidden = false
                self.payView?.frame = rect
            }
        } failure: { request in
            
        }

    }
    @objc func lateButtonAction() {
        popupView?.dismissPopupView(completion: { _ in
            
        })
    }
    
    @objc func closePayView() {
        node.view.endEditing(true)
        codeUnit.cleanContent()
        var rect = payView!.frame
        rect.origin.y = Constants.screenHeight
        UIView.animate(withDuration: 0.25) {
            self.backView?.isHidden = true
            self.payView?.frame = rect
        }
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MakeRedEnvelopeViewController: ASTableDelegate, ASTableDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        dismissKeyboard()
    }
    
}

extension MakeRedEnvelopeViewController: KeenKeyboardDelegate {
    func insert(_ keyboard: KeenKeyboard, text: String) {
        
    }
    
    func delete(_ keyboard: KeenKeyboard, text: String) {
        
    }
    
    func other(_ keyboard: KeenKeyboard, text: String) {
        if keyboardType == 1 {
            
        }
    }
    
    func attributesOfKeyboard(for keyboard: KeenKeyboard) -> KeenKeyboardAtrributes {
        self.keyboard = keyboard
        var attr = KeenKeyboardAtrributes()
        if keyboardType == 1 {
            attr.displayRandom = false
            attr.layout = .separator
            attr.style = .number
            attr.titleOfOther = nil
        }
        if keyboardType == 2 ||
            keyboardType == 3 {
            attr.keyboardStyle = .wechat
            attr.style = self.style
            attr.titleOfOther = "完成"
            attr.fontOfOther = .systemFont(ofSize: 20)
            attr.viewBackColor = UIColor.color(hexString: "#F6F6F5")
            attr.colorOfOther = .white
            attr.backColorOfOther = UIColor.color(hexString: "#FE6046")
        }
        return attr
    }
}

extension MakeRedEnvelopeViewController: KeenCodeUnitDelegate {
    
    func attributesOfCodeUnit(for codeUnit: KeenCodeUnit) -> KeenCodeUnitAttributes {
        var attr = KeenCodeUnitAttributes()
        attr.style = .splitborder
        attr.isSingleAlive = false
        attr.isSecureTextEntry = true
        attr.cursorHeightPercent = 0
        attr.lineColor = .clear
        attr.lineHighlightedColor = .clear
        attr.borderHighlightedColor = .clear
        attr.borderColor = .clear
        attr.cornerRadius = 8
        attr.viewBackColor = .clear
        attr.itemSpacing = 8
        attr.itemBackgroundColor = UIColor(hexString: "F2F2F2")
        attr.itemPadding = (Constants.screenWidth - (payTFWidth * CGFloat(attr.count)) - (CGFloat(attr.count - 1) * attr.itemSpacing)) / 2.0
        return attr
    }
    
    func codeUnit(_ codeUnit: KeenCodeUnit, codeText: String, complete: Bool) {
        if complete {
            let request = RedPacketPayRquest(amount: enterMoneyNode.money!, groupNo: session.groupNo!, num: enterCountNode.count!, payPassword: codeText.md5Encrpt().lowercased())
            request.start(withNetworkingHUD: true, showFailureHUD: true) { request in
                do {
                    let personModel = GlobalManager.manager.personModel
                    let resp = try JSONDecoder().decode(MessageEntity.self, from: request.wxResponseData())
                    resp.ownerId = personModel?.userId
                    MessageEntity.insertOrReplace(list: [resp])
                    self.sendRedPacketBlock?(resp)
                    self.dismiss(animated: true)
                }  catch {
                    print("Error decoding JSON: \(error)")
                }
            } failure: { _ in
                codeUnit.cleanContent()
            }
        }
    }
}
