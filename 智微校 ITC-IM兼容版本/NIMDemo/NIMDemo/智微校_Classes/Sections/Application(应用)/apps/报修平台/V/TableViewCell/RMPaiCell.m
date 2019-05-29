//
//  RMPaiCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RMPaiCell.h"
#import "RepairManagementModel.h"

@implementation RMPaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self LabelConfig];
    }
    return self;
}

-(void)LabelConfig
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, (SCREEN_WIDTH - 30) / 3, 30)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.likeRepairCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + (SCREEN_WIDTH - 30) / 3, 7, (SCREEN_WIDTH - 30) / 3, 30)];
    self.likeRepairCountLabel.font = [UIFont boldSystemFontOfSize:15];
    self.likeRepairCountLabel.textAlignment = NSTextAlignmentCenter;
    self.likeRepairCountLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.likeRepairCountLabel];
    
    self.nowRepairingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + (SCREEN_WIDTH - 30) / 3 * 2, 7, (SCREEN_WIDTH - 30) / 3, 30)];
    self.nowRepairingLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nowRepairingLabel.textColor = [UIColor darkGrayColor];
    self.nowRepairingLabel.textAlignment = NSTextAlignmentCenter;
    self.nowRepairingLabel.text = @"当前维修数";
    [self.contentView addSubview:self.nowRepairingLabel];
    
}


-(void)setModel:(RMServerWorkerModel *)model
{
    self.nameLabel.text = model.workerName;
    self.likeRepairCountLabel.text = model.sameKindWorkCount;
    self.nowRepairingLabel.text = model.workingCount;
    
    if ([model.sameKindWorkCount integerValue] >0) {
        self.likeRepairCountLabel.textColor = [UIColor redColor];
    }
    if ([model.workingCount integerValue] >0) {
        self.nowRepairingLabel.textColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:216/255.0 alpha:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
