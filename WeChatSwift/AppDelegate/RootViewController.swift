//
//  RootViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/12/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class RootViewController: ASTabBarController {
    
    private var chatsVC: SessionViewController!
    
    private var contactsVC: ContactsViewController!
    
    private var discoverVC: DiscoverViewController!
    
    private var meVC: MeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ASDisableLogging()
        buildTabbarContents()
        
        tabBar.unselectedItemTintColor = UIColor(hexString: "#181818")
        let controllers = [chatsVC, contactsVC, discoverVC, meVC]
        controllers.forEach { $0?.tabBarItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 9.5)
        ], for: .normal) }
        
        let chatNav = UINavigationController(rootViewController: chatsVC)
        let contactsNav = UINavigationController(rootViewController: contactsVC)
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        let meNav = UINavigationController(rootViewController: meVC)
        
        viewControllers = [chatNav, contactsNav, discoverNav, meNav]
        tabBar.tintColor = Colors.tintColor
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage.imageFromColor(.clear), for: .normal, barMetrics: .default)
        
        if #available(iOS 15.0, *) {
            let appearnce = UITabBarAppearance()
            appearnce.configureWithOpaqueBackground()
            appearnce.backgroundColor = UIColor(hexString: "#F5F5F5")
            tabBar.standardAppearance = appearnce
            tabBar.scrollEdgeAppearance = appearnce
        }
        
        

    }
    
    func handleLanguageDidChanged() {
        selectedIndex = 3
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    func buildTabbarContents() {
        // Do any additional setup after loading the view.
        chatsVC = SessionViewController()
        chatsVC.tabBarItem.selectedImage = HomeTab.chats.selectedImage
        chatsVC.tabBarItem.image = HomeTab.chats.image
        chatsVC.tabBarItem.title = LocalizedString("TabBar_MainFrameTitle")
        chatsVC.tabBarItem.tag = 0
        
        contactsVC = ContactsViewController()
        contactsVC.tabBarItem.selectedImage = HomeTab.contacts.selectedImage
        contactsVC.tabBarItem.image = HomeTab.contacts.image
        contactsVC.tabBarItem.title = LocalizedString("TabBar_ContactsTitle")
        contactsVC.tabBarItem.tag = 1
        
        discoverVC = DiscoverViewController()
        discoverVC.tabBarItem.selectedImage = HomeTab.discover.selectedImage
        discoverVC.tabBarItem.image = HomeTab.discover.image
        discoverVC.tabBarItem.title = LocalizedString("TabBar_FindFriendTitle")
        discoverVC.tabBarItem.tag = 2
        
        meVC = MeViewController()
        meVC.tabBarItem.selectedImage = HomeTab.me.selectedImage
        meVC.tabBarItem.image = HomeTab.me.image
        meVC.tabBarItem.title = LocalizedString("TabBar_MoreTitle")
        meVC.tabBarItem.tag = 3
        
    }
}

enum HomeTab: String {
    case chats
    case contacts
    case discover
    case me
    
    var selectedImage: UIImage? {
        get {
            let name = "icons_filled_\(rawValue)"
            return UIImage.SVGImage(named: name, fillColor: Colors.tintColor)
        }
    }
    
    var image: UIImage? {
        get {
            let name = "icons_outlined_\(rawValue)"
            return UIImage.SVGImage(named: name, fillColor: UIColor.black)
        }
    }
}
let lxfFlag: Int = 100
let itemIndex: Int = 0
extension UITabBar {
    
    // MARK: - 显示小红点
    
    func showBadgOn(index: HomeTab = .discover, tabbarItemNums: CGFloat = 4.0) {
        // 移除之前的小红点
        removeBadgeOn(index: index)
        // 创建小红点
        let bageView = UIView()
        bageView.tag = 2 + lxfFlag
        bageView.layer.cornerRadius = 4
        bageView.backgroundColor = UIColor.red
        let tabFrame = frame
        // 确定小红点的位置
        let percentX: CGFloat = (CGFloat(itemIndex) + 0.55) / tabbarItemNums
        
        let x: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let y: CGFloat = CGFloat(ceilf(Float(0.08 * tabFrame.size.height)+2.0))
        bageView.frame = CGRect(x: x, y: y, width: 8, height: 8)
        addSubview(bageView)
    }
    // MARK: - 隐藏小红点
    func hideBadg(index: HomeTab = .discover) {
        removeBadgeOn(index: index)
    }
    // MARK: - 移除小红点
    fileprivate func removeBadgeOn(index itemIndex: HomeTab) {
        // 按照tag值进行移除
        _ = subviews.map {
            if $0.tag == 2 + lxfFlag {
                $0.removeFromSuperview()
            }
        }
    }
}

