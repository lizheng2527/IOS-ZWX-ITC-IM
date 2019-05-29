//
//  PCheckMainCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCheckMainCell;

@class ProjectServiceApplyListModel;

@protocol PCheckMainCellDelegate <NSObject>

@optional

- (void)CheckClicked:(PCheckMainCell *)cell;

- (void)DetailBtnClicked:(PCheckMainCell *)cell;
@end


@interface PCheckMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Label_BelongProject;
@property (weak, nonatomic) IBOutlet UILabel *Label_ApplyUser;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTime;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceCustom;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTips;

@property (weak, nonatomic) IBOutlet UILabel *Label_Status;
@property (weak, nonatomic) IBOutlet UIButton *Button_Check;
@property (weak, nonatomic) IBOutlet UIButton *Button_Detail;

@property(nonatomic,retain)ProjectServiceApplyListModel *model;

@property(nonatomic,assign)id<PCheckMainCellDelegate>delegate;

@end
