//
//  PServerRecordCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PServerRecordCell;
@class ProjectServiceRecordListModel;

@protocol PServerRecordCellDelegate <NSObject>

@optional

- (void)CheckClickedInServerRecord:(PServerRecordCell *)cell;

- (void)DetailBtnClickedInServerRecord:(PServerRecordCell *)cell;
@end


@interface PServerRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Label_ServicePerson;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTime;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceCustom;
@property (weak, nonatomic) IBOutlet UILabel *Label_ServiceTips;

@property (weak, nonatomic) IBOutlet UILabel *Label_Status;
@property (weak, nonatomic) IBOutlet UIButton *Button_Check;
@property (weak, nonatomic) IBOutlet UIButton *Button_Detail;

@property(nonatomic,retain)ProjectServiceRecordListModel*model;
@property(nonatomic,assign)id<PServerRecordCellDelegate>delegate;

@end
