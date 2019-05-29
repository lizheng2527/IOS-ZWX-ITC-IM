//
//  MRADetailSeviceCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRADetailSeviceCell.h"
#import "MyRepairApplicationModel.h"

@implementation MRADetailSeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self viewConfig];
}


-(void)setModel:(MRAServerReocrdModel *)model
{
    self.titleLabel.text = model.recordContent;
    self.timeLabel.text = model.recordTime;
}

-(void)viewConfig
{
    self.backgroundColor = [UIColor clearColor];
    _circleLabel.layer.masksToBounds = YES;
    _circleLabel.layer.cornerRadius = 11 / 2;
    
    self.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
//    self.selectionStyle = NO;
}



-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
