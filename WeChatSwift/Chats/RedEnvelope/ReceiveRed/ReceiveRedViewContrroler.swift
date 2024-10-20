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
 

class ReceiveRedViewContrroler: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    private let headNode = ReceiveRedHeadNode()
    private var dataSource: [MeTableSection] = []
    
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
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "close_trusted_friend_tips_hl"), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
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
        tableNode.reloadData()
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
        return 8//dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let model = dataSource[indexPath.section].items[indexPath.row]
       let isLastCell = indexPath.row == (8-1)
        let block: ASCellNodeBlock = {
            return ReceiveRedCellNode(model: MeTableSection(items: []), isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}
 
