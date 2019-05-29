//
//  UITabBar+redBadge.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/4.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (redBadge)
//  显示红点
- (void)showBadgeOnItemIndex:(int)index;
//  隐藏红点
- (void)hideBadgeOnItemIndex:(int)index;
@end
