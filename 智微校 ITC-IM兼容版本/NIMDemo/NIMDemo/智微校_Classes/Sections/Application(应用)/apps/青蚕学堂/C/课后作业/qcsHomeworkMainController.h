//
//  qcsHomeworkMainController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsHomeworkMainController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *releaseHomewButton;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,copy)NSString *eclassIDs;
@property(nonatomic,copy)NSString *idCourses;
@property(nonatomic,copy)NSString *idGrade;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;

-(void)requestData;
@end
