//
//  ProjectNetHelper.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/1.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProjectPermissionModel;


@interface ProjectNetHelper : NSObject


//获取项目首页列表
-(void)getMyProjectListWithStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//获取审核权限
-(void)getCheckPermissionWithStatus:(void (^)(BOOL successful,ProjectPermissionModel *model))status failure:(void (^)(NSError *error))failure;

//获取项目列表项详情
-(void)getMyProjectDetailWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//获取审核列表
-(void)getCheckListWithCheckStatus:(NSString *)checkStatus andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取审核列表项详情
-(void)getCheckDetailWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure;


//获取当前项目详情 - 拜访记录列表
-(void)getVisitRecordListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//获取当前项目详情 - 服务申请列表
-(void)getServiceApplyListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//获取当前项目详情 - 服务记录列表
-(void)getServiceRecordListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;


//获取拜访记录详情
-(void)getVisitRecordDetailWithVisitRecordId:(NSString *)visitRecordId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure;

//获取服务申请详情
-(void)getServiceApplyDetailWithServiceApplyId:(NSString *)serviceApplyId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure;

//获取服务记录详情
-(void)getServiceRecordIdDetailWithVisitRecordId:(NSString *)serviceRecordId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure;


//添加拜访记录列表
-(void)saveNewVisitRecordWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//添加服务申请列表
-(void)saveNewServiceApplyWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//添加服务记录列表
-(void)saveNewServiceRecordWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;








//获取搜索列表
-(void)getSearchListWithProjectID:(NSString *)projectID StartDate:(NSString *)startDate EndDate:(NSString *)endDate DocumentKind:(NSString *)documentKind  UserID:(NSString *)userID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//提交新的项目申请
-(void)saveNewProjectApplicationWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//审核项目
-(void)checkProjectApplicationWithProjectID:(NSString *)projectID checkStatus:(NSString *)checkStatus note:(NSString *)note serverIDs:(NSString *)serverIDs andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;


@end
