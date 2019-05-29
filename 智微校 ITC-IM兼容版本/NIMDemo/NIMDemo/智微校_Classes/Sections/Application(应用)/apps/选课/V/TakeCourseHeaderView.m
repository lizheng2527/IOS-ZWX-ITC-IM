//
//  TakeCourseHeaderView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseHeaderView.h"
#import "SDAutoLayout.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation TakeCourseHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        _header_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        _header_bgView.backgroundColor = [UIColor colorWithRed:102.0/255 green:150.0/255 blue:150.0/255 alpha:1];
        [self addSubview:_header_bgView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.header_bgView addSubview:_titleLabel];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
