//
//  PAddServiceApplyCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PAddServiceApplyCell.h"

@implementation PAddServiceApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = NO;
    [self initCellView];
}


-(void)initCellView
{
    _textView_Jianshu.layer.masksToBounds = YES;
    _textView_Jianshu.layer.cornerRadius = 3.0f;
    _textView_Jianshu.layer.borderWidth = 0.5f;
    _textView_Jianshu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView_Target.layer.masksToBounds = YES;
    _textView_Target.layer.cornerRadius = 3.0f;
    _textView_Target.layer.borderWidth = 0.5f;
    _textView_Target.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView_Member.layer.masksToBounds = YES;
    _textView_Member.layer.cornerRadius = 3.0f;
    _textView_Member.layer.borderWidth = 0.5f;
    _textView_Member.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView_Remark.layer.masksToBounds = YES;
    _textView_Remark.layer.cornerRadius = 3.0f;
    _textView_Remark.layer.borderWidth = 0.5f;
    _textView_Remark.layer.borderColor = [UIColor lightGrayColor].CGColor;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
