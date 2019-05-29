//
//  WHStatisticsCountCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHGoodsStasticsStockModel;

@protocol WHStatisticsCountCellDelegate <NSObject>

@required
- (void)countLabelClickWithCell:(WHGoodsStasticsStockModel *)model;

- (void)inHouseLabelClickwithCell:(WHGoodsStasticsStockModel *)model;

- (void)outHouseLabelClickWithCell:(WHGoodsStasticsStockModel *)model;

@end

@interface WHStatisticsCountCell : UITableViewCell

@property(nonatomic,retain)UILabel *itemSchoolLabel;
@property(nonatomic,retain)UILabel *itemStoreLabel;
@property(nonatomic,retain)UILabel *itemCountLabel;

@property(nonatomic,retain)WHGoodsStasticsStockModel *model;

@property(nonatomic,assign)id<WHStatisticsCountCellDelegate>delegate;

@end
