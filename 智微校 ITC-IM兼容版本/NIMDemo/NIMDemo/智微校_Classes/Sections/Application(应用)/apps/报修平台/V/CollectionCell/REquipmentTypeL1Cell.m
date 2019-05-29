//
//  REquipmentTypeL1Cell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/13.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "REquipmentTypeL1Cell.h"
#import "TYHRepairMainModel.h"
#import <UIImageView+WebCache.h>
#import "TYHRepairDefine.h"

@implementation REquipmentTypeL1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor RepairBGColor];
}

-(void)setModel:(repairEquipmentTypeModel *)model
{
    self.itemNameLabel.text = model.name;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"icon_shebei_lan"]];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.contentView.backgroundColor = [UIColor RepairBGColor];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

@end
