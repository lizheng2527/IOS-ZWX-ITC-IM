//
//  WHApplicationDetailMainCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationDetailMainCell.h"
#import "WHMyApplicationModel.h"


@implementation WHApplicationDetailMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setModel:(WHMyDetailModel *)model
{
    self.applyCodeLabel.text = model.code;
    self.applyOrgLabel.text = model.departmentName;
    self.applyCheckerLabel.text = model.departCheckUserName;
    self.applyDateLabel.text = model.applyDate;
    self.applyTypeLabel.text = model.kindValue;
    self.applyReasonLabel.text = model.reason;
    self.applyTipsLabel.text = model.note;
    self.applyCheckStatusLabel.text = [NSString stringWithFormat:@"%@  %@",model.deptCheckStatus.length?model.deptCheckStatus:@"",model.zwCheckStatus.length?model.zwCheckStatus:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
