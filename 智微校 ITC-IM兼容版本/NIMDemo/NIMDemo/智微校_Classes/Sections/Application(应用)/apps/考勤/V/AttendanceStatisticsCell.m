//
//  AttendanceStatisticsCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceStatisticsCell.h"
#import "AttendanceModel.h"
#import "NSString+Empty.h"

@implementation AttendanceStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(AttendanceListModel *)model
{
    if (![NSString isBlankString:model.startTime]) {
        _startTimeLabel.text = [NSString stringWithFormat:@"%@",model.startTime];
    }
    if (![NSString isBlankString:model.startAddress]) {
        _startAddressLabel.text = [NSString stringWithFormat:@"%@",model.startAddress];
    }
    if (![NSString isBlankString:model.endTime]) {
        _endTimeLabel.text = [NSString stringWithFormat:@"%@",model.endTime];
    }
    if (![NSString isBlankString:model.endAddress]) {
        _endStressLabel.text = [NSString stringWithFormat:@"%@",model.endAddress];
    }
    
     if (![NSString isBlankString:model.workTime]) {
         _countLabel.text = [NSString stringWithFormat:@"%@小时",model.workTime];
     }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFARLT_UserName];
    if ([_nameLabel.text isEqualToString:userName]) {
        _nameLabel.textColor = [UIColor orangeColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
