//
//  HelpRedViewController.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/18.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class HelpRedViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    private var dataSource: [HelpRedModel] = []
    
    override init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        setDatasource()
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        node.addSubnode(tableNode)
        navigationItem.title = "微信红包"
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "close_trusted_friend_tips_hl"), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
    }
}


// MARK: - Event Handlers
extension HelpRedViewController {
    @objc private func handleCancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleMoreButtonClicked() {
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension HelpRedViewController: ASTableDelegate, ASTableDataSource {
     
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
       let isLastCell = indexPath.row == (8-1)
        let block: ASCellNodeBlock = {
            return HelpRedCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
         
    }
}
 
extension HelpRedViewController {
    private func setDatasource() {
        dataSource.append(HelpRedModel(type: 1, image: UIImage(named: "icon_red_face2face")!, name: "面对面红包", q1: "微信面对面红包使用方法", q2: "如何领取微信面对面红包", q3: "微信面对面红包可以截屏分享吗"))
        dataSource.append(HelpRedModel(type: 2, image: UIImage(named: "send_red_qua")!, name: "发红包问题", q1: "微信红包不收多久退回", q2: "已发出的红包如何撤回", q3: "怎么设置红包退款方式"))
        dataSource.append(HelpRedModel(type: 3, image: UIImage(named: "receive_red_qua")!, name: "收红包问题", q1: "怎么查看我的红包记录", q2: "为什么微信里领取了红包却未入账", q3: "微信收红包的方法"))
        dataSource.append(HelpRedModel(type: 4, image: UIImage(named: "withdraw_qua6")!, name: "提现问题", q1: "领取的微信红包资金怎么提现", q2: "微信红包提现支持哪些银行", q3: "微信零钱提现最高限额是多少"))
    }
}
