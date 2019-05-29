//
//  TYHBasePersonController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/6.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void (^ReturnTextArrayBlock)(NSMutableArray *arrayText);

typedef void (^ReturnUserModelBlock)(NSMutableArray *modelArray);

@interface TYHBasePersonController : UIViewController

@property (nonatomic, strong) UserModel * model;

@property (nonatomic, copy) ReturnUserModelBlock returnUserModelBlock;

@property (nonatomic, copy) ReturnTextArrayBlock returnTextArrayBlock;


@property (nonatomic, strong) NSMutableArray * chooseArray;

@property (nonatomic, strong) NSString * modelId;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,copy)   NSString *token;
@property (nonatomic, copy) NSString * urlStr;

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic, strong) NSMutableArray * tempArray;
@property (nonatomic, strong) NSMutableArray *showTableView;

@property (nonatomic, strong) NSMutableArray * groupArray;
@property (nonatomic, strong) UITableView * groupTableView;
@property (nonatomic, strong) NSSet * setArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray * selectArray;

@property(nonatomic,assign)NSInteger isAreadyInsertNum;

@property(nonatomic,assign)BOOL isTeacherOrAdmin;
@property(nonatomic,assign)BOOL whoWillIn;
@end
