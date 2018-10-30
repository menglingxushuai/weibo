//
//  LXMeituanRefreshView.swift
//  weibo
//
//  Created by xiaotong on 2018/10/29.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class LXMeituanRefreshView: LXRefreshView {

    @IBOutlet weak var buildingIcon: UIImageView!
    
    @IBOutlet weak var earthIcon: UIImageView!
    
    @IBOutlet weak var kangarooIcon: UIImageView!
    
    override func awakeFromNib() {
        // 房子
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        buildingIcon.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.5)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 2
        anim.isRemovedOnCompletion = false
        earthIcon.layer.add(anim, forKey: nil)
        
        // 袋鼠
        // 1->设置锚点
        kangarooIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        // 2->设置center
        let x = self.width * 0.5
        let y = self.height - 30
        kangarooIcon.center = CGPoint(x: x, y: y)
        
        kangarooIcon.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

    }
}
