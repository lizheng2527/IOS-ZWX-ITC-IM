//
//  WHApplicationHeaderView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationHeaderView.h"
#import "TYHWarehouseDefine.h"

@implementation WHApplicationHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lablel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 44)];
        _lablel.textColor = [UIColor TabBarColorWarehouse];
        _lablel.font = [UIFont boldSystemFontOfSize:15];
        _lablel.text = @"申领物品清单";
        [self addSubview:_lablel];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 43.5f, [UIScreen mainScreen].bounds.size.width, 0.5f)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel];
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
