//
//  WBStatus.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/17.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import YYModel
/// 微博数据模型
@objcMembers
class WBStatus: NSObject {
    /// Int 类型，在64 位的机器是64 位， 在32位机器是32位
    /// 如果不写Int64 在iPad2 / iPhone5/5c/4s/4 无法运行 会溢出
    var id: Int64 = 0
    /// 微博创建时间
    var created_at: String?
    /// 微博来源
    var source: String?
    /// 微博信息内容
    var text:String?
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 表态数
    var attitudes_count: Int = 0
    /// 微博的用户
    var user: WBUser?
    /// 微博配图模型数组
    var pic_urls: [WBStatusPicture]?
    /// 转发微博
    var retweeted_status: WBStatus?
    
    /// 重写description的计算性属性
    override var description: String {
        return yy_modelDescription()
    }
    
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": WBStatusPicture.self]
    }
}

