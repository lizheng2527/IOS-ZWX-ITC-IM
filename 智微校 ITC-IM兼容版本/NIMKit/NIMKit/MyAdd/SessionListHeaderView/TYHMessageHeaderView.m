//
//  TYHMessageHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 16/12/23.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "TYHMessageHeaderView.h"

#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"

#define AvatarWidth 40

@implementation TYHMessageHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatarImageView.image = [UIImage imageNamed:@"icon_v3_message"];
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 120, 18)];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, 250, 18)];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.font            = [UIFont systemFontOfSize:14.f];
        _messageLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"我是测试时间";
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.font            = [UIFont systemFontOfSize:14.f];
        _timeLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 69, [UIScreen mainScreen].bounds.size.width - 18, 0.3f)];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:_lineLabel];
        
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfDidClick:)];
        [self addGestureRecognizer:ges];
    }
    return self;
    
}


#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
- (void)refresh:(NIMRecentSession*)recent{
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 15;
    NSInteger sessionListNameTop                = 15;
    NSInteger sessionListNameLeftToAvatar       = 15;
    NSInteger sessionListMessageLeftToAvatar    = 15;
    NSInteger sessionListMessageBottom          = 15;
    NSInteger sessionListTimeRight              = 15;
    NSInteger sessionListTimeTop                = 15;
    NSInteger sessionBadgeTimeBottom            = 15;
    NSInteger sessionBadgeTimeRight             = 15;
    
    _avatarImageView.nim_left    = sessionListAvatarLeft;
    _avatarImageView.nim_centerY = self.nim_height * .5f;
    _nameLabel.nim_top           = sessionListNameTop;
    _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
    _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
    _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
    _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
    _timeLabel.nim_top           = sessionListTimeTop;
    _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight - 8;
    _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
    
}

-(void)selfDidClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TYHHeaderViewDidClick)]) {
        [_delegate TYHHeaderViewDidClick];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
