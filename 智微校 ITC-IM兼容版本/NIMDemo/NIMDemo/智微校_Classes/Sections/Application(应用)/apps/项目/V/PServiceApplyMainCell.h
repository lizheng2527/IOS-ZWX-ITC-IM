//
//  PServiceApplyMainCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PServiceApplyMainCell;

@class ProjectServiceApplyListModel;

@protocol PServiceApplyMainCellDelegate <NSObject>

@optional

- (void)CheckClickedInServiceApply:(PServiceApplyMainCell *)cell;

- (void)DetailBtnClickedInServiceApply:(PServiceApplyMainCell *)cell;
@end



@interface PServiceApplyMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Label_BelongProject;
@property (weak, nonatomic) IBOutlet UILabel *Label_ApplyUser;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTime;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceCustom;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTips;

@property (weak, nonatomic) IBOutlet UILabel *Label_Status;
@property (weak, nonatomic) IBOutlet UIButton *Button_Check;
@property (weak, nonatomic) IBOutlet UIButton *Button_Detail;

@property(nonatomic,retain)ProjectServiceApplyListModel *model;

@property(nonatomic,assign)id<PServiceApplyMainCellDelegate>delegate;
@end
