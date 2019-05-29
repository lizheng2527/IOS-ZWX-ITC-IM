//
//  AssetHeadView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetHeadView.h"

@implementation AssetHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor * color = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        self.backgroundColor = color;
        
        UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 10, self.frame.size.width, 40);
        button.backgroundColor = [UIColor whiteColor];
//        [button addTarget:self action:@selector(enterAllManager:) forControlEvents:(UIControlEventTouchUpInside)];
        // 添加 俩label
        UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
        [button addSubview:leftLabel];
        leftLabel.text = @"资产管理";
        leftLabel.textColor = [UIColor grayColor];
        leftLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 110, 5, 100, 30)];
        //    rightLabel.text = @"查看全部订车单>";
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textColor = [UIColor grayColor];
        [button addSubview:rightLabel];
        // 还有分割线
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.frame.size.width, 0.5)];
        view.backgroundColor = [UIColor lightGrayColor];
        [button addSubview:view];
        [self addSubview:button];
    }
    return self;
}
@end
