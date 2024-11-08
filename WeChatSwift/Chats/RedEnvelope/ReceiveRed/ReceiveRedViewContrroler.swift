//
//  ReceiveRedViewContrroler.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet
import KeenKeyboard
import SwiftyJSON
import MJRefresh


class ReceiveRedViewContrroler: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    private let headNode = ReceiveRedHeadNode()
    private var dataSource: [RedPacketRecordModel] = []
    private var page:Int = 1
    override init() {
        
        super.init(node: ASDisplayNode())
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wx_navigationBar.backgroundColor = Colors.RED_NAVIGATION_BAR_COLOR
        navigationItem.title = "收到的红包"
        let cancelButton = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_back", fillColor: .white), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        let moreItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_more", fillColor: .white), style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.addSubnode(tableNode)
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 366)
        headerView.addSubnode(headNode)
        headerView.backgroundColor = .blue
        headNode.frame = headerView.bounds
        tableNode.view.tableHeaderView = headerView
        loadRecordData()
        let mjFooter = MJRefreshBackNormalFooter {
            self.page += 1
            self.loadRecordData()
        }
        mjFooter.stateLabel?.isHidden = true
        mjFooter.arrowView?.image = nil
        tableNode.view.mj_footer = mjFooter
    }
    
    func loadRecordData() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        let request = RedPacketRecordRquest(page: "\(page)", year: "\(components.year ?? 2024)")
        let showHUD = page == 1 ? true : false
        request.start(withNetworkingHUD: showHUD, showFailureHUD: true) { request in
            self.tableNode.view.mj_footer?.endRefreshing()
            if let json = try? JSON(data: request.wxResponseData()) {
                self.headNode.updateContent(json: json)
                guard let detailList = json["detailList"].arrayObject,
                      detailList.count > 0 else {
                    self.tableNode.view.mj_footer?.isUserInteractionEnabled = false
                    return
                }
                if let jsonData = (detailList as NSArray).mj_JSONData() {
                    do {
                        let resp = try JSONDecoder().decode([RedPacketRecordModel].self, from: jsonData)
                        self.dataSource += resp
                        self.tableNode.reloadData()
                    }  catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        } failure: { request in
            self.tableNode.view.mj_footer?.endRefreshing()
        }
        
    }
    
}

// MARK: - Event Handlers
extension ReceiveRedViewContrroler {
    @objc private func handleCancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleMoreButtonClicked() {
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ReceiveRedViewContrroler: ASTableDelegate, ASTableDataSource {
    
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        //        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == (dataSource.count-1)
        let block: ASCellNodeBlock = {
            return ReceiveRedCellNode(model: self.dataSource[indexPath.row], isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}

