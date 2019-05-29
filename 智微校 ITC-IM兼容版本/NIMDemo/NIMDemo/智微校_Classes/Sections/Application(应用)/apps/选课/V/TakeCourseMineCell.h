//
//  TakeCourseMineCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class schoolTermStudentCourseModel;

@interface TakeCourseMineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectJudgeLabel;

@property(nonatomic,retain)schoolTermStudentCourseModel *model;
@end
