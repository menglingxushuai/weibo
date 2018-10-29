//
//  WBMainNavController.swift
//  weibo
//
//  Created by xiaotong on 2018/9/12.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBMainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏默认的 NavigationBar
        navigationBar.isHidden = true
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
            
            if let vc = viewController as? WBBaseViewController {
                var title = "返回"
                if childViewControllers.count == 1 {
                    // title显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                // 取出自定义的navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem.init(title: title, target: self, action: #selector(goToParent), isBack:true)
            }
            
        }
        
        // 判断控制器类型
        
        super.pushViewController(viewController, animated: animated)

    }
    
    
    @objc private func goToParent() {
        popViewController(animated: true)
    }
}


