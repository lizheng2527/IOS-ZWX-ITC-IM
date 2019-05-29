//
//  LHRatingView.h
//
//  Created by bosheng on 15/11/4.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHRatingView;

@protocol ratingViewDelegate <NSObject>

@optional

- (void)ratingView:(LHRatingView *)view score:(CGFloat)score;

@end

typedef NS_ENUM(NSUInteger, RatingType) {
    INTEGER_TYPE,
    FLOAT_TYPE
};;

@interface LHRatingView : UIView

@property (nonatomic,assign)RatingType ratingType;//评分类型，整颗星或半颗星

@property (nonatomic,assign)CGFloat score;//当前分数

@property (nonatomic,assign)id<ratingViewDelegate> delegate;

@end

/*
 *使用方法:
 *1.将本文件导入工程;
 *2.导入头文件LHRatingView.h;
 *3.遵守代理ratingViewDelegate;
 *4.示例代码:
 LHRatingView * rView = [[LHRatingView alloc]initWithFrame:CGRectMake(20, 100, 280, 60)];
 rView.center = self.view.center;
 rView.ratingType = INTEGER_TYPE;//整颗星
 rView.delegate = self;
 [self.view addSubview:rView];
 *
 #pragma mark - ratingViewDelegate
 - (void)ratingView:(LHRatingView *)view score:(CGFloat)score
 {
 NSLog(@"分数  %.2f",score);
 
 }
 */
