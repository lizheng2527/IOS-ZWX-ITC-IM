//
//  WHApplicationDetailItemCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationDetailItemCell.h"
#import "TYHWarehouseDefine.h"
#import "WHMyApplicationModel.h"


@implementation WHApplicationDetailItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initFrame];
}

-(void)setModel:(WHMyItemListModel *)model
{
    self.itemNameLabel.text = model.goodsInfoName;
    self.itemCountLabel.text = model.count;
    self.itemPriceLabel.text = model.Money;
}

-(void)initFrame
{
    _itemNameLabel.frame = CGRectMake(0, 7.5, SCREEN_WIDTH/3, 20);
    _itemCountLabel.frame = CGRectMake(SCREEN_WIDTH / 3, 7.5, SCREEN_WIDTH/3, 20);
    _itemPriceLabel.frame = CGRectMake(SCREEN_WIDTH / 3 * 2, 7.5, SCREEN_WIDTH/3, 20);
    _lineLabel.backgroundColor = [UIColor WarehouseStatisticsColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
