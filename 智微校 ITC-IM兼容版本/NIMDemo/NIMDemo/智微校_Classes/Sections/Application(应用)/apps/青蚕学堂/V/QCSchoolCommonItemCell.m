//
//  QCSchoolCommonItemCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/3/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSchoolCommonItemCell.h"
#import "QCSSourceHandler.h"

@implementation QCSchoolCommonItemCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 2.f;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setModel:(QCSSourceModel *)model
{
    self.titleLabel.text = model.itemTitle;
    self.IconView.image = [UIImage imageNamed:model.itemImageString];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
