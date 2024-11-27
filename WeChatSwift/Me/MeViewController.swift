//
//  MeViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit


class MeViewController: ASDKViewController<ASDisplayNode> {

    private let backgroundNode = ASDisplayNode()
    
    private let tableNode: ASTableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [MeTableSection] = []
    
    private var headerNode: MeHeaderNode!
    
    private let storyTeachVC = StoryTakePhotoTeachViewController()
    
    override init() {
        super.init(node: ASDisplayNode())
        backgroundNode.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.addSubnode(backgroundNode)
        node.addSubnode(tableNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundNode.frame = CGRect(x: 0, y: 111 + Constants.statusBarHeight + Constants.topInset, width: view.bounds.width, height: view.bounds.height * 2)
        
        addChild(storyTeachVC)
        storyTeachVC.view.frame = CGRect(x: 0, y: -410, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(storyTeachVC.view)
        view.sendSubviewToBack(storyTeachVC.view)
        storyTeachVC.didMove(toParent: self)

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        headerNode = MeHeaderNode()
        headerNode.addTarget(self, action: #selector(clickHeaderAction), forControlEvents: .touchUpInside)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 111)
        headerView.addSubnode(headerNode)
        headerNode.frame = headerView.bounds
        tableNode.view.tableHeaderView = headerView
        
        setupDataSource()
        tableNode.reloadData()
        headerNode.reloadContent()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeaderView), name: ConstantKey.NSNotificationPersonToken, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var url = GlobalManager.headImageUrl(name: GlobalManager.manager.personModel?.head)
        headerNode.avatarNode.url = url
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func clickHeaderAction() {
        navigationController?.pushViewController(SettingMyProfileViewController(), animated: true)
    }
    @objc func updateHeaderView() {
        headerNode.reloadContent()
    }
    
    private func setupDataSource() {
        
        let pay = MeTableModel(type: .pay, title: "服务", icon: "icons_outlined_wechatpay")
        dataSource.append(MeTableSection(items: [pay]))
        
        let fav = MeTableModel(type: .favorites, title: "收藏", icon: "icons_outlined_colorful_favorites")
        let posts = MeTableModel(type: .posts, title: LocalizedString("Setting_MyAlbum"), icon: "icons_outlined_album", color: Colors.Indigo)
        let sticker = MeTableModel(type: .sticker, title: "表情", icon: "icons_outlined_sticker", color: Colors.Orange)
        dataSource.append(MeTableSection(items: [fav, posts, sticker]))
        
        let settings = MeTableModel(type: .settings, title: LocalizedString("Setting_Title"), icon: "icons_outlined_setting", color: Colors.Indigo)
        dataSource.append(MeTableSection(items: [settings]))
    
//        let debug = MeTableModel(type: .debug, title: "Debug", icon: "icons_debug", color: Colors.Orange)
//        dataSource.append(MeTableSection(items: [debug]))
    }
    
    override var wx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
}

// MARK: - Event Handlers
extension MeViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MeViewController: ASTableDelegate, ASTableDataSource {
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
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model.type {
        case .pay:
            let paymentMainVC = PaymentMainViewController()
            navigationController?.pushViewController(paymentMainVC, animated: true)
        case .favorites:
            let myFavoritesVC = MyFavoritesViewController()
//            navigationController?.pushViewController(myFavoritesVC, animated: true)
        case .settings:
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
        case .sticker:
            let emoticonStoreViewController = EmoticonStoreViewController()
//            navigationController?.pushViewController(emoticonStoreViewController, animated: true)
//        case .debug:
//            FLEXManager.shared.showExplorer()
        default:
            break
        }
    }
}

extension MeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //print(scrollView.contentOffset.y)
        
        backgroundNode.frame.origin.y = 111 - scrollView.contentOffset.y
    }
}
