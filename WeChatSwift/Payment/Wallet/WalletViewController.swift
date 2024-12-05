//
//  WalletViewController.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/8.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class WalletViewController: ASDKViewController<ASDisplayNode> {
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [WalletSection] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "钱包"
        let rightButtonItem = UIBarButtonItem(title: "账单", style: .plain, target: nil, action: nil)
//        rightButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightButtonItem
        setupDataSource()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomSafeAreaHeight = window?.safeAreaInsets.bottom ?? 10
        let remainingHeight = WXDevice.screenHeight() - (wx_navigationBar.frame.height + 56*6 + 2*10 + bottomSafeAreaHeight)
        let footerView = UIView(frame: CGRectMake(0, 0, view.bounds.width, remainingHeight))
        footerView.backgroundColor = .clear
        let footerLabel = UILabel(frame: CGRect(x: 0, y: remainingHeight - 20, width: view.bounds.width, height: 20))
        footerLabel.textAlignment = .center
        footerLabel.attributedText = attributedText()
        footerView.addSubview(footerLabel)
        tableNode.view.tableFooterView = footerView
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            var section = self.dataSource.first
//            var smallChange = section?.items.first
//            smallChange?.value = "¥90.00"
//            section?.items[0] = smallChange!
//            self.dataSource[0] = section!
//            self.tableNode.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.fade)
//        }
    }
    func attributedText() -> NSAttributedString {
        let text = "身份信息  |  支付设置"
        let attribute = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "5A6A92"),
        ])
        if let range = text.range(of: "|") {
            let nsRange = NSRange(range, in: text)
            attribute.setAttributes([.foregroundColor: UIColor(hexString: "D4D5D4")], range: nsRange)
        }
        return attribute
    }
    private func setupDataSource() {
        let balance = GlobalManager.manager.personModel?.balance ?? "0.00"
        var smallChange = WalletModel(type: .smallChange, title: "零钱", icon: "icons_outlined_balance")
        smallChange.value = "¥" + balance
        var  changePass = WalletModel(type: .changePass, title: "零钱通", icon: "icons_outlined_o")
//        changePass.value = "¥0.00"
        let changeRate = GlobalManager.manager.personModel?.changeRate ?? (GlobalManager.manager.change_rate ?? "0.00%")
        changePass.additionalContent = "收益率\(changeRate)"
        let bankCard = WalletModel(type: .bankCard, title: "银行卡", icon: "icons_outlined_brank")
        let relativeCard = WalletModel(type: .relativeCard, title: "亲属卡", icon: "icons_outlined_relate")
        dataSource.append(WalletSection(items: [smallChange, changePass, bankCard, relativeCard]))
//        var shareInPayment = WalletModel(type: .shareInPayment, title: "分付", icon: "icons_outlined_minute")
//        shareInPayment.additionalContent = "按日计息，随借随还"
//        dataSource.append(WalletSection(items: [shareInPayment]))
//        let digitalRMB = WalletModel(type: .digitalRMB, title: "数字人民币", icon: "icons_outlined_wechatpay")
//        dataSource.append(WalletSection(items: [digitalRMB]))
        let pointsOfPayment = WalletModel(type: .pointsOfPayment, title: "支付分", icon: "icons_outlined_minute")
        dataSource.append(WalletSection(items: [pointsOfPayment]))
        let consumerProtection = WalletModel(type: .consumerProtection, title: "消费者保护", icon: "icons_outlined_protect")
        dataSource.append(WalletSection(items: [consumerProtection]))
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension WalletViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            let cell = WalletCellNode(model: model, isLastCell: isLastCell)
            cell.selectionStyle = .blue
            return cell
        }
        return block
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
        
    }
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model.type {
        case .smallChange:
            navigationController?.pushViewController(SmallChangeViewController(), animated: true)
        default:
            break
        }
    }
}

struct WalletSection {
    var items: [WalletModel]
}
struct WalletModel {
    var type: WalletType
    var image: UIImage?
    var title: String
    var value: String?
    var additionalContent: String?
//    var unread: Bool = false
//    var unreadCount: Int = 0
    
    init(type: WalletType, title: String, icon: String, color: UIColor? = nil, additionalContent: String? = nil) {
        self.type = type
        self.title = title
        self.image = UIImage(named: icon)
        self.additionalContent = additionalContent
//        self.unread = false
//        self.unreadCount = 0
    }
    mutating func setValue(value: String?) {
        self.value = value
    }
    mutating func setAdditionalContent(value: String?) {
        self.additionalContent = value
    }
    func wx_attributedStringForAdditional() -> NSAttributedString? {
        guard let value = additionalContent else { return nil }
        return NSAttributedString(string: value, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: Colors.Orange_100
            ])
    }
    func attributedStringForValue() -> NSAttributedString? {
        guard let value = value else { return nil }
        let unit = "¥"
        let mutableAttribtue = NSMutableAttributedString(string: value, attributes: [
            .font: Fonts.font(.superScriptMedium, fontSize: 17)!,
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
            ])
        if let range = value.range(of: unit) {
            let nsRange = NSRange(range, in: value)
            mutableAttribtue.addAttribute(.font, value:  UIFont.systemFont(ofSize: 17, weight: .medium), range: nsRange)
        }
        return mutableAttribtue
    }
}
extension WalletModel: WXTableCellModel {
    
    var wx_image: UIImage? { return image }
    
    var wx_title: String { return title }
}

enum WalletType {
    case smallChange
    case changePass
    case bankCard
    case relativeCard
    case shareInPayment
    case digitalRMB
    case pointsOfPayment
    case consumerProtection
}
