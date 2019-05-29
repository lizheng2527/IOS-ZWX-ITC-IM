//
//  RepairManagementListCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RepairManagementModel;
@class RepairManagementListCell;


@protocol RepairManagementListCellDelegate <NSObject>

@optional

- (void)LookBtnClicked:(RepairManagementListCell *)cell;

- (void)PaiBtnClicked:(RepairManagementListCell *)cell;

- (void)DealBtnClicked:(RepairManagementListCell *)cell;

- (void)CallBtnClicked:(RepairManagementListCell *)cell;

- (void)MessageBtnClicked:(RepairManagementListCell *)cell;

@end


@interface RepairManagementListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPhoneNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *paiBtn;
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealBtnRightToSpaceLayout;
@property (weak, nonatomic) IBOutlet UILabel *fyspOrPhoneNumLabel;


@property(nonatomic,assign)BOOL isFYSP;

@property(nonatomic,assign)id<RepairManagementListCellDelegate>delegate;

@property(nonatomic,retain)RepairManagementModel *model;

@property(nonatomic,copy)NSString *cellRepairID;
@property(nonatomic,copy)NSString *phoneNumber;
@property(nonatomic,copy)NSString *userID;

@end
