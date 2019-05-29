//
//  MRFeedBackScoreCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/6/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRFeedBackScoreCell.h"
#import "MyRepairApplicationModel.h"
#import "NSString+NTES.h"
#import <UIImageView+WebCache.h>
#import "YMTapGestureRecongnizer.h"

//#import "LHRatingView.h"
#import "ETTextView.h"


@implementation MRFeedBackScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = NO;
    
    self.textView.placeholder = @"暂无";
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = .5f;
    self.textView.userInteractionEnabled = NO;
    
    _ratingView_Speed = [[LHRatingView alloc]initWithFrame:CGRectMake(0 , 0, 160, 35)];
    _ratingView_Speed.ratingType = INTEGER_TYPE;//整颗星
    _ratingView_Speed.delegate = self;
    _ratingView_Speed.userInteractionEnabled = NO;
    [self.ratingBGView addSubview:_ratingView_Speed];
    
    _ratingView_Attitude = [[LHRatingView alloc]initWithFrame:CGRectMake(0 , 30, 160, 35)];
    _ratingView_Attitude.ratingType = INTEGER_TYPE;
    _ratingView_Attitude.delegate = self;
    _ratingView_Attitude.userInteractionEnabled = NO;
    [self.ratingBGView addSubview:_ratingView_Attitude];
    
    _ratingView_Level = [[LHRatingView alloc]initWithFrame:CGRectMake(0 , 60, 160, 35)];
    _ratingView_Level.ratingType = INTEGER_TYPE;
    _ratingView_Level.delegate = self;
    _ratingView_Level.userInteractionEnabled = NO;
    [self.ratingBGView addSubview:_ratingView_Level];
    
    _ratingView_Quality = [[LHRatingView alloc]initWithFrame:CGRectMake(0 , 90, 160, 35)];
    _ratingView_Quality.ratingType = INTEGER_TYPE;
    _ratingView_Quality.delegate = self;
    _ratingView_Quality.userInteractionEnabled = NO;
    [self.ratingBGView addSubview:_ratingView_Quality];
    
    _ratingView_Evaluate = [[LHRatingView alloc]initWithFrame:CGRectMake(0 , 130, 160, 35)];
    _ratingView_Evaluate.ratingType = INTEGER_TYPE;
    _ratingView_Evaluate.delegate = self;
    _ratingView_Evaluate.userInteractionEnabled = NO;
    [self.ratingBGView addSubview:_ratingView_Evaluate];
    
}


-(void)setModel:(MRAFeedBackInfoModel *)model
{
    self.textView.text = model.suggestion;
    if (![NSString isBlankString:model.repairFlag] && [model.repairFlag isEqualToString:@"1"]) {
        [_noButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_yesButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    else if(![NSString isBlankString:model.repairFlag] && [model.repairFlag isEqualToString:@"0"]) {
        [_yesButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_noButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    
    _ratingView_Speed.score = [model.speedStr integerValue];
    _ratingView_Attitude.score = [model.attitudeStr integerValue];
    _ratingView_Level.score = [model.technicalLevelStr integerValue];
    _ratingView_Quality.score = [model.qualityStr integerValue];
    _ratingView_Evaluate.score = [model.scoreStr integerValue];
    
    
    [model.repairImageList enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 5 * (idx % 4) + (idx % 4) * 6, 42 +7.5  + 3 * ((idx / 4) + 1) + (idx / 4) *  SCREEN_WIDTH / 5  , SCREEN_WIDTH / 5, SCREEN_WIDTH / 5)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,urlString]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
        [self.contentView addSubview:imageView];
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        tap.appendArray = model.repairImageList;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 9999 + idx;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }];
    
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
