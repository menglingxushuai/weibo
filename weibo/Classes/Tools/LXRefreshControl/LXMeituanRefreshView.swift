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
    
    override var parentViewHeight: CGFloat {
        didSet {
            print("父视图的高度\(parentViewHeight)")
            var scale: CGFloat
            if parentViewHeight >= 102 {
                scale = 1
            }else{
                scale = 1 - ((102 - parentViewHeight) / 102)
            }
            kangarooIcon.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
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
        let kImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        kangarooIcon.image = UIImage.animatedImage(with: [kImage1, kImage2], duration: 0.5)
        
        // 袋鼠
        // 1->设置锚点
        kangarooIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        // 2->设置center
        let x = self.width * 0.5
        let y = self.height - 20
        kangarooIcon.center = CGPoint(x: x, y: y)
        
        kangarooIcon.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

    }
}
