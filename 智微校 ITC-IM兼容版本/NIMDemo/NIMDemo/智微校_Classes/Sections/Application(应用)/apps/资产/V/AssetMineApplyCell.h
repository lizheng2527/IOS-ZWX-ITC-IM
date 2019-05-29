//
//  AssetMineApplyCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetMineApplyModel;

@interface AssetMineApplyCell : UITableViewCell
@property(nonatomic,retain)AssetMineApplyModel *model;

@property (weak, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetBumenLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *assetCheckLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetCheckBtn;

@end
