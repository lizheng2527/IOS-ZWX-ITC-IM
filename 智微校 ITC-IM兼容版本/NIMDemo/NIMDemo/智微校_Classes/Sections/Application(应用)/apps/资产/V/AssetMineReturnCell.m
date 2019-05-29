//
//  AssetMineReturnCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/6.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetMineReturnCell.h"
#import "TYHAssetModel.h"

@implementation AssetMineReturnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
}


-(void)initCellView
{
    _returnLookBTN.layer.masksToBounds = YES;
    _returnLookBTN.layer.cornerRadius = 3.0f;
    _returnLookBTN.layer.borderWidth = 0.5f;
    _returnLookBTN.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)setRModel:(AssetMineReturnModel *)rModel
{
    _returnPersonLabel.text = [NSString stringWithFormat:@"归还人: %@",rModel.userName];
    _returnOrganizationLabel.text = [NSString stringWithFormat:@"归还部门: %@",rModel.departmentName];
    _returnHandlerPersonLabel.text = [NSString stringWithFormat:@"经办人: %@",rModel.operatorName];
    _returnDateLabel.text = [NSString stringWithFormat:@"归还日期: %@",rModel.operateDate];
    
    _returnQianziLabel.text = [NSString stringWithFormat:@"是否签字: %@",rModel.signatureShow];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
