//
//  AssetDiliverCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/9.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetDiliverCell.h"
#import "TYHAssetModel.h"

@implementation AssetDiliverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
}


-(void)setModel:(AssetMineReturnModel *)model
{
    _assetUserLabel.text = [NSString stringWithFormat:@" %@",model.userName];
    _assetDepartmentLabel.text = [NSString stringWithFormat:@" %@",model.departmentName];
    _assetDiliverLabel.text = [NSString stringWithFormat:@" %@",model.operatorName];
    _assetDiliverDateLabel.text = [NSString stringWithFormat:@" %@",model.operateDate.length?model.operateDate:@"暂无"];
    _assetQianziLabel.text = [NSString stringWithFormat:@" 是否签字: %@",model.signatureShow];
    if ([model.signatureShow isEqualToString:@"是"]) {
        _assetBuqianBtn.hidden = YES;
    }
    
}

-(void)initCellView
{
    _assetLookBtn.layer.masksToBounds = YES;
    _assetLookBtn.layer.cornerRadius = 3.0f;
    _assetLookBtn.layer.borderWidth = 0.5f;
    _assetLookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _assetBuqianBtn.layer.masksToBounds = YES;
    _assetBuqianBtn.layer.cornerRadius = 3.0f;
    _assetBuqianBtn.layer.borderWidth = 0.5f;
    _assetBuqianBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
