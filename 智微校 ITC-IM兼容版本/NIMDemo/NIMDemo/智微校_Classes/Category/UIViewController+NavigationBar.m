//
//  UIViewController+NavigationBar.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/12.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PublicDefine.h"
#import "UIViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)changeNavigationBarWithTitle:(NSString *)title showBackBtn:(BOOL)showBackBtn
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if (showBackBtn) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回1"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    
    
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:16], NSFontAttributeName, nil]];
    
    [self setNavigationBarBackgroundColor:[UIColor TabBarColorGreen]];
    
}


- (void)changeNavigationBarWithTitle:(NSString *)title
{
    [self changeNavigationBarWithTitle:title showBackBtn:NO];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    UIImage *backgroundImage = [self imageWithColor:color];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setBackgroundImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = image;
    [self.view addSubview:imageView];
}

- (void)clickBackBtn
{
    
}

@end
