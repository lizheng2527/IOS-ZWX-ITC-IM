//
//  UIButton+Extention.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/3/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extention)

+ (UIButton *)addWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color image:(NSString *)image highImage:(NSString *)highImage;

@end
