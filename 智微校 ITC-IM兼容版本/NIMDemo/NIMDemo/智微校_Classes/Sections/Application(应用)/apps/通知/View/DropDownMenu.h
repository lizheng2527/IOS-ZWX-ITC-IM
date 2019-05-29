//
//  DropDownMenu.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownMenu;

@protocol DropDownMenuDelegate <NSObject>
// 设置可选的代理方法
@optional
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu;
- (void)dropdownMenuDidShow:(DropDownMenu *)menu;
@end

@interface DropDownMenu : UIView

@property (nonatomic, weak) id<DropDownMenuDelegate> delegate;

// 显示
- (void)showFrom:(UIView *)from;

// 销毁
- (void)dismiss;

// 内容
@property (nonatomic, strong) UIView *content;

// 内容控制器
@property (nonatomic, strong) UIViewController *contentController;

@end
