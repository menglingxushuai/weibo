
//
//  WBTitleButton.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/22.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    // title 为nil 显示首页 不显示箭头
    init(title: String?) {
        super.init(frame: CGRect.zero)
        
        // 1. 判断title是否为nil
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        sizeToFit()

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard
            let titleLabel = titleLabel,
            let imageView = imageView else {
            return
        }
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleLabel.width, height: height)
        imageView.frame = CGRect(x: titleLabel.width, y: 0, width: imageView.width, height: imageView.height)
        imageView.centerY = titleLabel.centerY

    }
    
}
