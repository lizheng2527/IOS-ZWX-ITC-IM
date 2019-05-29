//
//  ProjectNewApplicationCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectNewApplicationCell.h"

@implementation ProjectNewApplicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    [self initCellView];
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.applyTimeLabel.text = dateString;
    self.applyUserLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERNAME];
    self.applyUserPhoneLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MOBIENUM];
    
}

-(void)initCellView
{
    _textView_Describe.layer.masksToBounds = YES;
    _textView_Describe.layer.cornerRadius = 3.0f;
    _textView_Describe.layer.borderWidth = 0.5f;
    _textView_Describe.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView_Partner.layer.masksToBounds = YES;
    _textView_Partner.layer.cornerRadius = 3.0f;
    _textView_Partner.layer.borderWidth = 0.5f;
    _textView_Partner.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView_Opponent.layer.masksToBounds = YES;
    _textView_Opponent.layer.cornerRadius = 3.0f;
    _textView_Opponent.layer.borderWidth = 0.5f;
    _textView_Opponent.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
