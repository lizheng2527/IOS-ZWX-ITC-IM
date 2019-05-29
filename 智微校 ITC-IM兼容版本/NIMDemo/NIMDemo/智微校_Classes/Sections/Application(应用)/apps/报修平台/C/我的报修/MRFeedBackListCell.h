//
//  MRFeedBackListCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/6/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHRatingView.h"

@class ETTextView;
@class MRFeedBackListCell;


@protocol MRFeedBackListCellDelegate <NSObject>
@optional
-(void)yesBtnClick:(MRFeedBackListCell *)cell;
-(void)noBtnClick:(MRFeedBackListCell *)cell;
@end



@interface MRFeedBackListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ETTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;

@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property(nonatomic,retain)LHRatingView *ratingView_Speed;
@property(nonatomic,retain)LHRatingView *ratingView_Attitude;
@property(nonatomic,retain)LHRatingView *ratingView_Level;
@property(nonatomic,retain)LHRatingView *ratingView_Quality;

@property(nonatomic,retain)LHRatingView *ratingView_Evaluate;

@property(nonatomic,assign)id<MRFeedBackListCellDelegate>delegate;
@end
