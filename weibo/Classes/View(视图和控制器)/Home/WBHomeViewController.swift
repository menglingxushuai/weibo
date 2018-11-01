//
//  WBHomeViewController.swift
//  weibo
//
//  Created by xiaotong on 2018/9/12.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用 private 修饰,否则到处都可以访问
private let originalcellId = "originalcellId"
// 被转发的cellId
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {

    /// 列表视图模型
    private lazy var listViewModel = WBStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /// 加载数据
    override func loadData() {
        
//        refreshControl?.beginRefreshing()
//        
//        listViewModel.loadStatus(pullup: self.isPullUp) { (isSuccess, shouldRefresh) in
//            self.refreshControl?.endRefreshing()
//            self.isPullUp = false
//            if shouldRefresh {
//                self.tableView?.reloadData()
//            }
//        }
    }
    
}

// MARK: - 表格数据源方法
extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取出视图模型判断可重用cell
        let vm = listViewModel.statusList[indexPath.row]
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalcellId
                
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell

        cell.viewModel = listViewModel.statusList[indexPath.row]
        
        return cell
    }
    // 没有override在swift2.0时没问题，3.0后没有这个父类方法，不会被调用
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight ?? 0
    }
}
// MARK: - 设置界面
extension WBHomeViewController {
    
    // 设置导航栏标题
    private func setupNavTitle() {
        
        guard let screen_name = WBNetworkManager.shared.userAccount.screen_name else {
            return
        }
        
        let button = WBTitleButton(title: screen_name)
        button.addTarget(self, action: #selector(navTitleClick), for: .touchUpInside)
        navItem.titleView = button
    }
    
    override func setupTableView() {
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", target: self, action: #selector(showFriends))
        
        view.backgroundColor = UIColor.white
        
        // 注册原型 cell
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalcellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)

        // 设置行高
        tableView?.estimatedRowHeight = 300
        tableView?.rowHeight = UITableViewAutomaticDimension
        // 取消分割线
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    // 监听
    @objc func navTitleClick(b: UIButton) {
        b.isSelected = !b.isSelected
    }
    
    @objc private func showFriends() {
        print(#function)
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
