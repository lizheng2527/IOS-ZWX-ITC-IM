//
//  UITabBar+redBadge.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/4.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "UITabBar+redBadge.h"
#define TabbarItemNums 4.0  // tabbar的数量
@implementation UITabBar (redBadge)

- (void)showBadgeOnItemIndex:(int)index {

    [self removeBadgeOnItemIndex:index];
    
    UIView * badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceil(percentX * tabFrame.size.width);
    CGFloat y = ceil(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
    
}
- (void)hideBadgeOnItemIndex:(int)index {
    [self removeBadgeOnItemIndex:index];
}
- (void)removeBadgeOnItemIndex:(int)index {

    for (UIView * subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}
@end
