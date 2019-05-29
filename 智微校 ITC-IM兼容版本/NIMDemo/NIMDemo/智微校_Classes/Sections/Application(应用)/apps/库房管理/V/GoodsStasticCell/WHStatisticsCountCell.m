//
//  WHStatisticsCountCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHStatisticsCountCell.h"
#import "WHGoodsStasticsModel.h"

@implementation WHStatisticsCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initCellContentView];
    }
    return self;
}

-(void)setModel:(WHGoodsStasticsStockModel *)model
{
    self.itemSchoolLabel.text = model.schoolName;
    self.itemStoreLabel.text = model.warehouseName;
    self.itemCountLabel.text = model.count;
}


-(void)initCellContentView
{
    //    self.backgroundColor = [UIColor WarehouseStatisticsColor];
    
    
    _itemSchoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 44)];
    _itemSchoolLabel.textColor = [UIColor darkGrayColor];
    _itemSchoolLabel.font = [UIFont systemFontOfSize:14];
    _itemSchoolLabel.numberOfLines = 0;
    _itemSchoolLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemSchoolLabel];
    
    _itemStoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, 44)];
    _itemStoreLabel.textColor = [UIColor darkGrayColor];
    _itemStoreLabel.font = [UIFont systemFontOfSize:14];
    _itemStoreLabel.userInteractionEnabled = YES;
    _itemStoreLabel.numberOfLines = 0;
    _itemStoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemStoreLabel];
    
    _itemCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, 0, SCREEN_WIDTH / 3, 44)];
    _itemCountLabel.textColor = [UIColor darkGrayColor];
    _itemCountLabel.font = [UIFont systemFontOfSize:15];
    _itemCountLabel.userInteractionEnabled = YES;
    _itemCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemCountLabel];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 0, .5f, 44)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, 0, .5f, 44)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView2];
    
    
    UIView *lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5f, SCREEN_WIDTH, .5f)];
    lineViewBottom.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineViewBottom];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
