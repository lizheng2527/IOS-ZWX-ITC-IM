//
//  TYHContactDetailCell_NIMKIT.m
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "TYHContactDetailCell_NIMKIT.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>
#define BaseURL [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_BASEURL"]

@implementation TYHContactDetailCell_NIMKIT
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
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl]] placeholderImage:[UIImage imageNamed:@"defult_head_img"]];
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
