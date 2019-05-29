//
//  NTESContactDataCell.m
//  NIM
//
//  Created by chris on 2017/4/7.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESContactDataCell.h"
#import "NTESSessionUtil.h"
@implementation NTESContactDataCell

- (void)refreshUser:(id<NIMGroupMemberProtocol>)member
{
    [super refreshUser:member];
    NSString *state = [NTESSessionUtil onlineState:self.memberId detail:NO];
    NSString *title = @"";
    if (state.length)
    {
        title = [NSString stringWithFormat:@"[%@] %@",state,member.showName];
        
        if ([state hasSuffix:@"在线"]) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
            
            // 设置字体和设置字体的范围
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15.0f]
                            range:NSMakeRange(0, state.length + 2)];
            // 添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor TabBarColorGreen]
                            range:NSMakeRange(0, state.length + 2)];
            
            
            self.textLabel.attributedText = attrStr;
        }
        else if ([state hasSuffix:@"离线"]) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
            
            // 设置字体和设置字体的范围
            [attrStr addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15.0f]
                            range:NSMakeRange(0, state.length + 2)];
            // 添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor lightGrayColor]
                            range:NSMakeRange(0, state.length + 2)];
            
            self.textLabel.attributedText = attrStr;
        }
    }
    else
    {
        title = [NSString stringWithFormat:@"%@",member.showName];
    }
    
    self.textLabel.text = title;
}


@end
