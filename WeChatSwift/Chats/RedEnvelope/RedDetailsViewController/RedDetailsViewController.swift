//
//  RedDetailsViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RedDetailsViewController: ASDKViewController<ASDisplayNode>  {
    
    private let topView = ASDisplayNode()
    private let topIconView = ASImageNode()
    private let tableNode = ASTableNode()
    private let headerNode = RedDetailsHeaderNode()
    private var footerNode: UILabel!
    private var footerView: UIView!
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        node.addSubnode(topIconView)
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var wx_backImage: UIImage? {
        return UIImage.SVGImage(named: "icons_outlined_back", fillColor: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = .white
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .white
        tableNode.view.separatorStyle = .none
        let moreItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_more", fillColor: .white), style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        
        wx_navigationBar.backgroundColor = .clear
        topIconView.image = UIImage(named: "RedEnvelope_Bg_Hair")
        topIconView.frame = CGRectMake(0, 0, Constants.screenWidth, 128)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 337)
        headerView.addSubnode(headerNode)
        headerNode.frame = headerView.bounds
        tableNode.view.tableHeaderView = headerView
        
//        let sectionView = UIView(x: 0, y: 0, width: Constants.screenWidth, height: 48)
//        sectionView.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 50))
        footerNode = DNKCreate.label(text: "未领取的红包，将于24小时后发起退款", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
        footerNode.textAlignment = .center
        footerNode.frame = CGRect(x: 0, y: 30, width: Constants.screenWidth, height: 20)
        footerView.addSubview(footerNode)
        tableNode.view.tableFooterView = footerView
        updateFooterNode()
    }
    
    private func updateFooterNode() {
        let sectionHeight = 48.0
        let headerHeight = 337.0
        
        let offsetY = Constants.screenHeight - headerHeight - Constants.navigationHeight - 2*Constants.bottomInset - (1.0 * 72.0) - sectionHeight
        let y = offsetY-20 > 20  ? offsetY : 40
        
        footerView.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: y)
        footerNode?.frame = CGRect(x: 0, y: y-20, width: Constants.screenWidth, height: 20)
    }
}

extension RedDetailsViewController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let model = dataSource[indexPath.section].items[indexPath.row]
//        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let isLastCell = (indexPath.row == (4 - 1))
        let block: ASCellNodeBlock = {
            return RedDetailsCellNode(isLastCell: isLastCell)
        }
        return block
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("distance: \(offsetY)")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(x: 0, y: 0, width: Constants.screenWidth, height: 48)
        sectionView.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        let contentView = UIView(x: 0, y: 10, width: Constants.screenWidth, height: 38)
        contentView.backgroundColor = .white
        sectionView.addSubview(contentView)
        /*
         "已领取1/5个，共2.26/10.00元"
         5个红包，50秒被抢光
         */
        let label = DNKCreate.label(text: "已领取1/5个，共2.26/10.00元", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
        label.frame = CGRect(x: 16, y: 0, width: 300, height: 38)
        contentView.addSubview(label)
        
        let lineView = UIView(x: 18, y: 37.5, width: Constants.screenWidth - 18, height: 0.5)
        lineView.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        contentView.addSubview(lineView)
        return sectionView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let sectionView = UIView(x: 0, y: 0, width: Constants.screenWidth, height: 48)
//        sectionView.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
//
//        let label = DNKCreate.label(text: "未领取的红包，将于24小时后发起退款", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
//        label.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 38)
//        contentView.addSubview(label)
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 48
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension RedDetailsViewController {
    @objc func handleMoreButtonClicked() {
        
    }
}
