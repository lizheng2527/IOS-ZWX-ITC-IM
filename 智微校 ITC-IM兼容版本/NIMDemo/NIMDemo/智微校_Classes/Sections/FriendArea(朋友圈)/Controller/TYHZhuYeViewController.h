//
//  TYHZhuYeViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/2/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHZhuYeViewController : UIViewController
@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)__block NSMutableArray *dataSource;


@property(nonatomic,copy)NSString *voipAccount;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,retain)UIImage *headIconImage;
-(instancetype)initWithVoipAccount:(NSString *)voipAccount userName:(NSString*)userName headIconImage:(UIImage *)image teacherOrUser:(BOOL)teacherOrUser;


//ClassAdmin ＝ 1  NomorUser ＝ 0 判定是班级列表还是个人列表
@property(nonatomic,assign)BOOL ClassAdminOrNomorUser;

@end
