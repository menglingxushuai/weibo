//
//  WBStatusCell.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {

    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 等级
    @IBOutlet weak var levelIcon: UIImageView!
    /// 时间
    @IBOutlet weak var time: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 认证
    @IBOutlet weak var vipIcon: UIImageView!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    /// 图片视图
    @IBOutlet weak var statusPictureView: WBStatusPictureView!
    /// 转发内容的文字 -> 原创微博e没有此xib 有可能没有
    @IBOutlet weak var retweetedContent: UILabel?
    
    var viewModel: WBStatusViewModel? {
        didSet {
            
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            time.text = viewModel?.wbCreatTime
            sourceLabel.text = viewModel?.wbSource
            nameLabel.text = viewModel?.status.user?.screen_name
            contentLabel.text = viewModel?.status.text
            levelIcon.image = viewModel?.memberIcon
            vipIcon.image = viewModel?.vipIcon
            toolBar.viewModel = viewModel
            statusPictureView.viewModel = viewModel
            retweetedContent?.text = viewModel?.retweetedContent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 如果测试滚动已经很好了 就不需要离屏渲染了
        
        /*
        // 离屏渲染 - 异步绘制 就是在进入屏幕前就绘制，加载显示更快 随之而来的也更耗cpu
        self.layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // 停止滚动后可以接受监听
        self.layer.shouldRasterize = true
        // 使用 ‘栅格化’ 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
         */
        
    }
    
}
