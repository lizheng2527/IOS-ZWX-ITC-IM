//
//  AttendanceStatisticsCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceListModel;
@interface AttendanceStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStressLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property(nonatomic,retain)AttendanceListModel *model;
@end
