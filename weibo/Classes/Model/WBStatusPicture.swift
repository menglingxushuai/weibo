//
//  WBStatusPicture.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

@objcMembers
class WBStatusPicture: NSObject {
    
    /// 缩略图地址
    var thumbnail_pic: String?

    var largePic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
