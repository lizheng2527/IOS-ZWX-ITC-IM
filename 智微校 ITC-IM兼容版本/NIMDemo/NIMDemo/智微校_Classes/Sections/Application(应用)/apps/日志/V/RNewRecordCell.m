//
//  RNewRecordCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RNewRecordCell.h"

@implementation RNewRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = NO;
    [self initCellView];
}

-(void)initCellView
{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    _timeLabel.text = dateString;
    
    _planTextview.layer.masksToBounds = YES;
    _planTextview.layer.cornerRadius = 3.0f;
    _planTextview.layer.borderWidth = 0.5f;
    _planTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _summarizeTextview.layer.masksToBounds = YES;
    _summarizeTextview.layer.cornerRadius = 3.0f;
    _summarizeTextview.layer.borderWidth = 0.5f;
    _summarizeTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _noteTextview.layer.masksToBounds = YES;
    _noteTextview.layer.cornerRadius = 3.0f;
    _noteTextview.layer.borderWidth = 0.5f;
    _noteTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
