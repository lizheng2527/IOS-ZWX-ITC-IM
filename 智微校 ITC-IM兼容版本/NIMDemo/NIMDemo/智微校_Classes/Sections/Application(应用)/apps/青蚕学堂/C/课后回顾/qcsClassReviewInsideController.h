//
//  qcsClassReviewInsideController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassReviewInsideController : UIViewController

@property(nonatomic,assign)NSInteger viewTag;
@property(nonatomic,copy)NSString *viewTitle;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *tempCourseID;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;


@property(nonatomic,copy)NSString *chooseStartTime;
@property(nonatomic,copy)NSString *chooseEndTime;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;

-(void)getChooseDataClass;
-(void)getChooseDataStudent;
@end
