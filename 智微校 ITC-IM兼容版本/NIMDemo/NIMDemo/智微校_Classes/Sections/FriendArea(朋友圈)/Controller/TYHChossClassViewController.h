//
//  TYHChossClassViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/5/10.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolMatesModel.h"
@interface TYHChossClassViewController : UIViewController
@property(nonatomic,retain)UITableView *mainView;
@property(nonatomic,retain)NSMutableArray *settingArray;

@property (copy, nonatomic) void (^didTapLabel)(classModel * model);

@end
