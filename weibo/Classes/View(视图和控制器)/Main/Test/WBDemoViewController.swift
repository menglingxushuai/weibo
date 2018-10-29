//
//  WBDemoViewController.swift
//  weibo
//
//  Created by xiaotong on 2018/9/14.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setpUI()
        view.backgroundColor = UIColor.randomColor
        title = "我是\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc private func showNext() {
        let next = WBDemoViewController()
        navigationController?.pushViewController(next, animated: true)
    }
    
}

extension WBDemoViewController {
    
    private func setpUI() {
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", target: self, action: #selector(showNext))
    }
}

