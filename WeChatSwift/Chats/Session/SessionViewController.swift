//
//  SessionViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ZLPhotoBrowser
import SwiftyJSON

class SessionViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var menuFloatView: SessionMoreFrameFloatView?
    
    private var topSessions: [GroupEntity] = []
    
    private var dataSource: [GroupEntity] = []
    
    private var loadingView = LoadingCircle(circleWidth: 2, circleColor: .black)
    
    private var loadingContentView = UIView()
    
    private lazy var mainSearchViewController: MainSearchViewController = {
        return MainSearchViewController()
    }()
    
    private var searchViewController: UISearchController?
    private let dateFormatter = ChatRoomDateFormatter()
    
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.allowsMultipleSelectionDuringEditing = false
        tableNode.dataSource = self
        tableNode.delegate = self
        
        loadGroupData()
//        loadSessions()
        tableNode.reloadData()
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = "微信"
        
        setupSearchController()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTokenEvent), name: ConstantKey.NSNotificationRefreshToken, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(configUpdate), name: ConstantKey.NSNotificationConfigUpdate, object: nil)
        GlobalManager.manager.timingManager.addDelegate(delegate: self)
        GlobalManager.manager.timingManager.startLoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUnreadMsg()
    }
    
    @objc func refreshTokenEvent() {
        
    }
    @objc func configUpdate() {
        tableNode.reloadData()
    }
    
    private func loadSessions() {
        dataSource = MockFactory.shared.sessions()
//        let first = dataSource.removeFirst()
//        first.stickTop = true
//        topSessions.append(first)
    }
    
    private func showMoreMenu() {
        if menuFloatView == nil {
            let y = Constants.statusBarHeight + 44
            let frame = CGRect(x: 0, y: y, width: view.bounds.width, height: view.bounds.height - y)
            menuFloatView = SessionMoreFrameFloatView(frame: frame)
            menuFloatView?.delegate = self
        }
        menuFloatView?.show(in: self.view)
    }
    
    private func hideMoreMenu(animated: Bool = true) {
        menuFloatView?.hide(animated: animated)
    }
    
    private func setupSearchController() {
        
        searchViewController = UISearchController(searchResultsController: mainSearchViewController)
        searchViewController?.delegate = self
        searchViewController?.view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .defaultPrompt)
        searchViewController?.searchBar.placeholder = "搜索"
        searchViewController?.searchBar.barTintColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.tintColor = Colors.DEFAULT_LINK_COLOR
        searchViewController?.searchResultsUpdater = mainSearchViewController
        if let textField = searchViewController?.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white // 设置文本字段的背景视图为一个空的UIView，你可以设置它的背景色
//            textField.background?.backgroundColor = .red // 设置文本字段的背景色为红色
        }

        tableNode.view.tableHeaderView = searchViewController?.searchBar
        tableNode.view.backgroundView = UIView()
        
        mainSearchViewController.searchBar = searchViewController?.searchBar
        // 语音图标
        mainSearchViewController.searchBar?.setImage(UIImage(named: "Contact_Male_18x18_"), for: .bookmark, state: .normal)
        mainSearchViewController.searchBar?.alignmentCenter()
        
        definesPresentationContext = true
        searchViewController?.definesPresentationContext = true
        
        tableNode.view.contentInsetAdjustmentBehavior = .automatic
        extendedLayoutIncludesOpaqueBars = false
    }
}

// MARK: - Event Handlers
extension SessionViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        if self.menuFloatView?.superview != nil {
            hideMoreMenu()
            searchViewController?.searchBar.showsBookmarkButton = true
        } else {
            showMoreMenu()
            searchViewController?.searchBar.showsBookmarkButton = false
        }
    }
    
}

// MARK: - SessionMoreMenuViewDelegate
extension SessionViewController: SessionMoreMenuViewDelegate {
    
    func moreMenuView(_ menu: SessionMoreMenuView, didTap item: SessionMoreItem) {
        switch item.type {
        case .addFriends:
            let addFriendVC = AddContactViewController()
            navigationController?.pushViewController(addFriendVC, animated: true)
        case .scan:
            let cameraScanVC = CameraScanViewController()
            navigationController?.pushViewController(cameraScanVC, animated: true)
        case .money:
            let payVC = PayOfflinePayViewController()
            navigationController?.pushViewController(payVC, animated: true)
        case .groupChats:
            let multiSelectContactsVC = MultiSelectContactsViewController()
            multiSelectContactsVC.selectionHandler = { selectedContacts in
                
            }
            let nav = UINavigationController(rootViewController: multiSelectContactsVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
        hideMoreMenu(animated: false)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SessionViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topSessions.count
        }
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return SessionCellNode(session: session)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
//        if session.sessionID == Constants.BrandSessionName {
//            let brandTimelineVC = BrandTimelineViewController()
//            navigationController?.pushViewController(brandTimelineVC, animated: true)
//        } else {
        let chatVC = ChatRoomViewController(session: session)
            navigationController?.pushViewController(chatVC, animated: true)
        
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actions: [UITableViewRowAction] = []
//        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (_, _) in
//            
//        }
//        actions.append(deleteAction)
//        
//        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
//        if session.unreadCount > 0 {
//            let readAction = UITableViewRowAction(style: .normal, title: "标记为已读") { (_, _) in
//                
//            }
//            actions.append(readAction)
//        } else {
//            let unReadAction = UITableViewRowAction(style: .normal, title: "标记为未读") { (_, _) in
//                
//            }
//            actions.append(unReadAction)
//        }
        return actions
    }
}

// MARK: - UISearchControllerDelegate

extension SessionViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tabBarController?.tabBar.isHidden = true
//        searchController.searchBar.showsBookmarkButton = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tabBarController?.tabBar.isHidden = false
//        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.alignmentCenter()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        searchViewController?.searchResultsController?.view.isHidden = false
        searchController.searchBar.resetAlignment()
    }
}

extension SessionViewController: ChatDataDelegate {
    func willLoadAllChat() {
        navigationItem.title = nil
        loadingContentView.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        let label = DNKCreate.label(text: "加载中", textColor: Colors.DEFAULT_TEXT_COLOR, fontSize: 15)
        loadingContentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.loadingView.snp.right).offset(6)
        }
        wx_navigationBar.containerView.addSubview(loadingContentView)
        loadingContentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        wx_navigationBar.layoutIfNeeded()
        loadingView.start()
    }
    
    func didLoadAllChat(error: NSError?) {
        navigationItem.title = "微信"
        loadingView.stop()
        loadingContentView.isHidden = true
    }
    
    func updateGroupList(list: [GroupEntity]) {
        if list.count == 0 {
            return
        }
        for group in list.reversed() {
            if dataSource.contains(where: {$0.groupNo == group.groupNo}) {
                dataSource.removeAll {$0.groupNo == group.groupNo}
                dataSource.insert(group, at: 0)
            } else {
                dataSource.insert(group, at: 0)
            }
        }
        dataSource = dataSource.sorted(by: { $0.newAckMsgDate ?? 0 > $1.newAckMsgDate ?? 0})
        ChatRoomDateFormatter.groupFormatTime(groupList: dataSource)
        tableNode.reloadData()
    }
}

private extension SessionViewController {
    private func requestUnreadMsg() {
        let request = UnreadMsgRequest()
        request.startWithCompletionBlock { request in
            if let json = try? JSON(data: request.wxResponseData()) {
                if let unreadNum = json["unreadNum"].int {
                    if unreadNum > 0 {
                        self.tabBarController?.tabBar.showBadgOn()
                    } else {
                        self.tabBarController?.tabBar.hideBadg()
                    }
                }
            }
        }
    }
    
    func loadGroupData() {
        
    }
}
