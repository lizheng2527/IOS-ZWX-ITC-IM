//
//  TakeCourseHelper.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseHelper.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "TakeCourseDefine.h"
#import "TakeCourseModel.h"
@implementation TakeCourseHelper{
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

#pragma mark -学生进行选课
-(void)getChooseCourseWithEcID:(NSString *)ecid and:(void(^)(BOOL successful,TakeCourseModel *takeModel))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"ecActivityId":ecid,@"userId":userID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,ElectiveCourse];
//    NSMutableArray *blockArray = [NSMutableArray array];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        
        //takeCourseModel相关
        TakeCourseModel *takecourseModel_use = [TakeCourseModel new];
        takecourseModel_use.ecRuleModel = [EcRuleModel new];
        {
        takecourseModel_use.ecActivitymodel = [[ecActivityModel alloc]init];
        takecourseModel_use.ecElectiveGroupList = [NSMutableArray array];
        takecourseModel_use.currentUser = [json objectForKey:@"currentUser"];
        takecourseModel_use.ecActivitymodel.ecActivityID = [[json objectForKey:@"ecActivity"] objectForKey:@"id"];
        takecourseModel_use.ecActivitymodel.ecActivityKind = [[json objectForKey:@"ecActivity"] objectForKey:@"kind"];
        for (NSDictionary *ecElectiveGroupListDic in [json objectForKey:@"ecElectiveGroupList"]) {
            ecElectiveGroupListModel *gModel = [ecElectiveGroupListModel new];
            gModel.ecActivityCourseList = [NSMutableArray array];
            gModel.groupName = [ecElectiveGroupListDic objectForKey:@"groupName"];
            gModel.groupId = [ecElectiveGroupListDic objectForKey:@"groupId"];
            gModel.groupNum = [ecElectiveGroupListDic objectForKey:@"groupNum"];
            NSArray *array = [EcActivityCourseListModel mj_objectArrayWithKeyValuesArray:[ecElectiveGroupListDic objectForKey:@"ecActivityCourseList"]];
            gModel.ecActivityCourseList = [NSMutableArray arrayWithArray:array];
            if (array.count) {
                [takecourseModel_use.ecElectiveGroupList addObject:gModel];
            }
        }
    }
        
       //ruleModel相关
        EcRuleModel *ecrulemodel = [EcRuleModel new];
        {
        ecrulemodel.courseList = [NSMutableArray array];
        ecrulemodel.classTimeFlag = [[json objectForKey:@"electiveRuleMap"] objectForKey:@"classTimeFlag"];
        ecrulemodel.maxCount = [[json objectForKey:@"electiveRuleMap"] objectForKey:@"maxCount"];
        ecrulemodel.maxHour = [[json objectForKey:@"electiveRuleMap"] objectForKey:@"maxHour"];
        ecrulemodel.maxScore = [[json objectForKey:@"electiveRuleMap"] objectForKey:@"maxScore"];
        for (NSDictionary *ruleDic in [[json objectForKey:@"electiveRuleMap"] objectForKey:@"ruleList"]) {
            EcRuleCourseListModel *courseListModel = [EcRuleCourseListModel new];
            courseListModel.ruleListArray = [NSMutableArray array];
            courseListModel.minQuantity = [ruleDic objectForKey:@"minQuantity"];
            courseListModel.maxQuantity = [ruleDic objectForKey:@"maxQuantity"];
            for (NSDictionary *courseDic in [ruleDic objectForKey:@"courseList"]) {
                courseModel *coursemodel = [courseModel new];
                coursemodel.courseId = [courseDic objectForKey:@"courseId"];
                coursemodel.courseName = [courseDic objectForKey:@"courseName"];
                [courseListModel.ruleListArray addObject:coursemodel];
            }
            [ecrulemodel.courseList addObject:courseListModel];
            }
        }
        takecourseModel_use.ecRuleModel = ecrulemodel;
        status(YES,takecourseModel_use);
    } failure:^(NSError *error) {
        status(NO,[TakeCourseModel new]);
    }];
    
}

#pragma mark - 提交选课结果
-(void)saveEcCourseWithCourseIDs:(NSString *)courseIDs ecActivityIDs:(NSString *)ecActivityIDs and:(void(^)(BOOL successful,NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"courseIds":courseIDs,@"ecActivityId":ecActivityIDs,@"alternativeCourse1":@"",@"alternativeCourse2":@""};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,saveElectiveCourse];
    [TYHHttpTool gets:requestUrl params:dic success:^(id json) {
        status(YES,json);
    } failure:^(NSError *error) {
        status(NO,nil);
        NSLog(@"%@",error);
    }];
}

#pragma mark - 获取选课说明
//获取选课说明
-(void)getCourseNote:(void (^)(BOOL ,BeginTakeCourseModel *))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,courseDetailNote];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        BeginTakeCourseModel *model = [BeginTakeCourseModel mj_objectWithKeyValues:json];
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}


#pragma mark -我的选课
//我的选课
-(void)getMineCourse:(void (^)(BOOL successful,NSMutableArray *mineCourseDatasource))status failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,myCourse];
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray array];
        for (NSDictionary *SchoolTermInfoListModelDic in [json objectForKey:@"schoolTermInfoList"]) {
            SchoolTermInfoListModel *model = [SchoolTermInfoListModel new];
                model.fullName = [SchoolTermInfoListModelDic objectForKey:@"fullName"];
                model.schoolTermID = [SchoolTermInfoListModelDic objectForKey:@"id"];
                model.startDate = [SchoolTermInfoListModelDic objectForKey:@"startDate"];
                    model.sumScore = [[json objectForKey:@"schoolTermSumScoreMap"] objectForKey:model.schoolTermID];
            model.courseArray = [NSMutableArray array];
            NSArray * schoolTermStudentCourseArray = [[json objectForKey:@"schoolTermStudentCourseMap"] objectForKey:model.schoolTermID];
            for (NSDictionary *courseDic in schoolTermStudentCourseArray) {
                schoolTermStudentCourseModel *courseModel = [schoolTermStudentCourseModel new];
                courseModel.courseDisplayName = [courseDic objectForKey:@"courseDisplayName"];
                courseModel.ecActivityCourseId = [courseDic objectForKey:@"ecActivityCourseId"];
                courseModel.evaluate = [self dealEvaleateString:[courseDic objectForKey:@"evaluate"]];
                courseModel.scoreStr = [courseDic objectForKey:@"scoreStr"];
                courseModel.teacherName = [courseDic objectForKey:@"teacherName"];
                courseModel.schoolTermStartDate = [courseDic objectForKey:@"schoolTermStartDate"];
//                NSLog(@"===%@",courseModel.courseDisplayName);
                [model.courseArray addObject:courseModel];
            }
            [blockArray addObject:model];
        }
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark -Action
//处理成绩单的Evaleate,返回对应评价
-(NSString *)dealEvaleateString:(NSString *)srting
{
    switch ([srting integerValue]) {
        case 0:
            return @"优秀";
            break;
        case 1:
            return @"良好";
        case 2:
            return @"及格";
        case 3:
            return @"不及格";
        default:
            return @"";
            break;
    }
}

//

@end
