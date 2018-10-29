//
//  UIColor+Extension.swift
//  weibo
//
//  Created by xiaotong on 2018/9/14.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 哈希值标注
    convenience init(hex: String, a: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: a
        )
    }
    
    /// RGB色值标注
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a:CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    
}
