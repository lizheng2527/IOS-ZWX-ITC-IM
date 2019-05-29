//
//  qcsClassDetailInsideXZTDetailCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideXZTDetailCell.h"
#import "QCSClassDetailModel.h"
@implementation qcsClassDetailInsideXZTDetailCell

-(void)setModel:(QCSClassDetailXZTInsideModel *)model
{
    self.titleLabel.text = model.option;
    self.detailLabel.text = model.studentNames;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
