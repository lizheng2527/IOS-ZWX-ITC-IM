//
//  MRFeedBackScoreCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/6/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ETTextView;
@class MRAFeedBackInfoModel;

#import "LHRatingView.h"

@protocol MRFeedBackScoreCellDelegate <NSObject>
@optional
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;

@end




@interface MRFeedBackScoreCell : UITableViewCell<ratingViewDelegate>

@property (weak, nonatomic) IBOutlet ETTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;

@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;


@property (weak, nonatomic) IBOutlet UILabel *speedLabel;



@property(nonatomic,retain)LHRatingView *ratingView_Speed;
@property(nonatomic,retain)LHRatingView *ratingView_Attitude;
@property(nonatomic,retain)LHRatingView *ratingView_Level;
@property(nonatomic,retain)LHRatingView *ratingView_Quality;
@property(nonatomic,retain)LHRatingView *ratingView_Evaluate;

@property (weak, nonatomic) IBOutlet UIView *ratingBGView;

@property(nonatomic,assign)id<MRFeedBackScoreCellDelegate>delegate;
@property(nonatomic,retain)MRAFeedBackInfoModel *model;

@end
