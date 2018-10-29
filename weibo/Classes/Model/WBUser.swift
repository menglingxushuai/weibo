//
//  WBUser.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

/// 微博用户模型
@objcMembers
class WBUser: NSObject {
    // 基本数据类型和private不能使用KVC
    var id: Int64 = 0
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    /// 认证类型
    var verified_type: Int = 0
    /// 会员等级
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
