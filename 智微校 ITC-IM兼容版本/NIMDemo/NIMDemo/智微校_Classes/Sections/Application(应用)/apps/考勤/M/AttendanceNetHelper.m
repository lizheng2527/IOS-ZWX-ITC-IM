//
//  AttendanceNetHelper.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceNetHelper.h"
#import "AttendanceModel.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "NSString+Empty.h"

#define doAttendance @"/ta/teacherAttendanceMobile!doAttendance.action"  //开始考勤
#define attendataceList @"/ta/teacherAttendanceMobile!attendance.action"  //获取考勤列表
#define getAttendataceDateList @"/ta/teacherAttendanceMobile!getListOfDate.action" //获取考勤统计
#define buqian @"/ta/teacherAttendanceMobile!supplementSave.action"//补签
#define CostInfo @"/ta/teacherAttendanceMobile!getCostInfo.action"//外出报销列表
#define saveAttendance @"/ta/teacherAttendanceMobile!save.action" //保存备注和报销
#define CostInfo @"/ta/teacherAttendanceMobile!getCostInfo.action"//外出报销列表
#define saveAttendance @"/ta/teacherAttendanceMobile!save.action" //保存备注和报销

@implementation AttendanceNetHelper{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getNeedData];
    }
    return self;
}


#pragma mark - 获取初始化信息
-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
}


#pragma mark - 网络请求
//开始考勤上下班
-(void)doAttendanceActionWithAddress:(NSString *)address andFlag:(NSString *)timeFlag status:(void (^)(BOOL ,AttendanceModel *))status failure:(void (^)(NSError *error))failure
{
    if ([NSString isBlankString:address]) {
        address = @"暂未获取到您的地址";
    }
    NSString *myEquipType = [UIDevice currentDevice].model;
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"address":address,@"userId":userID,@"flag":timeFlag,@"equipType":myEquipType};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,doAttendance];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        AttendanceModel *model = [AttendanceModel mj_objectWithKeyValues:json];
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[AttendanceModel new]);
    }];
}

//获取当天考勤记录
-(void)getAttendanceActionListWithStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,attendataceList];
    NSMutableArray *blockArray = [NSMutableArray array];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        AttendanceListModel *model = [AttendanceListModel mj_objectWithKeyValues:json];
        if (![NSString isBlankString:model.startTime]) {
            AttendanceListModel *startModel = [AttendanceListModel new];
            startModel.startTime = model.startTime;
            startModel.startAddress = model.startAddress;
            startModel.typeString = @"上班考勤";
            [blockArray addObject:startModel];
        }
        else
        {
            if (![NSString isBlankString:model.endTime]) {
                AttendanceListModel *tmpModel = [AttendanceListModel new];
                tmpModel.typeString = @"上班考勤";
                tmpModel.startTime = @"上班未考勤";
                tmpModel.startAddress = @"暂无";
                [blockArray addObject:tmpModel];
            }
        }
        if (![NSString isBlankString:model.endTime]) {
            AttendanceListModel *endModel = [AttendanceListModel new];
            endModel.endTime = model.endTime;
            endModel.endAddress = model.endAddress;
            endModel.typeString = @"下班考勤";
            [blockArray addObject:endModel];
        }
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取当天统计
-(void)getAttendanceDateListWithDate:(NSString *)Date andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    if ([NSString isBlankString:Date]) {
        Date = dateString;
    }
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID,@"date":Date};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getAttendataceDateList];
    
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[AttendanceListModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,dataArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//上班补签
-(void)doBuqianActionWithAddress:(NSString *)address note:(NSString *)sayNote andFlag:(NSString *)timeFlag status:(void (^)(BOOL ,AttendanceModel *))status failure:(void (^)(NSError *error))failure
{
    if ([NSString isBlankString:address]) {
        address = @"暂未获取到您的地址";
    }
    
    NSString *myEquipType = [UIDevice currentDevice].model;
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"address":address,@"userId":userID,@"startTime":timeFlag,@"equipType":myEquipType,@"note":sayNote};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,buqian];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        AttendanceModel *model = [AttendanceModel mj_objectWithKeyValues:json];
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[AttendanceModel new]);
    }];
    
}

//外出报销列表
-(void)getCostInfoWithStatus:(void (^)(BOOL successful,AttendanceRemarkModel *remarkModel))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID};
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,CostInfo];
    
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        AttendanceRemarkModel *dataModel = [AttendanceRemarkModel  new];
       dataModel = [AttendanceRemarkModel mj_objectWithKeyValues:json];
            dataModel.costModelArray = [NSMutableArray arrayWithArray:[AttendanceRemarkCostModel mj_objectArrayWithKeyValuesArray:dataModel.costList]];
            dataModel.costTypeModelArray = [NSMutableArray arrayWithArray:[AttendanceRemarkCostModel mj_objectArrayWithKeyValuesArray:dataModel.costTypeList]];
        status(YES,dataModel);
    } failure:^(NSError *error) {
        status(NO,[AttendanceRemarkModel  new]);
    }];
}

//保存备注和报销
-(void)saveRemarkItemsWithRemarkText:(NSString *)text CoustType:(NSString *)coustType Coust:(NSString *)coust andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID,@"coust":coust,@"remark":text,@"coustType":coustType};
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,saveAttendance];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            status(YES);
        }
        else status(NO);
    } failure:^(NSError *error) {
        status(NO);
    }];
    
}



@end
