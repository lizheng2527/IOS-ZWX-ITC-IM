//
//  AssetMineDetailCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetMineDetailCell.h"
#import "TYHAssetModel.h"

@implementation AssetMineDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    return self;
}

-(void)setModel:(AssetMineDetailModel *)model
{
    _assetNameLabel.text = [NSString stringWithFormat:@"资产名称: %@",model.name];
    _assetTypeLabel.text = [NSString stringWithFormat:@"资产类别: %@",model.assetKindName];
    _assetCodeLabel.text = [NSString stringWithFormat:@"资产编码: %@",model.code];
    _assetDateLabel.text = [NSString stringWithFormat:@"借用日期: %@",model.registrationDate];
    _assetGuiGeLabel.text =[NSString stringWithFormat:@"型号规格: %@",model.patternName];
}


-(void)initCellView
{
    _assetCheckBtn.layer.masksToBounds = YES;
    _assetCheckBtn.layer.cornerRadius = 3.0f;
    _assetCheckBtn.layer.borderWidth = 0.5f;
    _assetCheckBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _assetAddBtn.layer.masksToBounds = YES;
    _assetAddBtn.layer.cornerRadius = 3.0f;
    _assetAddBtn.layer.borderWidth = 0.5f;
    _assetAddBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_assetAddBtn addTarget:self action:@selector(assetAddAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)assetAddAction:(id)sender
{
    UIButton *button = sender;
    
    [self.delegate assetAddBtnClickkkkk:self];
//    if ([self.assetAddBtn.titleLabel.text isEqualToString:@"添加"]) {
        [button setTitle:@"移除" forState:UIControlStateNormal];
//    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
