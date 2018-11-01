//
//  WBComposeTypeButton.swift
//  weibo
//
//  Created by xiaotong on 2018/10/31.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 要展示控制器的类名
    var clsName: String?
    /// 使用图像名称/标题 创建
    class func composeTypeButton(imageName: String, title: String) -> WBComposeTypeButton {
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let button = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        button.imageView.image = UIImage(named: imageName)
        button.titleLabel.text = title
        return button
    }

}
