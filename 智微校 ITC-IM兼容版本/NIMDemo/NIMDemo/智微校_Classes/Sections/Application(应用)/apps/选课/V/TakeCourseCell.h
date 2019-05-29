//
//  TakeCourseCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  EcActivityCourseListModel;

@interface TakeCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (weak, nonatomic) IBOutlet UILabel *hasSubmitLabel;

@property (weak, nonatomic) IBOutlet UIImageView *courseStatusImage;

@property(nonatomic,retain)EcActivityCourseListModel *model;

@end
