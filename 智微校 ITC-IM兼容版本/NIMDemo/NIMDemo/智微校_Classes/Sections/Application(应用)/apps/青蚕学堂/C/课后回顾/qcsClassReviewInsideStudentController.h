//
//  qcsClassReviewInsideStudentController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/12.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassReviewInsideStudentController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;
@property(nonatomic,copy)NSString *studentId;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,copy)NSString *chooseStartTime;
@property(nonatomic,copy)NSString *chooseEndTime;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
-(void)getChooseData;

@end
