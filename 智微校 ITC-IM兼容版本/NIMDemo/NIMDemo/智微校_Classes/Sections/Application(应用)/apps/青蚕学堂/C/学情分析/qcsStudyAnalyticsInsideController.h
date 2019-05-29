//
//  qcsStudyAnalyticsInsideController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface qcsStudyAnalyticsInsideController : UIViewController

//@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (retain, nonatomic)WKWebView *mainWebView;

@property(nonatomic,assign)NSInteger viewTag;
@property(nonatomic,copy)NSString *viewTitle;
@property(nonatomic,copy)NSString *controllerType;

@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;


@property(nonatomic,copy)NSString *chooseStartTime;
@property(nonatomic,copy)NSString *chooseEndTime;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;


@property(nonatomic,retain)NSMutableArray *gradeArray;

@property(nonatomic,retain)NSMutableArray *bigDataArray;
@property(nonatomic,retain)NSMutableArray *studentArray;

//-(void)getChooseDataClass;
//-(void)getChooseDataStudent;

@end
