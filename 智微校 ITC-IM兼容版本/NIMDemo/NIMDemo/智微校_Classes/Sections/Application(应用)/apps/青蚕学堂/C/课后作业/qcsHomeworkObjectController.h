//
//  qcsHomeworkObjectController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsHomeworkObjectController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseCourseButton;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;
@end
