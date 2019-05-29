//
//  QCSNetHelper.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCSMainModel.h"
@class QCSStudyAnalyticsModel;


@interface QCSNetHelper : NSObject


//获取青蚕学堂首页BaseInfo
-(void)getQCSchoolBaseInfoWithType:(NSString *)userType andStatus :(void (^)(BOOL successful,QCSMainModel *mainModel))status failure:(void (^)(NSError *error))failure;


#pragma mark - 获取课后回顾所有接口
//获取课程列表
-(void)getClassListWithEclassID:(NSString *)eclassId  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取课程列表 - 搜索结果
-(void)getClassSearchListWithEclassID:(NSString *)eclassId  courseID:(NSString *)courseID  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取学生和其课程列表 - (右侧栏)
-(void)getStudentAndClassListWithEclassID:(NSString *)eclassId  pageNum:(NSString * )num  startTime:(NSString *)startTime endTime:(NSString *)endTime studentID:(NSString *)studentID studentName:(NSString *)studentName courseID:(NSString *)courseID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取单独学生的列表 - 不是学生栏
-(void )getUserModelArrayWithEclassId:(NSString *)eclassId status:(void (^)(NSMutableArray *dataSource))status;



// --- 统计报表
//获取习题统计列表
-(void)getStasticXTTJListWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取答题榜,抢答榜,评级榜列表
-(void)getStasticBangDanListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取综合评价列表
-(void)getStasticZongHeListWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;


//----课堂详情
//获取手写笔记列表
-(void)getClassDetailSXBJListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//手写笔记详情 - 课堂进入
-(void)getClassDetailSXBJDetailListWithInteractionIdID:(NSString *)Id  andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取板书记录列表
-(void)getClassDetailBSJLListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取选择题列表
-(void)getClassDetailXZTListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取教学课件列表
-(void)getClassDetailJXKJListWithID:(NSString *)Id Type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

// ---师生互动表
-(void)getITeacherAndStudentInteractionWithID:(NSString *)Id andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;


#pragma mark - 获取学情分析所有接口
//获取学情分析基础查询数据
-(void)getStudyAnalyticsQueryData:(void (^)(BOOL successful,QCSStudyAnalyticsModel *mainModel))status failure:(void (^)(NSError *error))failure;


#pragma mark - 课后作业
//通过gradeID获取学科列表
-(void )getSubjectModelArrayWithGradeId:(NSString *)gradeId status:(void (^)(NSMutableArray *dataSource))status;

//获取作业首页列表
-(void)getHomeWorkPageListWithPageNum:(NSString * )num eclassIds:(NSString *)eclassId idGrade:(NSString *)idGrade idCourses:(NSString *)idCourses startTime:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//删除某条作业
-(void)delHomeworkListWithHomeworkID:(NSString *)homeworkID andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure;
//上传作业
-(void)uploadHomeworkWithPostdic:(NSDictionary *)postDic andItemSource:(NSMutableArray *)itemsource andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure;

@end
