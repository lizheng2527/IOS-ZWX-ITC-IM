//
//  WHMineListCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHMineListCell.h"
#import "WHMyApplicationModel.h"
#import "TYHWarehouseDefine.h"

@implementation WHMineListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configView];
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
    }
    
    if ([model.deptCheckStatusValue isEqualToString:@"部门未审核"] && model.checkKind == 0) {
        self.checkBtn.hidden = NO;
    }
    else if([model.zwCheckStatusValue isEqualToString:@"总务未审核"] && model.checkKind == 1)
    {
        self.checkBtn.hidden = NO;
    }
    else self.checkBtn.hidden = YES;
    
    if ([model.provideStatusValue isEqualToString:@"未发放"] && [model.checkStatusValue isEqualToString:@"总务审核通过"] && model.checkKind == 1) {
        self.checkBtn.hidden = NO;
    }
}

-(void)configView
{
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = 3;
    _lookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lookBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _lookBtn.layer.borderWidth = 0.5f;
    
    _checkBtn.layer.masksToBounds = YES;
    _checkBtn.layer.cornerRadius = 3;
    _checkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _checkBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _checkBtn.layer.borderWidth = 0.5f;
    
    _checkBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
