//
//  WHStatisticsHouseCountCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHStatisticsHouseCountCell.h"
#import "WHGoodsStasticsModel.h"

@implementation WHStatisticsHouseCountCell

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

-(void)setModel:(WHGoodsStasticsInOutHouseModel *)model
{
    self.itemNameLabel.text = model.schoolName;
    self.itemCountLabel.text = model.warehouseName;
    self.itemInHouseLabel.text = model.count;
    self.itemOutHouseLabel.text = model.moneycount;
}


-(void)initCellContentView
{
    //    self.backgroundColor = [UIColor WarehouseStatisticsColor];
    
    UITapGestureRecognizer *ges1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(countLabelClick:)];
    UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inHouseLabelClick:)];
    UITapGestureRecognizer *ges3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(outHouseLabelClick:)];
    
    
    _itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 4, 44)];
    _itemNameLabel.textColor = [UIColor darkGrayColor];
    _itemNameLabel.font = [UIFont systemFontOfSize:14];
    _itemNameLabel.textAlignment = NSTextAlignmentCenter;
    _itemNameLabel.numberOfLines = 0;
    [self addSubview:_itemNameLabel];
    
    _itemCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 0, SCREEN_WIDTH / 4, 44)];
    _itemCountLabel.textColor = [UIColor darkGrayColor];
    _itemCountLabel.font = [UIFont systemFontOfSize:14];
    _itemCountLabel.userInteractionEnabled = YES;
    _itemCountLabel.numberOfLines = 0;
    _itemCountLabel.textAlignment = NSTextAlignmentCenter;
    [_itemCountLabel addGestureRecognizer:ges1];
    [self addSubview:_itemCountLabel];
    
    _itemInHouseLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, 44)];
    _itemInHouseLabel.textColor = [UIColor darkGrayColor];
    _itemInHouseLabel.font = [UIFont systemFontOfSize:15];
    _itemInHouseLabel.userInteractionEnabled = YES;
    _itemInHouseLabel.textAlignment = NSTextAlignmentCenter;
    [_itemInHouseLabel addGestureRecognizer:ges2];
    [self addSubview:_itemInHouseLabel];
    
    _itemOutHouseLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 3, 0, SCREEN_WIDTH / 4, 44)];
    _itemOutHouseLabel.textColor = [UIColor darkGrayColor];
    _itemOutHouseLabel.font = [UIFont systemFontOfSize:15];
    _itemOutHouseLabel.userInteractionEnabled = YES;
    _itemOutHouseLabel.textAlignment = NSTextAlignmentCenter;
    [_itemOutHouseLabel addGestureRecognizer:ges3];
    [self addSubview:_itemOutHouseLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 0, .5f, 44)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, .5f, 44)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 3, 0, .5f, 44)];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView3];
    
    UIView *lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5f, SCREEN_WIDTH, .5f)];
    lineViewBottom.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineViewBottom];
    
}


-(void)countLabelClick:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(countLabelClickWithCell:)]) {
        
    }
}

-(void)inHouseLabelClick:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(inHouseLabelClickwithCell:)]) {
        
    }
}

-(void)outHouseLabelClick:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(outHouseLabelClickWithCell:)]) {
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
