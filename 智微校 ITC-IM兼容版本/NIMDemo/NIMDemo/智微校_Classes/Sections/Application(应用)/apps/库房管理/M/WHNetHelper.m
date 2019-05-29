//
//  WHNetHelper.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/6.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHNetHelper.h"
#import "TYHWarehouseDefine.h"
#import <MJExtension.h>
#import "TYHHttpTool.h"

#import "WHApplicationModel.h"
#import "WHMyApplicationModel.h"
#import "WHGoodsStasticsModel.h"
#import "WHGoodsModel.h"

#import "ContactModel.h"
#import "UserModel.h"

#import "WHOutModel.h"

@implementation WHNetHelper
{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *dataSourceName;
    
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
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    
    
//    valueForKey:USER_DEFAULT_USERID
}


#pragma mark - 方法

#pragma mark -易耗品管理主页信息
-(void)getMainPageInfo:(void (^)(BOOL successful, WHMainPageModel *mainModel))status failure:(void (^)(NSError *error))failure
{
    /**
     * zwslsh : 1    总务的审核权限   1有 0无
     * zwCount : 8     总务待审核数量
     * sr_statistics : 1    查看统计权限
     * sr_warehouseManage : 1    发放物品权限
     * deptslsh : 1  部门审核权限
     * deptCount : 4    部门待审核数量
     */
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_GetMainPageNum];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        WHMainPageModel *model = [WHMainPageModel mj_objectWithKeyValues:json];
        status(YES,model);
    } failure:^(NSError *error) {
        status(NO,[WHMainPageModel new]);
    }];
}

#pragma mark -申请相关
//获取申请列表信息
-(void)getApplicationInfo:(void (^)(BOOL successful,WHApplicationModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_ApplyRecordInfo];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID};
    
    //初始化
    WHApplicationModel *applicationModel = [[WHApplicationModel alloc]init];
    applicationModel.myDepartmentListArray = [NSMutableArray array];
    applicationModel.applyMessageModel = [WHAApplyMessageModel new];
    applicationModel.applyReceiveKindModel = [WHAApplyReceiveKindModel new];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSArray *array = [NSArray arrayWithArray:[json objectForKey:@"applymessage"]];
        applicationModel.applyMessageModel = [WHAApplyMessageModel mj_objectWithKeyValues:array[0]];
        applicationModel.applyReceiveKindModel = [WHAApplyReceiveKindModel mj_objectWithKeyValues:[json objectForKey:@"applyReceiveKind"]];
        
        applicationModel.myDepartmentListArray = [WHAMyDepartmentListModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"myDepartmentList"]];
        for (WHAMyDepartmentListModel *dModel in applicationModel.myDepartmentListArray) {
            dModel.userListModelArray = [WHACheckerModel mj_objectArrayWithKeyValuesArray:dModel.userList];
        }
        
        applicationModel.WHAApplyReceiveKindListModelArray = [NSMutableArray arrayWithArray:[WHAApplyReceiveKindListModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applyReceiveKindList"]]];
        
        status(YES,applicationModel);
    } failure:^(NSError *error) {
        status(NO,[WHApplicationModel new]);
    }];
    
}


//提交申请
-(void)submitApplicationWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_SubmitApply];
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"resultJson":resultDic.mj_JSONString};
    
    [TYHHttpTool post:requestURL params:dic success:^(id json) {
        status(YES,[NSMutableArray arrayWithObject:json]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}



#pragma mark -我的申领相关
//获取我的申领列表
-(void)getMyApplicationList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_MyApplicationList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHMyApplicationModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"gridModel"]]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取申领详情
-(void)getMyApplicationDetailWithApplyID:(NSString *)applyId andStatus:(void (^)(BOOL successful,WHMyApplicationDetailModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_MyApplicationDetail];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":applyId};
    
    WHMyApplicationDetailModel *adModel  = [WHMyApplicationDetailModel new];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        adModel.detailArray = [NSMutableArray arrayWithArray:[WHMyDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applyreceiverecord"]]];
        adModel.itemListArray = [NSMutableArray arrayWithArray:[WHMyItemListModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applygoodsList"]]];
        
        status(YES,adModel);
    } failure:^(NSError *error) {
        status(NO,[WHMyApplicationDetailModel new]);
    }];
    
    
}

#pragma mark -申领列表
//获取申领列表
-(void)getApplicationList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_OutList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHMyApplicationModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"gridModel"]]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        
    }];
}


#pragma mark -出库列表
//获取出库列表
-(void)getOutListWithPageNum:(NSString *)num andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_getOutWarehouseList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":userID,@"num":num};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHOutModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        
    }];
}

//获取出库列表详情
-(void)getOutListDetailWithOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,WHOutModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_getOutListDetail];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":outID};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        WHOutModel *outModel = [WHOutModel mj_objectWithKeyValues:json];
        outModel.goodsListModelArray = [NSMutableArray arrayWithArray:[WHOutDetailoodsListModel mj_objectArrayWithKeyValuesArray:outModel.goodsList]];
        
        status(YES,outModel);
        
    } failure:^(NSError *error) {
        
        status(NO,[WHOutModel new]);
        
    }];
}

//按申领人姓名搜索出库单
-(void)searchGetOutByUserName:(NSString *)username andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_searchByUserName];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userName":username};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHOutModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        
    }];

}

//获取补签详情
-(void)getResignDetailWithOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,WHOutResignModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_getReSignDetail];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":outID};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        WHOutResignModel *resignModel = [WHOutResignModel mj_objectWithKeyValues:json];
        resignModel.goodsListModelArray = [NSMutableArray arrayWithArray:[WHOutGoodsListModel mj_objectArrayWithKeyValuesArray:resignModel.goodsList]];
        
        status(YES,resignModel);
    } failure:^(NSError *error) {
        status(NO,[WHOutResignModel new]);
        }];
}

//提交补签
-(void)saveResignImageWitjOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    UIImage *imageNeedUpload = [UIImage imageWithData:imageData];
    NSMutableArray *imageArray = [NSMutableArray array];
    if (imageNeedUpload && imageNeedUpload != nil) {
        [imageArray addObject:imageNeedUpload];
    }
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSString *requstURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,url_saveReSign,userName,password,dataSourceName];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:outID forKey:@"id"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    
    [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
        params[str2] = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
    }];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    ////    这个决定了下面responseObject返回的类型
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableArray  *imageDataArr = [NSMutableArray array];
    //    UIImage * image2;
    for (UIImage * image in imageArray) {
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

#pragma mark -统计相关
//获取物品统计列表
-(void)getGoodsStasticsList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_GoodsStastics];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHGoodsStasticsModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"goodsstatistics"]]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取物品统计出库入库详情列表
-(void)getGoodsStasticsInOutHouseListWithgoodsID:(NSString *)goodsID RequestType:(NSString *)requestType andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = @"";
    if ([requestType isEqualToString:@"入库详情"]) {
       requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_GoodsInHouseDetail];
    }
    else
    {
        requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_GoodsOutHouseDetail];
    }
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":goodsID};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *blockArray = [NSMutableArray array];
        if ([requestType isEqualToString:@"入库详情"]) {
            blockArray = [NSMutableArray arrayWithArray:[WHGoodsStasticsInOutHouseModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"intogoodsstatistics"]]];
        }
        else
        {
            blockArray = [NSMutableArray arrayWithArray:[WHGoodsStasticsInOutHouseModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"outgoodsstatistics"]]];
        }
        
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


//获取物品统计库存详情列表
-(void)getGoodsStasticsStockListWithgoodsID:(NSString *)goodsID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_GoodsCountDetail];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":goodsID};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHGoodsStasticsStockModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"intogoodsstatistics"]]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}


#pragma mark -申领审核
//申领审核-部门
-(void)getApplicationCheckBMList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_ApplicationCheckBM];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"kind":@"dept",@"pageObj.pageSize":@"1000"};
    
//    sys_username	test
//    sys_password	670b14728ad9902aecba32e22fa4f6bd
//    kind	dept
//    dataSourceName	SCHOOL_CONTEXT_DEFAULT
//    sys_Token	2b02cdb2a8d930bac292daf596f9616f
//    pageObj.pageSize	1000
//    sys_auto_authenticate	true
//    http://www.zdhx-edu.com:10010/dc/sr/applyReceiveRecord!auditZWListData.action
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHMyApplicationModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"gridModel"]]];
        for (WHMyApplicationModel *model in blockArray) {
            model.checkKind = 0;
        }
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}
//申领审核-总务
-(void)getApplicationCheckZWList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_ApplicationCheckZW];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"kind":@"zw",@"pageObj.pageSize":@"1000"};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHMyApplicationModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"gridModel"]]];
        for (WHMyApplicationModel *model in blockArray) {
            model.checkKind = 1;
        }
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//提交申领审核
-(void)ApplicationCheckWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_ApplicationCheckSubmit];
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"resultJson":jsonString};
    
    [TYHHttpTool post:requestURL params:dic success:^(id json) {
        status(YES,[NSMutableArray arrayWithObject:json]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

#pragma mark -获取物品
//获取物品分类
-(void)getGoodsKindListWithOutWarehouseID:(NSString *)outwarehouseID and:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_goodsKindList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"storeId":outwarehouseID.length?outwarehouseID:@""};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHGoodsKindModel mj_objectArrayWithKeyValuesArray:json]];
        for (WHGoodsKindModel *model in blockArray) {
            model.nodesModelArray = [WHGoodsKindInnerModel mj_objectArrayWithKeyValuesArray:model.nodes];
        }
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//获取物品分类的详情
-(void)getGoodsDetailListWithGoodsID:(NSString *)goodsId andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_goodsDetailInfoList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":goodsId};
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *blockArray = [NSMutableArray arrayWithArray:[WHGoodsDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"gridModel"]]];
        
        for (WHGoodsDetailModel *model in blockArray) {
            model.goodsInfoName = model.name;
            model.itemId = model.goodsID;
            model.sum = model.inventory;
        }
        
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
    
}

#pragma mark -申领发放
//获取申领发放信息
-(void)getApplyDiliverMainInfoWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful,WHMyApplicationDetailModel *model))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_applyDiliverMainInfo];
    applyID = applyID.length?applyID:@"";
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":applyID};
    
    WHMyApplicationDetailModel *detailModel = [WHMyApplicationDetailModel new];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        detailModel.detailArray = [NSMutableArray arrayWithArray:[WHMyDetailModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applyreceiverecord"]]];
        detailModel.itemListArray = [NSMutableArray arrayWithArray:[WHMyItemListModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"applygoodsList"]]];
        
        
        status(YES,detailModel);
    } failure:^(NSError *error) {
        status(NO,[WHMyApplicationDetailModel new]);
    }];
}
//获取申领发放的申请物品清单
-(void)getApplyDiliverGoodsListWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSourceUseKind,NSMutableArray *dataSourceChecker,NSMutableArray *wareHouseListArray))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_applyDiliverItemInfoList];
    applyID = applyID.length?applyID:@"";
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":applyID,@"kind":@"2"};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *useKindArray = [NSMutableArray arrayWithArray:[WHMyApplicationUseKindModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"outwarehouseKindList"]]];
        
        NSMutableArray *wareHouseListArray = [NSMutableArray arrayWithArray:[self handleContactList:[json objectForKey:@"schoolwarehouseTree"]]];
        
        NSMutableArray *checkerArray = [NSMutableArray arrayWithArray:[WHMyApplicationCheckModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"warehouseRecordData"]]];
        status(YES,useKindArray,checkerArray,wareHouseListArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array]);
    }];
}

//获取申领发放的部门列表
-(void)getApplyDepartmentListWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful, NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_applyDepartmentList];
    
    applyID = applyID.length?applyID:@"";
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"id":applyID,@"dataSourceName":dataSourceName};
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[self handleContactList:json]];
        status(YES,itemArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray new]);
    }];
}


////申请发放提交
-(void)submitApplicationDiliverWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    UIImage *imageNeedUpload = [UIImage imageWithData:imageData];
    NSMutableArray *imageArray = [NSMutableArray array];
    if (imageNeedUpload && imageNeedUpload != nil) {
        [imageArray addObject:imageNeedUpload];
    }
    
    if (!imageArray.count) {
        NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,url_ApplicationDiliverSubmit];
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName,@"resultJson":resultDic.mj_JSONString};
        
        [TYHHttpTool post:requestURL params:dic success:^(id json) {
            status(YES,[NSMutableArray arrayWithObject:json]);
        } failure:^(NSError *error) {
            status(NO,[NSMutableArray array]);
        }];
    }
    else
    {
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        NSString *requstURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,url_ApplicationDiliverSubmit,userName,password,dataSourceName];
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        params[@"resultJson"] = resultDic.mj_JSONString;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            params[str2] = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
        }];
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        //    UIImage * image2;
        for (UIImage * image in imageArray) {
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


#pragma mark - TreeAbout
- (NSMutableArray *)handleContactList:(NSMutableArray *)array;
{
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    static NSUInteger indentation = 0;
    
    for (NSDictionary *dic in array) {
        ContactModel *contactModel = [[ContactModel alloc] init];
        contactModel.IndentationLevel = indentation;
        contactModel.contactId = dic[@"id"];
        contactModel.name = dic[@"name"];
        contactModel.parentId = dic[@"parentId"];
        NSMutableArray *childsArray = [dic objectForKey:@"childs"];
        if (childsArray && childsArray.count > 0) {
            contactModel.childs = [self addSubContact:childsArray withContactModel:contactModel andIndentation:indentation];
        }
        NSMutableArray *userListArray = [dic objectForKey:@"userList"];
        if (userListArray && userListArray.count >0) {
            contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
        }
        [totalArray addObject:contactModel];
    }
    return totalArray;
}

- (NSMutableArray *)addSubContact:(NSMutableArray *)childsArray withContactModel:(ContactModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in childsArray) {
        NSString *parentId = [dic objectForKey:@"parentId"];
        if ([model.contactId isEqualToString:parentId]) {
            ContactModel *contactModel = [[ContactModel alloc] init];
            contactModel.IndentationLevel = indentation;
            contactModel.contactId = [dic objectForKey:@"id"];
            
            contactModel.name = [dic objectForKey:@"name"];
            contactModel.parentId = [dic objectForKey:@"parentId"];
            [model.childs addObject:contactModel];
            NSMutableArray *subArray = [dic objectForKey:@"childs"];
            if (subArray && subArray.count > 0) {
                contactModel.childs = [self addSubContact:subArray withContactModel:contactModel andIndentation:indentation];
            }
            else
            {
                NSMutableArray *goodsArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"goodsCount"]];
                NSMutableArray *goodsModelArray = [NSMutableArray array];

                [goodsArray enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ContactGoodsCountModel *goodsModel = [ContactGoodsCountModel new];
                    goodsModel.goodsCount = [obj objectForKey:@"count"];
                    if ([[obj objectForKey:@"count"] integerValue] <= 0) {
                        goodsModel.goodsCount = @"0";
                    }
                    goodsModel.goodsID = [obj objectForKey:@"id"];
                    [goodsModelArray addObject:goodsModel];
                }];
                contactModel.goodsCountArray = [NSMutableArray arrayWithArray:goodsModelArray];
            }
            NSMutableArray *userListArray = [dic objectForKey:@"userList"];
            if (userListArray && userListArray.count >0) {
                contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
            }
        }
    }
    return model.childs;
}


- (NSMutableArray *)addSubUserList:(NSMutableArray *)userListArray withContactModel:(ContactModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.userList = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *userDic in userListArray) {
        UserModel *userModel = [[UserModel alloc] init];
        userModel.IndentationLevel = indentation;
        userModel.userId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
        userModel.voipAccount = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"voipAccount"]];
        userModel.strId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.headPortraitUrl = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"headPortraitUrl"]];
        [model.userList addObject:userModel];
//        [self.dataSource addObject:userModel];
    }
    return model.userList;
}


#pragma mark - ImageDeal
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



@end
