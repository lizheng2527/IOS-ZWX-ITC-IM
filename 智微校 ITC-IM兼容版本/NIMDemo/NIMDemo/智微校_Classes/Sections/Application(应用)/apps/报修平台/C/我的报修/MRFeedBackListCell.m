//
//  MRFeedBackListCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/6/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRFeedBackListCell.h"
#import "ETTextView.h"

@implementation MRFeedBackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self viewConfig];
     self.selectionStyle = NO;
}


-(void)viewConfig
{
    _ratingView_Speed = [[LHRatingView alloc]initWithFrame:CGRectMake(105, 80 - 5, 180, 40)];
    _ratingView_Speed.ratingType = INTEGER_TYPE;//整颗星
    [self.contentView addSubview:_ratingView_Speed];
    
    _ratingView_Attitude = [[LHRatingView alloc]initWithFrame:CGRectMake(105, 120 - 5, 180, 40)];
    _ratingView_Attitude.ratingType = INTEGER_TYPE;
    [self.contentView addSubview:_ratingView_Attitude];
    
    _ratingView_Level = [[LHRatingView alloc]initWithFrame:CGRectMake(105, 160 - 5, 180, 40)];
    _ratingView_Level.ratingType = INTEGER_TYPE;
    [self.contentView addSubview:_ratingView_Level];
    
    _ratingView_Quality = [[LHRatingView alloc]initWithFrame:CGRectMake(105, 200 - 5, 180, 40)];
    _ratingView_Quality.ratingType = INTEGER_TYPE;
    [self.contentView addSubview:_ratingView_Quality];
    
    _ratingView_Evaluate = [[LHRatingView alloc]initWithFrame:CGRectMake(105, 250, 180, 40)];
    _ratingView_Evaluate.ratingType = INTEGER_TYPE;
    [self.contentView addSubview:_ratingView_Evaluate];
    
    self.textView.placeholder = @"选填";
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.f;
    
    
    UITapGestureRecognizer *gesYES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yesAction:)];
    gesYES.delegate = self;
    [self.yesLabel addGestureRecognizer:gesYES];
    UITapGestureRecognizer *gesNO = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noAction:)];
    gesNO.delegate = self;
    [self.noLabel addGestureRecognizer:gesNO];
    [self.yesButton addTarget:self action:@selector(yesAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.noButton addTarget:self action:@selector(noAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)yesAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(yesBtnClick:)]) {
        [self.delegate yesBtnClick:self];
    }
}

-(void)noAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(noBtnClick:)]) {
        [self.delegate noBtnClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
