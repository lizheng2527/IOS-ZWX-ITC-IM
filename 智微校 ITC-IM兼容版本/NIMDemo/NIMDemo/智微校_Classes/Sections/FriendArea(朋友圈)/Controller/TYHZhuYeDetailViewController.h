//
//  TYHZhuYeDetailViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/3/3.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolMatesModel.h"
@interface TYHZhuYeDetailViewController : UIViewController
@property(nonatomic,retain)momentsModel *tmpModel;


@property(nonatomic,retain)NSMutableArray *listDatasource;

@property (retain, nonatomic)UIImageView *userIcon;
@property (retain, nonatomic)UILabel *areaNameLabel;
@property (retain, nonatomic)UITableView *mainTableView;


-(instancetype)initWithCommentID:(NSString *)commentID ClassAdminOrNomorUser:(BOOL)ClassAdminOrNomorUser className:(NSString *)className;
-(instancetype)initWithCommentID:(NSString *)commentID ClassAdminOrNomorUser:(BOOL)ClassAdminOrNomorUser headUrl:(NSString *)headUrl;


@property(nonatomic,assign)BOOL ClassAdminOrNomorUser;
@property(nonatomic,copy)NSString *className;

@property(nonatomic,copy)NSString *UserIconURL;

@end
