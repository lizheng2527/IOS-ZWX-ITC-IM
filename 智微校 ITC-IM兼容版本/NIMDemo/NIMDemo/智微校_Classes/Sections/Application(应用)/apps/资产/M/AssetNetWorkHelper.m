//
//  AssetNetWorkHelper.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetNetWorkHelper.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "TYHAssetModel.h"
#import "NSString+Empty.h"
#import "TYHAssetDefine.h"
#import "TYHAssetModel.h"
#import <AFNetworking.h>


@implementation AssetNetWorkHelper{
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

#pragma mark - 获取首页信息
-(void)getIndexJson:(void(^)(BOOL successful,TYHAssetManagerItemModel *tmpModel))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,IndexJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        
        TYHAssetManagerItemModel *dicModel = [TYHAssetManagerItemModel mj_objectWithKeyValues:json];
        status(YES,dicModel);
        
    } failure:^(NSError *error) {
        status(NO,[TYHAssetManagerItemModel new]);
    }];
}

#pragma mark -获取首页数据
-(void)getGrantNumJson:(void(^)(BOOL successful,TYHAssetManagerItemModel *tmpModel))status failure:(void(^)(NSError *error))failure
{
    //http://117.78.48.224:12000/zddc/ao/assetMobile!getNotSignedGrantNumJson.action
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,notSignedGrantNumJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        TYHAssetManagerItemModel *dicModel = [TYHAssetManagerItemModel mj_objectWithKeyValues:json];
        status(YES,dicModel);
    } failure:^(NSError *error) {
        status(NO,[TYHAssetManagerItemModel new]);
    }];
    
}






#pragma mark - 获取发放列表
-(void)getGrantListJson:(void(^)(BOOL successful,NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure
{
    //http://117.78.48.224:12000/zddc/ao/assetMobile!getGrantListJson.action?sys_username=lixin&sys_password=839e9c1a49e7ebdeddf258630a89a2bc&sys_auto_authenticate=true
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,GrantListJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[AssetMineReturnModel objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


#pragma mark - 查找资产
-(void)searchAssetWithOperationCode:(NSString *)code andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"operationCode":code};
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getSearchAssetListJson];
    
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        //        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[AssetApplySchoolModel objectArrayWithKeyValuesArray:[json objectForKey:@"schools"]]];
        
        status(YES,[NSMutableArray array]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取资产查找结果
-(void)getSearchAssetListsJsonnWithLocationID:(NSString *)locationID kitFlag:(NSString *)kitFlag assetKindId:(NSString *)assetKindId purchaseDateEnd:(NSString *)purchaseDateEnd brandId:(NSString *)brandId name:(NSString *)name purchaseDateStart:(NSString *)purchaseDateStart code:(NSString *)code patternId:(NSString *)patternId andStatus:(void(^)(BOOL successful, NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure
{
    if ([NSString isBlankString:locationID]) {
        locationID = @"";
    }
    if ([NSString isBlankString:kitFlag]) {
        kitFlag = @"";
    }
    if ([NSString isBlankString:assetKindId]) {
        assetKindId = @"";
    }
    if ([NSString isBlankString:purchaseDateEnd]) {
        purchaseDateEnd = @"";
    }
    if ([NSString isBlankString:brandId]) {
        brandId = @"";
    }
    if ([NSString isBlankString:name]) {
        name = @"";
    }
    else
    {
        name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ([NSString isBlankString:code]) {
        code = @"";
    }
    else
    {
        code = [code stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ([NSString isBlankString:purchaseDateStart]) {
        purchaseDateStart = @"";
    }
    if ([NSString isBlankString:patternId]) {
        patternId = @"";
    }
    
    NSDictionary *dic = @{@"locationId":locationID,@"kitFlag":kitFlag,@"assetKindId":assetKindId,@"purchaseDateEnd":purchaseDateEnd,@"brandId":brandId,@"name":name,@"purchaseDateStart":purchaseDateStart,@"code":code,@"patternId":patternId,@"operationCode":@"CheckManage"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSString *requstURL = [NSString stringWithFormat:@"%@%@?resultJson=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,getSearchAssetListJson,jsonString ,userName,password,dataSourceName];
    requstURL = [requstURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [TYHHttpTool post:requstURL params:dic success:^(id json) {
        
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[AssetMineDetailModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark - 审核资产通过&不通过
-(void)saveAssetCheckWithCheckReason:(NSString *)reason checkRestult:(NSString *)result  checkApplyID:(NSString *)applyIDS andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"checkReason":reason,@"applyIds":applyIDS,@"checkResult":result};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urll = [NSString stringWithFormat:@"%@%@?resultJson=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true",k_V3ServerURL,saveCheck,jsonString ,userName,password];
    urll = [urll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [TYHHttpTool posts:urll params:nil success:^(id json) {
        status(YES,[NSMutableArray arrayWithObject:json]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}


- (NSString *)URLEncodedString:(NSString*)resource {
    CFStringRef url = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)resource, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8); // for some reason, releasing this is disasterous
    NSString *result = (__bridge NSString *)url;
    //    [result autorelease];
    return result;
}

#pragma mark - 发放资产提交(可以多个资产)
-(void)submitAssetDiliverWithAssetIDs:(NSString *)assetIds ApplicationRecordID:(NSString *)applicationRecordId DepartmentID:(NSString *)departmentId userID:(NSString *)userId LocationID:(NSString *)locationId uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure
{
    //    http://117.78.48.224:12000/zddc/ao/assetMobile!saveGrant.action?sys_username=gaoyacun&sys_password=670b14728ad9902aecba32e22fa4f6bd&sys_auto_authenticate=true
    
    if (uploadFiles.count == 0 && uploadFiles) {
        NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"assetIds":assetIds,@"applicationRecordId":applicationRecordId,@"departmentId":departmentId,@"userId":userId,@"locationId":locationId};
        //                NSString *urll = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&assetIds=%@applicationRecordId=%@&departmentId=%@&userId=%@&locationId=%@",k_V3ServerURL,saveGrant,userName,password,assetIds,applicationRecordId,departmentId,userId,locationId];
        //        NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"assetIds":assetIds,@"applicationRecordId":applicationRecordId,@"departmentId":departmentId,@"userId":userId,@"locationId":locationId};
        //
        NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,saveGrant];
        
        //        urll = [urll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        //        NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"assetIds":assetIds,@"applicationRecordId":applicationRecordId,@"departmentId":departmentId,@"userId":userId,@"locationId":locationId};
        
        
        [TYHHttpTool get:requstURL params:dic success:^(id json) {
            status(YES,[NSMutableArray arrayWithObject:json]);
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        NSString *requstURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",k_V3ServerURL,saveGrant,userName,password];
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        params[@"assetIds"] = assetIds;
        params[@"userId"] = userId;
        params[@"applicationRecordId"] = applicationRecordId;
        params[@"departmentId"] = departmentId;
        params[@"id"] = locationId;
        params[@"dataSourceName"] = dataSourceName;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        
        [uploadFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            params[str2] = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        //    UIImage * image2;
        for (UIImage * image in uploadFiles) {
            //设置image的尺寸
            UIImage *imageNew = image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.8);
            [imageDataArr addObject:imageData];
        }
        
        [manager POST:requstURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
            
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
                
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
                
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"]) {
                status(YES,responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"服务器返回:%@",[error localizedDescription]);
            status(NO,[NSMutableArray arrayWithArray:[NSArray arrayWithObject:[error localizedDescription]]]);
        }];
        
    }
}



#pragma mark - 获取查找资产列表
-(void)getAssetPageJsonWithCheckModel:(NSString *)checkModel andStatus:(void(^)(BOOL successful,NSMutableArray *locationsArray))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"operationCode":checkModel};
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,AssetPageJson];
    
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[AssetApplySchoolModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"locations"]]];
        
        for (AssetApplySchoolModel *model in dataArray) {
            model.classesArray = [NSMutableArray arrayWithArray:[AssetApplySchoolsAuditorModel mj_objectArrayWithKeyValuesArray:model.tmpClassArray]];
        }
        
        status(YES,dataArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//根据查找到的资产列表获取资产列表
-(void)getAssetListJsonWithLocationID:(NSString *)locationID andStatus:(void(^)(BOOL successful,NSMutableArray *locationsArray))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"locationId":locationID};
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,InStockNumJson];
    
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        
        NSMutableArray *handleArray = [NSMutableArray array];
        handleArray = [self handleContactList:[json objectForKey:@"assetKinds"]];
        
        status(YES,handleArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}



#pragma mark - <------------获取我的资产List---------------------->
-(void)getMyAssetListJson:(void(^)(BOOL successful,AssetMineModel *assetMineModel))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    //    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@""];
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,getMyAssetListJsonn];
    AssetMineModel *mineModel = [AssetMineModel new];
    mineModel.myAssetListArray = [NSMutableArray array];
    mineModel.returnAssetsArray = [NSMutableArray array];
    mineModel.applicationRecordsArray = [NSMutableArray array];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        mineModel.myAssetListArray = [NSMutableArray arrayWithArray:[AssetMineDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"myAssetList"]]];
        mineModel.returnAssetsArray = [NSMutableArray arrayWithArray:[AssetMineReturnModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"returnRecords"]]];
        mineModel.applicationRecordsArray = [NSMutableArray arrayWithArray:[AssetMineApplyModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applicationRecords"]]];
        status(YES,mineModel);
        
    } failure:^(NSError *error) {
        status(NO,[AssetMineModel new]);
    }];
}

#pragma mark -获取资产详情
-(void)getAssetDetailJsonWithAssetId:(NSString *)assetID andStatus:(void(^)(BOOL successful,AssetDetailModel *detailModel))status failure:(void(^)(NSError *error))failure
{
    //    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"ecActivityId":ecid,@"userId":userID};
    //    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@""];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"code":assetID};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,AssetInfoJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        AssetDetailModel *detailModel = [AssetDetailModel mj_objectWithKeyValues:json];
        if ([[json objectForKey:@"attachments"] count] > 0  && ![NSString isBlankString:[[json objectForKey:@"attachments"][0] objectForKey:@"url"]]) {
            detailModel.imageURL = [[json objectForKey:@"attachments"][0] objectForKey:@"url"];
        }
        status(YES,detailModel);
    } failure:^(NSError *error) {
        status(NO,[AssetDetailModel new]);
    }];
}

#pragma mark -获取资产申请详情

-(void)getApplyDetailJsonWithApplyId:(NSString *)applyID andStatus:(void(^)(BOOL successful,AssetMineApplyModel *applyModel))status failure:(void(^)(NSError *error))failure
{
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":applyID};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,CheckInfoJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        AssetMineApplyModel *detailModel = [AssetMineApplyModel mj_objectWithKeyValues:json];
        detailModel.checkStatus = [self dealEvaleateString:detailModel.checkStatus];
        status(YES,detailModel);
    } failure:^(NSError *error) {
        status(NO,[AssetMineApplyModel new]);
    }];
}

#pragma mark -获取资产归还详情
-(void)getReturnDetailJsonWithReturnId:(NSString *)returnID andStatus:(void(^)(BOOL successful,AssetMineReturnModel *returnModel))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":returnID};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,ReturnInfoJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        AssetMineReturnModel *model = [AssetMineReturnModel mj_objectWithKeyValues:json];
        model.returnAssetsArray = [NSMutableArray array];
        model.returnAssetsArray = [AssetDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"returnAssets"]];
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[AssetMineReturnModel new]);
    }];
}

#pragma mark -获取资产申请详情
-(void)getGrantDetailJsonWithReturnId:(NSString *)returnID andStatus:(void(^)(BOOL successful,AssetMineReturnModel *returnModel))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":returnID};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,GrantInfoJson];
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        AssetMineReturnModel *model = [AssetMineReturnModel mj_objectWithKeyValues:json];
        model.returnAssetsArray = [NSMutableArray array];
        model.returnAssetsArray = [AssetDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"grantAssets"]];
        status(YES,model);
        
    } failure:^(NSError *error) {
        status(NO,[AssetMineReturnModel new]);
    }];
}


#pragma mark - <------------获取审核发放List---------------------->
-(void)getCheckDiliverlJsonWithPageNum:(NSString *)pageNum State:(NSString *)state andStatus:(void(^)(BOOL successful, TYHAssetModel *assetModel))status failure:(void(^)(NSError *error))failure
{
    //    NSDictionary *paraDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    //
    //    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,CheckListJson];
    //
    NSDictionary *dic = @{@"pageNum":@"1",@"status":@""};
    NSString *urll = [NSString stringWithFormat:@"%@%@?resultJson=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true",k_V3ServerURL,CheckListJson,dic,userName,password];
    urll = [urll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    TYHAssetModel *tmpModel = [TYHAssetModel new];
    tmpModel.assetAllArray = [NSMutableArray array];
    tmpModel.assetPassArray = [NSMutableArray array];
    tmpModel.assetCheckArray = [NSMutableArray array];
    tmpModel.assetUnPassArray = [NSMutableArray array];
    tmpModel.assetDiliverArray = [NSMutableArray array];
    
    [TYHHttpTool get:urll params:nil success:^(id json) {
        NSMutableArray *cdArray = [AssetCheckDiliverModel mj_objectArrayWithKeyValuesArray:json];
        
        for (AssetCheckDiliverModel *model in cdArray) {
            if ([model.checkStatusView isEqualToString:@"未审核"]) {
                [tmpModel.assetCheckArray addObject:model];
            }
            else if ([model.checkStatusView isEqualToString:@"已发放"]) {
                [tmpModel.assetDiliverArray addObject:model];
            }
            else if ([model.checkStatusView isEqualToString:@"已通过"]) {
                [tmpModel.assetPassArray addObject:model];
            }
            else if ([model.checkStatusView isEqualToString:@"未通过"]) {
                [tmpModel.assetUnPassArray addObject:model];
            }
        }
        tmpModel.assetAllArray = cdArray;
        status(YES,tmpModel);
    } failure:^(NSError *error) {
        status(NO,[TYHAssetModel new]);
    }];
}



#pragma mark - 提交申请
-(void)summitApplicationWithReason:(NSString *)aplReason applyDate:(NSString *)aplDate schoolId:(NSString *)aplschoolId departmentId:(NSString *)apldepartmentId demand:(NSString *)apldemand assetKindId:(NSString *)aplassetKindId checkPersonID:(NSString *)checkpersonID andStatus:(void(^)(BOOL successful, NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{@"reason":aplReason,@"applyDate":aplDate,@"schoolId":aplschoolId,@"userId":checkpersonID.length?checkpersonID:@"",@"departmentId":apldepartmentId,@"demand":apldemand,@"assetKindId":aplassetKindId};
    
    NSDictionary *resultDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"resultJson":dic.mj_JSONString};
    
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,saveApplication];
    
    [TYHHttpTool posts:requstURL params:resultDic success:^(id json) {
        status(YES,[NSMutableArray arrayWithObject:json]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

- (NSString*)my_description {
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}


#pragma mark -申请界面List请求
-(void)getApplicationJsonWithOperationCode:(NSString *)code andStatus:(void(^)(BOOL successful,NSMutableArray *assetListArray,NSMutableArray *schoolDatasource,NSMutableArray *departmentDatasource))status failure:(void(^)(NSError *error))failure
{
    ///ao/assetMobile!getApplicationJson.action?operationCode=CheckManage
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"operationCode":code};
    NSString *requstURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,ApplicationJson];
    
    //    requstURL = [requstURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [TYHHttpTool get:requstURL params:dic success:^(id json) {
        NSMutableArray *handleArray = [NSMutableArray array];
        handleArray = [self handleContactList:[json objectForKey:@"assetKinds"]];
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[AssetApplySchoolModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"schools"]]];
        
        for (AssetApplySchoolModel *model in dataArray) {
            model.auditorsArray = [NSMutableArray arrayWithArray:[AssetApplySchoolsAuditorModel mj_objectArrayWithKeyValuesArray:model.tmpArray]];
        }
        NSMutableArray *departMentArray = [NSMutableArray arrayWithArray:[AssetApplyUserDepartmentsModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"userDepartments"]]];
        
        status(YES,handleArray,dataArray,departMentArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array]);
    }];
}

- (NSMutableArray *)handleContactList:(NSMutableArray *)array;
{
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    static NSUInteger indentation = 0;
    
    for (NSDictionary *dic in array) {
        AssetListModel *contactModel = [[AssetListModel alloc] init];
        contactModel.IndentationLevel = indentation;
        contactModel.contactId = dic[@"id"];
        contactModel.name = dic[@"name"];
        contactModel.parentId = dic[@"parentId"];
        contactModel.quantity = dic[@"count"];
        contactModel.assetBrandsArray = dic[@"assetBrands"];
        NSMutableArray *childsArray = [dic objectForKey:@"childs"];
        if (childsArray && childsArray.count > 0) {
            contactModel.childs = [self addSubContact:childsArray withContactModel:contactModel andIndentation:indentation];
        }
        NSMutableArray *userListArray = [dic objectForKey:@"userList"];
        if (userListArray && userListArray.count >0) {
            contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
        }
        //        if ([contactModel.parentId isEqualToString:@"0"]) {
        //            [totalArray addObject:contactModel];
        //        }
        [totalArray addObject:contactModel];
    }
    return totalArray;
}

- (NSMutableArray *)addSubContact:(NSMutableArray *)childsArray withContactModel:(AssetListModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in childsArray) {
        NSString *parentId = [dic objectForKey:@"parentId"];
        if ([model.contactId isEqualToString:parentId]) {
            AssetListModel *contactModel = [[AssetListModel alloc] init];
            contactModel.IndentationLevel = indentation;
            contactModel.contactId = [dic objectForKey:@"id"];
            
            contactModel.name = [dic objectForKey:@"name"];
            contactModel.parentId = [dic objectForKey:@"parentId"];
            
            contactModel.quantity = dic[@"count"];
            contactModel.assetBrandsArray = dic[@"assetBrands"];
            
            [model.childs addObject:contactModel];
            
            
            NSMutableArray *subArray = [dic objectForKey:@"childs"];
            if (subArray && subArray.count > 0) {
                contactModel.childs = [self addSubContact:subArray withContactModel:contactModel andIndentation:indentation];
            }
            NSMutableArray *userListArray = [dic objectForKey:@"userList"];
            if (userListArray && userListArray.count >0) {
                contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
            }
        }
    }
    return model.childs;
}


- (NSMutableArray *)addSubUserList:(NSMutableArray *)userListArray withContactModel:(AssetListModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.userList = [[NSMutableArray alloc] initWithCapacity:0];
    //    model.userList = [AssetListDetailsModel objectArrayWithKeyValuesArray:userListArray];
    for (NSDictionary *userDic in userListArray) {
        AssetListDetailsModel *userModel = [[AssetListDetailsModel alloc] init];
        userModel.IndentationLevel = indentation;
        userModel.assetID = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.assetName = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
        [model.userList addObject:userModel];
    }
    return model.userList;
}

#pragma mark - 逻辑&方法
//处理状态码,返回对应状态
-(NSString *)dealEvaleateString:(NSString *)srting
{
    switch ([srting integerValue]) {
        case 0:
            return @"全部";
            break;
        case 1:
            return @"未审核";
            break;
        case 2:
            return @"未通过";
            break;
        case 3:
            return @"已通过";
            break;
        case 4:
            return @"已发放";
            break;
        default:
            return @"";
            break;
    }
}

//压缩图片方法
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


//对图片尺寸进行压缩--

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end

