//
//  WBBaseVisitorView.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/13.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

/// 访客视图
class WBBaseVisitorView: UIView {
    
    lazy var registBtn: UIButton = UIButton.mg_textButton("注册", fontSize: 16.0, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    lazy var loginBtn: UIButton = UIButton.mg_textButton("登录", fontSize: 16.0, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    // MARK: - 通过属性修改访客视图
    var visitorInfo:[String: String]? {
        didSet {
            guard
                let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            // 其它控制器不需要显示
            houseView.isHidden = true
            maskIconView.isHidden = true
            tipLabel.text = message
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 首页旋转动画
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 15
        animation.isRemovedOnCompletion = false // 完成之后不删除
        iconView.layer.add(animation, forKey: nil)
    }
    
    // MARK: - 私有控件
    /// 懒加载属性只有调用UIKit控件的指定构造函数，其它都需要适用类型
    private lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    private lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    private lazy var houseView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    private lazy var tipLabel: UILabel = UILabel.mg_label(withText: "关注一些人,回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    
}

// MARK: - 设置界面
extension WBBaseVisitorView {
    
    func setupUI() {
        backgroundColor = UIColor.init(r: 237, g: 237, b: 237)
        
        // 1.添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseView)
        addSubview(tipLabel)
        addSubview(registBtn)
        addSubview(loginBtn)

        iconView.centerX = self.centerX
        iconView.centerY = self.centerY - 60
        
        houseView.center = iconView.center
        
        tipLabel.y = iconView.bottom + 20
        tipLabel.centerX = self.centerX
        tipLabel.width = 237
        tipLabel.height = 50
        tipLabel.textAlignment = NSTextAlignment.center
        
        registBtn.y = tipLabel.bottom + 40
        registBtn.width = 100
        registBtn.x = 80
        
        loginBtn.y = registBtn.y
        loginBtn.width = registBtn.width
        loginBtn.right = self.right - 80
        
        maskIconView.frame = CGRect(x: 0, y: 0, width: self.width, height: registBtn.centerY)
    }
}
