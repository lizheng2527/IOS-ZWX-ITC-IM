//
//  HomeWorkViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeWorkViewController : UIViewController

@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)__block NSMutableArray *dataSource;
@property(nonatomic,retain)__block NSMutableArray *ListArray;


@property(nonatomic,copy)NSString *voipAccount;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,retain)UIImage *headIconImage;
-(instancetype)initWithVoipAccount:(NSString *)voipAccount userName:(NSString*)userName headIconImage:(UIImage *)image teacherOrUser:(BOOL)teacherOrUser;


@end
