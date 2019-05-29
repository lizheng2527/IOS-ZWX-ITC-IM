//
//  WHStatisticsHouseCountCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHGoodsStasticsInOutHouseModel;
@class WHStatisticsHouseCountCell;

@protocol WHStatisticsHouseCountCellDelegate <NSObject>

@required
- (void)countLabelClickWithCell:(WHStatisticsHouseCountCell *)cell;

- (void)inHouseLabelClickwithCell:(WHStatisticsHouseCountCell *)cell;

- (void)outHouseLabelClickWithCell:(WHStatisticsHouseCountCell *)cell;

@end

@interface WHStatisticsHouseCountCell : UITableViewCell

@property(nonatomic,retain)UILabel *itemNameLabel;
@property(nonatomic,retain)UILabel *itemCountLabel;
@property(nonatomic,retain)UILabel *itemInHouseLabel;
@property(nonatomic,retain)UILabel *itemOutHouseLabel;


@property(nonatomic,retain)WHGoodsStasticsInOutHouseModel *model;
@property(nonatomic,assign)id<WHStatisticsHouseCountCellDelegate>delegate;

@end
