//
//  CAEvaluateListCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CAEvaluateListCell.h"
#import "ClassAttendanceModel.h"


@implementation CAEvaluateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    self.contentView.backgroundColor= [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
}



-(void)setModel:(CAEvaluateItemModel *)model
{
    _model = model;
    self.itemNameLabel.text = model.name;
    self.itemScoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
    
    
    if ([model.score hasPrefix:@"+"]) {
        self.itemScoreLabel.textColor = [UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1];
    }else
    {
        self.itemScoreLabel.textColor = [UIColor redColor];
    }
    
}


- (IBAction)delButtonClickedAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemDelButtonClicked:)]) {

        [self.delegate itemDelButtonClicked:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
