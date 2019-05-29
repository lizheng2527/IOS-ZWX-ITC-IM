//
//  PServerRecordCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PServerRecordCell.h"
#import "ProjectMainModel.h"


@implementation PServerRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
    self.selectionStyle = NO;
}


-(void)setModel:(ProjectServiceRecordListModel *)model
{
    
    _model = model;
    _Label_ServicePerson.text = model.applyUserName;
    
    _Label_ServiceTime.text = model.serviceTime;
    
    _Label_ServiceCustom.text = model.serviceObject;
    
    _Label_ServiceTips.text = model.serviceSketch;
    
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
    if ([self.delegate respondsToSelector:@selector(CheckClickedInServerRecord:)]) {
        [self.delegate CheckClickedInServerRecord:self];
    }
}

- (IBAction)detailAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DetailBtnClickedInServerRecord:)]) {
        [self.delegate DetailBtnClickedInServerRecord:self];
    }
}
@end
