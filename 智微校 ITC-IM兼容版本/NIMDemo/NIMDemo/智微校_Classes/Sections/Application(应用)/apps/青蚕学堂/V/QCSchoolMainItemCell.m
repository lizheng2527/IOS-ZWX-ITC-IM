//
//  QCSchoolMainItemCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/3/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSchoolMainItemCell.h"
#import "QCSSourceHandler.h"


@implementation QCSchoolMainItemCell

-(void)setModel:(QCSSourceModel *)model
{
    self.titleLabel.text = model.itemTitle;
    self.describitionLabell.text = model.itemDescribition;
    self.IconView.image = [UIImage imageNamed:model.itemImageString];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
