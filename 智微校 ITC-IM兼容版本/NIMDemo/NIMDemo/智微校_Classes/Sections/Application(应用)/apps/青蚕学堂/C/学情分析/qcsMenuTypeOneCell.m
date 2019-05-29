//
//  qcsMenuTypeOneCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/27.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsMenuTypeOneCell.h"
#import "QCSchoolDefine.h"
@implementation qcsMenuTypeOneCell

-(void)setModelStudent:(QCSSourceModel *)modelStudent
{
    self.iconView.image = [UIImage imageNamed:modelStudent.itemDescribition];
    self.titleLabel.text = modelStudent.itemTitle;
}

-(void)setModelClass:(QCSSourceModel *)modelClass
{
    if ([modelClass.typeNum isEqualToString:@"0"] && [modelClass.level isEqualToString:@"0"]) {
        self.iconView.image = [UIImage imageNamed:modelClass.itemImageString];
        self.titleLabel.textColor = [UIColor blackColor];
        self.selectionStyle = NO;
    }
    if ([modelClass.typeNum isEqualToString:@"1"] && [modelClass.level isEqualToString:@"0"]) {
        self.iconView.image = [UIImage imageNamed:modelClass.itemImageString];
        self.titleLabel.textColor = [UIColor blackColor];
        self.selectionStyle = NO;
    }
    
    self.titleLabel.text = modelClass.itemTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
