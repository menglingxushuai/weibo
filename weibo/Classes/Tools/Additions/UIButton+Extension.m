//
//  UIButton+Extension.m
//  FSQ_PLATFORM1
//
//  Created by 曹野 on 16/10/22.
//  Copyright © 2016年 豫王. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (instancetype)mg_buttonWithImagename:(NSString *)imagename
                     hightImagename:(NSString *)hightImagename
                        bgImagename:(NSString *)bgImagename
                             target:(id)target
                             action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (imagename) {
        [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    }
    if (hightImagename) {
        [button setImage:[UIImage imageNamed:hightImagename] forState:UIControlStateNormal];
    }
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    return button;
    
}

+ (instancetype)mg_buttonWithTitle:(NSString *)title normalColor:(UIColor *)normalColor diableColor:(UIColor *)diableColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (normalColor && title) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (diableColor && title) {
        [button setTitleColor:diableColor forState:UIControlStateDisabled];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    
    return button;
}

+ (instancetype)mg_buttonWithTitle:(NSString *)title
                    normalColor:(UIColor *)normalColor
                  highlightedColor:(UIColor *)highlightedColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target
                         action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (normalColor && title) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (highlightedColor && title) {
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    
    return button;
}


+ (instancetype)mg_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName {
    
    UIButton *button = [[self alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if (backgroundImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
        
        NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    }
    
    [button sizeToFit];
    
    return button;
    
}



@end
