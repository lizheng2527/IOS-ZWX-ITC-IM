//
//  TYHUserListCell.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/2/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolMatesModel.h"

@interface TYHUserListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabelImage;
@property (weak, nonatomic) IBOutlet UILabel *monthLabelImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageTmp;
@property (weak, nonatomic) IBOutlet UILabel *contenLabelImage;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)setCellWithMomentModel :(momentsModel *)model;

@end
