//
//  AttachmentCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/11/6.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "AttachmentCell.h"


@implementation AttachmentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setNameLabel:(UILabel *)nameLabel {

    _nameLabel = nameLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)cellAutoLayoutHeight:(NSString *)str {

        return (CGFloat)fmaxf(30.0f, (float)[self detailTextHeight:str] + 15.0f);
    
}
+ (CGFloat)detailTextHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(240.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil];
    return rectToFit.size.height;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
//    CGFloat calculatedHeight = [[self class] detailTextHeight:_nameLabel.text];
//    detailTextLabelFrame.size.height = calculatedHeight;
//    self.nameLabel.frame = detailTextLabelFrame;
}

@end
