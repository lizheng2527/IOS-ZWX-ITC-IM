//
//  WHApplicationDetailMainCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHMyDetailModel;


@interface WHApplicationDetailMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyOrgLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyCheckerLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyCheckStatusLabel;

@property(nonatomic,retain)WHMyDetailModel *model;
@end
