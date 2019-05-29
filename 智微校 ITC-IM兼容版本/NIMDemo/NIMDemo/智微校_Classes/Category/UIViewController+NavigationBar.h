//
//  UIViewController+NavigationBar.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/12.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

- (void)changeNavigationBarWithTitle:(NSString *)title;
- (void)changeNavigationBarWithTitle:(NSString *)title showBackBtn:(BOOL)showBackBtn;
- (void)setNavigationBarBackgroundColor:(UIColor *)color;
- (void)setBackgroundImage:(UIImage *)image;


@end
