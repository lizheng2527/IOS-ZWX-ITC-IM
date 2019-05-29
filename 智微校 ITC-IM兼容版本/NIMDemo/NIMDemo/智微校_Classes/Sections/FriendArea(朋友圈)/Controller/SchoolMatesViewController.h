//
//  SchoolMatesViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewStateModel;

//校友圈
@interface SchoolMatesViewController : UIViewController
@property(nonatomic,retain)NSMutableArray *listDatasource;

@property (retain, nonatomic)UIImageView *userIcon;
@property (retain, nonatomic)UILabel *areaNameLabel;
@property (retain, nonatomic)UITableView *mainTableView;

-(instancetype)initWithRecordModel: (NewStateModel *)model;
@property(nonatomic,retain)NewStateModel *stateModel;
@end
