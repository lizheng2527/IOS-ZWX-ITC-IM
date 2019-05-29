//
//  NTESSettingPortraitCell.m
//  NIM
//
//  Created by chris on 15/6/26.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESSettingPortraitCell.h"
#import "NIMCommonTableData.h"
#import "UIView+NTES.h"
#import "NTESSessionUtil.h"
#import "NIMAvatarImageView.h"
#import "NSString+NTES.h"
@interface NTESSettingPortraitCell()

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *accountLabel;

@end

@implementation NTESSettingPortraitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat avatarWidth = 45.f;
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, avatarWidth, avatarWidth)];
        [self addSubview:_avatar];
        _nameLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:18.f];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    
    if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
        self.textLabel.text       = rowData.title;
        self.detailTextLabel.text = rowData.detailTitle;
        NSString *uid = rowData.extraInfo;
        if ([uid isKindOfClass:[NSString class]]) {
            NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:uid option:nil];
            self.nameLabel.text   = info.showName ;
            [self.nameLabel sizeToFit];
            self.accountLabel.text = [NSString stringWithFormat:@"帐号：%@",uid];
            [self.accountLabel sizeToFit];
            [self.avatar nim_setImageWithURL:[NSURL URLWithString:info.avatarUrlString] placeholderImage:info.avatarImage options:SDWebImageRetryFailed];
        }
    }
    else
    {
        if (!rowData.title.length) {
            self.nameLabel.text       = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME]];
        }
        else self.nameLabel.text = rowData.title;
        
        [self.nameLabel sizeToFit];
        //    self.detailTextLabel.text = rowData.detailTitle;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
        NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
        
        NSString *string = [NSString stringWithFormat:@"%@%@&sys_username=%@&sys_auto_authenticate=true&sys_password=%@",BaseURL,[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_HeadPortraitUrl],userName,password];
        
        NSString *extroHeadURL = rowData.extraInfo;
        if (![NSString isBlankString:extroHeadURL]) {
            string = extroHeadURL;
        }
        
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"mk-photo"] options:SDWebImageRetryFailed];
        
        UIImage *image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_HEADIMAGE_DATA]];
        if (image && [NSString isBlankString:extroHeadURL]) {
            self.avatar.image = image;
        }
    }
    
    
    
    
    
//    self.textLabel.text       = rowData.title;
//    self.detailTextLabel.text = rowData.detailTitle;
//    NSString *uid = rowData.extraInfo;
    
//    if ([uid isKindOfClass:[NSString class]]) {
//        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:uid option:nil];
//        self.nameLabel.text   = info.showName ;
//        [self.nameLabel sizeToFit];
//        self.accountLabel.text = [NSString stringWithFormat:@"帐号：%@",uid];
//        [self.accountLabel sizeToFit];
    
        //修改头像
//        [self.avatar nim_setImageWithURL:[NSURL URLWithString:info.avatarUrlString] placeholderImage:info.avatarImage options:SDWebImageRetryFailed];
//    }
}


#define AvatarLeft 30
#define TitleAndAvatarSpacing 12
#define TitleTop 22
#define AccountBottom 22

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatar.left    = AvatarLeft;
    self.avatar.centerY = self.height * .5f;
    self.nameLabel.left = self.avatar.right + TitleAndAvatarSpacing;
    self.nameLabel.top  = TitleTop;
}




@end
