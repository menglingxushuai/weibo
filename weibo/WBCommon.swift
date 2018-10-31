//
//  WBCommon.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/18.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import Foundation

// MARK : - 应用程序信息
let WBAppKey = "1280805937"
let WBAppSecret = "cfb9a2352e4f4266a2eb343b74e594a5"
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

// MARK: - 刷新空间高度
/// 刷新状态切换的临界点
let CGRefreshOffset: CGFloat = 102

