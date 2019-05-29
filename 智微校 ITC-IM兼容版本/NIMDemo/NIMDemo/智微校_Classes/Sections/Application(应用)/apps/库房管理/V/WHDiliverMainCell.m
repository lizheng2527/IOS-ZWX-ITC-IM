//
//  WHDiliverMainCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHDiliverMainCell.h"
#import "WHMyApplicationModel.h"


@implementation WHDiliverMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self cellConfig];
}

-(void)cellConfig
{
    self.userPersonLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseUserPersonLabelAction:)];
    [self.userPersonLabel addGestureRecognizer:ges];
}

-(void)setModel:(WHMyDetailModel *)model
{
    self.numberTextfield.text = model.code;
    [self.outDateBtn setTitle:model.applyDate forState:UIControlStateNormal];
}

#pragma mark - CellAction

- (IBAction)chooseDateAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyDateBtnDidClick:)]) {
        [_delegate applyDateBtnDidClick:self];
    }
}

- (IBAction)chooseWareHouseAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyOutWarehouseBtnDidClick:)]) {
        [_delegate applyOutWarehouseBtnDidClick:self];
    }
}
- (IBAction)chooseUseTypeAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyUseKindBtnDidClick:)]) {
        [_delegate applyUseKindBtnDidClick:self];
    }
}

- (IBAction)chooseDepartmentAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(applyDepartmentBtnDidClick:)]) {
        [_delegate applyDepartmentBtnDidClick:self];
    }
}




-(void)chooseUserPersonLabelAction:(id)sender
{
    if (self.delegate && [_delegate respondsToSelector:@selector(applyUserBtnDidClick:)]) {
        [_delegate applyUserBtnDidClick:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
