//
//  AttendanceCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceCell.h"
#import "AttendanceModel.h"

@implementation AttendanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellModel:(AttendanceListModel *)cellModel
{
    if ([cellModel.typeString isEqualToString:@"上班考勤"]) {
        self.timeLabel.text = [NSString stringWithFormat:@"上班考勤时间 %@",cellModel.startTime];
        self.locationLabel.text = [NSString stringWithFormat:@"%@",cellModel.startAddress];
        if ([cellModel.startTime isEqualToString:@"上班未考勤"]) {
            self.timeLabel.text = @"上班未考勤";
            self.locationLabel.text = @"暂无";
            [self.refreshBtn setTitle:@"上班补签" forState:UIControlStateNormal];
            self.refreshImageView.image = [UIImage imageNamed:@"icon_ci_bu"];
        }
        
        if ([cellModel.startTime hasSuffix:@"(补签)"]) {
            self.refreshBtn.hidden = YES;
            self.refreshImageView.hidden = YES;
        }
    }
    else
    {
        self.refreshBtn.hidden = YES;
        self.refreshImageView.hidden = YES;
        
        self.timeLabel.text = [NSString stringWithFormat:@"下班考勤时间 %@",cellModel.endTime];
        self.locationLabel.text = [NSString stringWithFormat:@"%@",cellModel.endAddress];
        self.typeImageView.image = [UIImage imageNamed:@"icon_xia"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
