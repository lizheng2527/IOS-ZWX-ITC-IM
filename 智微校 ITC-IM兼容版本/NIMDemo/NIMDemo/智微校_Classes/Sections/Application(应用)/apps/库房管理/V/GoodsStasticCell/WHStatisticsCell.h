//
//  WHStatisticsCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHStatisticsCell;
@class WHGoodsStasticsModel;

@protocol WHStatisticsCellDelegate <NSObject>

@required
- (void)countLabelClickWithCell:(WHGoodsStasticsModel *)model;

- (void)inHouseLabelClickwithCell:(WHGoodsStasticsModel *)model;

- (void)outHouseLabelClickWithCell:(WHGoodsStasticsModel *)model;

@end


@interface WHStatisticsCell : UITableViewCell

@property(nonatomic,retain)UILabel *itemNameLabel;
@property(nonatomic,retain)UILabel *itemCountLabel;
@property(nonatomic,retain)UILabel *itemInHouseLabel;
@property(nonatomic,retain)UILabel *itemOutHouseLabel;

@property(nonatomic,retain)WHGoodsStasticsModel *model;

@property(nonatomic,assign)id<WHStatisticsCellDelegate>delegate;
@end
