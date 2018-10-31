//
//  LXRefreshControl.swift
//  weibo
//
//  Created by xiaotong on 2018/10/26.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit


/// 刷新状态
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点 如果放手开始刷新
/// - WillRefresh: 用户超过临界点并且放手
enum LXRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新控件 - 负责刷新相关的逻辑处理
class LXRefreshControl: UIControl {
    
    private weak var scrollView: UIScrollView?
    /// 刷新视图
    private lazy var refreshView: LXRefreshView = LXRefreshView.refreshView()
    
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
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        // 根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.width, height: height)
        
        // --- 传递父视图高度，如果正在刷新中，不传递
        // --- 把代码放在`最合适`的位置！
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
        
        // 判断临界点
        if sv.isDragging {
            if (height > CGRefreshOffset) && (refreshView.refreshState == .Normal) {
                print("放手更新")
                refreshView.refreshState = .Pulling
            } else if (height < CGRefreshOffset) && (refreshView.refreshState == .Pulling){
                print("再使劲")
                refreshView.refreshState = .Normal
            }
        } else {
            if refreshView.refreshState == .Pulling {
                beginRefreshing()
                
                // 发送刷新数据的事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    /// 开始刷新
    func beginRefreshing() {
        // 判断父视图
        guard let sv = scrollView else {
            return
        }
        // 判断如果正在刷新 直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        // 设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        // 让整个刷新视图能够显示出来
        // 解决方法 - 修改表格的contentInset
        var inset = sv.contentInset
        inset.top += CGRefreshOffset
        sv.contentInset = inset
        // 设置刷新视图父视图的高度
        refreshView.parentViewHeight = CGRefreshOffset
        
        print("开始刷新")
    }
    /// 结束刷新
    func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        // 判断
        if refreshView.refreshState != .WillRefresh {
            return
        }
        // 恢复表格视图的contentInset
        var inset = sv.contentInset
        inset.top -= CGRefreshOffset
        sv.contentInset = inset

        UIView.animate(withDuration: 0.5) {
            sv.contentInset = inset
        }
        
        // 恢复状态
        refreshView.refreshState = .Normal
    }

}

extension LXRefreshControl {
    
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        // 添加刷新视图 - 从xib加载出来 默认是xib指定的宽高
        addSubview(refreshView)
        
        // 自动布局 - 设置xib控件的自动布局，需要指定宽高
    refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.height))


    }
    
}
