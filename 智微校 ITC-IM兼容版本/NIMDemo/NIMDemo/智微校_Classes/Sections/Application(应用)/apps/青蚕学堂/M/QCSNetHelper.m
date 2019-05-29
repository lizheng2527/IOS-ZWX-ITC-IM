//
//  QCSNetHelper.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSNetHelper.h"
#import "QCSchoolDefine.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>

#import "QCSStasticModel.h"
#import "QCSClassDetailModel.h"
#import "QCSStudyAnalyticsModel.h"
#import "qcsHomeworkModel.h"
#import "NSString+NTES.h"

#import <AFNetworking.h>


@implementation QCSNetHelper
{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *dataSourceName;
    NSString *token;
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
    
    userName = @"machikouyuwen";
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName,@"visitFlag":@"mobile",@"sys_token":token};
}


#pragma mark - 获取青蚕学堂主页Info
-(void)getQCSchoolBaseInfoWithType:(NSString *)userType andStatus :(void (^)(BOOL successful,QCSMainModel *mainModel))status failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    
    if (userType.length) {
        [dic setValue:userType forKey:@"operationDict"];
    }
    NSString *requestURL = [self GetTrueV3URLWithURL:url_GetBaseDataInfo];
    
    
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetBaseDataInfo] params:dic success:^(id json) {
        
        QCSMainModel *mainModel  = [[QCSMainModel alloc]init];
        mainModel = [QCSMainModel mj_objectWithKeyValues:json];
        mainModel.resultGradeModelArray = [NSMutableArray arrayWithArray:[QCSMainResultGradeModel mj_objectArrayWithKeyValuesArray:mainModel.resultGrade]];
        
        mainModel.stuCoursesModelArray = [NSMutableArray arrayWithArray:[QCSMainChildrenCourseModel mj_objectArrayWithKeyValuesArray:mainModel.stuCourses]];
        
        [mainModel.resultGradeModelArray enumerateObjectsUsingBlock:^(QCSMainResultGradeModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.childrenEclassModelArray = [NSMutableArray arrayWithArray:[QCSMainChildrenEclassModel mj_objectArrayWithKeyValuesArray:obj.childrenEclass]];
            obj.parentId = obj.id;
            
            [obj.childrenEclassModelArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel   *eclassObj, NSUInteger idxx, BOOL * _Nonnull stop) {
                eclassObj.parentId = obj.id;
                if (idx == 0 && idxx == 0) {
                    mainModel.tempEclassID = eclassObj.idMobile;
                }
                eclassObj.childrenCourseModelArray = [NSMutableArray arrayWithArray:[QCSMainChildrenCourseModel mj_objectArrayWithKeyValuesArray:eclassObj.childrenCourse]];
                
                [eclassObj.childrenCourseModelArray enumerateObjectsUsingBlock:^(QCSMainChildrenCourseModel   *courseObj, NSUInteger idxxx, BOOL * _Nonnull stop) {
                    courseObj.parentId = eclassObj.parentId;
                    courseObj.parentMobileID = eclassObj.idMobile;
                    
                    if (idx == 0 && idxx == 0 && idxxx == 0) {
                        mainModel.tempCourseID = courseObj.id;
                    }
                }];
                
            }];
            
            
        }];
        
        
        status(YES,mainModel);
        
    } failure:^(NSError *error) {
        status(NO,[QCSMainModel new]);
    }];
    
}


#pragma mark -获取单独学生的列表 - 不是学生栏
-(void )getUserModelArrayWithEclassId:(NSString *)eclassId status:(void (^)(NSMutableArray *dataSource))status
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:eclassId.length?eclassId:@"" forKey:@"eclassId"];
    
     __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStudentLists] params:dic success:^(id json) {
    
        studentArray = [NSMutableArray arrayWithArray:[QCSMainUserModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(studentArray);
        
    } failure:^(NSError *error) {
        status([NSMutableArray array]);
    }];
}



#pragma mark -获取课程列表
-(void)getClassListWithEclassID:(NSString *)eclassId  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:eclassId.length?eclassId:@"" forKey:@"eclassId"];
    [dic setValue:startTime.length?startTime:@"" forKey:@"startTime"];
    [dic setValue:endTime.length?endTime:@"" forKey:@"endTime"];
    [dic setValue:@"10" forKey:@"pageSize"];
     [dic setValue:num forKey:@"pageNum"];
    
    __block NSMutableArray *classArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassList] params:dic success:^(id json) {
        
        classArray = [QCSMainCLassModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"list"]];
        
        [classArray enumerateObjectsUsingBlock:^(QCSMainCLassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.courseID = [obj.course objectForKey:@"id"];
            obj.courseName = [obj.course objectForKey:@"name"];
            obj.eclassID = [obj.eclass objectForKey:@"id"];
        }];
        status(YES,classArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


#pragma mark -获取课程列表 - 搜索结果
-(void)getClassSearchListWithEclassID:(NSString *)eclassId  courseID:(NSString *)courseID  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:eclassId.length?eclassId:@"" forKey:@"eclassId"];
    [dic setValue:startTime.length?startTime:@"" forKey:@"startTime"];
    [dic setValue:endTime.length?endTime:@"" forKey:@"endTime"];
    [dic setValue:@"10" forKey:@"pageSize"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:courseID.length?courseID:@"" forKey:@"courseId"];
    
    __block NSMutableArray *classArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassList] params:dic success:^(id json) {
        
        classArray = [QCSMainCLassModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"list"]];
        
        [classArray enumerateObjectsUsingBlock:^(QCSMainCLassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.courseID = [obj.course objectForKey:@"id"];
            obj.courseName = [obj.course objectForKey:@"name"];
            obj.eclassID = [obj.eclass objectForKey:@"id"];
        }];
        status(YES,classArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


#pragma mark -获取学生和其课程列表 - (右侧栏)
-(void)getStudentAndClassListWithEclassID:(NSString *)eclassId  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime studentID:(NSString *)studentID studentName:(NSString *)studentName courseID:(NSString *)courseID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:eclassId.length?eclassId:@"" forKey:@"eclassId"];
    [dic setValue:startTime.length?startTime:@"" forKey:@"startTime"];
    [dic setValue:endTime.length?endTime:@"" forKey:@"endTime"];
    [dic setValue:@"10" forKey:@"pageSize"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:studentID.length?studentID:@"" forKey:@"studentId"];
    [dic setValue:courseID.length?courseID:@"" forKey:@"courseId"];
    
    
    __block NSMutableArray *STUDENTArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStudentClassList] params:dic success:^(id json) {
        
        STUDENTArray = [QCSMainStudentModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"list"]];
        
        
        [STUDENTArray enumerateObjectsUsingBlock:^(QCSMainStudentModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.studentID = studentID;
            obj.studentName = studentName;
            
            __block NSMutableArray *handwriteListArray = [NSMutableArray array];
            [obj.handwriteList enumerateObjectsUsingBlock:^(NSDictionary   *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //添加titleImage
                handwriteListArray = [QCSMainStudentSXBJModel mj_objectArrayWithKeyValuesArray:[objDic objectForKey:@"questUrl" ]];
                //添加学生手写笔记图片
                NSMutableArray *detailArray = [NSMutableArray arrayWithArray:[QCSMainStudentSXBJModel mj_objectArrayWithKeyValuesArray:[objDic objectForKey:@"stuAnswerUrl" ]]];
                [handwriteListArray addObjectsFromArray:detailArray];
            }];
            obj.handwriteListModelArray = handwriteListArray;
            
            
            __block NSMutableArray *chooseListArray = [NSMutableArray array];
            [obj.chooseList enumerateObjectsUsingBlock:^(NSDictionary   *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
                
                QCSMainStudentXZTJModel *model = [QCSMainStudentXZTJModel mj_objectWithKeyValues:objDic];
                
                model.name = [model.questUrl[0] objectForKey:@"name"];
                model.downloadUrl = [model.questUrl[0] objectForKey:@"downloadUrl"];
                model.picUrl = [model.questUrl[0] objectForKey:@"picUrl"];
                [chooseListArray addObject:model];
                
            }];
            obj.chooseListModelArray = chooseListArray;
        }];
        
//        QCSMainStudentSXBJModel
//        QCSMainStudentXZTJModel
        
        
        status(YES,STUDENTArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


#pragma mark - 统计报表
#pragma mark -获取习题统计列表
-(void)getStasticXTTJListWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStasticXTTJ] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSStasticModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"studentList"]]];
        [studentArray enumerateObjectsUsingBlock:^(QCSStasticModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.orderNumber = [NSString stringWithFormat:@"%lu",idx + 1];
        }];
        
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}

#pragma mark -获取答题榜,抢答榜,评级榜列表
-(void)getStasticBangDanListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
//    answerNum 答题榜
//    quickAnswerNum 抢答榜
//    evaluateCount 评价榜
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    [dic setValue:type.length?type:@"" forKey:@"type"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStasticBangDan] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSStasticListModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"wisdomclassStudents"]]];
        
        [studentArray enumerateObjectsUsingBlock:^(QCSStasticListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.orderNumber = [NSString stringWithFormat:@"%lu",idx + 1];
            obj.name = [obj.student objectForKey:@"name"];
            obj.displayName = [obj.student objectForKey:@"displayName"];
            obj.status = [obj.student objectForKey:@"status"];
            obj.modelType = type;
        }];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark -获取综合评价列表
-(void)getStasticZongHeListWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStasticZongHe] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSStasticComprehensiveModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"studentList"]]];
        
        [studentArray enumerateObjectsUsingBlock:^(QCSStasticComprehensiveModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.orderNumber = [NSString stringWithFormat:@"%lu",idx + 1];
        }];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark - 课堂详情
#pragma mark -获取手写笔记列表
-(void)getClassDetailSXBJListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    [dic setValue:type.length?type:@"" forKey:@"type"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassDetailSXBJ_JXKJ] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSClassDetailSXBJModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"interactions"]]];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//手写笔记详情 - 课堂进入
-(void)getClassDetailSXBJDetailListWithInteractionIdID:(NSString *)Id  andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"interactionId"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassDetailSXBJDetail] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSClassDetailSXBJDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"studentAnswers"]]];
        
        [studentArray enumerateObjectsUsingBlock:^(QCSClassDetailSXBJDetailModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.answerUrlModelArray = [NSMutableArray arrayWithArray:[QCSClassDetailSXBJDetailModel mj_objectArrayWithKeyValuesArray:obj.answerUrl]];
            if (obj.answerUrlModelArray.count) {
                obj.name = [obj.answerUrlModelArray[0] name];
                obj.downloadUrl = [obj.answerUrlModelArray[0] downloadUrl];
                obj.picUrl = [obj.answerUrlModelArray[0] picUrl];
            }
        }];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


#pragma mark -获取板书记录列表
-(void)getClassDetailBSJLListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    [dic setValue:type.length?type:@"" forKey:@"type"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassDetailBSJL] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSClassDetailBSJLModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"urls"]]];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}





#pragma mark -获取选择题列表
-(void)getClassDetailXZTListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    [dic setValue:type.length?type:@"" forKey:@"type"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassDetailXZT] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSClassDetailXZTModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"studentList"]]];
        
        [studentArray enumerateObjectsUsingBlock:^(QCSClassDetailXZTModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.optionListModelArray = [NSMutableArray arrayWithArray:[QCSClassDetailXZTInsideModel mj_objectArrayWithKeyValuesArray:obj.optionList]];
        }];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


#pragma mark -获取教学课件列表
-(void)getClassDetailJXKJListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    [dic setValue:type.length?type:@"" forKey:@"type"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetClassDetailSXBJ_JXKJ] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSClassDetailJXKJModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"coursewares"]]];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark - 获取师生互动表
-(void)getITeacherAndStudentInteractionWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:Id.length?Id:@"" forKey:@"wisdomclassId"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetTeacherStudentInteraction] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSMainInteractionModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(YES,studentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


#pragma mark - 获取学情分析所有接口
//获取学情分析基础查询数据
-(void)getStudyAnalyticsQueryData:(void (^)(BOOL successful,QCSStudyAnalyticsModel *mainModel))status failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetStudyAnalysisbaseQueryData] params:dic success:^(id json) {
        
        QCSStudyAnalyticsModel *model = [QCSStudyAnalyticsModel mj_objectWithKeyValues:json];
        model.gradeDataModelArray = [NSMutableArray arrayWithArray:[QCSStudyAnalyticsItemModel mj_objectArrayWithKeyValuesArray:model.gradeData]];
        model.courseDataModelArray = [NSMutableArray arrayWithArray:[QCSStudyAnalyticsItemModel mj_objectArrayWithKeyValuesArray:model.courseData]];
        model.shcoolDataModelArray = [NSMutableArray arrayWithArray:[QCSStudyAnalyticsItemModel mj_objectArrayWithKeyValuesArray:model.shcoolData]];
        status(YES,model);
        
    } failure:^(NSError *error) {
        status(NO,[QCSStudyAnalyticsModel new]);
    }];
}



#pragma mark - 课后作业
//通过gradeID获取学科列表
-(void )getSubjectModelArrayWithGradeId:(NSString *)gradeId status:(void (^)(NSMutableArray *dataSource))status
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:gradeId.length?gradeId:@"" forKey:@"gradeId"];
    
    __block NSMutableArray *studentArray = [NSMutableArray array];
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetCoursesByGradeId] params:dic success:^(id json) {
        
        studentArray = [NSMutableArray arrayWithArray:[QCSMainUserModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(studentArray);
        
    } failure:^(NSError *error) {
        status([NSMutableArray array]);
    }];
}




//获取作业首页列表
-(void)getHomeWorkPageListWithPageNum:(NSString * )num eclassIds:(NSString *)eclassId idGrade:(NSString *)idGrade idCourses:(NSString *)idCourses startTime:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];

    [dic setValue:@"10" forKey:@"pageSize"];
    [dic setValue:num forKey:@"pageNum"];

    if (![NSString isBlankString:idGrade]) {
        [dic setValue:idGrade forKey:@"idGrade"];
    }
    if (![NSString isBlankString:idCourses]) {
        [dic setValue:idCourses forKey:@"idCourses"];
    }
    if (![NSString isBlankString:startTime]) {
        [dic setValue:startTime forKey:@"startTime"];
    }
    if (![NSString isBlankString:endTime]) {
        [dic setValue:endTime forKey:@"endTime"];
    }
    if (![NSString isBlankString:type]) {
        [dic setValue:type forKey:@"type"];
    }
    if (![NSString isBlankString:eclassId]) {
        [dic setValue:type forKey:@"eclassId"];
    }
    

    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_GetHomeworkPage] params:dic success:^(id json) {

        NSMutableArray *pageListArray = [NSMutableArray arrayWithArray:[qcsHomeworkModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"result"]]];

        [pageListArray enumerateObjectsUsingBlock:^(qcsHomeworkModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            obj.attachmentVosModelArray = [qcsHomeworkItemModel mj_objectArrayWithKeyValuesArray:obj.attachmentVos];
            obj.homeworkEclassesModelArray = [NSMutableArray arrayWithArray:[qcsHomeworkItemModel mj_objectArrayWithKeyValuesArray:obj.homeworkEclasses]];
            [obj.homeworkEclassesModelArray enumerateObjectsUsingBlock:^(qcsHomeworkItemModel  *itemObj, NSUInteger idx, BOOL * _Nonnull stop) {
                itemObj.dboEclassID = [itemObj.dboEclass objectForKey:@"id"];
                itemObj.dboEclassName = [itemObj.dboEclass objectForKey:@"name"];
            }];

            obj.dboGradeID = [obj.dboGrade objectForKey:@"id"];
            obj.dboCourseName = [obj.dboCourse objectForKey:@"name"];

            obj.homeworkTypesModelArray = [NSMutableArray arrayWithArray:[qcsHomeworkItemModel mj_objectArrayWithKeyValuesArray:obj.homeworkTypes]];
        }];

        status(YES,pageListArray);

    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


//删除某条作业
-(void)delHomeworkListWithHomeworkID:(NSString *)homeworkID andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:homeworkID.length?homeworkID:@"" forKey:@"id"];
    
    [TYHHttpTool get:[self GetTrueV3URLWithURL:url_DelHomeworkItem] params:dic success:^(id json) {
        status(YES);
    } failure:^(NSError *error) {
        status(NO);
    }];
    
}


//上传作业
-(void)uploadHomeworkWithPostdic:(NSDictionary *)postDic andItemSource:(NSMutableArray *)itemsource andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&dataSourceName=%@&sys_token=%@",[self GetTrueV3URLWithURL:url_SaveOrUpdateMobile],userName,password,dataSourceName,token];
    
   
    if (!itemsource.count) {
        [TYHHttpTool post:requestURL params:paraDic success:^(id json) {
            
            NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"]) {
                status(YES);
            }
            else
                status(NO);
            
        } failure:^(NSError *error) {
                status(NO);
        }];
    }
    
    else
    {

        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        
        [itemsource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            paraDic[str2] = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableArray  *itemDataArr = [NSMutableArray array];
        //    UIImage * image2;
        
//        [itemsource enumerateObjectsUsingBlock:^(qcsHomeworkMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.type isEqualToString:@"Image"]) {
//
//                UIImage *imageNew = obj.CoverImage;
//                //设置image的尺寸
//                CGSize imagesize = imageNew.size;
//                imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
//                NSData *imageData = UIImageJPEGRepresentation(imageNew,0.8);
//                [itemDataArr addObject:imageData];
//
//            }else if([obj.type isEqualToString:@"Video"]) {
//
//            }else if([obj.type isEqualToString:@"Audio"]) {
//
//            }
//        }];
        
        
        [manager POST:requestURL parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
            
            //           __block NSInteger imgCount = 0;
            
            [itemDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
                
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
                
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"]) {
                status(YES);
            }else status(NO);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"服务器返回:%@",[error localizedDescription]);
            status(NO);
        }];
        
    }
}


#pragma mark - private

-(NSString *)GetTrueV3URLWithURL:(NSString *)url
{
//    NSString *v3url = k_V3ServerURL;
//    NSArray *array =  [v3url componentsSeparatedByString:@"/dc"];
//    NSString *trueURL = [NSString stringWithFormat:@"%@%@",array[0],url];
    
//    NSString *urlll = [[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_QCXT_URL];
    
    return [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_QCXT_URL],url] ;
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
