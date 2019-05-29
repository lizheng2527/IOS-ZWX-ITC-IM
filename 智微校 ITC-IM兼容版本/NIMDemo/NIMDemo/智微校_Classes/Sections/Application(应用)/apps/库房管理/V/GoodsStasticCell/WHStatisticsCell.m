//
//  WHStatisticsCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHStatisticsCell.h"
#import "TYHWarehouseDefine.h"
#import "WHGoodsStasticsModel.h"

@implementation WHStatisticsCell

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


-(void)setModel:(WHGoodsStasticsModel *)model
{
    _model = model;
    self.itemNameLabel.text = model.goodsInfoName;
    self.itemCountLabel.text = model.inventory;
    self.itemInHouseLabel.text = model.intoWarehouseCount;
    self.itemOutHouseLabel.text = model.outWarehouseCount;
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_itemCountLabel.text attributes:attribtDic];
    //赋值
    _itemCountLabel.attributedText = attribtStr;
    
    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:_itemInHouseLabel.text attributes:attribtDic];
    //赋值
    _itemInHouseLabel.attributedText = attribtStr2;
    
    NSMutableAttributedString *attribtStr3 = [[NSMutableAttributedString alloc]initWithString:_itemOutHouseLabel.text attributes:attribtDic];
    //赋值
    _itemOutHouseLabel.attributedText = attribtStr3;
    
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
    _itemCountLabel.font = [UIFont systemFontOfSize:15];
    _itemCountLabel.userInteractionEnabled = YES;
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
        [self.delegate countLabelClickWithCell:_model];
    }
}

-(void)inHouseLabelClick:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(inHouseLabelClickwithCell:)]) {
        [self.delegate inHouseLabelClickwithCell:_model];
    }
}

-(void)outHouseLabelClick:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(outHouseLabelClickWithCell:)]) {
        [self.delegate outHouseLabelClickWithCell:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
