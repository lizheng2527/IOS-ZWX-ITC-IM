//
//  ButtonCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/29/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "ButtonCell.h"
#import "TYHAssetModel.h"
#import "TYHRepairMainModel.h"


@implementation ButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.number.layer setMasksToBounds:YES];
    [self.number.layer setCornerRadius:8];
    [self.number.layer setBorderWidth:1.5];
    [self.number.layer setBorderColor:[UIColor TabBarColorOrange].CGColor];
    
}


-(void)setManagerItemModel:(TYHAssetManagerItemModel *)managerItemModel
{
    self.name.text = managerItemModel.itemName;
    self.number.text = managerItemModel.itemNum;
    self.backImage.image = [UIImage imageNamed:managerItemModel.itemImage];
    //    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    [self getCellHidden:self withNum:managerItemModel.itemNum];
}


- (void)getCellHidden:(ButtonCell *)cell withNum:(NSString *)num {
    // 不论 num 是NSString 还是 NSNumber
    int number =  [num intValue];
    if (!(number == 0)) {
        cell.number.hidden = NO;
        cell.number.text = [NSString stringWithFormat:@"%d",number];
        
    } else {
        cell.number.hidden = YES;
    }
}

//-(void)layoutSubviews
//{
//    [self getCellHidden:self withNum:self.number.text];
//}


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

//我要维修-app
-(void)setRepairModel:(id)repairModel
{
    
}


@end
