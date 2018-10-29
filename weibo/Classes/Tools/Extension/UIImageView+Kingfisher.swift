//
//  UIImageView+Kingfisher.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation


extension UIImageView {
    
    func cz_setImage(urlString : String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        guard let urlString = urlString?.replacingOccurrences(of: "http://", with: "https://"),
            let url = URL.init(string: urlString) else {
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: image, options: .progressiveDownload) { [weak self] (image, _, _, _) in
            // 完成回调 - 判断是否是头像
            if isAvatar {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
        
    }
    
}
