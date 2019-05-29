//
//  WHApplicationMainCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationMainCell.h"
#import "WHApplicationModel.h"



@implementation WHApplicationMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(WHApplicationModel *)model
{
    self.applyNumTextField.text = model.applyMessageModel.code;
    [self.applyDateBtn setTitle:model.applyMessageModel.date forState:UIControlStateNormal];
    if (model.myDepartmentListArray.count) {
        [self.applyOrgBtn setTitle:[model.myDepartmentListArray[0] departmentName] forState:UIControlStateNormal];
        if ([model.myDepartmentListArray[0] userListModelArray].count) {
            [self.applyCheckerBtn setTitle:[[model.myDepartmentListArray[0] userListModelArray][0] checkUserName] forState:UIControlStateNormal];
        }
    }
//    self.applyReasonTF.text = model.applyReason;
//    self.applyTipTF.text = model.applyNote;
    
    [self.applyTypeBtn setTitle:model.applyReceiveKindModel.grsl forState:UIControlStateNormal];
}


- (IBAction)applyDateBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyDateBtnDidClick:)]) {
        [_delegate applyDateBtnDidClick:self];
    }
}

- (IBAction)applyOrgBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyOrgBtnDidClick:)]) {
        [_delegate applyOrgBtnDidClick:self];
    }
}

- (IBAction)applyCheckerBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyCheckerBtnDidClick:)]) {
        [_delegate applyCheckerBtnDidClick:self];
    }
}
- (IBAction)applyTypeBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyTypeBtnDidClick:)]) {
        [_delegate applyTypeBtnDidClick:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
