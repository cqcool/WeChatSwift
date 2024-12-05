//
//  SettingsViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class SettingsViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingsTableGroupModel] = []
    
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
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        navigationItem.title = LocalizedString("Setting_Title")
        setupDataSource()
        tableNode.reloadData()
    }
    
    private func setupDataSource() {
        let accountModel = SettingsTableModel(type: .accountAndSecurity, title: LocalizedString("Setting_AccountSectionTitle"))
        dataSource.append(SettingsTableGroupModel(models: [accountModel]))

        let teenagerModel = SettingsTableModel(type: .teenagers, title:"青少年模式")
        let careModel = SettingsTableModel(type: .care, title:"关怀模式")
        dataSource.append(SettingsTableGroupModel(models: [teenagerModel, careModel]))

        
        let messageModel = SettingsTableModel(type: .newMessageNotification, title: LocalizedString("Setting_NotificationSectionTitle"))
        let devicesModel = SettingsTableModel(type: .devices, title: "设备")
        let generalModel = SettingsTableModel(type: .general, title: LocalizedString("Setting_GeneralTitle"))
        dataSource.append(SettingsTableGroupModel(models: [messageModel, devicesModel, generalModel]))
        
        let friendModel = SettingsTableModel(type: .friend, title: "朋友权限")
        let personalModel = SettingsTableModel(type: .personal, title: "个人信息与权限")
        let personalCollectionModel = SettingsTableModel(type: .personalCollection, title: "个人信息收集清单")
        let thirdModel = SettingsTableModel(type: .third, title: "第三方信息共享清单")
        dataSource.append(SettingsTableGroupModel(models: [friendModel, personalModel, personalCollectionModel, thirdModel]))
        
        var pluginModel = SettingsTableModel(type: .plugins, title: LocalizedString("Wechat_Labs_Title"))
        pluginModel.value = "微信输入法可以【问AI】了"
        pluginModel.leftImage = UIImage(named: "plugin_icon")
        dataSource.append(SettingsTableGroupModel(models: [pluginModel]))
        
        let helpModel = SettingsTableModel(type: .helpAndFeedback, title: LocalizedString("Setting_QA"))
        var aboutModel = SettingsTableModel(type: .about, title: LocalizedString("Setting_Other_AboutMM"))
        aboutModel.value = "版本8.0.42"
        dataSource.append(SettingsTableGroupModel(models: [helpModel, aboutModel  ]))
        
        let switchAccountModel = SettingsTableModel(type: .switchAccount, title: LocalizedString("Login_LoginInfo_Mgr"))
        dataSource.append(SettingsTableGroupModel(models: [switchAccountModel]))
        
        let logoutModel = SettingsTableModel(type: .logout, title: LocalizedString("Setting_Quit_Title"))
        dataSource.append(SettingsTableGroupModel(models: [logoutModel]))
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingsViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].models[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].models.count - 1
        let block: ASCellNodeBlock = {
            return SettingsCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 :(section == 3 ? 40 : 8.0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let label = UILabel(frame: CGRectMake(16, 18, 50, 15))
            label.text = "隐私"
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor(hexString: "5D5D5D")
            let headerView = UIView()
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].models[indexPath.row]
        switch model.type {
        case .about:
            let aboutVC = AboutViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        case .logout:
            let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
            actionSheet.add(WXActionSheetItem(title: "退出登录", handler: { _ in
                let logoutRequest = LogoutRequest()
                logoutRequest.start(withNetworkingHUD: true, showFailureHUD: true) { _ in
                    GlobalManager.manager.logout()
                }
            }))
            actionSheet.add(WXActionSheetItem(title: "关闭微信", handler: { _ in
                
            }))
            actionSheet.show()
//        case .accountAndSecurity:
//            let myAccountInfoVC = SettingMyAccountInfoViewController()
//            navigationController?.pushViewController(myAccountInfoVC, animated: true)
//        case .newMessageNotification:
//            let notificationVC = SettingNotificationViewController()
//            navigationController?.pushViewController(notificationVC, animated: true)
//        
//        case .privacy:
//            let privacyVC = SettingPrivacyViewController()
//            navigationController?.pushViewController(privacyVC, animated: true)
//        case .general:
//            let generalVC = SettingGeneralViewController()
//            navigationController?.pushViewController(generalVC, animated: true)
//        case .plugins:
//            let labVC = SettingLabViewController()
//            navigationController?.pushViewController(labVC, animated: true)
        default:
            break
        }
    }
}
