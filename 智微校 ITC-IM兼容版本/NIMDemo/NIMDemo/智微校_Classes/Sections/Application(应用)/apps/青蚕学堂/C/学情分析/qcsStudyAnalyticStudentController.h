//
//  qcsStudyAnalyticStudentController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/3.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

@interface qcsStudyAnalyticStudentController : UIViewController

@property (retain, nonatomic)WKWebView *mainWebView;

@property(nonatomic,retain)NSMutableArray *gradeArray;

@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;

@property(nonatomic,copy)NSString *chooseStudentName;
@property(nonatomic,copy)NSString *studentID;
@end
