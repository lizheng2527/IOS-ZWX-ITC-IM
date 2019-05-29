//
//  AssetApplyDetailController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/2.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetApplyDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetApplyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetApplyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetApplyOraginationLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetBeiApplyOraLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetUsageNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetSetNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetApplyStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetCheckLabel;

@property(nonatomic,copy)NSString *applyID;
@end
