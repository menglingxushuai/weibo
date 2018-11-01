//
//  WBComposeTypeView.swift
//  weibo
//
//  Created by xiaotong on 2018/10/31.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import pop

/// 撰写微博类型视图
class WBComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var returnCenterX: NSLayoutConstraint!
    @IBOutlet weak var closeCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var returnButton: UIButton!
    
    private var completionBlock: ((_ clsName: String?)->())?
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]

    
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        v.frame = UIScreen.main.bounds
        v.setupUI()

        return v
    }
    
    /// 显示当前视图
    func show(completion: @escaping (_ clsName: String?)->()) {
        completionBlock = completion
        // 将试图 添加到跟视图控制器的view上
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        
        showCurrentView()
    }

    // MARK: - 监听方法
    @objc private func clickButton(sender: WBComposeTypeButton) {
        // 判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / UIScreen.cz_screenWidth())
        let v = scrollView.subviews[page]
        
        for btn in v.subviews {
            
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (btn == sender) ? 1.2 : 0.8
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            // 渐变动画 - 动画组
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            if btn != sender {
                continue
            }
            // 监听最后一个动画
            alphaAnim.completionBlock = { _,_ in
                print("完成回调")
                self.completionBlock?(sender.clsName)
            }
            
        }
    }
    
    @objc private func clickMore() {
        print("点击更多")
        // 将scrollView滚动到第二页
        scrollView .setContentOffset(CGPoint(x: UIScreen.cz_screenWidth(), y: 0), animated: true)
        
        returnButton.isHidden = false
        
        let margin = UIScreen.cz_screenWidth() / 6
        closeCenterX.constant += margin
        returnCenterX.constant -= margin
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func returnAction(_ sender: UIButton) {
        scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    
        
        closeCenterX.constant = 0
        returnCenterX.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
        
    }
    @IBAction func close(_ sender: UIButton) {
        print("关闭了")
        hideButtons()
    }
    
}


// MARK: - 动画方法扩展
private extension WBComposeTypeView {
    
    private func hideButtons() {
        let page = Int(scrollView.contentOffset.x / UIScreen.cz_screenWidth())
        let v = scrollView.subviews[page]
        
        for (i,btn) in v.subviews.enumerated().reversed() {
            // 创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.centerY
            anim.toValue = btn.centerY + 400
            anim.beginTime = CACurrentMediaTime() + Double(v.subviews.count - i) * 0.025
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == 0 {
                anim.completionBlock = { _, _ in
                    self.hideCurrentView()
                }
            }
        }

    }
    
    
    private func hideCurrentView() {
        // 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.15
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    private func showCurrentView() {
        // 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        pop_add(anim, forKey: nil)
        
        // 添加按钮的动画
        showButtons()
    }
    
    private func showButtons() {
        // 1.获取scrollView子视图的第0个view
        let v = scrollView.subviews[0]
        
        for (i,btn) in v.subviews.enumerated() {
            // 创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            // 设置动画属性
            anim.fromValue = btn.centerY + 400
            anim.toValue = btn.centerY
            // 弹力系数
            anim.springBounciness = 10
            // 设置开始动画时间
            anim.beginTime = CACurrentMediaTime() + Double(i) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
    
}
// 让extension中的方法都是私有的
private extension WBComposeTypeView {
    func setupUI() {
        
        print(scrollView.frame)
        
        // 1.向scrollView添加视图
        let rect = scrollView.bounds
        
        let width: CGFloat = UIScreen.cz_screenWidth()
        
        for i in 0..<2 {
            let v = UIView(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: rect.height))
            // 2.向视图添加按钮
            addButtons(v: v, idx: i * 6)
            scrollView.addSubview(v)
        }
        scrollView.contentSize = CGSize(width: width * 2, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
    }
    
    /// 向v中添加按钮 按钮的数组索引从idx开始
    func addButtons(v: UIView, idx: Int) {
        // 从idx开始添加6个按钮
        let count = 6
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    continue
            }
            
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            
            v.addSubview(btn)
            
            // 添加监听方法
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            btn.clsName = dict["clsName"]
        }
        
        
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (UIScreen.cz_screenWidth() - 3 * btnSize.width) / 4
        // 遍历子视图 布局按钮
        for (i, btn) in v.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (v.height - btnSize.height) : 0
            let col = i % 3
            let x: CGFloat = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
        }
        
    }
    
}
