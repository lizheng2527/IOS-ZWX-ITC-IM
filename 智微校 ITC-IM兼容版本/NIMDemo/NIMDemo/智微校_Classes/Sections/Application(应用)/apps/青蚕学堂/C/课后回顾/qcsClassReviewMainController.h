//
//  qcsClassReviewMainController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tagChangeDelegate <NSObject>

@optional

- (void)tagDidChange:(NSInteger)tag;

@end




@interface qcsClassReviewMainController : UIViewController

@property (strong, nonatomic)UIScrollView *topScrollView;
@property (strong, nonatomic)UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger viewTag;

@property (nonatomic, assign) NSInteger defaultIndex;


@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,assign)id<tagChangeDelegate>delegate;

@property(nonatomic,copy)NSString *chooseStartTime;
@property(nonatomic,copy)NSString *chooseEndTime;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;


@end
