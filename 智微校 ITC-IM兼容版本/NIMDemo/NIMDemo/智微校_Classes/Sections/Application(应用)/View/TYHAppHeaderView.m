//
//  TYHAppHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 17/3/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHAppHeaderView.h"

@implementation TYHAppHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 , 20);

        UIView *lineViewLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 1)];
        lineViewLeft.backgroundColor = [UIColor colorWithRed:73/255.0 green:108/255.0 blue:234/255.0 alpha:0.2];
        lineViewLeft.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 - 40 - 30, 20);
        [self addSubview:lineViewLeft];
        
        UIView *lineViewRight = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 1)];
        lineViewRight.backgroundColor = [UIColor colorWithRed:73/255.0 green:108/255.0 blue:234/255.0 alpha:0.2];
        lineViewRight.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 40 + 30, 20);
        [self addSubview:lineViewRight];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}


@end
