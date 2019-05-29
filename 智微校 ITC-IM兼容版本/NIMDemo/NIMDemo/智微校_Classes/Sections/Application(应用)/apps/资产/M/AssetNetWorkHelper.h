//
//  AssetNetWorkHelper.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AssetMineModel;
@class AssetDetailModel;
@class AssetMineApplyModel;
@class AssetMineReturnModel;
@class TYHAssetModel;
@class TYHAssetManagerItemModel;

@interface AssetNetWorkHelper : NSObject

//获取我的资产List
-(void)getMyAssetListJson:(void(^)(BOOL successful,AssetMineModel *assetMineModel))status failure:(void(^)(NSError *error))failure;
//获取我的-资产详情
-(void)getAssetDetailJsonWithAssetId:(NSString *)assetID andStatus:(void(^)(BOOL successful,AssetDetailModel *detailModel))status failure:(void(^)(NSError *error))failure;
//获取我的-申请详情
-(void)getApplyDetailJsonWithApplyId:(NSString *)applyID andStatus:(void(^)(BOOL successful,AssetMineApplyModel *applyModel))status failure:(void(^)(NSError *error))failure;
//获取我的-归还详情
-(void)getReturnDetailJsonWithReturnId:(NSString *)returnID andStatus:(void(^)(BOOL successful,AssetMineReturnModel *returnModel))status failure:(void(^)(NSError *error))failure;


//获取审核发放List
-(void)getCheckDiliverlJsonWithPageNum:(NSString *)pageNum State:(NSString *)state andStatus:(void(^)(BOOL successful, TYHAssetModel *assetModel))status failure:(void(^)(NSError *error))failure;


//获取首页数据
-(void)getIndexJson:(void(^)(BOOL successful,TYHAssetManagerItemModel *tmpModel))status failure:(void(^)(NSError *error))failure;
//获取首页数值
-(void)getGrantNumJson:(void(^)(BOOL successful,TYHAssetManagerItemModel *tmpModel))status failure:(void(^)(NSError *error))failure;

//http://117.78.48.224:12000/zddc/ao/assetMobile!getNotSignedGrantNumJson.action

//获取申请页面数据
-(void)getApplicationJsonWithOperationCode:(NSString *)code andStatus:(void(^)(BOOL successful,NSMutableArray *assetListArray,NSMutableArray *schoolDatasource,NSMutableArray *departmentDatasource))status failure:(void(^)(NSError *error))failure;
//申请资产提交
-(void)summitApplicationWithReason:(NSString *)aplReason applyDate:(NSString *)aplDate schoolId:(NSString *)aplschoolId departmentId:(NSString *)apldepartmentId demand:(NSString *)apldemand assetKindId:(NSString *)aplassetKindId checkPersonID:(NSString *)checkpersonID andStatus:(void(^)(BOOL successful, NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure;


//查找资产
-(void)searchAssetWithOperationCode:(NSString *)code andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure;

//获取资产查找结果
-(void)getSearchAssetListsJsonnWithLocationID:(NSString *)locationID kitFlag:(NSString *)kitFlag assetKindId:(NSString *)assetKindId purchaseDateEnd:(NSString *)purchaseDateEnd brandId:(NSString *)brandId name:(NSString *)name purchaseDateStart:(NSString *)purchaseDateStart code:(NSString *)code patternId:(NSString *)patternId andStatus:(void(^)(BOOL successful, NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure;


//获取我的发放列表 (collectionCell 第四个)
-(void)getGrantListJson:(void(^)(BOOL successful,NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure;
//获取资产归还详情
-(void)getGrantDetailJsonWithReturnId:(NSString *)returnID andStatus:(void(^)(BOOL successful,AssetMineReturnModel *returnModel))status failure:(void(^)(NSError *error))failure;


//审核资产通过&不通过
-(void)saveAssetCheckWithCheckReason:(NSString *)reason checkRestult:(NSString *)result  checkApplyID:(NSString *)applyIDS andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure;

//发放资产提交
-(void)submitAssetDiliverWithAssetIDs:(NSString *)assetIds ApplicationRecordID:(NSString *)applicationRecordId DepartmentID:(NSString *)departmentId userID:(NSString *)userId LocationID:(NSString *)locationId uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void(^)(BOOL successful,NSMutableArray *datasource))status failure:(void(^)(NSError *error))failure;


//http://117.78.48.224:12000/zddc/ao/assetMobile!saveGrant.action?sys_username=gaoyacun&sys_password=670b14728ad9902aecba32e22fa4f6bd&sys_auto_authenticate=true


//查找界面获取列表
-(void)getAssetPageJsonWithCheckModel:(NSString *)checkModel andStatus:(void(^)(BOOL successful,NSMutableArray *locationsArray))status failure:(void(^)(NSError *error))failure;
//根据查找到的资产列表获取资产列表
-(void)getAssetListJsonWithLocationID:(NSString *)locationID andStatus:(void(^)(BOOL successful,NSMutableArray *locationsArray))status failure:(void(^)(NSError *error))failure;



@end
