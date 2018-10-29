//
//  WBNetworkManager.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/16.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import AFNetworking

enum WBHTTPMethod {
    case POST
    case GET
}

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    /**
        单利
        静态区/常量/闭包
        在第一次访问时，执行闭包，并且将结果保存在 shared中
     */
    static let shared = WBNetworkManager()
    
    
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标记（计算性属性）
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method:WBHTTPMethod, URLString: String, parameters: [String: AnyObject]?, completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
     
        // 判断token,程序执行过程中一般不会为nil
        guard let token = userAccount.access_token else {
            print("没有token！需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            return
        }
        // 处理token字典
        var parameters = parameters
        
        if parameters == nil {
            parameters = [String: AnyObject]()
        }
        // 字典一定有值
        parameters!["access_token"] = token as AnyObject
        
        // 处理真正的请求
        request(method:method , URLString: URLString, parameters: parameters, completion: completion)
    }
    
    
    /// 使用一个函数封装 AFN 的 post/get请求
    func request(method:WBHTTPMethod, URLString: String, parameters: [String: AnyObject]?, completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // ()->() 参数  返回值 in 闭包写法
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json as AnyObject, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token过期了")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            }
            
            print("网络请求错误\(error)")
            completion(error as AnyObject, false)
        }
        
        let progress = { (progress: Progress) -> () in
            
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }
        
    }
}
