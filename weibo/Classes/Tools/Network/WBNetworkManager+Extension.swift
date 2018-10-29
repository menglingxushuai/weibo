//
//  WBNetworkManager+Extension.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/16.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0。
    ///   - completion: 完成回调
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion:@escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        // 用网络工具加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // Swift中 Int可以转换成AnyObject,但是Int64不行
        let paremters = [
            "since_id" : "\(since_id)",
            "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(method: .GET, URLString: urlString, parameters: paremters as [String : AnyObject]) { (json, success) in
            let result = json?["statuses"] as? [[String: AnyObject]]    
            completion(result, true)
        }
        
    }
 
}

// MARK : - 用户信息
extension WBNetworkManager {
    func loadUserInfo(completion:@escaping (_ json: [String: AnyObject]) -> ()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        let pamraters = ["uid" : uid as AnyObject]
        
        tokenRequest(method: .GET, URLString: urlStr, parameters: pamraters) { (json, isSuccess) in
            completion((json as? [String : AnyObject]) ?? [:])
        }
    }
}

// MARK : - Oauth2相关
extension WBNetworkManager {
    // 加载accessToken
    func loadAccessToken(code: String, completion: @escaping (_ isSucceess: Bool) -> ()) {
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        request(method: .POST, URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccees) in
            
            self.userAccount.yy_modelSet(withJSON: json as Any)
            
            // 加载用户当前信息
            self.loadUserInfo(completion: { (dict) in
                self.userAccount.yy_modelSet(with: dict)
                self.userAccount.saveAccount()
                completion(isSuccees)
            })
            
        }
        
    }
}
