//
//  qcsStudyAnalyticsMainController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSStudyAnalyticsModel.h"


@protocol StudyAnalyticsControllerTagChangeDelegate <NSObject>

@optional

- (void)tagDidChange:(NSInteger)tag;

@end

@interface qcsStudyAnalyticsMainController : UIViewController


@property (strong, nonatomic)UIScrollView *topScrollView;
@property (strong, nonatomic)UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger viewTag;

@property (nonatomic, assign) NSInteger defaultIndex;


@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,assign)id<StudyAnalyticsControllerTagChangeDelegate>delegate;

@property(nonatomic,copy)NSString *chooseStartTime;
@property(nonatomic,copy)NSString *chooseEndTime;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;

@property(nonatomic,retain)NSMutableArray *gradeArray;

@property(nonatomic,retain)NSMutableArray *bigDataArray;
@property(nonatomic,retain)QCSStudyAnalyticsModel *mainModel;
@end
