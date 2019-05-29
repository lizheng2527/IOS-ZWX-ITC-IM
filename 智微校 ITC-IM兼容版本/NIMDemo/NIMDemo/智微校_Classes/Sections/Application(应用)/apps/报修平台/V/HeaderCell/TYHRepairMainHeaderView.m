//
//  TYHRepairMainHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 17/3/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHRepairMainHeaderView.h"
#import "TYHRepairDefine.h"


@implementation TYHRepairMainHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headerViewInit];
    }
    return self;
}

#pragma mark - ConfigFrame
-(void)headerViewInit
{
    UILabel *lineViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    lineViewLabel.backgroundColor = [UIColor RepairBGColor];
    [self addSubview:lineViewLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40.f, [UIScreen mainScreen].bounds.size.width, .5f)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 25)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 15, 90, 15);
    [_checkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _checkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_checkBtn addTarget:self action:@selector(checkAllRepairListAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右02"]];
    imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 17.5, 8, 10);
    [self addSubview:imageView];
}

-(void)checkAllRepairListAction
{
    if (self.delegate && [_delegate respondsToSelector:@selector(CheckAllRepairListWithType:)]) {
        [self.delegate CheckAllRepairListWithType:_type];
    }
}


@end
