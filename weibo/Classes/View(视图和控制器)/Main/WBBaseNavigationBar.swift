//
//  WBBaseNavigationBar.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/11.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBBaseNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let statusRect: CGRect = UIApplication.shared.statusBarFrame
        
        if #available(iOS 11.0, *) {
            
            for subview in self.subviews {
                
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                
                if stringFromClass.elementsEqual("_UINavigationBarContentView") {
                   
                    subview.frame = CGRect(x: 0, y: statusRect.height, width: subview.width, height: 44)
                } else if stringFromClass.elementsEqual("_UIBarBackground") {
                    subview.frame = self.bounds
                }
            }
        }
        
        
    }
}
