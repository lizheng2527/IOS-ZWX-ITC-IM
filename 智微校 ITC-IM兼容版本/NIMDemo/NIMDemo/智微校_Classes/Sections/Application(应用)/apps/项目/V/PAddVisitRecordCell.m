//
//  PAddVisitRecordCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PAddVisitRecordCell.h"

@implementation PAddVisitRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    [self initCellView];
}

-(void)initCellView
{
    _visitReasonTextView.layer.masksToBounds = YES;
    _visitReasonTextView.layer.cornerRadius = 3.0f;
    _visitReasonTextView.layer.borderWidth = 0.5f;
    _visitReasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _togetherMemberTextView.layer.masksToBounds = YES;
    _togetherMemberTextView.layer.cornerRadius = 3.0f;
    _togetherMemberTextView.layer.borderWidth = 0.5f;
    _togetherMemberTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _remarkTextview.layer.masksToBounds = YES;
    _remarkTextview.layer.cornerRadius = 3.0f;
    _remarkTextview.layer.borderWidth = 0.5f;
    _remarkTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _visitJianshuTextview.layer.masksToBounds = YES;
    _visitJianshuTextview.layer.cornerRadius = 3.0f;
    _visitJianshuTextview.layer.borderWidth = 0.5f;
    _visitJianshuTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
