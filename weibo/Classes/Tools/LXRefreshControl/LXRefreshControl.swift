//
//  LXRefreshControl.swift
//  weibo
//
//  Created by xiaotong on 2018/10/26.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

/// 刷新控件
class LXRefreshControl: UIControl {
    
    private weak var scrollView: UIScrollView?
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        // 记录父视图
        scrollView = sv
        
        // KVO监听父视图的contentoffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 本视图从父视图上移除
    // 提示：所有的下拉刷新框架都是监听父视图的 contentOffset
    // 所有的框架的 KVO 监听实现思路都是这个！
    override func removeFromSuperview() {
        
        // superView 还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        // superView 不存在
    }
    
    // kvo会统一调用此方法
    // 观察者模式，在不需要的时候，都需要被释放
    //  - 通知中心：如果不释放。什么也不会发生，但是会有内存泄露，会d有多次注册的发生
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // contentOffset y值跟 contentInset 的 top 有关
        guard let sv = scrollView else {
            return
        }
        
        print(sv.contentInset)
        
        print(sv.contentOffset)
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        // 根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.width, height: height)
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
    }
    /// 结束刷新
    func endRefreshing() {
        
    }

    private func setupUI() {
        backgroundColor = UIColor.orange
    }
}
