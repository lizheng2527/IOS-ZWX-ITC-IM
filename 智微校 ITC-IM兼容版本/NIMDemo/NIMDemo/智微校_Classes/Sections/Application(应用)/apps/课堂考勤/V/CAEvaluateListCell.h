//
//  CAEvaluateListCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAEvaluateListCell;
@class CAEvaluateItemModel;

@protocol CAEvaluateListCellDelegate <NSObject>
@optional
//删除
- (void)itemDelButtonClicked:(CAEvaluateListCell *)cell;

@end



@interface CAEvaluateListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemDelButton;

@property(nonatomic,retain)CAEvaluateItemModel *model;

@property(nonatomic,weak)id<CAEvaluateListCellDelegate>delegate;

@end
