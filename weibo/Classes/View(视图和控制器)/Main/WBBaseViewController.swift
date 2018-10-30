//
//  WBBaseViewController.swift
//  weibo
//
//  Created by xiaotong on 2018/9/14.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

// 面试题: OC 中支持多继承吗？ 不支持 如何替代 答案：使用协议替代
// swift 的写法更类似多继承

// swift 中 利用extension 可以把‘函数’按照功能分类管理，便于阅读和维护
// - 1.extension 中不能拥有属性
// - 2.extension 中不能重写父类方法 ，重写父类方法是子类的职责。扩展是对类的扩展
class WBBaseViewController: UIViewController {
   
    /// 访客视图信息x字典
    var visitorInfoDict:[String: String]?
    /// 表格视图 - 如果用户没有登录就不创建
    var tableView: UITableView?
    var refreshControl: LXRefreshControl?
    /// 上拉刷新标记
    var isPullUp = false
    
    lazy var navigationBar = WBBaseNavigationBar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: NAVH))
    
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        WBNetworkManager.shared.userLogon ? loadData() : ()

        /// 登录成功修改界面
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotificaiton), object: nil)

    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func loginSuccess(n: Notification) {
        print("登陆成功")
        
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新UI -> 需要重新设置view
        // 在访问view的getter时，如果view == nil 会调用 loadView -> viedDidLoad
        view = nil
        // 注销通知 -> 重新c执行viewDidLoad会再辞注册，避免通知被重复注册
        NotificationCenter.default.removeObserver(self)

    }
    
    /// 加载数据 - 具体实现由子类负责、
    @objc func loadData() {
        refreshControl?.endRefreshing()
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
}

// MARK: - 注册登录的点击事件
extension WBBaseViewController {
    @objc private func regist() {
        print("注册")
    }
    
    @objc private func login() {
        print("登录")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
}

// MARK: - 设置界面
extension WBBaseViewController {
    // 可以用dynamic（动态）改为OC方法进行重写 --未尝试
    private func setupUI() {
        view.backgroundColor = UIColor.white

        setupNavgationBar()
        
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    /** 设置表格视图 */
    @objc dynamic func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: NAVH, width: view.width, height: view.height - NAVH), style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        // 设置内容缩进
//        tableView?.contentInset = UIEdgeInsets.init(top:44, left: 0, bottom: 0, right: 0)
        // 滚动条 强行解包是为了拿到一个c必有的 inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        // 设置刷新控件
        refreshControl = LXRefreshControl()
        tableView?.addSubview(refreshControl!)
        
        // 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    /// 设置访客视图
    private func setupVisitorView() {
        let visitorView = WBBaseVisitorView.init(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        visitorView.visitorInfo = visitorInfoDict
        visitorView.registBtn.addTarget(self, action: #selector(regist), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(regist))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))

    }
    
    private func setupNavgationBar() {
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        // 设置navBar的渲染颜色
        navigationBar.barTintColor = UIColor.init(hex: "F6F6F6")
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WBBaseViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法, 子类负责具体实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == (count - 1) && !isPullUp{
            print("上拉刷新")
            isPullUp = true
            loadData()
        }
    }
    
}
