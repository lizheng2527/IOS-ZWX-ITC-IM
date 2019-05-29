//
//  WHApplicationDetailHeaderView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/20.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationDetailHeaderView.h"
#import "TYHWarehouseDefine.h"


@implementation WHApplicationDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lablel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 24)];
        _lablel.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:0.8];
        _lablel.textColor = [UIColor TabBarColorWarehouse];
        _lablel.font = [UIFont boldSystemFontOfSize:15];
        _lablel.text = @"   申领物品列表";
        [self addSubview:_lablel];
        
//        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 23.5f, [UIScreen mainScreen].bounds.size.width, 0.5f)];
//        lineLabel.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:lineLabel];
        
        UILabel *itemNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 24 , [UIScreen mainScreen].bounds.size.width / 3 , 30)];
        itemNameLabel.backgroundColor = [UIColor WarehouseStatisticsColor];
        itemNameLabel.font = [UIFont boldSystemFontOfSize:14];
        itemNameLabel.text = @"物品名称";
        itemNameLabel.textColor = [UIColor darkGrayColor];
        itemNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:itemNameLabel];
        
        UILabel *itemCountLabel =[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3, 24, [UIScreen mainScreen].bounds.size.width / 3 , 30)];
        itemCountLabel.backgroundColor = [UIColor WarehouseStatisticsColor];
        itemCountLabel.textAlignment = NSTextAlignmentCenter;
        itemCountLabel.font = [UIFont boldSystemFontOfSize:14];
        itemCountLabel.text = @"数量";
        itemCountLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:itemCountLabel];
        
        UILabel *itemPriceLabel =[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * 2, 24, [UIScreen mainScreen].bounds.size.width / 3 , 30)];
        itemPriceLabel.textAlignment = NSTextAlignmentCenter;
        itemPriceLabel.textColor = [UIColor darkGrayColor];
        itemPriceLabel.backgroundColor = [UIColor WarehouseStatisticsColor];
        itemPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        itemPriceLabel.text = @"金额";
        [self addSubview:itemPriceLabel];
        
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
