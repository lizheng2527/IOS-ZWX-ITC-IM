//
//  TYHContactDetailCell.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "TYHContactDetailCell.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>
#import "PublicDefine.h"

@implementation TYHContactDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer *lay = _userIcon.layer;//获取ImageView的层 [lay
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:10.0];
//        _userIcon.layer.masksToBounds = YES;
//        _userIcon.layer.cornerRadius = 10;
    }
    return self;
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


-(void)setModel:(UserModel *)model
{
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width / 2;
    self.nameLabel.text = model.name;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
