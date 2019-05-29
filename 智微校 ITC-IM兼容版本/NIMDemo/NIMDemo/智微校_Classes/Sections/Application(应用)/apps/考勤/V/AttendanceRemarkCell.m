//
//  AttendanceRemarkCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceRemarkCell.h"

@implementation AttendanceRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _useageBtn.layer.masksToBounds = YES;
    _useageBtn.layer.cornerRadius = 4.0f;
}

- (IBAction)delAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(remarkItemDelete:)]) {
        [_delegate remarkItemDelete:(self)];
    }
}

- (IBAction)typeChooseAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(typeBtnChoose:)]) {
        [_delegate typeBtnChoose:(self)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end
