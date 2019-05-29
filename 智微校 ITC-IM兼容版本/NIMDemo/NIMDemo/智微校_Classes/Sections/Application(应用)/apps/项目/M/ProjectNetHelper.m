
//
//  ProjectNetHelper.m
//  NIM
//
//  Created by 中电和讯 on 2017/12/1.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectNetHelper.h"
#import <MJExtension.h>
#import "TYHHttpTool.h"
#import "ProjectMainModel.h"

#import "ACMediaModel.h"

//#define k_V3ServerURL @"http://192.168.1.20:8080/dc-base"


@implementation ProjectNetHelper
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


#pragma mark - 方法
#pragma mark - 获取我的项目列表
-(void)getMyProjectListWithStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proappstart!getAllprojectList.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    
    [TYHHttpTool gets:requestURL params:dic success:^(id json) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ProjectMainModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}

//获取审核权限
-(void)getCheckPermissionWithStatus:(void (^)(BOOL successful,ProjectPermissionModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!getCheckPermission.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    
    [TYHHttpTool gets:requestURL params:dic success:^(id json) {
        
        ProjectPermissionModel *model = [ProjectPermissionModel mj_objectWithKeyValues:json];
        
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[ProjectPermissionModel new]);
    }];
}


//获取项目列表项详情
-(void)getMyProjectDetailWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proappstart!getProjectDetail.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"projectId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {

        NSMutableArray *array = [NSMutableArray array];
        ProjectListDetailModel *model = [ProjectListDetailModel mj_objectWithKeyValues:json];
        [array addObject:model];
        
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


//获取审核列表
-(void)getCheckListWithCheckStatus:(NSString *)checkStatus andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!getAllServiceApply.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:checkStatus.length?checkStatus:@"" forKey:@"check"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ProjectServiceApplyListModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取审核列表项详情
-(void)getCheckDetailWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,  NSDictionary *jsonDic))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!getServiceApplyDetail.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"serviceApplyId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSDictionary *dic = json;
        status(YES,dic);
    } failure:^(NSError *error) {
        status(NO,[NSDictionary dictionary]);
    }];
    
}

//获取当前项目详情 - 拜访记录
-(void)getVisitRecordListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/provisitrec!getVisitRecordList.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
     [dic setValue:projectID.length?projectID:@"" forKey:@"projectId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ProjectVisitRecordListModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}

//获取当前项目详情 - 服务申请
-(void)getServiceApplyListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!getServiceApplyList.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"projectId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ProjectServiceApplyListModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取当前项目详情 - 服务记录
-(void)getServiceRecordListWithProjectID:(NSString *)projectID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proservicerec!getServiceRecordList.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"projectId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ProjectServiceRecordListModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}




//获取拜访记录详情
-(void)getVisitRecordDetailWithVisitRecordId:(NSString *)visitRecordId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/provisitrec!getVisitRecordDetail.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:visitRecordId.length?visitRecordId:@"" forKey:@"visitRecordId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSDictionary *dic = json;
        status(YES,dic);
    } failure:^(NSError *error) {
        status(NO,[NSDictionary dictionary]);
    }];
}

//获取服务申请详情
-(void)getServiceApplyDetailWithServiceApplyId:(NSString *)serviceApplyId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!getServiceApplyDetail.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:serviceApplyId.length?serviceApplyId:@"" forKey:@"serviceApplyId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSDictionary *dic = json;
        status(YES,dic);
    } failure:^(NSError *error) {
        status(NO,[NSDictionary dictionary]);
    }];
}

//获取服务记录详情
-(void)getServiceRecordIdDetailWithVisitRecordId:(NSString *)serviceRecordId andStatus:(void (^)(BOOL successful,NSDictionary  *jsonDic))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proservicerec!getServiceRecordDetail.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:serviceRecordId.length?serviceRecordId:@"" forKey:@"serviceRecordId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSDictionary *dic = json;
        status(YES,dic);
    } failure:^(NSError *error) {
        status(NO,[NSDictionary dictionary]);
    }];
}


//添加拜访记录
-(void)saveNewVisitRecordWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/provisitrec!addVisitRecord.action"];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [requestDic setValue:userID forKey:@"userId"];
    [requestDic addEntriesFromDictionary:dic];
    
    if (!imageArray.count) {
        [TYHHttpTool get:requestURL params:requestDic success:^(id json) {
            
            NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"sucess"] || [string isEqualToString:@"ok"] || [string isEqualToString:@"true"]) {
                status(YES,[NSMutableArray array]);
            }else status(NO,[NSMutableArray array]);
            
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,@"/bd/provisitrec!addVisitRecord.action",userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [dic setValue:obj.name forKey:@"uploadFileNames"];
            
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            requestDic[str2] = [NSString stringWithFormat:@"%@",obj.name];
            
            
            UIImage *imageNew = obj.image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.7);
            [imageDataArr addObject:imageData];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestURL parameters:requestDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@",[(ACMediaModel *)imageArray[idx] name]];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"] || [data isEqualToString:@"success"] || [data isEqualToString:@"true"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
    
    
}

//添加服务申请
-(void)saveNewServiceApplyWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!addServiceApply.action"];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [requestDic setValue:userID forKey:@"userId"];
    [requestDic addEntriesFromDictionary:dic];
    
    if (!imageArray.count) {
        [TYHHttpTool get:requestURL params:requestDic success:^(id json) {
            
            NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"sucess"] || [string isEqualToString:@"ok"] || [string isEqualToString:@"true"]) {
                status(YES,[NSMutableArray array]);
            }else status(NO,[NSMutableArray array]);
            
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,@"/bd/proserviceapp!addServiceApply.action",userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [dic setValue:obj.name forKey:@"uploadFileNames"];
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            dic[str2] = [NSString stringWithFormat:@"%@",obj.name];
            
            UIImage *imageNew = obj.image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.7);
            [imageDataArr addObject:imageData];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestURL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@",[(ACMediaModel *)imageArray[idx] name]];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"] || [data isEqualToString:@"success"] || [data isEqualToString:@"true"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
    
}

//添加服务记录
-(void)saveNewServiceRecordWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proservicerec!addServiceRecord.action"];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [requestDic setValue:userID forKey:@"userId"];
    [requestDic addEntriesFromDictionary:dic];
    
    if (!imageArray.count) {
        [TYHHttpTool get:requestURL params:requestDic success:^(id json) {
            
            NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"sucess"] || [string isEqualToString:@"ok"] || [string isEqualToString:@"true"]) {
                status(YES,[NSMutableArray array]);
            }else status(NO,[NSMutableArray array]);
            
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,@"/bd/proservicerec!addServiceRecord.action",userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            dic[str2] = [NSString stringWithFormat:@"%@",obj.name];
            
//            [dic setValue:obj.name forKey:@"uploadFileNames"];
            
            UIImage *imageNew = obj.image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.7);
            [imageDataArr addObject:imageData];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestURL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@",[(ACMediaModel *)imageArray[idx] name]];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"] || [data isEqualToString:@"success"] || [data isEqualToString:@"true"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
    
}






//获取搜索列表
-(void)getSearchListWithProjectID:(NSString *)projectID StartDate:(NSString *)startDate EndDate:(NSString *)endDate DocumentKind:(NSString *)documentKind  UserID:(NSString *)userIDD andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{

    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proappstart!searchDocumentByProject.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userIDD.length?userIDD:@"" forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"projectId"];
    [dic setValue:startDate.length?startDate:@"" forKey:@"startDate"];
    [dic setValue:endDate.length?endDate:@"" forKey:@"endDate"];
    [dic setValue:documentKind.length?documentKind:@"" forKey:@"documentKind"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *array = [NSMutableArray array];
        if ([documentKind isEqualToString:@"1"]) {
            array = [NSMutableArray arrayWithArray:[ProjectVisitRecordListModel mj_objectArrayWithKeyValuesArray:json]];
        }
        else if([documentKind isEqualToString:@"2"]) {
            array = [NSMutableArray arrayWithArray:[ProjectServiceApplyListModel mj_objectArrayWithKeyValuesArray:json]];
        }else if([documentKind isEqualToString:@"3"]) {
            array = [NSMutableArray arrayWithArray:[ProjectServiceRecordListModel mj_objectArrayWithKeyValuesArray:json]];
        }
        
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//提交新的项目申请
-(void)saveNewProjectApplicationWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proappstart!saveProjectApply.action"];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [requestDic setValue:userID forKey:@"userId"];
    [requestDic addEntriesFromDictionary:dic];
    
    [TYHHttpTool gets:requestURL params:requestDic success:^(id json) {
        
        NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSLog(@"%@",json);
        if ([string isEqualToString:@"sucess"]) {
            status(YES,[NSMutableArray array]);
        }
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}




//审核项目
-(void)checkProjectApplicationWithProjectID:(NSString *)projectID checkStatus:(NSString *)checkStatus note:(NSString *)note serverIDs:(NSString *)serverIDs andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
//    sys_username    gaoyacun
//    id    20171208172910051360435362805485
//    check    1
//    sys_password    e10adc3949ba59abbe56e057f20f883e
//    dataSourceName    SCHOOL_CONTEXT_DEFAULT
//    serverIds
//    sys_Token    20171208182226381108316571115370
//    note    通过
//    sys_auto_authenticate    true
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/proserviceapp!submitServiceApplyCheck.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:projectID.length?projectID:@"" forKey:@"id"];
    [dic setValue:checkStatus.length?checkStatus:@"" forKey:@"check"];
    [dic setValue:note.length?note:@"" forKey:@"note"];
    [dic setValue:serverIDs.length?serverIDs:@"" forKey:@"serverIds"];
    
    [TYHHttpTool gets:requestURL params:dic success:^(id json) {
        
        NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSMutableArray *array = [NSMutableArray arrayWithObject:string];
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}



#pragma mark - ImageHandler

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
