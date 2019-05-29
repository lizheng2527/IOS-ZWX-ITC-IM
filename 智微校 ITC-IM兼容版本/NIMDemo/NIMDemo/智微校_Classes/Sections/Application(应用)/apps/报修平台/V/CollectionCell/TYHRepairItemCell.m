//
//  TYHRepairItemCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHRepairItemCell.h"
#import "TYHRepairMainModel.h"

@implementation TYHRepairItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.number.layer setMasksToBounds:YES];
    [self.number.layer setCornerRadius:8];
    [self.number.layer setBorderWidth:1.5];
    [self.number.layer setBorderColor:[UIColor TabBarColorOrange].CGColor];
    
}

- (void)getCellHidden:(TYHRepairItemCell *)cell withNum:(NSString *)num {
    // 不论 num 是NSString 还是 NSNumber
    int number =  [num intValue];
    if (!(number == 0)) {
        cell.number.hidden = NO;
        cell.number.text = [NSString stringWithFormat:@"%d",number];
        
    } else {
        cell.number.hidden = YES;
    }
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

-(void)layoutSubviews
{
    [self getCellHidden:self withNum:self.number.text];
}


@end
