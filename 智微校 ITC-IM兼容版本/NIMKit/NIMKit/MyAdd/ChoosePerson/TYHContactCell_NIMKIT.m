//
//  TYHContactCell_NIMKIT.m
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "TYHContactCell_NIMKIT.h"

@implementation TYHContactCell_NIMKIT

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(13, 23, 5, 5)];
        _icon.image = [UIImage imageNamed:@"未展开"];
        [self addSubview:_icon];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 15, 300, 21)];
        [self addSubview:_titleLabel];
        
        float indentPoints = self.indentationLevel * self.indentationWidth;
        
        self.contentView.frame = CGRectMake(
                                            indentPoints,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width - indentPoints,
                                            self.contentView.frame.size.height
                                            );
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
