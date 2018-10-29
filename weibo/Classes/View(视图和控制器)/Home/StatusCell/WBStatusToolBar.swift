//
//  WBStatusToolBar.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetedButton: UIButton!
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞
    @IBOutlet weak var likeButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
