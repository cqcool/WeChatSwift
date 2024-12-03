//
//  ChatRoomViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import WXActionSheet
import PINRemoteImage
import SwiftyJSON
import MJRefresh

enum ChatRoomStatus: Int {
    case normal = 0
    case dissolve = 1/// 解散
    case ban = 2 /// 被封
    case byRemove /// 被移出群聊
}

class ChatRoomViewController: ASDKViewController<ASDisplayNode> {
    
    private let session: GroupEntity
    
    private let dataSource: ChatRoomDataSource
    private var members: [MemberModel]?
    
    //    private let user: MockData.User
    
    private let inputNode = ChatRoomKeyboardNode()
    
    private let backgroundImageNode = ASImageNode()
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var roomStatus: ChatRoomStatus = .normal
    
    internal var menuMessage: Message?
    
    private let errorTextNode = ASTextNode()
    private let errorIconNode = ASImageNode()
    private let errorNode = ASDisplayNode()
    private let arrowNode = ASImageNode()
    
    private let notSendView = UIView()
    private let notSendContentView = UIView()
    private let notSendLabel = UILabel()
    private let notSendImageView = UIImageView(image: UIImage(named: "lqt_deposit_info_icon"))
    private let notSendLine = UIView()
    /// 默认还有历史数据
    private var hasHistory: Bool = true
    
    var updateGroupBlock:((_: GroupEntity) -> ())?
    
    private var isRequestRed = false
    
    init(session: GroupEntity) {
        self.session = session
        self.dataSource = ChatRoomDataSource(sessionID: session.groupNo!)
        //        self.user = MockFactory.shared.user(with: sessionID)!
        
        super.init(node: ASDisplayNode())
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundImageNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        node.addSubnode(backgroundImageNode)
        node.addSubnode(tableNode)
        node.addSubnode(inputNode)
        let textSize = 16.0
        let heightNode = 50.0
        errorNode.backgroundColor = UIColor(hexString: "FAEDED")
        errorNode.frame = CGRect(x: 0, y: Constants.navigationHeight, width: Constants.screenWidth, height: heightNode)
        errorTextNode.frame = CGRectMake(54, (heightNode - textSize) / 2 , Constants.screenWidth, textSize + 2.0)
        errorTextNode.attributedText = "本群涉嫩传播欺诈内容，已被停用。".addAttributed(font: .systemFont(ofSize: textSize), textColor: .black, lineSpacing: 0, wordSpacing: 0)
        errorNode.addSubnode(errorTextNode)
        errorIconNode.image = UIImage(named: "ExclamationMark")
        errorIconNode.frame = CGRect(x: 10, y: (heightNode - 30) / 2, width: 36, height: 36)
        errorNode.addSubnode(errorIconNode)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        let size: CGSize = arrowNode.image!.size
        arrowNode.frame = CGRect(x: Constants.screenWidth - 20 - size.width, y: (50.0 - size.height)/2, width: size.width, height: size.height)
        errorNode.addSubnode(arrowNode)
        errorNode.isHidden = true
        getGroupInfo()
    }
    
    deinit {
        print("chatRoom deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func wx_backButtonClicked() {
        super.wx_backButtonClicked()
        Socket.shared.delegate = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        loadGroupMessage()
        // 群聊
        if session.groupType == 2 {
            requestMembers(showHUD: false)
        } else {
            members = [session.toMember()]
        }
        Socket.shared.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
                // 监听屏幕熄灭
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterScreenOff), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appDidEnterBackground() {
        inputNode.dismissKeyboard()
    }
    @objc func appDidEnterScreenOff() {
        inputNode.dismissKeyboard()
    }
    
    private func updateChatRoomView(status: ChatRoomStatus) {
        switch status {
        case .ban:
            errorNode.isHidden = false
            inputNode.isHidden = true
            notSendView.isHidden = true
            tableNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight)
            navigationItem.rightBarButtonItem = nil
        case .byRemove, .dissolve:
            errorNode.isHidden = true
            inputNode.isHidden = true
            notSendView.isHidden = false
            layoutNotSendView(status: status)
            navigationItem.rightBarButtonItem = nil
        case .normal:
            errorNode.isHidden = true
            inputNode.isHidden = false
            notSendView.isHidden = true
        }
    }
    
    private func layoutNotSendView(status: ChatRoomStatus) {
        notSendLine.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        notSendContentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        notSendImageView.snp.remakeConstraints { make in
            if status == .byRemove {
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
                make.size.equalTo(CGSizeMake(24, 24))
            } else {
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
                make.size.equalTo(CGSizeMake(24, 24))
            }
        }
        notSendLabel.text = status == .byRemove  ? "无法在已退出的群聊中发送消息" : "无法在已解散的群聊中发送消息"
        notSendLabel.snp.remakeConstraints { make in
            if status == .byRemove {
                make.left.top.bottom.equalToSuperview()
                make.right.equalTo(notSendImageView.snp.left).offset(-4)
            } else {
                make.right.top.bottom.equalToSuperview()
                make.left.equalTo(notSendImageView.snp.right).offset(4)
            }
        }
        
        node.view.layoutIfNeeded()
    }
    
    func sendMediaAssets(_ assets: [MediaAsset]) {
        for mediaAsset in assets {
            if mediaAsset.asset.mediaType == .image {
                let thumbImage = mediaAsset.asset.thumbImage(with: CGSize(width: 500, height: 500))
                let imageMsg = ImageMessage(image: thumbImage, size: mediaAsset.asset.pixelSize)
                let message = Message()
                message.chatID = session.groupNo!
                message.content = .image(imageMsg)
                message.senderID = AppContext.current.userID
                message.localMsgID = UUID().uuidString
                message.time = TimeInterval(Date().timeIntervalSinceNow)
                dataSource.append(message)
            } else if mediaAsset.asset.mediaType == .video {
                let thumbImage = mediaAsset.asset.thumbImage(with: CGSize(width: 500, height: 500))
                let duration = mediaAsset.asset.duration
                let size = mediaAsset.asset.pixelSize
                let videoMsg = VideoMessage(url: nil, thumb: thumbImage, size: size, fileSize: 0, duration: Float(duration))
                let message = Message()
                message.chatID = session.groupNo!
                message.content = .video(videoMsg)
                message.senderID = AppContext.current.userID
                message.localMsgID = UUID().uuidString
                message.time = TimeInterval(Date().timeIntervalSinceNow)
                dataSource.append(message)
            }
        }
    }
    
    func scrollToLastMessage(animated: Bool) {
        DispatchQueue.main.async {
            let last = self.dataSource.numberOfRows() - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                self.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    private func showSendLocationActionSheet() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "发送位置", handler: { [weak self] _ in
            self?.sendLocation()
        }))
        actionSheet.add(WXActionSheetItem(title: "共享实时位置", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func sendLocation() {
        let message = Message()
        message.chatID = session.groupNo!
        
        message.content = .location(LocationMessage(coordinate: CLLocationCoordinate2DMake(39.996074, 116.480813), thumbImage: UIImage(named: "location_thumb"), title: "望京SOHOT2(北京市朝阳区)", subTitle: "北京市朝阳区阜通东大街"))
        message.senderID = AppContext.current.userID
        message.localMsgID = UUID().uuidString
        message.time = TimeInterval(Date().timeIntervalSinceNow)
        dataSource.append(message)
    }
    
    private func showLongPressImageActionSheet(imageMsg: ImageMessage) {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "收藏", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "保存图片", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "编辑", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "定位到聊天", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func previewImages(imageMsg: ImageMessage, originView: UIView) {
        var ds: PhotoBrowserDataSource
        if let image = imageMsg.image {
            ds = PhotoBrowserLocalDataSource(numberOfItems: 1, images: [image])
        } else {
            let thumb = originView.toImage()
            ds = PhotoBrowserNetworkDataSource(numberOfItems: 1, placeholders: [thumb], remoteURLs: [imageMsg.url])
        }
        let trans = PhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return originView
        }
        let delegate = PhotoBrowserDefaultDelegate()
        delegate.longPressedHandler = { [weak self] (browser, index, image, gesture) in
            self?.showLongPressImageActionSheet(imageMsg: imageMsg)
        }
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans, delegate: delegate)
        browser.show(pageIndex: 0, in: self)
    }
    
    private func previewVideo(videoMsg: VideoMessage, originView: UIView) {
        print("TODO")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

// MARK: - Event Handlers

extension ChatRoomViewController {
     
    @objc private func handlePopGesture(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = true
        case .cancelled, .ended:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = false
        default:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = true
        }
    }
    
    @objc private func moreButtonClicked() {
        if members == nil {
            requestMembers(showHUD: true)
            return
        }
        let contactVC = ChatRoomContactInfoViewController(contact: session, members: members!)
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
    private func loadGroupMessage() {
        // 先加载本地数据
        loadLocalData()
        
    }
    private func loadLocalData() {
        // 有未读消息，就从服务端请求，否则加载本地数据即可
        let hasUnreadMsg = Int(session.unReadNum ?? "0")! > 0 ? true : false
        guard let mssageList = MessageEntity.queryMessag(groupNo: session.groupNo!),
              mssageList.count > 0 else {
            loadRemoteMessage(msgNo: nil, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
            return
        }
        self.dataSource.appendMsgList(mssageList, scrollToLastMessage: true, showMsgTime: true)
//        if hasUnreadMsg {
            loadRemoteMessage(msgNo: mssageList.last?.no, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
//        }
    }
    /*
     sort=1, 获取新数据，sort=0，获取历史数据，
     hasUnreadMsg: 有未读消息，需要通知服务器更新消息状态
     oldNo：本地最新消息no，socket收到消息是，latestNo与本地最新消息no对比，不一致时，表示遗漏了数据
     */
    private func loadRemoteMessage(sort: String = "1", msgNo: String?, hasUnreadMsg: Bool = false, lookUpHistory: Bool, showMsgTime: Bool = true, untilOldNo oldNo: String? = nil) {
        //        let isLoadLatest = sort == "1" ? true : false
        let request = MessageRequest(groupNo: session.groupNo!)
        request.sort = sort
        /*
         sort=1, 获取新数据，分3种情况
         1. 无本地数据，lastAckMsgNo = nil
         2. 有本地数据，lastAckMsgNo = 本地最新数据no
         3. 有消息时，lastAckMsgNo = 本地最新数据no
         sort=0，获取历史数据，
         no = 最早的历史数据no
         */
        if hasUnreadMsg {
            // 有本地数据
            if msgNo != nil {
                request.lastAckMsgNo = msgNo
            }
        } else {
            request.no = msgNo
        }
        
        request.start(withNetworkingHUD: false, showFailureHUD: true) { request in
            self.tableNode.view.mj_header?.endRefreshing()
            do {
                
                let resp = try JSONDecoder().decode([MessageEntity].self, from: request.wxResponseData())
                if resp.count > 0 {
                    let personModel = GlobalManager.manager.personModel
                    resp.forEach { $0.ownerId = personModel?.userId }
                    MessageEntity.insertOrReplace(list: resp)
                    // 本地没有最新获取的消息，仍需要进一步获取消息
                    if self.dataSource.messages.first(where: { $0.entity?.no == resp.first?.no }) == nil {
                        self.loadRemoteMessage(sort: "0", msgNo: resp.first?.no, hasUnreadMsg: false, lookUpHistory: true, untilOldNo:oldNo)
                    }
                    if oldNo != nil {
                        self.dataSource.appendMsgList(resp, scrollToLastMessage:true, lookUpHistory:lookUpHistory, showMsgTime: showMsgTime)
                    } else {
                        self.dataSource.appendMsgList(resp, scrollToLastMessage:sort == "1", lookUpHistory:lookUpHistory, showMsgTime: showMsgTime)
                    }
                    if hasUnreadMsg {
                        self.readMessage(no: resp.last?.no ?? "")
                    }
                } else {
                    if sort == "0" {
                        self.hasHistory = false
                    }
                    if hasUnreadMsg {
                        self.readMessage(no: self.dataSource.messages.last?.entity?.no ?? "")
                    }
                }
            }  catch {
                print("Error decoding JSON: \(error)")
            }
        } failure: { _ in
            self.tableNode.view.mj_header?.endRefreshing()
        }
    }
    
    private func readMessage(no: String, entity: MessageEntity? = nil) {
        let request = MsgReadRequest(no: no)
        request.startWithCompletionBlock { _ in
            // entity不为nil，更新会话最新消息
            self.updateNewAckMessage(entity: entity)
        }
    }
    
    private func updateNewAckMessage(entity: MessageEntity? = nil) {
        if let msgEntity = entity {
            if (self.session.newAckMsgDate ?? 0) < (msgEntity.createTime ?? 0) {
                self.session.userMsgType = 1
                self.session.newAckMsgDate = msgEntity.createTime
                self.session.newAckMsgInfo = msgEntity.content
                self.session.newAckMsgNo = msgEntity.no
                self.session.newAckMsgType = msgEntity.type
                self.session.newAckMsgUserId = msgEntity.userId
                self.session.newAckMsgUserNickname = msgEntity.nickname
            }
        }
        self.session.unReadNum = "0"
        self.updateGroupBlock?(self.session)
        GroupEntity.updateUnreadNum(group: self.session)
    }
    
    private func requestMembers(showHUD: Bool) {
        let request = GroupMembersRequest(groupNo: session.groupNo)
        request.start(withNetworkingHUD: showHUD, showFailureHUD: showHUD) { request in
            if let json = try? JSON(data: request.wxResponseData()) {
                if let groupList = json["friendList"].arrayObject,
                   let jsonData = (groupList as NSArray).mj_JSONData() {
                    
                    do {
                        let resp = try JSONDecoder().decode([MemberModel].self, from: jsonData)
                        self.members = resp
                        self.navigationItem.title = self.session.name ?? "群聊\(String(describing: self.members?.count))"
                        if showHUD {
                            self.moreButtonClicked()
                        }
                        print(resp)
                    }  catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        } failure: { request in
//            self.handleGroupError(request: request)
        }
    }
    private func getGroupInfo() {
        let request = GroupInfoRequest(groupNo: session.groupNo)
        request.start(withNetworkingHUD: false, showFailureHUD: false) { request in
        } failure: { request in
            self.handleGroupError(request: request)
        }
    }
    private func handleGroupError(request: YTKBaseRequest) {
        let code = request.apiCode()
        if code == NetworkCode.GROUP_IS_BLOCKED.rawValue ||
            code == NetworkCode.GROUP_IS_REMOVE.rawValue {
            self.session.status = code == -7 ? 2 : 1
            GroupEntity.insertOrReplace(list: [self.session])
            self.updateChatRoomView(status: ChatRoomStatus(rawValue: self.session.status) ?? .normal)
            return
        }
        if code == NetworkCode.GROUP_USER_IS_REMOVE.rawValue {
            self.updateChatRoomView(status: .byRemove)
            return
        }
    }
}

// MARK: - ASTableDataSource & ASTableDelegate
extension ChatRoomViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let message = dataSource.itemAtIndexPath(indexPath)
        let nodeBlock: ASCellNodeBlock = {
            let cellNode = ChatRoomCellNodeFactory.node(for: message)
            cellNode.backgroundColor = .clear
            cellNode.delegate = self
            return cellNode
        }
        return nodeBlock
    }
}

// MARK: - UIScrollViewDelegate

extension ChatRoomViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inputNode.dismissKeyboard()
    }
}


// MARK: - ChatRoomKeyboardNodeDelegate

extension ChatRoomViewController: ChatRoomKeyboardNodeDelegate {
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendText text: String) {
        let msg = dataSource.messages.last
        let messagaEntity = MessageEntity.buildMessage(content: text, groupNo: session.groupNo!, groupType: session.groupType!, lastNo: msg?.entity?.no)
        Socket.shared.sendData(message: messagaEntity)
        dataSource.appendMsgList([messagaEntity], scrollToLastMessage: true, showMsgTime: false)
        
        //        let message = Message()
        //        message.chatID = session.groupNo!
        //        message.content = .text(text)
        //        message.senderID = AppContext.current.userID
        //        message.localMsgID = UUID().uuidString
        //        message.time = TimeInterval(Date().timeIntervalSinceNow)
        //        dataSource.append(message)
        
        inputNode.clearText()
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSelectToolItem tool: ChatRoomTool) {
        switch tool {
            //        case .album:
            //            let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
            //                self?.sendMediaAssets(selectedAssets)
            //                self?.dismiss(animated: true, completion: nil)
            //            }
            //            let configuration = AssetPickerConfiguration.configurationForChatRoom()
            //            let albumPickerVC = AlbumPickerViewController(configuration: configuration)
            //            albumPickerVC.selectionHandler = selectionHandler
            //            let assetPickerVC = AssetPickerViewController(configuration: configuration)
            //            assetPickerVC.selectionHandler = selectionHandler
            //            let nav = UINavigationController()
            //            nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
            //            nav.modalPresentationStyle = .fullScreen
            //            present(nav, animated: true, completion: nil)
            //        case .camera:
            //            let sightCameraVC = SightCameraViewController()
            //            sightCameraVC.modalPresentationCapturesStatusBarAppearance = true
            //            sightCameraVC.modalTransitionStyle = .coverVertical
            //            sightCameraVC.modalPresentationStyle = .overCurrentContext
            //            present(sightCameraVC, animated: true, completion: nil)
            //        case .location:
            //            showSendLocationActionSheet()
        case .redPacket:
            let makeRedEnvelopeVC = MakeRedEnvelopeViewController()
            makeRedEnvelopeVC.session = session
            makeRedEnvelopeVC.sendRedPacketBlock = { msg in
                self.dataSource.appendMsgList([msg], scrollToLastMessage: true, showMsgTime: false)
            }
            let nav = UINavigationController(rootViewController: makeRedEnvelopeVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendSticker sticker: WCEmotion) {
        let message = Message()
        message.chatID = session.groupNo!
        message.content = .emoticon(EmoticonMessage(md5: sticker.name, packageID: sticker.packageID, title: sticker.title))
        message.senderID = AppContext.current.userID
        message.localMsgID = UUID().uuidString
        message.time = TimeInterval(Date().timeIntervalSinceNow)
        dataSource.append(message)
    }
    
    func keyboardAddFavoriteEmoticonButtonPressed() {
        
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendGameEmoticon game: FavoriteEmoticon) {
        switch game.type {
        case .dice:
            let message = Message()
            message.chatID = session.groupNo!
            message.content = .game(GameMessage(gameType: .dice))
            message.senderID = AppContext.current.userID
            message.localMsgID = UUID().uuidString
            message.time = TimeInterval(Date().timeIntervalSinceNow)
            dataSource.append(message)
        default:
            break
        }
    }
    
    func keyboardEmoticonSettingsButtonPressed() {
        let emoticonManageVC = EmoticonManageViewController()
        emoticonManageVC.isPresented = true
        let nav = UINavigationController(rootViewController: emoticonManageVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func keyboardEmoticonAddButtonPressed() {
        let emoticonStoreVC = EmoticonStoreViewController(presented: true)
        let nav = UINavigationController(rootViewController: emoticonStoreVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - MessageCellNodeDelegate
extension ChatRoomViewController: MessageCellNodeDelegate {
    
    func messageCell(_ cellNode: MessageCellNode, didTapAvatar userID: String) {
        return
        guard let user = MockFactory.shared.user(with: userID) else {
            return
        }
        let contactVC = ContactInfoViewController(contact: user.toContact())
        navigationController?.pushViewController(contactVC, animated: true)
    }
    func messageCell(_ cellNode: MessageCellNode, didTapRed orderNumber: String) {
        
        var message: Message? = nil
        if let row = dataSource.messages.firstIndex(where: { msg in
            if  msg.entity?.orderNumber == orderNumber {
                message = msg
                return true
            }
            return false
        }) {
            let indexPath = IndexPath(row: row, section: 0)
            messageCell(cellNode, indexPath: indexPath, didTapContent: message!.content)
        }
    }
    
    func messageCell(_ cellNode: MessageCellNode, didLongPressedAvatar userID: String) {
        
    }
    
    func messageCell(_ cellNode: MessageCellNode, indexPath: IndexPath, didTapContent content: MessageContent) {
        switch content {
        case .emoticon(let emoticonMsg):
            let controller = ChatRoomEmoticonPreviewViewController(emoticon: emoticonMsg)
            navigationController?.pushViewController(controller, animated: true)
        case .location(let locationMsg):
            let controller = ChatRoomMapViewController(location: locationMsg)
            navigationController?.pushViewController(controller, animated: true)
        case .image(let imageMsg):
            let originView = (cellNode.contentNode as? MessageImageContentNode)?.imageView ?? cellNode.contentNode.view
            previewImages(imageMsg: imageMsg, originView: originView)
        case .video(let videoMsg):
            let originView = (cellNode.contentNode as? VideoContentNode)?.imageView ?? cellNode.contentNode.view
            previewVideo(videoMsg: videoMsg, originView: originView)
        case .redPacket(let msg):
            clickRedPacket(indexPath: indexPath, msg: msg)
        default:
            break
        }
    }
    
    func messageCell(_ cellNode: MessageCellNode, didTapLink url: URL?) {
        //        if let url = url {
        //            let webVC = WebViewController(url: url)
        //            navigationController?.pushViewController(webVC, animated: true)
        //            inputNode.dismissKeyboard()·
        //        }
    }
    
    func messageCell(_ cellNode: MessageCellNode, showMenus menus: [MessageMenuAction], message: Message, targetRect: CGRect, targetView: UIView) {
       
    }
    
    func clickRedPacket(indexPath: IndexPath, msg: RedPacketMessage) {
        
        guard let entity = msg.entity else {
            handleRedPacket(indexPath: indexPath, model: nil, msg: msg)
            return
        }
        handleRedPacket(indexPath: indexPath, model: entity, msg: nil)
    }
    func handleRedPacket(indexPath: IndexPath?, model: RedPacketGetEntity?, msg: RedPacketMessage?) {
        if isRequestRed {
            return
        }
        let red = RedEnvelopView.init()
        red.redMsg = msg

        red.callBackClosure = {
        }
        red.detailsClosure = { m in
            let vc = RedDetailsViewController()
            vc.redPacket = m ?? model
            self.navigationController?.pushViewController(vc, animated: false)
        }
        red.updateDBClosure = {flag in
            if flag {
                if let indexPath {
                    let message = self.dataSource.messages[indexPath.row]
                    message.updateRedPacket()
                    self.tableNode.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        if (model != nil) {
            // 自己领取了
            red.updateRedContent(model: model, msg: msg)
            red.showView()
            return
        }
        // 检查是否被领取完
        isRequestRed = true
        red.requestRedPacketGetRequest(isGet: "0") { resp, error in
            self.isRequestRed = false
            guard let resp else {
                return
            }
            guard let status = resp.status else {
                return
            }
            // 状态(1进行中,2已完成,3已过期)
            if status == 2 || status == 3  {
                resp.groupNo = red.redMsg?.groupNo ?? ""
                resp.orderNumber = red.redMsg?.orderNumber ?? ""
                resp.ownerId = GlobalManager.manager.personModel?.userId
                RedPacketGetEntity.insertOrReplace(list: [resp])
                red.updateDBClosure!(true)
            }
            red.updateRedContent(model: resp, msg: msg)
            red.showView()
        }
    }
}

extension ChatRoomViewController {
    private func layoutUI() {
        navigationItem.title = session.name ?? "群聊\(String(describing: session.userNum))"
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        if let backgroundImageName = AppContext.current.userSettings.globalBackgroundImage {
            backgroundImageNode.image = UIImage.as_imageNamed(backgroundImageName)
        }
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        backgroundImageNode.frame = view.bounds
        let bottomHeight = 56 + Constants.bottomInset
        tableNode.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.backgroundColor = .clear
        tableNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight - bottomHeight)
        inputNode.tableNode = tableNode
        inputNode.delegate = self
        
        dataSource.tableNode = tableNode
        
        scrollToLastMessage(animated: false)
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture(_:)))
        
        node.addSubnode(errorNode)
        
        notSendView.frame = CGRect(x: 0, y: Constants.screenHeight - bottomHeight, width: Constants.screenWidth, height:  bottomHeight)
        notSendView.isHidden = true
        node.view.addSubview(notSendView)
        notSendView.addSubview(notSendLine)
        notSendLine.backgroundColor = UIColor(white: 0, alpha: 0.1)
        notSendView.addSubview(notSendContentView)
        notSendContentView.addSubview(notSendLabel)
        notSendContentView.addSubview(notSendImageView)
        notSendLabel.textColor = UIColor(white: 0, alpha: 0.6)
        notSendLabel.font = .systemFont(ofSize: 15)
        
        updateChatRoomView(status: ChatRoomStatus(rawValue: session.status) ?? .byRemove)
        
        let mjHeader = MJRefreshNormalHeader(refreshingBlock: {
            if self.hasHistory {
                self.loadRemoteMessage(sort: "0", msgNo: self.dataSource.messages.last?.entity?.no, lookUpHistory: true)
                return
            }
            self.tableNode.view.mj_header?.endRefreshing()
        })
        mjHeader.lastUpdatedTimeLabel?.isHidden = true
        mjHeader.stateLabel?.isHidden = true
        mjHeader.arrowView?.image = nil
        tableNode.view.mj_header = mjHeader
    }
    
    
}

extension ChatRoomViewController: SocketDelegate {
    /// 发送消息，接收到ack回调，更新信息
    func updateLatestMessageEntity(entity: MessageEntity, latestNo: String?, oldNo: String?, isReadMoreHisoty: Bool) {
        let personModel = GlobalManager.manager.personModel
        entity.ownerId = personModel?.userId
        MessageEntity.insertOrReplace(list: [entity])
        if !isReadMoreHisoty {
            return
        }
        loadRemoteMessage(sort: "0", msgNo: latestNo, hasUnreadMsg: false, lookUpHistory: true, untilOldNo:oldNo)
    }
    /// 收到最新消息
    func receiveLatestMessageEntity(groupNo: String, entity: MessageEntity) {
        if groupNo != session.groupNo {
            return
        }
        if entity.userId != nil &&
            entity.userId == GlobalManager.manager.personModel?.userId {
            self.updateNewAckMessage(entity: entity)
            return
        }
        if entity.groupIsChange == 1 ||
            entity.type == 6 {
            getGroupInfo()
            return
        }
        self.readMessage(no: entity.no!, entity: entity)
        if let lastNo = entity.lastNo {
            let oldNo = dataSource.messages.last?.entity?.no
            if oldNo == lastNo {
                let personModel = GlobalManager.manager.personModel
                entity.ownerId = personModel?.userId
                MessageEntity.insertOrReplace(list: [entity])
                dataSource.appendMsgList([entity], scrollToLastMessage: true, showMsgTime: false)
            }
            loadRemoteMessage(sort: "0", msgNo: lastNo, hasUnreadMsg: false, lookUpHistory: true, untilOldNo:oldNo)
        } else {
            let personModel = GlobalManager.manager.personModel
            entity.ownerId = personModel?.userId
            MessageEntity.insertOrReplace(list: [entity])
            dataSource.appendMsgList([entity], scrollToLastMessage: true, showMsgTime: false)
        }
    }
    
}
