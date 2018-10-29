//
//  WBStatusPictureView.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    var viewModel: WBStatusViewModel? {
        didSet {
            calcViewSize()
            urls = viewModel?.picURLs
        }
    }
    
    /// 根据视图模型配置视图大小，调整显示内容
    private func calcViewSize() {
        let v = subviews[0]

        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMagrin, width: viewSize.width, height: viewSize.height - WBStatusPictureViewOutterMagrin)
        } else {
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMagrin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        }
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    private var urls: [WBStatusPicture]? {
        didSet {
            
            for v in subviews {
                // 先隐藏
                v.isHidden = true
            }
            
            var indexImage = 0
            for (index, status) in (urls ?? []).enumerated() {
                
                // 处理第四张
                if index > 1 && urls?.count == 4 {
                    indexImage = index + 1
                } else {
                    indexImage = index
                }

                let iv = subviews[indexImage] as! UIImageView

                iv.cz_setImage(urlString: status.thumbnail_pic, placeholderImage: nil)
                iv.isHidden = false

            }
        }
    }
    
    /// picView高度
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    /// 配图视图
    @IBOutlet weak var pictureView: UIView!
    
    override func awakeFromNib() {
        
        setupUI()
        clipsToBounds = true
        backgroundColor = superview?.backgroundColor
    }

}

// MARK : - 设置界面
extension WBStatusPictureView {
    
    // cell中的所有空间都要提前准备好
    // 设置的时候，根据数据决定是否显示
    // 不要动态设置空间
    private func setupUI() {
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureViewOutterMagrin,
                          width: WBStatusPictureItemWidth,
                          height: WBStatusPictureItemWidth)
        // 循环创建9个imageView
        for i in 0..<9 {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            // 行 -> Y
            let row = CGFloat(i / count)
            // 列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
    }
}
