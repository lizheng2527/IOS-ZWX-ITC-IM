//
//  NTESNoticeSelPerTableViewCell.m
//  NIM
//
//  Created by 中电和讯 on 2019/11/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NTESNoticeSelPerTableViewCell.h"

@implementation NTESNoticeSelPerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
