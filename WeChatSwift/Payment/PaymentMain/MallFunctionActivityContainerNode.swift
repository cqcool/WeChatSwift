//
//  MallFunctionActivityContainerNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MallFunctionActivityContainerNode: ASDisplayNode {
    
    private let titleNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    private var activitiesNode: [MallFunctionActivityNode] = []
    
    static let nodeItemHeight: CGFloat = 100
    static let itemOffsetY: CGFloat = 30
    
    init(title: String, activities: [MallFunctionActivity]) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "#716F76")
            ])
        
        lineNode.backgroundColor = .clear//(hexString: "#E5E5E5")
        
        for activity in activities {
            activitiesNode.append(MallFunctionActivityNode(activity: activity))
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 10
        cornerRoundingType = .defaultSlowCALayer
    }
 
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 32, height: 18)
        titleNode.style.layoutPosition = CGPoint(x: 16, y: 17.5)
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 0, y: 52)
        
        let itemWidth = constrainedSize.max.width/4
        for (index, activityNode) in activitiesNode.enumerated() {
            activityNode.style.preferredSize = CGSize(width: itemWidth, height: MallFunctionActivityContainerNode.nodeItemHeight)
            let col = index % 4
            let row = index / 4
            activityNode.style.layoutPosition = CGPoint(x: CGFloat(col) * itemWidth, y: CGFloat(row) * MallFunctionActivityContainerNode.nodeItemHeight + MallFunctionActivityContainerNode.itemOffsetY)
        }
        
        var elements = [titleNode, lineNode]
        elements.append(contentsOf: activitiesNode)
        
        return ASAbsoluteLayoutSpec(children: elements)
        
//        layout.children = [titleNode, lineNode] + activitiesNode
        
//        return layout
    }
}
