//
//  CAEvaluateItemHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CAEvaluateItemHeaderView.h"
#import "LLSwitch.h"

//@interface CAEvaluateItemHeaderView () <LLSwitchDelegate>
//
//@end


@implementation CAEvaluateItemHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 15, 24, 24)];
        _iconView.image = [UIImage imageNamed:@"CA_circle"];
        [bgView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 38, 5, SCREEN_WIDTH - 8 - 60, 45)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = @"评分项";
        _titleLabel.textColor = [UIColor grayColor];
//        _titleLabel.textColor = [UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1];
        [bgView addSubview:_titleLabel];
        
        _switchButton = [[LLSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 16 - 8 , 15, 60, 30)];
        _switchButton.offColor = [UIColor redColor];
        _switchButton.onColor = [UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1];
        _switchButton.animationDuration = 0.3;
        [bgView addSubview:_switchButton];
        _switchButton.hidden = YES;
//        _switchButton.delegate = self;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 59.5, SCREEN_WIDTH - 8 - 36, 0.5f)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel];
    }
    return self;
}



//临时注释
//-(void)setIsAddItem:(BOOL)isAddItem
//{
//    if (isAddItem) {
//        _titleLabel.text = @"评分项 (加分)";
//        _titleLabel.textColor = [UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1];
//    }else
//    {
//        _titleLabel.text = @"评分项 (减分)";
//        _titleLabel.textColor = [UIColor redColor];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
