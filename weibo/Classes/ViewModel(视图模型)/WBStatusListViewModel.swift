//
//  WBStatusListViewModel.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/17.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import Foundation
import SDWebImage

/// 微博数据列表视图模型
/*
    父类的选择
 
    - 如果类需要使用 ‘KVC’ 或者字典转模型框架设置对象值，需要继承自NSObject
    - 如果类只是包装一些代码逻辑（写了一些函数),可以不用任何父类, 好处 ：更加轻量级
 
    使命：负责微博的数据处理
    1.字典转模型
    2.下拉、上拉的刷新处理
 */


/// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    lazy var statusList = [WBStatusViewModel]()
    /// 上拉错误次数
    private var pullErrorTimes = 0
    
    func loadStatus(pullup: Bool, completion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool ) -> ()) {
        
        // 判断是否是上拉刷新，同时检查刷新次数
        if pullup &&  pullErrorTimes > maxPullupTryTimes {
            completion(false, false)
            return
        }
        
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (listResult, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
                return
            }
            
            var array = [WBStatusViewModel]()
            
            for dict in listResult ?? [] {
                guard let model = WBStatus.yy_model(with: dict) else {
                    continue
                }
                array.append(WBStatusViewModel(model: model))
            }
            
//            print("数据\(array)")
            // 2.拼接数据
            // 下拉刷新应该将最新的数据放在前面
            
            if pullup {
                self.statusList += array
            } else {
                self.statusList = array + self.statusList
            }
            
            // 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullErrorTimes += 1
                completion(isSuccess, false)
            } else {
                // 通过参数传递闭包 缓存之后刷新表格
                self.cacheSingleImage(list: array, finished: completion)
            }
        }
    }
    
    /// 缓存本次下载微博数据中的单张图像
    /// 本次下载的图像模型数组
    /// 应该缓存完单张图像，并且修改过配图的大小之后 在回调 保证表格显示单张图像
    
    private func cacheSingleImage(list: [WBStatusViewModel], finished:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 遍历数组如果有单张图像的，进行缓存
        for vm in list {
            // 1> 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            // 2> 获取图像模型 数组中有且仅有一张
            guard let pic = vm.picURLs![0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            
            
            // 3> 下载头像
            // downloadImage是SDWebImage的核心功能 下载完成之后保存在沙盒 路径是url的MD5
            // 如果沙盒中已经存在缓存的数据，会先从沙盒加载 不会发起网络请求，同时回调方法同样会调用
            
            // 入组
            group.enter()
            
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _) in

            if let image = image,
            let data = UIImagePNGRepresentation(image) {
                length = length + data.count
                print("图像\(image)长度\(length)")
                
                // 图像缓存成功
                vm.updataSingleImageSize(image: image)
            }
            
            group.leave()
            
            })
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("图像下载完成\(length/1024)k")
            finished(true, true)
        }
    }
    
}
