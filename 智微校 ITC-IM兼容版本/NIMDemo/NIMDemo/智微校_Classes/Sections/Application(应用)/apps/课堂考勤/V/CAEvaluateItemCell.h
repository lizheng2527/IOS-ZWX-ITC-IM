//
//  CAEvaluateItemCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPNumberButton;
@class CAEvaluateItemCell;
@class CAEvaluateItemModel;


@protocol CAEvaluateItemCellDelegate <NSObject>

@optional
//选择框
- (void)itemSelectButtonClicked:(CAEvaluateItemCell *)cell;
//数字button
- (void)itemNumberButtonViewClicked:(CAEvaluateItemCell *)cell;


@end



@interface CAEvaluateItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemSelectButton;
@property (weak, nonatomic) IBOutlet PPNumberButton *itemNumberButtonView;

@property(nonatomic,retain)CAEvaluateItemModel *model;

@property(nonatomic,weak)id<CAEvaluateItemCellDelegate>delegate;
@end
