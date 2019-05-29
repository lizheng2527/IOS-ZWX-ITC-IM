//
//  TYHAddPersonCell.m
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "TYHAddPersonCell.h"
#import <UIImageView+WebCache.h>
#import "UserModel.h"

@implementation TYHAddPersonCell
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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 5.0f, 40.0f, 40.0f)];
        _portraitImg.contentMode = UIViewContentModeScaleAspectFit;
        _portraitImg.image = [UIImage imageNamed:@"personal_portrait"];
        [self.contentView addSubview:_portraitImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 10.0f, self.frame.size.width-80.0f, 25.0f)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, _nameLabel.frame.size.width, 15.0f)];
        _numberLabel.font = [UIFont systemFontOfSize:13.0f];
        _numberLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _numberLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_numberLabel];
        
        _selecImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 25, 15.0f, 22.25f, 22.25f)];
        _selecImage.image =[UIImage imageNamed:@"select_account_list_unchecked"];
        
        [self.contentView addSubview:_selecImage];
        
    }
    return self;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(UIImage *)dealImageWIthVoipAccount:(NSString *)voipAccount
{
    UIImage *image = [[UIImage alloc]init];
    image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:voipAccount];
    if (image && ![self isBlankString:voipAccount]) {
        return image;
    }
    else
        return [UIImage imageNamed:@"defult_head_img"];
}

- (void)updateContent:(UserModel *)contact {
    //    _avatarImageView.backgroundColor = [UIColor colorWithWhite:(arc4random() % 255)/255.0f alpha:1];
    //    _portraitImg.image = [UIImage imageNamed:@"defult_head_img"];
    //    [_portraitImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,contact.headPortraitUrl]] placeholderImage:[UIImage imageNamed:@"defult_head_img"]];
    self.portraitImg.image = [self dealImageWIthVoipAccount:contact.voipAccount];
    _nameLabel.text = contact.name;
    _portraitImg.layer.masksToBounds = YES;
    _portraitImg.layer.cornerRadius = _portraitImg.frame.size.width / 2;
}


@end
