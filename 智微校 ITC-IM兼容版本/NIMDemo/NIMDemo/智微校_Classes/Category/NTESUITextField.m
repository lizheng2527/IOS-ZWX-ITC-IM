//
//  NTESUITextField.m
//  NIM
//
//  Created by 中电和讯 on 2017/8/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESUITextField.h"

@implementation NTESUITextField

//取消uitextfiled的activityMenu
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
