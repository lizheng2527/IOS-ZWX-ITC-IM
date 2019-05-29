//
//  WHApplicationItemCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationItemCell.h"
#import "TYHRepairDefine.h"

@implementation WHApplicationItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.layer.cornerRadius = 3;
    _deleteBtn.layer.borderWidth = 0.5f;
    _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _deleteBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
    [_decreaseBtn setBackgroundColor:[UIColor RepairBGColor]];
    [_addBtn setBackgroundColor:[UIColor RepairBGColor]];
}

#pragma mark - clickActions
- (IBAction)discreaseBtnDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemWillDiscrease:)]) {
        [_delegate itemWillDiscrease:self];
    }
}

- (IBAction)addBtnDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemWillAdd:)]) {
        [_delegate itemWillAdd:self];
    }
}

- (IBAction)deleteBtnDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemWillDel:)]) {
        [_delegate itemWillDel:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
