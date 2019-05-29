//
//  AssetMineDetailCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetMineDetailCell;//为代理方法引入

@class AssetMineDetailModel;
@class AssetMineReturnModel;

@protocol AssetMineDetaitCellDelegate <NSObject>

-(void)assetAddBtnClickkkkk:(AssetMineDetailCell *)cell;

@end

@interface AssetMineDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetGuiGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *assetAddBtn;


@property(nonatomic,retain)AssetMineDetailModel *model;

@property (nonatomic,assign) id<AssetMineDetaitCellDelegate> delegate; 
@end
