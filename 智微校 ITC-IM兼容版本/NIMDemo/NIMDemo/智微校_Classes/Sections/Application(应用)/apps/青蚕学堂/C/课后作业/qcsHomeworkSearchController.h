//
//  qcsHomeworkSearchController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsHomeworkSearchController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseClassButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseCourseButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseEndTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;
@end
