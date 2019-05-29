//
//  ClassAttendanceNetHelper.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "ClassAttendanceNetHelper.h"
#import "NSString+NTES.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "ClassAttendanceModel.h"

//#define k_V3ServerURL @"http://192.168.1.125:9996/dc-classroomattendance"


#define  GetCurrentTeachWeekList @"/ca/doAttendance!getCurrentTeachWeekList.action" //获取当前所有的教学周
#define  GetTeacherTimetable @"/ca/doAttendance!getTeacherTimetableByWeek.action" //按教学周获取教师课表
#define  GetStudentList @"/ca/doAttendance!getStudentListByCourseId.action" //根据课程id获取学生
#define  GetEvaluationItemAndRecord @"/ca/doAttendance!getEvaluationItemAndRecord.action" //获取评价项和评价记录
#define DelRecord @"/ca/doAttendance!deletePerformanceRecord.action" //删除评价记录
#define SubmitRecord @"/ca/doAttendance!batchAddPerformanceRecord.action" //提交评价记录


@implementation ClassAttendanceNetHelper
{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *dataSourceName;
    NSDictionary *userInfoDic;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getNeedData];
    }
    return self;
}

#pragma mark - 获取用户基础数据
-(void)getNeedData
{
    
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName};
}

#pragma mark - 获取所有的教学周
-(void)getAllClassWeeksWithJson:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,GetCurrentTeachWeekList];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
//    [dic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:NODE_SERVER_PARAM] forKey:@"reqParam"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *weekArray = [NSMutableArray arrayWithArray:[CAWeekModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,weekArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//按教学周获取教师课表
-(void)getTeacherTimeTableURLWithWeek:(NSString *)weekNum andResult:(void (^)(BOOL successful,NSString *requestURL))status
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,GetTeacherTimetable];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:weekNum forKey:@"weekNum"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        
    }];
}


//获取学生打分项
-(void)getEvaluationItemAndRecordWithAttendanceId:(NSString *)attendanceId studentId:(NSString *)studentId andResult:(void (^)(BOOL successful,CAEvaluateMainModel *dataModel))status
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,GetEvaluationItemAndRecord];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:attendanceId.length?attendanceId:@"" forKey:@"attendanceId"];
    [dic setValue:studentId.length?studentId:@"" forKey:@"studentId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        CAEvaluateMainModel *model = [CAEvaluateMainModel new];
        
        model = [CAEvaluateMainModel mj_objectWithKeyValues:json];
        
        model.deductionListModelArray = [NSMutableArray arrayWithArray:[CAEvaluateItemModel mj_objectArrayWithKeyValuesArray:model.deductionList]];
        model.bonusPointListModelArray = [NSMutableArray arrayWithArray:[CAEvaluateItemModel mj_objectArrayWithKeyValuesArray:model.bonusPointList]];
        
        for (CAEvaluateItemModel *itemModel in model.deductionListModelArray) {
            itemModel.score = [NSString stringWithFormat:@"-%@",itemModel.defaultNum];
            itemModel.isSelected = NO;
        }
        for (CAEvaluateItemModel *itemModel in model.bonusPointListModelArray) {
            itemModel.score = [NSString stringWithFormat:@"+%@",itemModel.defaultNum];
            itemModel.isSelected = NO;
        }
        model.recordModel = [CAEvaluateRecordModel new];
        model.recordModel = [CAEvaluateRecordModel mj_objectWithKeyValues:model.recordList];
        model.recordModel.detailListListModelArray = [CAEvaluateItemModel mj_objectArrayWithKeyValuesArray:model.recordModel.detailList];
        
        status(YES,model);
        NSLog(@"%@",model);
    } failure:^(NSError *error) {
        status(NO,[CAEvaluateMainModel new]);
        
    }];
}

//删除打分项
-(void)delEvaluationItemAndRecordWithItemId:(NSString *)EvaluationItemID  andResult:(void (^)(BOOL successful))status
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,DelRecord];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:EvaluationItemID.length?EvaluationItemID:@"" forKey:@"id"];
    
    [TYHHttpTool gets:requestURL params:dic success:^(id json) {
        NSString *resultSring = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if ([resultSring isEqualToString:@"ok"]) {
            status(YES);
        }else status(NO);
    } failure:^(NSError *error) {
        status(NO);
    }];
    
}

//提交打分项
-(void)submitEvaluationItemAndRecordSumDic:(NSDictionary *)sumDic  andResult:(void (^)(BOOL successful))status
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,SubmitRecord];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic addEntriesFromDictionary:sumDic];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
//        NSString *resultSring = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//        if ([resultSring isEqualToString:@"ok"]) {
//            status(YES);
//        }else
//            status(NO);
        status(YES);
    } failure:^(NSError *error) {
        status(NO);
    }];
}


@end
