//
//  TYHContactCell.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "TYHContactCell.h"

@implementation TYHContactCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(
                                        indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height
                                        );
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
