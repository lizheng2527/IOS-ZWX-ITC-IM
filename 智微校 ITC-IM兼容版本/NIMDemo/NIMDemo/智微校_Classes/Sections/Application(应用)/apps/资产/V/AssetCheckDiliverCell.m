//
//  AssetCheckDiliverCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetCheckDiliverCell.h"
#import "TYHAssetModel.h"
#import "NSString+Empty.h"
@implementation AssetCheckDiliverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
}

-(void)setModel:(AssetCheckDiliverModel *)model
{
    _assetTypeLabel.text      = [NSString stringWithFormat:@"%@",model.assetKindName];
    _assetDateLabel.text     = [NSString stringWithFormat:@"%@",model.applyDate];
    _assetPersonLabel.text  = [NSString stringWithFormat:@"%@",model.applyUserName];
    _assetBumenLabel.text  = [NSString stringWithFormat:@"%@",model.departmentName];
    _assetSchoolLabel.text  = [NSString stringWithFormat:@"%@",model.school];
    if (![NSString isBlankString:model.reason]) {
        _assetUsageLabel.text   = [NSString stringWithFormat:@"%@",model.reason];
    }
    if (![NSString isBlankString:model.demand]) {
        _assetNeedLabel.text   = [NSString stringWithFormat:@"%@",model.demand];
    }
    _assetCheckStateLabel.text = [NSString stringWithFormat:@"%@",model.checkStatusView];
    
    if([model.checkStatusView isEqualToString:@"已发放"])
    {
        self.assetDiliverBtn.hidden = YES;
        self.assetCheckBtn.hidden = YES;
    }
    else if([model.checkStatusView isEqualToString:@"未通过"])
    {
        self.assetDiliverBtn.hidden = YES;
        self.assetCheckBtn.hidden = NO;
    }
    else if([model.checkStatusView isEqualToString:@"已通过"])
    {
        self.assetCheckBtn.hidden = NO;
        self.assetDiliverBtn.hidden = NO;
    }
    else if([model.checkStatusView isEqualToString:@"未审核"])
    {
        self.assetDiliverBtn.hidden = YES;
    }
    
    if (self.assetDiliverBtn.hidden) {
        self.chenkBtnRIghtToViewLayout.constant = 114 - 11 - 46;
    }
}

-(void)initCellView
{
    _assetCheckBtn.layer.masksToBounds = YES;
    _assetCheckBtn.layer.cornerRadius = 3.0f;
    _assetCheckBtn.layer.borderWidth = 0.5f;
    _assetCheckBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _assetDiliverBtn.layer.masksToBounds = YES;
    _assetDiliverBtn.layer.cornerRadius = 3.0f;
    _assetDiliverBtn.layer.borderWidth = 0.5f;
    _assetDiliverBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _assetLookBtn.layer.masksToBounds = YES;
    _assetLookBtn.layer.cornerRadius = 3.0f;
    _assetLookBtn.layer.borderWidth = 0.5f;
    _assetLookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
