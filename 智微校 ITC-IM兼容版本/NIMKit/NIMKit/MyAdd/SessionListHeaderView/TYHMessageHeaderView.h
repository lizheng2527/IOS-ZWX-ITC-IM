//
//  TYHMessageHeaderView.h
//  NIM
//
//  Created by 中电和讯 on 16/12/23.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMAvatarImageView;
@class NIMRecentSession;
@class NIMBadgeView;

@protocol TYHMessageHeaderViewDelegate <NSObject>
@optional
-(void)TYHHeaderViewDidClick;
@end


@interface TYHMessageHeaderView : UIView

@property (nonatomic,strong) NIMAvatarImageView *avatarImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property(nonatomic,strong)UILabel *lineLabel;

@property (nonatomic,strong) NIMBadgeView *badgeView;

@property(nonatomic,assign)id<TYHMessageHeaderViewDelegate>delegate;

- (void)refresh:(NIMRecentSession*)recent;

@end
