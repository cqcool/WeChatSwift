//
//  NewsViewController.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/20.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import SwiftyJSON

class NewsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var session: GroupEntity!
    private var dataSource: [MessageEntity] = []
    /// 默认还有历史数据
    private var hasHistory: Bool = true
    
    var updateGroupBlock:((_: GroupEntity) -> ())?
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "腾讯新闻"
        let moreItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_setting"), style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: WXDevice.bottomSafeArea() +  10, right: 0)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: Constants.navigationHeight, width: Constants.screenWidth, height: Constants.screenHeight - Constants.navigationHeight), collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(NewsCellNode.self, forCellWithReuseIdentifier: "NewsCellNode")
        view.addSubview(collectionView)
        loadGroupMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(configUpdate), name: ConstantKey.NSNotificationConfigUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLatestMessage), name: NSNotification.Name(self.session.groupNo ?? ""), object: nil)
    }
    
    @objc func handleMoreButtonClicked() {
//        navigationController?.pushViewController(NewDetailsViewController(), animated: true)
        
    }
    @objc func configUpdate() {
        collectionView.reloadData()
    }
    @objc func receiveLatestMessage() {
        loadRemoteMessage(msgNo: dataSource.last?.no, hasUnreadMsg: true, lookUpHistory: false)
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
        self.dataSource += mssageList
        self.collectionView.reloadData()
        scrollToBottom(animated: false)
        self.readMessage(no: self.dataSource.last?.no ?? "")
        if hasUnreadMsg {
            loadRemoteMessage(msgNo: mssageList.last?.no, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
        }
        
    }
    /*
     hasUnreadMsg: 有未读消息，需要通知服务器更新消息状态
     */
    private func loadRemoteMessage(sort: String = "1", msgNo: String?, hasUnreadMsg: Bool = false, lookUpHistory: Bool) {
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
        if hasUnreadMsg || sort == "1" {
            request.lastAckMsgNo = msgNo
        } else {
            request.no = msgNo
        }
        
        request.start(withNetworkingHUD: false, showFailureHUD: true) { [weak self] request in
            self?.collectionView.mj_header?.endRefreshing()
            do {
                let personModel = GlobalManager.manager.personModel
                let resp = try JSONDecoder().decode([MessageEntity].self, from: request.wxResponseData())
                resp.forEach { $0.ownerId = personModel?.userId }
                if resp.count > 0 {
                    MessageEntity.insertOrReplace(list: resp)
                    self?.dataSource += resp
//                    if hasUnreadMsg {
                        self?.readMessage(no: resp.last?.no ?? "")
//                    }
                    self?.collectionView.reloadData()
                    self?.scrollToBottom(animated: true)
                } else {
                    if sort == "0" {
                        self?.hasHistory = false
                    }
                }
            }  catch {
                print("Error decoding JSON: \(error)")
            }
        } failure: { _ in
            self.collectionView.mj_header?.endRefreshing()
        }
    }
    private func scrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.dataSource.count > 0 {
                var y: CGFloat = 0
                var height: CGFloat = 0
                var index: Int = 0
                while(index <= self.dataSource.count - 1) {
                    let size = self.modelHeight(row: index)
                    y += size.height
                    if index == self.dataSource.count - 1 {
                        height = size.height
                        height -= WXDevice.bottomSafeArea()
                    }
                    index += 1
                }
                
                let rect = CGRectMake(0, y, WXDevice.widthScale(), height)
                self.collectionView.scrollRectToVisible(rect, animated: animated)
            }
            
        }
        if self.dataSource.count > 0 {
//            let index = IndexPath(row: self.dataSource.count - 1, section: 0)
//            collectionView.scrollToItem(at: index, at: .bottom, animated: false)

            
        }
    }
    private func readMessage(no: String) {
        let request = MsgReadRequest(no: no)
        request.startWithCompletionBlock { _ in
            self.session.unReadNum = "0"
            self.updateGroupBlock?(self.session)
            GroupEntity.updateUnreadNum(group: self.session)
        }
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = dataSource[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCellNode", for: indexPath)
        (cell as! NewsCellNode).cellForModel(model: message)
        (cell as! NewsCellNode).clickNewsBlock = { newsLink in
            let vc = NewDetailsViewController()
            vc.link = newsLink
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return modelHeight(row: indexPath.row)
//        let message = dataSource[indexPath.row]
//        if let list = (message.linkContent! as NSString).mj_JSONObject() as? Array<Any> {
//            let height: Float = 74.0 * Float((list.count - 1))
//            return CGSizeMake(Constants.screenWidth - 40, 150.0 + 44.0 + 16.0 + CGFloat(height))
//        }
//        return CGSizeZero
    }
    private func modelHeight(row: Int) -> CGSize {
        let message = dataSource[row]
        if let list = (message.linkContent! as NSString).mj_JSONObject() as? Array<Any> {
            let height: Float = 74.0 * Float((list.count - 1))
            return CGSizeMake(Constants.screenWidth - 40, 150.0 + 44.0 + 16.0 + CGFloat(height))
        }
        return CGSizeZero
    }
}
