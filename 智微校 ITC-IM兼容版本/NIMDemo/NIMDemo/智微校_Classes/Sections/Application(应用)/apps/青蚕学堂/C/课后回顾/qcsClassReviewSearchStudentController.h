//
//  qcsClassReviewSearchStudentController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassReviewSearchStudentController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseClassButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseCourseButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseEndTimeButton;


@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;


@property(nonatomic,retain)NSMutableArray *studentCourseArray;
@end
