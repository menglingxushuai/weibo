//
//  WBStatusViewModel.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/23.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import Foundation

class WBStatusViewModel: CustomStringConvertible {
    /// 微博模型
    var status: WBStatus
    /// hui会员图标
    var memberIcon: UIImage?
    /// 认证类型 -1 没有认证 0 认证用户 2 3 5 企业认证 220 达人
    var vipIcon: UIImage?
    /// 转发文字
    var retweetedStr: String?
    /// 评论文字
    var commentStr: String?
    /// 点赞文字
    var likeStr: String?
    /// 配图视图大小
    var pictureViewSize = CGSize()
    /// 如果是被转发的微博，返回被转发微博的配图
    var picURLs: [WBStatusPicture]? {
        // 如果有被转发的微博返回被转发的图
        // 没有被转发返回原创配图
        // 都没有返回nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    /// 被转发微博的文字
    var retweetedContent: String?
    /// 微博来源
    var wbSource: String?
    /// 创建时间
    var wbCreatTime: String?
    /// 行高
    var rowHeight: CGFloat?
    
    
    init(model: WBStatus) {
        status = model
        if (model.user?.mbrank ?? 0) > 0 && (model.user?.mbrank ?? 0) < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        switch status.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")

        default:
            break
        }
        
        // 设置底部计算字符串
        retweetedStr = countString(count: status.reposts_count, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count, defaultStr: "赞")

        // 计算配图视图大小
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        /// 被转发微博的文字
        retweetedContent = "@\(status.retweeted_status?.user?.screen_name ?? ""):\(status.retweeted_status?.text ?? "")"
        wbSource = sourceString(source: status.source)
        wbCreatTime = timeString(created_at: status.created_at)
        
        
        updateRowHeight()
    }
    
    /// 计算行高
    func updateRowHeight() {
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolBarheight: CGFloat = 35
        
        var height: CGFloat = 0
        // 1.计算顶部位置
        height = 2 * margin + iconHeight + margin
        height = height + calculateTextHeight(text: status.text) // 正文内容
        // 判断是否是转发微博
        if status.retweeted_status != nil {
            height = height + 2 * margin + calculateTextHeight(text: retweetedContent)
        }
        
        // 配图视图
        height = height + pictureViewSize.height
        height = height + margin + toolBarheight
        
        // 使用属性记录
        rowHeight = height
    }
    
    private func calculateTextHeight(text: String?) -> CGFloat {
        
        if let text = text {
            
            let width = UIScreen.cz_screenWidth() - WBStatusPictureViewOutterMagrin * 2
            let font = UIFont.systemFont(ofSize: 15)
            let rect = (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
            return rect.height
        }
        
        return 0
    }
    
    /// 使用单个图像更新视图配图的大小
    func updataSingleImageSize(image: UIImage) {
        var size = image.size
        
        // 过宽图像处理
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40

        if size.width > maxWidth {
            // 等比例调整高度
            size.height = maxWidth * size.height / size.width
            size.width = maxWidth
        }
        
        if size.width < minWidth {
            size.height = maxWidth * size.height / size.width / 4
            size.width = minWidth
        }
        
        // 注意尺寸需要加顶部的12d个点
        size.height = WBStatusPictureViewOutterMagrin + size.height
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
    }
    
    private func sourceString(source: String?) -> String {
        guard let arr = source?.components(separatedBy: ">") else {
            return ""
        }
        if arr.count >= 2 {
            return arr[1].replacingOccurrences(of: "</a", with: "")
        }
        return ""
    }
    
    private func timeString(created_at: String?) -> String {
       
        return created_at ?? ""
    }
    
    private func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }        // 计算配图视图的宽度
        
        // 计算高度 根据count行数
        let row = (count! - 1) / 3 + 1
        
        let height = WBStatusPictureViewOutterMagrin + CGFloat(row) * WBStatusPictureItemWidth + (CGFloat(row) - 1) * WBStatusPictureViewInnerMargin
        
        return CGSize(width: WBStatusPictureItemWidth, height: height)
    }
    
    /**
        给定一个数字返回结果
        == 0 显示默认文字
        超过10000 显示 XX万
        < 10000 显示实际数字
     */
    private func countString(count: Int = 0, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.2f万", Double(count) / 10000.0)
    }
    
    var description: String {
        return status.yy_modelDescription()
    }
    
}
