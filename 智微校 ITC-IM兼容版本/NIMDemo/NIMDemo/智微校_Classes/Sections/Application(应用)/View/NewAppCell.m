//
//  NewAppCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/2/25.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "NewAppCell.h"

@implementation NewAppCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}


@end
