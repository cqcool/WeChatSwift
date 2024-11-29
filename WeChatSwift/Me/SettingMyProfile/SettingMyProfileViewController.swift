//
//  SettingMyProfileViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import ZLPhotoBrowser


class SettingMyProfileViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    private var dataSource: [MyProfileSection] = []
//    private var avatarImg: UIImage?
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "个人信息"
        
        setupDataSource()
    }
    private func setupDataSource() {
        let person = GlobalManager.manager.personModel
        let avatar = MyProfileModel(type: .avatar, title: "头像")
        var name = MyProfileModel(type: .name, title: "名字")
        name.value = person?.nickname ?? ""
        let takeShot = MyProfileModel(type: .takeShot, title: "拍一拍")
        var wechatNo = MyProfileModel(type: .wechatNo, title: "微信号")
        wechatNo.value = person?.wechatId ?? ""
        let qrCode = MyProfileModel(type: .qrCode, title: "我的二维码")
        let more = MyProfileModel(type: .more, title: "更多")
        dataSource.append(MyProfileSection(items: [avatar, name, takeShot, wechatNo, qrCode, more]))
        
        let bells = MyProfileModel(type: .bells, title: "来电铃声")
        dataSource.append(MyProfileSection(items: [bells]))
        let wechatPoint = MyProfileModel(type: .wechatPoint, title: "微信豆")
        dataSource.append(MyProfileSection(items: [wechatPoint]))
        let address = MyProfileModel(type: .address, title: "我的地址")
        dataSource.append(MyProfileSection(items: [address]))
        
    }
}

extension SettingMyProfileViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            return MyProfileCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        var model = dataSource[indexPath.section].items[indexPath.row]
        if model.type ==  .avatar {
            
            modifyAvatar(indexPath: indexPath)
            return
        }
        if model.type ==  .name {
            let vc = ModifyNameViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.name = GlobalManager.manager.personModel?.nickname
            present(vc, animated: true)
            vc.confirmBlock = { text in
                model.value = text
                self.dataSource[indexPath.section].items[indexPath.row] = model
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            }
            return
        } 
    }
    
    private func modifyAvatar(indexPath: IndexPath) {
        
        self.wx_navigationBar.isHidden = true
        let minItemSpacing: CGFloat = 2
        let minLineSpacing: CGFloat = 2
        // Custom UI
        ZLPhotoUIConfiguration.default()
            .minimumInteritemSpacing(minItemSpacing)
            .minimumLineSpacing(minLineSpacing)
            .columnCountBlock { Int(ceil($0 / (428.0 / 4))) }
            .showScrollToBottomBtn(false)
         
        ZLPhotoConfiguration.default()
            .maxSelectCount(1)
            .showSelectedIndex(false)
            .showPreviewButtonInAlbum(false)
            .showSelectCountOnDoneBtn(false)
            .autoScrollWhenSlideSelectIsActive(false)
            .allowSlideSelect(false)
            .saveNewImageAfterEdit(false)
            .allowSelectOriginal(false)
            .editAfterSelectThumbnailImage(true)
            .allowSelectGif(false)
            .allowSelectVideo(false)
            .allowMixSelect(false)
            .allowEditImage(true)
            .editImageConfiguration
            .showClipDirectlyIfOnlyHasClipTool(true)
            .clipRatios([.wh1x1])
            .tools([.clip])
        
         ZLPhotoConfiguration.default()
             .cameraConfiguration
             .allowTakePhoto(false)

        ZLPhotoConfiguration.default()
            .canSelectAsset { _ in true }
            .didSelectAsset { _ in }
            .didDeselectAsset { _ in }
            .noAuthorityCallback { type in
                switch type {
                case .library:
                    debugPrint("No library authority")
                case .camera:
                    debugPrint("No camera authority")
                case .microphone:
                    debugPrint("No microphone authority")
                }
            }         /// Using this init method, you can continue editing the selected photo
        let ac = ZLPhotoPreviewSheet(results: nil)
        
        ac.selectImageBlock = { [weak self] results, isOriginal in
            guard let `self` = self else { return }
            guard let image = results.map({ $0.image }).first else { return }
            WXProgressHUD.showProgressMsg("正在加载")
            UploadManager.manager.upload(prefixType: .avatar, number: "1", type: .image, image: image) {obj, error in
                DispatchQueue.main.async {
                    self.wx_navigationBar.isHidden = false
                    if error != nil {
                        WXProgressHUD.brieflyProgressMsg("上传头像失败")
                        return
                    }
                    let head = obj as! String
                    GlobalManager.manager.personModel?.updateHead(headText: head) 
                    var model = self.dataSource[indexPath.section].items[indexPath.row]
                    model.image = image
                    self.dataSource[indexPath.section].items[indexPath.row] = model
                    self.tableNode.reloadRows(at: [indexPath], with: .fade)
                    WXProgressHUD.brieflyProgressMsg("上传头像完成")
                }
            }
            
        }
        ac.cancelBlock = {
            self.wx_navigationBar.isHidden = false
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { errorAssets, errorIndexs in
            self.wx_navigationBar.isHidden = false
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPhotoLibrary(sender: self)
    }
    
}
