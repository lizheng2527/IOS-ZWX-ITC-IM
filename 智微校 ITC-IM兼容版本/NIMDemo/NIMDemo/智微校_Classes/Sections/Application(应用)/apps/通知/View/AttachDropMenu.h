//
//  AttachDropMenu.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/11/6.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttachDropMenu;

@protocol AttachDropMenuDelegate <NSObject>
// 设置可选的代理方法
@optional
- (void)dropdownMenuDidDismiss:(AttachDropMenu *)menu;
- (void)dropdownMenuDidShow:(AttachDropMenu *)menu;

@end

@interface AttachDropMenu : UIView


@property (nonatomic, weak) id<AttachDropMenuDelegate> delegate;

// 显示
- (void)showFrom:(UIButton *)from;

// 销毁
- (void)dismiss;

// 内容
@property (nonatomic, strong) UIView *content;

// 内容控制器
@property (nonatomic, strong) UIViewController *contentController;
@end
