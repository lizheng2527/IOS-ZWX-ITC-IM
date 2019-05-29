//
//  UIButton+Extention.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/3/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "UIButton+Extention.h"

@implementation UIButton (Extention)

+ (UIButton *)addWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color image:(NSString *)image highImage:(NSString *)highImage {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置文字
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    return btn;
}

@end
