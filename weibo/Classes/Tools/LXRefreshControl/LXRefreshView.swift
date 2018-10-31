//
//  LXRefreshView.swift
//  weibo
//
//  Created by xiaotong on 2018/10/29.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

/// 刷新视图 - 负责刷新相关的UI 显示动画
class LXRefreshView: UIView {
    /*
        iOS 系统中 UIView 封装的旋转动画
        - 默认是顺时针旋转
        - 就近原则
        - 要想实现同方向旋转需要调整一个非常小的数字 （近）
        - 如果实现360旋转 需要CABasicAnimation
     */
    /// 刷新状态
    var refreshState: LXRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                // 隐藏提示图标 显示菊花
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                
                tipLabel?.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }

            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: .pi + 0.001)
                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                // 隐藏提示图标 显示菊花
                tipIcon?.isHidden = true
                // 显示菊花
                indicator?.startAnimating()
            }
        }
    }
    
    /// 父视图的高度 - 为了刷新控件不需要关心当前具体的刷新视图具体是谁
    var parentViewHeight: CGFloat = 0.0
    
    /// 提示图像
    @IBOutlet weak var tipIcon: UIImageView?
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    class func refreshView() -> LXRefreshView {
        let nib = UINib(nibName: "LXMeituanRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! LXRefreshView
    }
    
}
