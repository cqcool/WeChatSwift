//
//  RedDetailsCellNode.swift
//  WeChatSwift
//
//  Created by Aliens on 2024/10/19.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class RedDetailsCellNode: ASCellNode {
    
    private let iconNode = ASNetworkImageNode()
    private let nameNode = ASTextNode()
    private let timeNode = ASTextNode()
    private let moneyNode = ASTextNode()
    private let bestLabelNode = ASTextNode()
    private let besticonNode = ASImageNode()
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init( isLastCell: Bool, model: RedPacketRecordModel) {
        self.isLastCell = isLastCell
        super.init()
        
        automaticallyManagesSubnodes = true
        iconNode.defaultImage = UIImage(named: "login_defaultAvatar")
        iconNode.style.preferredSize = CGSizeMake(44, 44)
        iconNode.cornerRadius = 6
        let headUrl = GlobalManager.headImageUrl(name: model.head ?? "")
        iconNode.url = headUrl
        
        nameNode.attributedText = (model.nickname ?? "").addAttributed(font: .systemFont(ofSize: 17), textColor: .black)
        let time = NSString.timeText(withTimestamp: model.receiveTime ?? 0, formatter: "HH:mm")
        timeNode.attributedText = time.addAttributed(font: .systemFont(ofSize: 15), textColor: Colors.DEFAULT_TEXT_GRAY_COLOR)
        
        moneyNode.attributedText = "\(model.amount ?? "0.00")元".unitTextAttribute(textColor: .black, font:  Fonts.font(.superScriptRegular, fontSize: 17)!, unitFont: Fonts.font(.superScriptRegular, fontSize: 17)!, unit: "元", baseline: 0, kern: 0)
        bestLabelNode.attributedText = "手气最佳".addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(hexString: "#EDA529"))
        besticonNode.image = UIImage(named: "LuckyMoney_WinnerIcon")
        besticonNode.style.preferredSize = CGSize(width: 16, height: 16)
        let isBest = (model.isBest ?? 0) == 0 ? true : false
        bestLabelNode.isHidden = isBest
        besticonNode.isHidden = isBest
        
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.spacingBefore = 18
        
        
        let horizontal1 = ASStackLayoutSpec.horizontal()
        horizontal1.justifyContent = .spaceBetween
        nameNode.style.preferredSize = CGSize(width: 150, height: 19)
        horizontal1.children = [nameNode, moneyNode]
        
        let horizontal3 = ASStackLayoutSpec.horizontal()
        horizontal3.spacing = 0
        horizontal3.verticalAlignment = .center
        horizontal3.children = [besticonNode, bestLabelNode]
        
        let horizontal2 = ASStackLayoutSpec.horizontal()
        horizontal2.justifyContent = .spaceBetween
        besticonNode.style.spacingAfter = 4
        bestLabelNode.style.spacingBefore = 4
        horizontal2.children = [timeNode, horizontal3]
//        if isLastCell {
//        } else {
//            horizontal2.children = [timeNode]
//        }
        
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.children = [horizontal1, horizontal2]
        vertical.style.spacingBefore = 10
        vertical.style.spacingAfter = 15
        vertical.style.flexGrow = 1
        vertical.spacing = 8
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 72)
        horizontal.children = [iconNode, vertical]
        horizontal.verticalAlignment = .center
        
//        lineNode.isHidden = isLastCell
        let offsetX: CGFloat = 18.0 + 44.0
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - offsetX, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: offsetX, y: 72 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [horizontal, lineNode])
    }
}
