//
//  WBComposeViewController.swift
//  weibo
//
//  Created by xiaotong on 2018/11/1.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.randomColor
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "退出", target: self, action: #selector(close))
    }
    

    @objc private func close() {
        dismiss(animated: true) {
            
        }
    }
}
