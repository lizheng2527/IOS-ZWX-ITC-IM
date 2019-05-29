//
//  MRADetailCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRADetailCell;
@class MyRepairApplicationModel;
@class RepairManagementModel;

@protocol MRADetailCellDelegate <NSObject>

@optional

- (void)LookBtnClicked:(MRADetailCell *)cell;

- (void)FeedBackClicked:(MRADetailCell *)cell;

- (void)DelBtnClicked:(MRADetailCell *)cell;
@end


@interface MRADetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property(nonatomic,assign)id<MRADetailCellDelegate>delegate;

@property(nonatomic,retain)MyRepairApplicationModel *model;


@property(nonatomic,retain)RepairManagementModel *myServerModel;
@property(nonatomic,copy)NSString *cellRepairID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delBtnRightSpaceLayout;


@end
