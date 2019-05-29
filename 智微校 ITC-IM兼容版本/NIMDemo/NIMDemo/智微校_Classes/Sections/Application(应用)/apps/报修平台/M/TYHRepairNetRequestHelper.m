//
//  TYHRepairNetRequestHelper.m
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHRepairNetRequestHelper.h"
#import "TYHRepairMainModel.h"
#import "RAPlaceModel.h"
#import "TYHRepairDefine.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>

#import "RepairManagementModel.h"
#import "MyRepairApplicationModel.h"
#import <AFNetworking.h>
#import "ACMediaModel.h"

#import "MRSAddDetailCell.h"
#import "NSString+NTES.h"

@implementation TYHRepairNetRequestHelper
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
#pragma mark - 获取维修首页信息
-(void)getRepairMainIndexInfo:(void (^)(BOOL successful,NSMutableArray  *repairItemArray,NSString *describitionString))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_RepairMainIndex];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        if ([[[NSMutableDictionary alloc]initWithDictionary:[json objectForKey:@"myRepair"]] count]) {
            [array addObject:[myRepairModel mj_objectWithKeyValues:[json objectForKey:@"myRepair"]]];
        }
        
        if ([[[NSMutableDictionary alloc]initWithDictionary:[json objectForKey:@"repairManage"]] count]) {
            [array addObject:[repairManageModel mj_objectWithKeyValues:[json objectForKey:@"repairManage"]]];
        }
        if ([[[NSMutableDictionary alloc]initWithDictionary:[json objectForKey:@"myTask"]] count]) {
            [array addObject:[myTaskModel mj_objectWithKeyValues:[json objectForKey:@"myTask"]]];
        }
        status(YES,array,[NSString stringWithFormat:@"%@",[json objectForKey:@"statement"]]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],@"");
    }];
}

#pragma mark - 我要维修
//获取维修组列表
-(void)getRepairEquipmentTeamList:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_RepairEquipmentTeamList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID] forKey:@"userId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[repairEquipmentTypeModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取设备分类列表 - 第一级
-(void)getRepairEquipmentTypeLvOneListWithID:(NSString *)groupID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_RepairEquipmentTypeLvOne];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:groupID forKey:@"groupId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[repairEquipmentTypeModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}

//获取设备分类列表 - 第二级
-(void)getRepairEquipmentTypeLvTwoListWithLvOneID:(NSString *)levelOneId andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_RepairEquipmentTypeLvTwo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:levelOneId forKey:@"levelOneId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[repairEquipmentTypeModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取设备常见故障列表以及故障地点
-(void)getMalfunctionPlaceListWithGoodsID:(NSString *)goodsID andStatus:(void (^)(BOOL successful,NSMutableArray  *placeSource,NSMutableArray *errorSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_MalfunctionPlaceList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:goodsID forKey:@"goodsId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blcokArray = [NSMutableArray arrayWithArray:[RASchoolModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"schoolList"]]];
        
        for (RASchoolModel *schoolModel in blcokArray) {
            schoolModel.buildingListModelArray = [NSMutableArray arrayWithArray:[RAPlaceModel mj_objectArrayWithKeyValuesArray:schoolModel.buildingList]];
            for (RAPlaceModel *placeModel in schoolModel.buildingListModelArray) {
                placeModel.floorListModelArray = [NSMutableArray arrayWithArray:[RAPlaceFloorModel mj_objectArrayWithKeyValuesArray:placeModel.floorList]];
                for (RAPlaceFloorModel *floorModel in placeModel.floorListModelArray) {
                    floorModel.roomListModelArray = [NSMutableArray arrayWithArray:[RAPlaceRoomModel mj_objectArrayWithKeyValuesArray:floorModel.roomList]];
                }
            }
        }
        
        NSMutableArray *errorArray = [NSMutableArray arrayWithArray:[RAErrorModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"faultList"]]];
        status(YES,blcokArray,errorArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array]);
    }];
}
//上传维修申请
-(void)submitRepairApplicationWithResultJson:(NSDictionary *)resultDic ImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_submitRepairApplication];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
    [dic setValue:@"true" forKey:@"sys_auto_authenticate"];
    [dic setValue:[NSString stringWithFormat:@"%@",userName] forKey:@"sys_username"];
    [dic setValue:password forKey:@"sys_password"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_DataSourceName] forKey:@"dataSourceName"];
    
    if (!imageArray.count) {
        
        [TYHHttpTool posts:requestURL params:dic success:^(id json) {
            status(YES,[NSMutableArray arrayWithObject:json]);
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,url_submitRepairApplication,userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            if ([data isEqualToString:@"ok"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
        
    }
    
    
    //    uploadFileNames
}

#pragma mark - 我的报修
//我的报修单列表
-(void)getMyRepairApplicationListWithType:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wjdSource,NSMutableArray *wxzSource,NSMutableArray *dfkSource,NSMutableArray *yxhSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_myRepairApplicationList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:type forKey:@"status"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[MyRepairApplicationModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(YES,blockArray,blockArray,blockArray,blockArray,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array]);
    }];
}

//获取我的报修单详情
-(void)getMyRepairApplicationDetailWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_myRepairApplicationDetail];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    
    NSMutableArray *blockArray = [NSMutableArray array];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        MRARequestInfoModel *requestModel = [MRARequestInfoModel mj_objectWithKeyValues:[json objectForKey:@"requestInfo"]];
        
        MRAServerInfoModel *severModel = [MRAServerInfoModel mj_objectWithKeyValues:[json objectForKey:@"repairInfo"]];
        severModel.goodsSumModelArray = [NSMutableArray arrayWithArray:[MRSAddModel mj_objectArrayWithKeyValuesArray: severModel.goodsSum]];
        
        MRAFeedBackInfoModel *feedBackModel = [MRAFeedBackInfoModel mj_objectWithKeyValues:[json objectForKey:@"feedBackInfo"]];
        
        [blockArray addObject:requestModel];
        [blockArray addObject:severModel];
        
        if (![NSString isBlankString:feedBackModel.repairFlag]) {
            [blockArray addObject:feedBackModel];
        }
        
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取我的报修维修记录
-(void)getMyRepairApplicationServerDetailWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_myRepairApplicationSevice];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[MRAServerReocrdModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


//个人删除报修单
-(void)delRepairApplicationWithRepairID:(NSString *)repairID  andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_DelRepairApplication];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"id"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        status(YES,[NSMutableArray arrayWithObject:json]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//提交反馈
-(void)saveMyRepairApplicationFeedbackWithFeedbackDic:(NSMutableDictionary *)dictionary imageArray:(NSMutableArray *)repairImageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_submitMyApplicationFeedBack];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic addEntriesFromDictionary:dictionary];
    
    if (!repairImageArray.count) {
        [TYHHttpTool posts:requestURL params:dic success:^(id json) {
            status(YES,[NSMutableArray arrayWithObject:json]);
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,url_submitMyApplicationFeedBack,userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [repairImageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                NSString *fileName = [NSString stringWithFormat:@"%@",[(ACMediaModel *)repairImageArray[idx] name]];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
}


//获取提交后的评价列表
-(void)getMyRepairApplicationFeedBackContentListWithReportId:(NSString *)reportID andStatus:(void (^)(BOOL successful,MRAFeedBackInfoModel  *feedBackModel))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_myRepairApplicationFeedBackContentList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:reportID.length?reportID:@"" forKey:@"reportId"];
    //    requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@&reportId=%@",k_V3ServerURL,url_myRepairApplicationFeedBackContentList,userName,password,dataSourceName,reportID];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        MRAFeedBackInfoModel *model = [MRAFeedBackInfoModel new];
        
        model = [MRAFeedBackInfoModel mj_objectWithKeyValues:json];
        
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[MRAFeedBackInfoModel new]);
    }];
}

#pragma mark - 报修管理
//获取报修管理列表
-(void)getRepairManageMentListWithRequestTpe:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wjdSource,NSMutableArray *wxzSource,NSMutableArray *dfkSource,NSMutableArray *yxhSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_RepairManegementMainList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:type forKey:@"status"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[RepairManagementModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray,blockArray,blockArray,blockArray,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array]);
    }];
}


//获取可派维修人员列表
-(void)getServerPersonListWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_getPaiPersonList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[RMServerWorkerModel mj_objectArrayWithKeyValuesArray:json]];
        for (RMServerWorkerModel *model in blockArray) {
            model.isSelected = NO;
        }
        
        status(YES,blockArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//派单给相关维修人员
-(void)submitPaiRequestWithRepairID:(NSString *)repairID WorkerID:(NSString *)workerID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_submitPaiWorker];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    [dic setValue:workerID forKey:@"workerId"];
    [dic setValue:@"true" forKey:@"sendMessageFlag"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        status(YES,[NSMutableArray array]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//费用审批
-(void)submitChargeWithRepairID:(NSString *)repairID YESorNO:(BOOL)handler reasonText:(NSString *)text andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_submitChargeHandler];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    [dic setValue:text.length?text:@"" forKey:@"checkNote"];
    [dic setValue:handler?@"1":@"2" forKey:@"checkFlag"];
    
    [TYHHttpTool posts:requestURL params:dic success:^(id json) {
        status(YES,[NSMutableArray array]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//接单
-(void)acceptOrdersWith:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_receiveRequest];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:repairID forKey:@"repairId"];
    [TYHHttpTool posts:requestURL params:dic success:^(id json) {
        NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if ([data isEqualToString:@"ok"]) {
            status(YES,[NSMutableArray array]);
        }
        else
            status(NO,[NSMutableArray array]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


//通过userID获取云信ID
-(void)getYunXinIDWithUserID:(NSString *)v3ID andStatus:(void (^)(BOOL successful,NSString  *yunxinID))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,url_getYunXinID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:v3ID forKey:@"v3Id"];
    NSString *userNameAndOrg = [NSString stringWithFormat:@"%@%,%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME],[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID]];
    [dic setValue:userNameAndOrg forKey:@"sys_username"];
    
    
    [TYHHttpTool gets:requestURL params:dic success:^(id json) {
        
        NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        status(YES,string);
        
    } failure:^(NSError *error) {
        status(NO,error.description);
    }];
    
    
    //    // 1.创建请求管理者
    //    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    //
    //
    //    // 2.发送请求
    //    [mgr GET:requestURL parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
    //        status(YES,string);
    //    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    //        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
    //        status(NO,string);
    //    }];
    
}
#pragma mark - 我的维修
//我的维修列表
-(void)getMyServerListWithType:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wxzSource,NSMutableArray *yfkSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_MySeverList];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:type forKey:@"status"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[RepairManagementModel mj_objectArrayWithKeyValuesArray:json]];
        
        status(YES,blockArray,blockArray,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array]);
    }];
    
}

//提交我的维修反馈
-(void)submitMyServerFeedBackWithResultJson:(NSDictionary *)resultDic ImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_submitMySeverFeedBack];
    
    //    requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",k_V3ServerURL,url_submitMySeverFeedBack,userName,password];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
    [dic setValue:@"true" forKey:@"sys_auto_authenticate"];
    [dic setValue:[NSString stringWithFormat:@"%@",userName] forKey:@"sys_username"];
    [dic setValue:password forKey:@"sys_password"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_DataSourceName] forKey:@"dataSourceName"];
    
    if (!imageArray.count) {
        
        [TYHHttpTool posts:requestURL params:dic success:^(id json) {
            status(YES,[NSMutableArray arrayWithObject:json]);
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
        
    }
    else
    {
        
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,url_submitMySeverFeedBack,userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            if ([data isEqualToString:@"ok"]) {
                status(YES,responseObject);
            }
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
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

