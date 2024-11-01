//
//  NewsViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/20.
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
       
        collectionView = UICollectionView(frame: CGRect(x: 0, y: Constants.navigationHeight, width: Constants.screenWidth, height: Constants.screenHeight - Constants.navigationHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NewsCellNode.self, forCellWithReuseIdentifier: "NewsCellNode")
        view.addSubview(collectionView)
        loadGroupMessage()
    }
    
    @objc func handleMoreButtonClicked() {
        navigationController?.pushViewController(NewDetailsViewController(), animated: true)
        
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
//            if hasUnreadMsg {
                loadRemoteMessage(msgNo: nil, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
//            } else {
//                loadRemoteMessage(sort: "0", msgNo: nil, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
//            }
            return
        }
        self.dataSource += mssageList
        if hasUnreadMsg {
            loadRemoteMessage(msgNo: mssageList.first?.no, hasUnreadMsg: hasUnreadMsg, lookUpHistory: false)
        }
     
    }
    /*
     hasUnreadMsg: 有未读消息，需要通知服务器更新消息状态
     */
    private func loadRemoteMessage(sort: String = "1", msgNo: String?, hasUnreadMsg: Bool = false, lookUpHistory: Bool, showMsgTime: Bool = true) {
//        let isLoadLatest = sort == "1" ? true : false
        let request = MessageRequest(groupNo: session.groupNo!)
        request.groupNo = session.groupNo!
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
            // 无本地数据
            if msgNo != nil {
                request.lastAckMsgNo = msgNo
            }
        } else {
            request.no = msgNo
        }
        
        request.start(withNetworkingHUD: false, showFailureHUD: true) { request in
            self.collectionView.mj_header?.endRefreshing()
            do {
                let resp = try JSONDecoder().decode([MessageEntity].self, from: request.wxResponseData())
                if resp.count > 0 {
                    MessageEntity.insertOrReplace(list: resp)
                    self.dataSource += resp
                    if hasUnreadMsg {
                        self.readMessage(no: resp.last?.no ?? "")
                    }
                } else {
                    if sort == "0" {
                        self.hasHistory = false
                    }
                }
            }  catch {
                print("Error decoding JSON: \(error)")
            }
        } failure: { _ in
            self.collectionView.mj_header?.endRefreshing()
        }
    }
    
    private func readMessage(no: String) {
        let request = MsgReadRequest(no: no)
        request.startWithCompletionBlock { _ in
            self.session.unReadNum = "0"
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
        let message = dataSource[indexPath.row]
        if let list = (message.linkContent! as NSString).mj_JSONObject() as? Array<Any> {
            let height: Float = 74.0 * Float((list.count - 1))
            return CGSizeMake(Constants.screenWidth - 40, 150.0 + 44.0 + 16.0 + CGFloat(height))
            //240 224
        }
        return CGSizeZero
    }
}
