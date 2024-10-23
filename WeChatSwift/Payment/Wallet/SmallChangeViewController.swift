//
//  SmallChangeViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/9.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SmallChangeViewController: ASDKViewController<ASDisplayNode> {
    private let tableNode = ASTableNode(style: .plain)
    
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
        let rightButtonItem = UIBarButtonItem(title: "零钱明细", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightButtonItem
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wx_navigationBar.backgroundColor = .white
        node.backgroundColor = .white
        node.view.backgroundColor = .white
        tableNode.view.backgroundColor = .clear
        tableNode.backgroundColor = .clear
        tableNode.frame = view.bounds
        tableNode.view.separatorStyle = .none
        tableNode.view.tableFooterView = nil
        tableNode.view.showsVerticalScrollIndicator = false
        tableNode.view.bounces = true
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SmallChangeViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            let balance = GlobalManager.manager.personModel?.balance ?? "0.00"
            let cell = SmallChangeCellNode(model: balance)
            cell.selectionStyle = .none
            return cell
        }
        return block
    }
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}
