//
//  AssetMineReturnCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/6.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetMineReturnModel;

@interface AssetMineReturnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *returnPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnOrganizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnHandlerPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *returnLookBTN;

@property (weak, nonatomic) IBOutlet UILabel *returnQianziLabel;

@property(nonatomic,retain)AssetMineReturnModel *rModel;

@end
