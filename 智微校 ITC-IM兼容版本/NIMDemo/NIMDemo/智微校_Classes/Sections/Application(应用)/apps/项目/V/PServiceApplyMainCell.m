//
//  PServiceApplyMainCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PServiceApplyMainCell.h"
#import "ProjectMainModel.h"


@implementation PServiceApplyMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
    self.selectionStyle = NO;
}


-(void)setModel:(ProjectServiceApplyListModel *)model
{
    _model = model;
    
    _Label_ApplyUser.text = model.applyUserName;
    _Label_ServiceTime.text = model.serviceTime;
    _Label_ServiceCustom.text = model.serviceObject;
    _Label_ServiceTips.text = model.serviceSketch;
    
    
    _Label_Status.text = [model.check isEqualToString: @"0"]?@"待审核":@"已通过";
    if ([model.check isEqualToString:@"0"]) {
        _Label_Status.textColor = [UIColor redColor];
    }else
    {
        _Label_Status.textColor = [UIColor greenColor];
        self.Button_Check.hidden = YES;
    }
    
}

-(void)initCellView
{
    _Button_Check.layer.masksToBounds = YES;
    _Button_Check.layer.cornerRadius = 3.0f;
    _Button_Check.layer.borderWidth = 0.5f;
    _Button_Check.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _Button_Detail.layer.masksToBounds = YES;
    _Button_Detail.layer.cornerRadius = 3.0f;
    _Button_Detail.layer.borderWidth = 0.5f;
    _Button_Detail.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


#pragma mark - ButtonClick

- (IBAction)checkAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CheckClickedInServiceApply:)]) {
        [self.delegate CheckClickedInServiceApply:self];
    }
}

- (IBAction)detailAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DetailBtnClickedInServiceApply:)]) {
        [self.delegate DetailBtnClickedInServiceApply:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
