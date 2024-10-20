//
//  NewsViewController.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/20.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation

import AsyncDisplayKit

class NewsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "腾讯新闻"
        let moreItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_setting"), style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(Constants.screenWidth - 40, 390+44)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: Constants.navigationHeight, width: Constants.screenWidth, height: Constants.screenHeight - Constants.navigationHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NewsCellNode.self, forCellWithReuseIdentifier: "NewsCellNode")
        view.addSubview(collectionView)
    }
    
    @objc func handleMoreButtonClicked() {
        navigationController?.pushViewController(NewDetailsViewController(), animated: true)
        
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCellNode", for: indexPath)
        (cell as! NewsCellNode).cellForModel(model: nil)
        return cell
    }
    
   
}
