//
//  AssetDetailController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/1.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDetailController : UIViewController
@property(nonatomic,copy)NSString *assetCode;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetGuiGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetSavePersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetSvaeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetBuyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetOwnOraLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetSolveLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetAddDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *assetImageViewTap;

@property(nonatomic,copy)NSString *whoGoinType;
@property (weak, nonatomic) IBOutlet UIButton *diliverBtn;
@property(nonatomic,retain)NSMutableArray *dataArray;

@end
