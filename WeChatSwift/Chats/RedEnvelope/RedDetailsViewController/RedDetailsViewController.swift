//
//  RedDetailsViewController.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class RedDetailsViewController: ASDKViewController<ASDisplayNode>  {
    
    private let topView = ASDisplayNode()
    private let topIconView = ASImageNode()
    private let tableNode = ASTableNode()
    private let headerNode = RedDetailsHeaderNode()
    private var footerNode: UILabel!
    private var footerView: UIView!
    private var datas: [RedPacketRecordModel]? = nil
    var resp: FullRedPacketGetEntity?
    var redPacket: RedPacketGetEntity?
    var redMsg: RedPacketMessage? = nil
    var groupNo: String? = nil
    var orderNumber: String? = nil
    
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
        topIconView.frame = CGRectMake(0, 0, Constants.screenWidth, 105 * WXDevice.heightScale())
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
        tableNode.view.tableHeaderView = headerView
        
//        footerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 50))
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 50))
        footerNode = WXCreate.label(text: "未领取的红包，将于24小时后发起退款", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
        footerNode.textAlignment = .center
        footerNode.frame = CGRect(x: 0, y: 30, width: Constants.screenWidth, height: 20)
        footerView.addSubview(footerNode)
        tableNode.view.tableFooterView = footerView
        tableNode.view.tableFooterView?.isHidden = true
        updateFooterNode()
        
        loadDetails()
        
        headerNode.toTipsNode.isUserInteractionEnabled = true
        headerNode.toTipsNode.addTarget(self, action: #selector(recoradAction), forControlEvents: .touchUpInside)
    }
    @objc func recoradAction() {
        navigationController?.pushViewController(SmallChangeViewController(), animated: true)
    }
    
    private func loadDetails() {
//        let request = RedPacketGetRequest(groupNo: redPacket?.groupNo ?? (groupNo ?? ""), isGet: "1", orderNumber: redPacket?.orderNumber ?? (orderNumber ?? ""))
//        request.start(withNetworkingHUD: true, showFailureHUD: true) { [weak self] request in
//            do {
//                let resp = try JSONDecoder().decode(FullRedPacketGetEntity.self, from: request.wxResponseData())
//                self?.resp = resp
                let height = self.headerViewHeight()
                self.tableNode.view.tableHeaderView?.isHidden = false
                let headerView = UIView()
                headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: height)
//                if self != nil {
//                    
                    headerView.addSubnode(self.headerNode)
//                }
                self.headerNode.frame = headerView.bounds
                self.tableNode.view.tableHeaderView = headerView
        if let status = self.resp?.status {
                    if status == 1 {
                        self.footerNode.text = "未领取的红包，将于24小时后发起退款"
                        self.footerView.isHidden = false
                    } else if status == 3 {
                        self.footerNode.text = "未领取的红包过期后会发起退款"
                        self.footerView.isHidden = false
                    } else {
                        self.footerView.isHidden = true
                    }
                }
        self.headerNode.updateContent(resp: self.resp!)
                self.updateFooterNode()
        self.datas = self.resp!.detailList
                self.tableNode.reloadData()
//            }  catch {
//                print("Error decoding JSON: \(error)")
//            }
//        } failure: { request in
//            
//        }
    } 
    
    private func updateFooterNode() {
        let sectionHeight = 48.0
        let headerHeight = headerViewHeight()
        
        let offsetY = Constants.screenHeight - headerHeight - Constants.navigationHeight - 2 * Constants.bottomInset - (1.0 * 72.0) - sectionHeight
        let y = offsetY-20 > 20  ? offsetY : 40
        
        footerView.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: y)
        footerNode?.frame = CGRect(x: 0, y: y-20, width: Constants.screenWidth, height: 20)
    }
    private func headerViewHeight() -> CGFloat {
        self.resp?.isMyselfReceive == 1 ? 312.0 : 130.0
    }
}

extension RedDetailsViewController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let model = dataSource[indexPath.section].items[indexPath.row]
//        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let isLastCell = (indexPath.row == (datas!.count - 1))
        let block: ASCellNodeBlock = {
            return RedDetailsCellNode(isLastCell: isLastCell, model: self.datas![indexPath.row])
        }
        return block
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("distance: \(offsetY)")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(x: 0, y: 0, width: Constants.screenWidth, height: 48)
        sectionView.backgroundColor = .white
        let contentView = UIView(x: 0, y: 10, width: Constants.screenWidth, height: 38)
        contentView.backgroundColor = .white
        sectionView.addSubview(contentView)
        /*
         "已领取1/5个，共2.26/10.00元"
         5个红包，50秒被抢光
         */
        if resp != nil {
            var label: UILabel! = nil
            if self.resp?.status == 1 {
                sectionView.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
                label = WXCreate.label(text: "已领取\(resp?.receiveNum ?? 0)/\(resp?.num ?? 0)个，共\(resp?.receiveAmount ?? "0")/\(resp?.amount ?? "0")元", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
            } else {
                let prefixStr = (resp?.status == 3) ? "该红包已过期。" : ""
                sectionView.backgroundColor = (resp?.isMyselfReceive == 1) ? Colors.DEFAULT_BACKGROUND_COLOR : .white
                let seconds = (Int(resp?.completeTime ?? "0") ?? 0) / 1000
                let time = formatTime(seconds1: seconds)
                label = WXCreate.label(text: "\(prefixStr)\(resp?.num ?? 0)个红包共\(resp?.amount ?? "0")元，\(time)被抢光", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
            }
            label.frame = CGRect(x: 16, y: 0, width: 300, height: 38)
            contentView.addSubview(label)
            let lineView = UIView(x: 18, y: 37.5, width: Constants.screenWidth - 18, height: 0.5)
            lineView.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
            contentView.addSubview(lineView)
        }
        
        return sectionView
    }
    private func formatTime(seconds1: Int) -> String {
        if seconds1 < 60 {
            return "\(seconds1)秒"
        }
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds1)
        var str = ""
        if hours > 0 {
            str = str + "\(hours)小时"
        }
        if minutes > 0 {
            str = str + "\(minutes)分钟"
        }
        if seconds > 0 {
            str = str + "\(seconds)秒"
        }
        return str
    }
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return (hours, minutes, seconds)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let sectionView = UIView(x: 0, y: 0, width: Constants.screenWidth, height: 48)
//        sectionView.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
//
//        let label = WXCreate.label(text: "未领取的红包，将于24小时后发起退款", textColor: Colors.DEFAULT_TEXT_GRAY_COLOR, fontSize: 14)
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
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "红包记录", handler: { _ in
            self.navigationController?.pushViewController(ReceiveRedViewContrroler(), animated: true)
        }))
        if resp?.senderUserId == GlobalManager.manager.personModel?.userId {
            actionSheet.add(WXActionSheetItem(title: "帮助与反馈", handler: { _ in
                self.navigationController?.pushViewController(ReceiveRedViewContrroler(), animated: true)
            }))
        }
        actionSheet.show()
    }
}
