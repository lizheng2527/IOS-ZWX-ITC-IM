//
//  MRSAddFooterView.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRSAddFooterView.h"
#import "TYHRepairDefine.h"

@implementation MRSAddFooterView

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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    lineView.backgroundColor = [UIColor RepairBGColor];
    [view addSubview:lineView];
    
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 65, 5, 130, 30)];
    addView.layer.masksToBounds = YES;
    addView.layer.cornerRadius = 15.f;
    addView.backgroundColor = [UIColor TabBarColorRepair];
    [view addSubview:addView];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBtnClick:)];
    addView.userInteractionEnabled = YES;
    [addView addGestureRecognizer:ges];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(4, 4.f, 22, 22);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btn_ci_add"] forState:UIControlStateNormal];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 22 / 2;
    [addView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 2.5f, 95, 25)];
    label.text = @"添加配件明细";
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [addView addSubview:label];
    
     _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 30)];
//    _titleLabel.text = @"  配件总金额(元): 0.00元";
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.backgroundColor = [UIColor RepairBGColor];
    [view addSubview:_titleLabel];
}


-(void)addBtnClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(partsItemAdd)]) {
        
        [_delegate partsItemAdd];
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
