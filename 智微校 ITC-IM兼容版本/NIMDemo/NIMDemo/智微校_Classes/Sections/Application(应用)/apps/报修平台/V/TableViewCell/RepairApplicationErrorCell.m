//
//  RepairApplicationErrorCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RepairApplicationErrorCell.h"

@implementation RepairApplicationErrorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self contentViewConfig];
}

-(void)contentViewConfig
{
    _errorDescribleTextView.layer.masksToBounds = YES;
    _errorDescribleTextView.layer.cornerRadius = 5.0f;
    _errorDescribleTextView.layer.borderWidth = .5f;
    _errorDescribleTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _errorDescribleTextView.placeholder = @"必填";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
