//
//  WHOutResignCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WHOutResignCell.h"
#import "WHOutModel.h"

@implementation WHOutResignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self BtnConfig];
    
}


-(void)setModel:(WHOutModel *)model
{
    self.outCodeLabel.text = model.code;
    self.outWareHouseLabel.text = model.warehouseName;
    self.outDateLabel.text = model.date;
    self.outKindLabel.text = model.outKindValue;
    self.outApplicationUserLabel.text = model.receiverName;
    
    if (![model.signatureFlag isEqualToString:@"0"]) {
        self.resignBtn.hidden = YES;
        self.statusLabel.text = @"已签字";
    }
    else
    {
        self.resignBtn.hidden = NO;
        self.statusLabel.text = @"未签字";
        self.statusLabel.textColor = [UIColor redColor];
    }
}

-(void)BtnConfig
{
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = 3;
    _lookBtn.layer.borderWidth = 0.5f;
    _lookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lookBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
    _resignBtn.layer.masksToBounds = YES;
    _resignBtn.layer.cornerRadius = 3;
    _resignBtn.layer.borderWidth = 0.5f;
    _resignBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _resignBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
