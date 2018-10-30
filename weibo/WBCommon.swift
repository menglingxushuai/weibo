//
//  WBCommon.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/18.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import Foundation

// MARK : - 应用程序信息
let WBAppKey = "1437197467"
let WBAppSecret = "ac5c60952f11d95a7422955fbba4f7d3"
let WBRedirectURI = "http://baidu.com"

// MARK : - 全局通知定义
/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功
let WBUserLoginSuccessNotificaiton = "WBUserLoginSuccessNotificaiton"


// MARK : - 沙盒路径
let accountFile: NSString = "useraccount.json"

// MARK : - 微博视图配图常量
/// 配图外侧间距
let WBStatusPictureViewOutterMagrin = CGFloat(12)
/// 配图内部视图的间距
let WBStatusPictureViewInnerMargin = CGFloat(10)
/// 视图的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureViewOutterMagrin
// 每个Item的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3
// 导航条高
let NAVH = 44 + UIApplication.shared.statusBarHeight

