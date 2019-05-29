//
//  qcsClassReviewSearchController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassReviewSearchController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseClassButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseEndTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@property(nonatomic,copy)NSString *userType;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,copy)NSString *chooseName;
@property(nonatomic,copy)NSString *chooseEclassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@end
