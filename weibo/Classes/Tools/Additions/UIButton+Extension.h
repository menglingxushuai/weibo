//
//  UIButton+Extension.h
//  FSQ_PLATFORM1
//
//  Created by 曹野 on 16/10/22.
//  Copyright © 2016年 豫王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  快速创建一个UIButton对象 通过给定的图片
 */
+ (instancetype)mg_buttonWithImagename:(NSString *)imagename
                     hightImagename:(NSString *)hightImagename
                        bgImagename:(NSString *)bgImagename
                             target:(id)target
                             action:(SEL)action;

+ (instancetype)mg_buttonWithTitle:(NSString *)title
                    normalColor:(UIColor *)normalColor
                  highlightedColor:(UIColor *)highlightedColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target
                         action:(SEL)action;

+ (instancetype)mg_buttonWithTitle:(NSString *)title
                    normalColor:(UIColor *)normalColor
                    diableColor:(UIColor *)diableColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target
                         action:(SEL)action;

/**
 创建文本按钮
 
 @param title               标题文字
 @param fontSize            字体大小
 @param normalColor         默认颜色
 @param highlightedColor    高亮颜色
 @param backgroundImageName 背景图像名称
 
 @return UIButton
 */
+ (instancetype)mg_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName;
@end
