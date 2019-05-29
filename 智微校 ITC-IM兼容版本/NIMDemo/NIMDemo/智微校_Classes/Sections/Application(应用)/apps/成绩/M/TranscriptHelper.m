//
//  TranscriptHelper.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TranscriptHelper.h"
#import "TranscriptDefine.h"
//#import "TranscriptModel.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
@implementation TranscriptHelper{
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
#pragma mark - 方法
//获取所有学期
-(void)getAllSchoolTermJson:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getSchoolTermAllJson];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *modelArray = [TranscriptModel mj_objectArrayWithKeyValuesArray:json];
        status(YES,modelArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}

-(void)getExamListWithSchoolTermId:(NSString *)terminalID Status:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"schoolTermId":terminalID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getExamListJsonWithSchoolTermId];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *modelArray = [ExamListModel mj_objectArrayWithKeyValuesArray:json];
        status(YES,modelArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}

-(void)getgetStudentScoreWithExamID:(NSString *)examID Status:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"examId":examID,@"studentId":userID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getStudentScoreJson];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *modelArray = [StudentScoreModel mj_objectArrayWithKeyValuesArray:json];
        status(YES,modelArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}


@end
