//
//  AttendanceRemarkAddRowFooterView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceRemarkAddRowFooterView.h"

@implementation AttendanceRemarkAddRowFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self addSubview:view];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 21, 5, 40, 40);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btn_ci_add"] forState:UIControlStateNormal];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 40 / 2;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
}

-(void)addBtnClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(remarkItemAdd)]) {
        [_delegate remarkItemAdd];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
