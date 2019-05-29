//
//  SchoolMatesHeaderView.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SchoolMatesHeaderView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation SchoolMatesHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //mainview
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 216)];
        _mainView.backgroundColor = [UIColor whiteColor];
        //bgImageView
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -80, WIDTH, 256)];
        _bgImageView.image = [UIImage imageNamed:@"chat_bg1.jpg"];
        //_areaNameLabel
        _areaNameLabel = [[UILabel alloc]init];
        _areaNameLabel.backgroundColor = [UIColor clearColor];
        _areaNameLabel.textColor = [UIColor whiteColor];
        _areaNameLabel.text = @"啥子呦";
        _areaNameLabel.frame = CGRectMake(WIDTH - 80 -16 - 200, 141, 190, 30);
        _areaNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _areaNameLabel.textAlignment = NSTextAlignmentRight;
        //_userIcon
        _userIcon = [[UIImageView alloc]init];
        _userIcon.frame = CGRectMake(WIDTH - 80 -16, 136, 80, 80);
        _userIcon.image = [UIImage imageNamed:@"hhh"];
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = 40 ;
        self.userIcon.layer.borderWidth = 1.5f;
        self.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;

        //添加到view上和层级关系
        [_mainView addSubview:_bgImageView];
        [_mainView addSubview:_areaNameLabel];
        [_mainView addSubview:_userIcon];
        [self addSubview:_mainView];
        
        
//        _smallBgView.frame = CGRectMake(WIDTH / 2 -20, 216 / 2 - 5, 40, 10);
        _smallBgView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH / 2 -40, 216 / 2 - 25, 82, 30)];
        _smallBgView.backgroundColor = [UIColor colorWithRed:36/255 green:36/255 blue:36/255 alpha:0.3];
        _smallBgView.layer.masksToBounds = YES;
        _smallBgView.layer.cornerRadius = 3;
        [_mainView addSubview:_smallBgView];
        
        _smallUserIcon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 22, 22)];
        _smallUserIcon.image = [UIImage imageNamed:@"mk-photo"];
        _smallUserIcon.layer.masksToBounds = YES;
        _smallUserIcon.layer.cornerRadius = _smallUserIcon.frame.size.width / 2;
        [_smallBgView addSubview:_smallUserIcon];
        
        _smallTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,50 , 30)];
        _smallTitleLabel.text = @"0条消息";
        _smallTitleLabel.textColor = [UIColor whiteColor];
        _smallTitleLabel.textAlignment = NSTextAlignmentCenter;
        _smallTitleLabel.font = [UIFont systemFontOfSize:11];
        [_smallBgView addSubview:_smallTitleLabel];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
