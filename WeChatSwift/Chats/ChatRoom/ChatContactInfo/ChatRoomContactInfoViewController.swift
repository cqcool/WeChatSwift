//
//  ChatRoomContactInfoViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomContactInfoViewController: ASDKViewController<ASDisplayNode> {
    private let tableNode = ASTableNode(style: .grouped)
    private var dataSource: [ChatRoomContactInfoSection] = []
    private var members: [AddChatRoomMemberItem] = []
    private let contact: Contact
    private var isGroup: Bool = true
    
    
    init(contact: Contact) {
        self.contact = contact
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.dataSource = self
        tableNode.delegate = self
        setupDataSource()
        setupMembers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        navigationItem.title = isGroup ? "聊天信息(\(8))" : LocalizedString("MessageContent_Title")
        
    }
    
    private func setupDataSource() {
        if isGroup {
            
            dataSource.append(ChatRoomContactInfoSection(items:
                                                            [ChatRoomContactInfoModel(type: .addContactToChatRoom)]))
            
            dataSource.append(ChatRoomContactInfoSection(items:
                                                            [ChatRoomContactInfoModel(type: .groupName, value: "xxxx"),
                                                             ChatRoomContactInfoModel(type: .groupCode),
                                                             ChatRoomContactInfoModel(type: .groupNotice),
                                                             ChatRoomContactInfoModel(type: .remak)]))
            
            dataSource.append(ChatRoomContactInfoSection(items: [ChatRoomContactInfoModel(type: .searchChatHistory)]))
            
            dataSource.append(ChatRoomContactInfoSection(items: [
                ChatRoomContactInfoModel(type: .mute),
                ChatRoomContactInfoModel(type: .stickToTop),
                ChatRoomContactInfoModel(type: .addressBook)]))
            dataSource.append(ChatRoomContactInfoSection(items: [
                ChatRoomContactInfoModel(type: .inGroupName, value: "xxxx"),
                ChatRoomContactInfoModel(type: .showOtherName)]))
            dataSource.append(ChatRoomContactInfoSection(items: [
                ChatRoomContactInfoModel(type: .chatBackground),
                ChatRoomContactInfoModel(type: .clearChat),
                ChatRoomContactInfoModel(type: .report)]))
             
            dataSource.append(ChatRoomContactInfoSection(items: [
                ChatRoomContactInfoModel(type: .logout)]))

        } else {
            dataSource.append(ChatRoomContactInfoSection(items:
                                                            [ChatRoomContactInfoModel(type: .addContactToChatRoom)]))
            
            dataSource.append(ChatRoomContactInfoSection(items: [ChatRoomContactInfoModel(type: .searchChatHistory)]))
            dataSource.append(ChatRoomContactInfoSection(items: [
                ChatRoomContactInfoModel(type: .mute),
                ChatRoomContactInfoModel(type: .stickToTop),
                ChatRoomContactInfoModel(type: .forceNotify)]))
            
            dataSource.append(ChatRoomContactInfoSection(items: [ChatRoomContactInfoModel(type: .chatBackground)]))
            dataSource.append(ChatRoomContactInfoSection(items: [ChatRoomContactInfoModel(type: .clearChat)]))
            dataSource.append(ChatRoomContactInfoSection(items: [ ChatRoomContactInfoModel(type: .report)]))
        }
    }
    
    private func updateMembers(selectedContacts: [MultiSelectContact]) {
        let insert = selectedContacts.map { return AddChatRoomMemberItem.contact($0) }
        members.insert(contentsOf: insert, at: members.count - 1)
        tableNode.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
    }
    
    private func setupMembers() {
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.contact(contact))
        members.append(.addButton)
        members.append(.removeButton)
    }
    
    private func presentMultiSelectContacts() {
        let multiSelectContactsVC = MultiSelectContactsViewController()
        multiSelectContactsVC.selectionHandler = { [weak self] selectedContacts in
            self?.updateMembers(selectedContacts: selectedContacts)
        }
        let nav = UINavigationController(rootViewController: multiSelectContactsVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func viewContactInfo(_ contact: Contact) {
        let contactInfoVC = ContactInfoViewController(contact: contact)
        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ChatRoomContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let members = self.members
        let block: ASCellNodeBlock = { [weak self] in
            if model.type == .addContactToChatRoom {
                let addContactCell = ChatRoomAddContactCellNode(members: members)
                addContactCell.addButtonHandler = { [weak self] in
//                    self?.presentMultiSelectContacts()
                }
                addContactCell.contactTapHandlder = { [weak self] contact in
//                    self?.viewContactInfo(contact)
                }
                return addContactCell
            }
            else {
                return WCTableCellNode(model: model, isLastCell: isLastCell)
            }
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        var model = dataSource[indexPath.section].items[indexPath.row]
        if model.type == .groupName {
            let vc = ModifyRoomNameViewController()
            vc.name = model.value
            navigationController?.pushViewController(vc, animated: true)
            vc.confirmBlock = { text in
                model.value = ((text?.isEmpty) != nil) ? "未命名" : text
                self.dataSource[indexPath.section].items[indexPath.row] = model
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            }
        }
        return
//        switch model {
//        case .chatBackground:
//            let chatBackgroundVC = ChatRoomBackgroundEntranceViewController()
//            navigationController?.pushViewController(chatBackgroundVC, animated: true)
//        default:
//            break
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
//    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        let model = dataSource[indexPath.section].items[indexPath.row]
//        switch model {
//        case .addContactToChatRoom, .mute, .stickToTop, .forceNotify:
//            return false
//        default:
//            return true
//        }
//    }
    
}

struct ChatRoomContactInfoSection {
    var items: [ChatRoomContactInfoModel]
}

enum AddChatRoomMemberItem {
    case contact(Contact)
    case addButton
    case removeButton
}

struct ChatRoomContactInfoModel: WCTableCellModel {
    
    var type: ChatCellType
    var value: String?
    
    init(type: ChatCellType, value: String? = nil) {
        self.type = type
        self.value = value
    }
    var wc_title: String {
        switch type {
        case .addContactToChatRoom:
            return ""
        case .searchChatHistory:
            return LocalizedString("ChatRoomSetting_EditAndSearch")
        case .mute:
            return "消息免打扰"
        case .stickToTop:
            return LocalizedString("MessageContent_TopSession")
        case .forceNotify:
            return "提醒"
        case .chatBackground:
            return LocalizedString("MessageRoomContent_ChangeChatBackground")
        case .clearChat:
            return LocalizedString("ChatRoomSetting_ClearAll")
        case .report:
            return "投诉"
        case .groupName:
            return "群聊名称"
        case .groupCode:
            return "群二维码"
        case .groupNotice:
            return "群公告"
        case .groupManage:
            return "群管理"
        case .remak:
            return "备注"
        case .inGroupName:
            return "我在群里的昵称"
        case .showOtherName:
            return "显示群成员昵称"
        case .addressBook :
            return "显示群成员昵称"
        case .logout:
            return "退出群聊"
        default:
            return ""
        }
        
    }
    
    var wc_accessoryNode: ASDisplayNode? {
        if let value {
            let valueNode = ASTextNode()
            valueNode.attributedText = value.addAttributed(font: .systemFont(ofSize: 17), textColor: UIColor(white: 0, alpha: 0.7), lineSpacing: 0, wordSpacing: 0)
            return valueNode
        }
        if type == .groupCode {
            let iconNode = ASImageNode()
            iconNode.image = UIImage.SVGImage(named: "icons_outlined_qr-code")
            return iconNode
        }
        return nil
    }
    
    var wc_image: UIImage? {
        return nil
    }
    
    var wc_showSwitch: Bool {
        switch type {
        case .mute, .stickToTop, .forceNotify, .addressBook, .showOtherName:
            return true
        default:
            return false
        }
    }
    
    var wc_switchValue: Bool {
        switch type {
        case .mute:
            return false
        case .stickToTop:
            return false
        case .forceNotify:
            return false
        case .showOtherName:
            return true
        default:
            return false
        }
    }
    var wc_cellStyle: WCTableCellStyle {
        if type == .logout {
            return .destructiveButton
        }
        return .default
    }
}

enum ChatCellType {
    case addContactToChatRoom
    case searchChatHistory
    case mute
    case stickToTop
    case forceNotify
    case chatBackground
    case clearChat
    case report
    
    case remak
    case groupName
    case groupCode
    case groupNotice
    case groupManage
    case addressBook
    
    case inGroupName
    case showOtherName
    
    case logout
}
