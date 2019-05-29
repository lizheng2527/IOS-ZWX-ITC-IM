//
//  AssetCheckDiliverCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetCheckDiliverModel;


@interface AssetCheckDiliverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chenkBtnRIghtToViewLayout;

@property (weak, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetBumenLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetNeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetUsageLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *assetDiliverBtn;
@property (weak, nonatomic) IBOutlet UIButton *assetLookBtn;

@property (weak, nonatomic) IBOutlet UILabel *assetCheckStateLabel;

@property(nonatomic,retain)AssetCheckDiliverModel *model;

@end
