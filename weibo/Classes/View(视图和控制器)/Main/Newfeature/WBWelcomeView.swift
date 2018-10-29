//
//  WBWelcomeView.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/22.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {

    @IBOutlet weak var avatar_large: UIImageView!
    @IBOutlet weak var welcome: UILabel!
    
    @IBOutlet weak var imgBottom: NSLayoutConstraint!
    class func welcome() -> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgBottom.constant = height - 200
        
        // 控件的frame还没计算好时 layoutIfNeeded 所有的约束都会一起动画

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            // 动画中更新约束
            self.layoutIfNeeded()
            
        }) { (_) in
            
            UIView.animate(withDuration: 2, animations: {
                self.welcome.alpha = 1
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.removeFromSuperview()
                })
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let url = URL(string: WBNetworkManager.shared.userAccount.avatar_large ?? "") else {
            return
        }
        
        avatar_large.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"), options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: nil)
         let screen_name = (WBNetworkManager.shared.userAccount.screen_name ?? "") + "\n欢迎回来"
        
        welcome.text = screen_name
    }
}
