//
//  homeworkListCell.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWListModel.h"

@interface homeworkListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *myBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *FinishLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *DetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *mutableTimeLabel_Left;

@property (weak, nonatomic) IBOutlet UILabel *mutableTimeLabel_Right;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@property(nonatomic,retain)HWListModel *model;

@end

