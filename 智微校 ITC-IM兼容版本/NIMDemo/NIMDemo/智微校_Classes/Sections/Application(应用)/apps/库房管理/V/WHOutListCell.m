//
//  WHOutListCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHOutListCell.h"
#import "WHMyApplicationModel.h"
#import "TYHWarehouseDefine.h"

@implementation WHOutListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self BtnConfig];
}


-(void)setModel:(WHMyApplicationModel *)model
{
    self.applyCodeLabel.text = model.code;
    self.applyOrgLabel.text = model.departmentName;
    self.applyDateLabel.text = model.date;
    self.applyTypeLabel.text = model.kindValue;
    self.applyCheckStatusLabel.text = model.checkStatusValue;
    self.applyDiliverStatusLabel.text = model.provideStatusValue;
    if ([model.provideStatusValue isEqualToString:@"未发放"]) {
        self.applyDiliverStatusLabel.textColor = [UIColor redColor];
        self.checkBtn.hidden = NO;
    }
}



-(void)BtnConfig
{
    
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = 3;
    _lookBtn.layer.borderWidth = 0.5f;
    _lookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lookBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
    _checkBtn.layer.masksToBounds = YES;
    _checkBtn.layer.cornerRadius = 3;
    _checkBtn.layer.borderWidth = 0.5f;
    _checkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _checkBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
