//
//  RMPaiHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 17/3/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RMPaiHeaderView.h"

@implementation RMPaiHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self LabelConfig];
    }
    return self;
}

-(void)LabelConfig
{
    self.backgroundColor = [UIColor colorWithRed:234/255.0 green:239/255.0 blue:242/255.0 alpha:0.8];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, (SCREEN_WIDTH - 30) / 3, 30)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor darkGrayColor];
    self.nameLabel.text = @"姓名";
    [self addSubview:self.nameLabel];
    
    self.likeRepairCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(35 + (SCREEN_WIDTH - 30) / 3, 5, (SCREEN_WIDTH - 30) / 3, 30)];
    self.likeRepairCountLabel.font = [UIFont boldSystemFontOfSize:15];
    self.likeRepairCountLabel.textAlignment = NSTextAlignmentCenter;
    self.likeRepairCountLabel.textColor = [UIColor darkGrayColor];
    self.likeRepairCountLabel.text = @"类似维修数";
    [self addSubview:self.likeRepairCountLabel];
    
    self.nowRepairingLabel = [[UILabel alloc]initWithFrame:CGRectMake(35 + (SCREEN_WIDTH - 30) / 3 * 2, 5, (SCREEN_WIDTH - 30) / 3, 30)];
    self.nowRepairingLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nowRepairingLabel.textAlignment = NSTextAlignmentCenter;
    self.nowRepairingLabel.textColor = [UIColor darkGrayColor];
    self.nowRepairingLabel.text = @"当前维修数";
    [self addSubview:self.nowRepairingLabel];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
