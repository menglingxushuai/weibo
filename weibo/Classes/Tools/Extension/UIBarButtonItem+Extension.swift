//
//  UIBarButtonItem+Extension.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/11.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - normalColor: normalColor 默认darkGray
    ///   - highlightedColor: highlightedColor 默认orange
    ///   - fontSize: fontSize 默认16
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否为返回按钮
    convenience init(title: String, normalColor: UIColor = UIColor.darkGray, highlightedColor: UIColor = UIColor.orange, fontSize: CGFloat = 16, target: Any, action: Selector, isBack:Bool = false) {
                
        let btn:UIButton = UIButton.mg_button(withTitle: title, normalColor: normalColor, highlightedColor: highlightedColor, fontSize: fontSize, target: target, action: action)
        if isBack {
            btn.setImage(UIImage(named: "navigationbar_back_withtext"), for: .normal)
            btn.setImage(UIImage(named: "navigationbar_back_withtext_highlighted"), for: .highlighted)
        }
        self.init(customView: btn)
    }
}

