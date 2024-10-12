//
//  WeChatRegisterViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//注册页面
class WeChatRegisterViewController: UIViewController,WeChatCustomNavigationHeaderDelegate,
                                    UITableViewDelegate,UITableViewDataSource {
    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 44
    let fontName:String = "AlNile"
    let topPadding:CGFloat = 20
    
    let tableHeaderHeight:CGFloat = 80
    let bottomHeight:CGFloat = 40
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initFrame()
    }
    
    func initFrame(){
        initNavigationBar()
        initTableView()
        addBottom()
    }
    
    //MARKS: 自己定义导航条
    func initNavigationBar(){
        //获取状态栏
        let statusBarFrame = UIApplication.shared.statusBarFrame
        self.navigationHeight += statusBarFrame.height
        
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.main.bounds.width, navigationHeight), backImage: nil, backTitle: "取消", centerLabel: "", rightButtonText: "", rightButtonImage: nil, backgroundColor: UIColor.white, leftLabelColor: UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1), rightLabelColor: nil)
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
    }
    
    func initTableView(){
        self.tableView = UITableView()
        self.tableView.frame = CGRectMake(0, self.navigationHeight, self.view.frame.width, self.view.frame.height - self.navigationHeight - self.bottomHeight)
        
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
        initTableHeaderView()
    }
    
    //MARKS: 初始化tableHeader
    func initTableHeaderView(){
        //画底部线条
        //let shape = WeChatDrawView().drawLineAtLast(0,height: headerView.frame.height)
        //shape.lineWidth = 0.2
        //headerView.layer.addSublayer(shape)
        
        let topView = UIView()
        topView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableHeaderHeight)
        topView.backgroundColor = .white
        
        let label = createLabel(
            frame: CGRectMake(0, topPadding, self.view.frame.width, 30),
            string: "请输入你的手机号码",
            color: .black,
            font: UIFont(name: self.fontName, size: 25)!)
        label.textAlignment = .center
        topView.addSubview(label)
        
        self.tableView.tableHeaderView =  topView
    }
    
    //MARKS: 添加底部协议
    func addBottom(){
        let bottomView = UIView()
        bottomView.frame = CGRectMake(0, UIScreen.main.bounds.height - self.bottomHeight, UIScreen.main.bounds.width, self.bottomHeight)
        
        let font = UIFont(name: self.fontName,size: 10)
        let label1 = createLabel(frame: CGRectMake(0, 10, bottomView.frame.width, 10), string: "轻触上面的“注册”按钮,即表示你同意\n", color: UIColor.darkGray, font: font!)
        label1.textAlignment = .center
        
        let label2 = createLabel(frame: CGRectMake(0, label1.frame.origin.y + label1.frame.height + 2, bottomView.frame.width, label1.frame.height), string: "《WeChat软件许可及服务协议》", color: UIColor(red: 0/255,green:191/255,blue:255/255,alpha:1), font: font!)
        label2.textAlignment = .center
        
        bottomView.addSubview(label1)
        bottomView.addSubview(label2)
        self.view.addSubview(bottomView)
    }
    
    func createLabel(frame:CGRect,string:String,color:UIColor,font:UIFont) -> UILabel{
        let label = UILabel(frame: frame)
        label.font = font
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
        return label
    }
    
    func createTextField(frame:CGRect,placeholder:String) -> UITextField{
        let textField = UITextField(frame: frame)
        textField.frame = frame
        textField.placeholder = placeholder
        textField.font = UIFont(name: "宋体", size: 16)
        textField.contentMode = .center
        textField.borderStyle = .none
        textField.tintColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)//设置光标颜色
        textField.keyboardType = .phonePad
        return textField
    }
    
    //MARKS: 返回每组行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARKS: 返回分组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return lastCellHeight
        }
        
        return cellHeight
    }
    
    let cellLeftPadding:CGFloat = 15
    let cellComponentHeight:CGFloat = 25
    
    var labelLeftWidth:CGFloat = 0
    let addLabelWidth:CGFloat = 10
    let addLabelHeight:CGFloat = 20
    let cellTextFieldLeftPadding:CGFloat = 7
    let cellButtonTopPadding:CGFloat = 20
    let cellButtonHeight:CGFloat = 40
    
    let cellHeight:CGFloat = 40
    let lastCellHeight:CGFloat = 60
    let cellWidth:CGFloat = UIScreen.main.bounds.width
    
    var phoneTextField:UITextField?
    var registerBtn:UIButton?
    var numberTextField:UITextField?
    var loadingView:WeChatNormalLoadingView?
    var loadingViewWidth:CGFloat = 120
    var loadingViewHeight:CGFloat = 120
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }
        
        for view in cell!.subviews {
            view.removeFromSuperview()
        }
        
        labelLeftWidth = (cellWidth - cellLeftPadding) / 4
        
        let toppadding:CGFloat = (cellHeight - cellComponentHeight) / 2
        
        if indexPath.row == 0 {//国家/地区
            let areaLabel = createLabel(
                frame: CGRectMake(cellLeftPadding, toppadding, labelLeftWidth, cellComponentHeight),
                string: "国家/地区",
                color: UIColor.black,
                font: UIFont(name: self.fontName, size: 15)!)
            
            let countryLabel = createLabel(
                frame: CGRectMake(cellLeftPadding + labelLeftWidth + cellTextFieldLeftPadding, toppadding, cellWidth - cellLeftPadding - labelLeftWidth, cellComponentHeight),
                string: "中国",
                color: UIColor.black,
                font: UIFont(name: self.fontName, size: 15)!)
            
            cell?.addSubview(areaLabel)
            cell?.addSubview(countryLabel)
            cell?.accessoryType = .disclosureIndicator//显示右箭头
        } else if indexPath.row == 1 { //电话号码
            
            let addLabel = createLabel(
                frame: CGRectMake(cellLeftPadding, (cell!.frame.height - addLabelHeight ) / 2, addLabelWidth, addLabelHeight),
                string: "+",
                color: UIColor.black,
                font: UIFont(name: self.fontName, size: 25)!)
            cell?.addSubview(addLabel)
            
            let numberBeginX:CGFloat = addLabelWidth + cellLeftPadding
            self.numberTextField = createTextField(frame: CGRectMake(numberBeginX, toppadding, labelLeftWidth - addLabelWidth, cellComponentHeight), placeholder: "")
            numberTextField!.text = "86"
            //numberTextField?.font = UIFont(name: self.fontName, size: 22)
            cell?.addSubview(numberTextField!)
            
            let phoneWidth:CGFloat = cell!.frame.width - cellLeftPadding - labelLeftWidth
            let phoneBeginX:CGFloat = cellLeftPadding + labelLeftWidth + cellTextFieldLeftPadding
            self.phoneTextField = createTextField(frame: CGRectMake(phoneBeginX, toppadding, phoneWidth, cellComponentHeight), placeholder: "请输入手机号码")
            //phoneTextField?.font = UIFont(name: self.fontName, size: 22)
            
            //注册change事件通知
            NotificationCenter.default.addObserver(self, selector: #selector(phoneTextChange), name: UITextField.textDidChangeNotification, object: phoneTextField)
            cell?.addSubview(self.phoneTextField!)
            
            let lineShape = WeChatDrawView().drawLine(beginPointX: cellLeftPadding + labelLeftWidth, beginPointY: 0, endPointX: cellLeftPadding + labelLeftWidth, endPointY:cellHeight,color:.darkGray)
            
            lineShape.lineWidth = 0.1
            cell?.layer.addSublayer(lineShape)
            
        } else if indexPath.row == 2 { //注册按钮
            self.registerBtn = UIButton(type: .custom)
            registerBtn!.frame = CGRectMake(cellLeftPadding, cellButtonTopPadding, cellWidth - cellLeftPadding * 2, cellButtonHeight)
            registerBtn!.setTitle("注册", for: .normal)
            registerBtn!.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)
            registerBtn!.setTitleColor(UIColor.white, for: .normal)
            registerBtn!.isEnabled = false
            registerBtn!.layer.cornerRadius = 3
            registerBtn!.layer.masksToBounds = true
            cell?.addSubview(registerBtn!)
            
            registerBtn!.addTarget(self, action: #selector(registerBtnClick), for: UIControl.Event.touchUpInside)
        }
        
        //添加底部线条
        if indexPath.row == 0 || indexPath.row == 1 {
            let shape = WeChatDrawView().drawLineAtLast(beginX: cellLeftPadding,height: cellHeight)
            shape.lineWidth = 0.1
            cell?.layer.addSublayer(shape)
        }
        
        
        cell?.selectionStyle = .none
       // cell?.layer.borderWidth = 1
        
        return cell!
    }
    
    //MARKS: 创建加载View
    func createLoadingView(){
        if loadingView == nil {
            let beginY:CGFloat = (self.view.frame.height - navigationHeight) / 2 - self.loadingViewHeight / 2
            let beginX:CGFloat = self.view.frame.width / 2 - self.loadingViewWidth / 2
            
            loadingView = WeChatNormalLoadingView(frame: CGRectMake(beginX, beginY, loadingViewWidth, loadingViewHeight), labelText: "请稍候...")
        }
        self.view.addSubview(loadingView!)
    }
    
    
    //MARKS: 注册按钮点击事件
    @objc func registerBtnClick(){
        self.createLoadingView()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("validateNumber")), userInfo: nil, repeats: false)
    }
    
    func validateNumber(){
        self.loadingView?.removeFromSuperview()
        if self.phoneTextField?.text?.count != 11 {
            createErrorAlert()
        }else{
            createCorrectAlert()
        }
    }
    
    func createErrorAlert(){
        let alertController = UIAlertController(title: "手机号码错误", message: "你输入的是一个无效的手机号码", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default,handler: nil)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createCorrectAlert(){
        let alertController = UIAlertController(title: "确认手机号码", message: "我们将发送验证码短信到这个号码:\n" + self.phoneTextField!.text!, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let okAction = UIAlertAction(title: "好", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.createLoadingView()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.openSendMsgViewController), userInfo: nil, repeats: false)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func openSendMsgViewController(){
        self.loadingView?.removeFromSuperview()
    }
    
    
    //MARKS: 手机号码textField改变事件
    @objc func phoneTextChange(){
        if !self.phoneTextField!.text!.isEmpty {
            self.registerBtn?.isEnabled = true
        } else {
            self.registerBtn?.isEnabled = false
        }
        
        if (self.phoneTextField!.text?.count)! > 11 {
            var text = NSString(string: self.phoneTextField!.text!)
            let range = NSRange(location: 0,length: 11)
            text = text.substring(with: range) as NSString
            self.phoneTextField!.text = text as String
        }
        
    }
    
    //MARKS: 取消事件
    func leftBarClick() {
        self.numberTextField?.resignFirstResponder()
        self.phoneTextField?.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    //MARKS: 返回每行的单元格
    func rightBarClick() {
        
    }
    
}
