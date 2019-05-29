//
//  AssetDiliverCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/9.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetMineReturnModel;

@interface AssetDiliverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *assetUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDepartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDiliverLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDiliverDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetLookBtn;
@property (weak, nonatomic) IBOutlet UIButton *assetBuqianBtn;

@property (weak, nonatomic) IBOutlet UILabel *assetQianziLabel;

@property(nonatomic,retain)AssetMineReturnModel *model;
@end
