//
//  AttendanceCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceListModel;

@interface AttendanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImageView;

@property(nonatomic,retain)AttendanceListModel *cellModel;
@end
