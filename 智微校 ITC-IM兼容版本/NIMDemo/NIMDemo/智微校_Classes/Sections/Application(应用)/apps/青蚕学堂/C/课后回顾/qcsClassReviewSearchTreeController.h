//
//  qcsClassReviewSearchTreeController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassReviewSearchTreeController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableview;

@property(nonatomic,retain)NSMutableArray *itemDatasource;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;
@end
