//
//  ContactsViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactsViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [ContactSection] = []
    private var lettersArray: [String] = []
    private var searchViewController: UISearchController?
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.view.sectionIndexColor = UIColor(white: 0, alpha: 0.5)
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
        tableNode.view.backgroundColor = .clear
        
        setupDataSource()
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addfriends"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = LocalizedString("TabBar_ContactsTitle")
        // header
        setupSearchController()
        // footer
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        footerLabel.textColor = UIColor(white: 0, alpha: 0.5)
        footerLabel.font = UIFont.systemFont(ofSize: 17)
        footerLabel.text = String(format: "%d个朋友", dataSource.count)
        footerLabel.textAlignment = .center
        footerLabel.backgroundColor = .white
        tableNode.view.tableFooterView = footerLabel
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print(searchViewController?.searchBar.frame)
//        if let textField = findTextField() {
//            print(textField.frame)
//            let x = CGRectGetMinX(textField.frame)
//            let y = CGRectGetMinY(textField.frame)
//            let height = CGRectGetHeight(textField.frame)
//            textField.frame = CGRectMake(0, y, view.bounds.width, height)
//            textField.backgroundColor = .red
//            print(textField.layer.cornerRadius)
//            searchViewController?.searchBar.layoutIfNeeded()
//        }
//        tableNode.reloadData()
//    }
    func findTextField() -> UITextField! {
        if #available(iOS 13.0, *) {
            return searchViewController!.searchBar.searchTextField
        } else { // Fallback on earlier versions
            for subview in searchViewController!.searchBar.subviews.first?.subviews ?? [] {
                if let textField = subview as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
    
    private func setupDataSource() {
        let searchSection = ContactSection(title: "", models: [.newFriends, .groupChats, .tags, .officialAccounts])
        dataSource.append(searchSection)
        
        let users = MockFactory.shared.contacts()
        let groupingDict = Dictionary(grouping: users, by: { $0.letter })
        var contacts = groupingDict.map { return ContactSection(title: $0.key, models: $0.value.map { return ContactModel.contact($0) }) }
        contacts.sort(by: { $0.title < $1.title })
        lettersArray = contacts.map { $0.title.uppercased() }
        //往索引数组的开始处添加一个放大镜🔍 放大镜是系统定义好的一个常量字符串表示UITableViewIndexSearch 当然除了放大镜外也可以添加其他文字
        lettersArray.insert(UITableView.indexSearch, at:0)
        dataSource.append(contentsOf: contacts)
    }
    
}

// MARK: - Event Handlers
extension ContactsViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        return
        let controller = AddContactViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource

extension ContactsViewController: ASTableDelegate, ASTableDataSource {
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
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let contact = dataSource[indexPath.section].models[indexPath.row]
        switch contact {
        case .groupChats:
            let chatRoomListVC = ChatRoomListViewController()
            //            navigationController?.pushViewController(chatRoomListVC, animated: true)
        case .newFriends:
            let sayHelloVC = SayHelloViewController()
            //            navigationController?.pushViewController(sayHelloVC, animated: true)
        case .officialAccounts:
            let brandContactsVC = BrandContactsViewController()
            //            navigationController?.pushViewController(brandContactsVC, animated: true)
        case .tags:
            let contactTagListVC = ContactTagListViewController()
            //            navigationController?.pushViewController(contactTagListVC, animated: true)
        case .contact(let contact):
            let contactInfoVC = ContactInfoViewController(contact: contact)
            //            navigationController?.pushViewController(contactInfoVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 32.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let title = dataSource[section].title
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: 32))
        headerLabel.text = title.uppercased()
        headerLabel.textColor = UIColor(white: 0, alpha: 0.5)
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        let header = UIView()
        header.addSubview(headerLabel)
        header.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        lettersArray
    }
    //    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    //        index
    //    }
    
    private func setupSearchController() {
//        let searchBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
//        searchBarView.backgroundColor = .clear
//        let searchContentView = UIView(frame: CGRect(x: 8, y: 10, width: view.bounds.width - 16 , height: 36))
//        searchBarView.addSubview(searchContentView)
//        searchContentView.backgroundColor = .white
//        searchContentView.layer.cornerRadius = 4
//        let searchPlaceholder = UILabel()
//        searchPlaceholder.text = "搜索"
//        searchPlaceholder.textColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        searchViewController = UISearchController(searchResultsController: nil)
        searchViewController?.view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .defaultPrompt)
        searchViewController?.searchBar.placeholder = "搜索"
        searchViewController?.searchBar.barTintColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.tintColor = Colors.DEFAULT_LINK_COLOR
        searchViewController?.searchBar.isUserInteractionEnabled = false
        if let textField = searchViewController?.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white // 设置文本字段的背景视图为一个空的UIView，你可以设置它的背景色  设置文本字段的背景色为红色
        }
        
        tableNode.view.tableHeaderView = searchViewController?.searchBar
        tableNode.view.backgroundView = UIView()
        searchViewController?.searchBar.alignmentCenter()
        
        definesPresentationContext = true
        searchViewController?.definesPresentationContext = true
        
        tableNode.view.contentInsetAdjustmentBehavior = .automatic
        extendedLayoutIncludesOpaqueBars = false
        
        let directionalMargins = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: -8)
        searchViewController?.searchBar.directionalLayoutMargins = directionalMargins
    }
}

// MARK: - UISearchControllerDelegate

extension ContactsViewController: UISearchControllerDelegate {
    
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
