//
//  WBUserAccount.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/19.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

@objcMembers
class WBUserAccount: NSObject {
    var access_token: String?
    var uid: String?
    /// 过期日期
    var expires_in: TimeInterval = 0 {
        didSet {
           expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name: String?
    /// 用户头像
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        
        // 从磁盘加载保存的文件 -> 字典
        guard
            let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
                return
        }
        
        yy_modelSet(with: dict ?? [:])
        
//        expiresDate = Date(timeIntervalSinceNow: -3600*48)
//        print(expiresDate)
        
        if expiresDate?.compare(Date()) != ComparisonResult.orderedDescending {
            // 清空tonken
            access_token = nil
            uid = nil
            
            try? FileManager.default.removeItem(atPath: path)
            print("账户过期")
        }
        print("账户正常")
        print("沙盒信息\(self)")
    }
    
    /**
        1.偏好设置
        2.沙盒 归档/plist/json
        3.数据库
        4.钥匙串（- 需要使用框架 SSKeychain）
     */
    
    func saveAccount() {
        
        var dict = self.yy_modelToJSONObject() as? [String: AnyObject]
       
        dict?.removeValue(forKey: "expires_in")
        
     guard
        let data = try? JSONSerialization.data(withJSONObject: dict as Any, options: []),
        let filePath = accountFile.cz_appendDocumentDir() else {
            return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("保存信息成功:\(filePath)")
        
    }
}
