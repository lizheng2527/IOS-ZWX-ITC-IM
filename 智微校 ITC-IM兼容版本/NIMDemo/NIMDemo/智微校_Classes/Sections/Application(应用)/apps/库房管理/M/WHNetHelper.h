//
//  WHNetHelper.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/6.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHApplicationModel;
@class WHMyApplicationDetailModel;
@class WHMainPageModel;
@class WHOutResignModel;
@class WHOutModel;


@interface WHNetHelper : NSObject

// 易耗品管理主页信息
-(void)getMainPageInfo:(void (^)(BOOL successful, WHMainPageModel *mainModel))status failure:(void (^)(NSError *error))failure;

/**
 获取申请列表信息
 */
-(void)getApplicationInfo:(void (^)(BOOL successful,WHApplicationModel *model))status failure:(void (^)(NSError *error))failure;

//提交申请
-(void)submitApplicationWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取我的申领列表
-(void)getMyApplicationList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取申领详情
-(void)getMyApplicationDetailWithApplyID:(NSString *)applyId andStatus:(void (^)(BOOL successful,WHMyApplicationDetailModel *model))status failure:(void (^)(NSError *error))failure;

//获取申领列表
-(void)getApplicationList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取出库列表
-(void)getOutListWithPageNum:(NSString *)num andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取出库列表详情
-(void)getOutListDetailWithOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,WHOutModel *model))status failure:(void (^)(NSError *error))failure;
//按申领人姓名搜索出库单
-(void)searchGetOutByUserName:(NSString *)username andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取补签详情
-(void)getResignDetailWithOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,WHOutResignModel *model))status failure:(void (^)(NSError *error))failure;
//提交补签
-(void)saveResignImageWitjOutID:(NSString *)outID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取物品统计列表
-(void)getGoodsStasticsList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取物品统计出库入库详情列表
-(void)getGoodsStasticsInOutHouseListWithgoodsID:(NSString *)goodsID RequestType:(NSString *)requestType andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//获取物品统计库存详情列表
-(void)getGoodsStasticsStockListWithgoodsID:(NSString *)goodsID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//申领审核-部门
-(void)getApplicationCheckBMList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//申领审核-总务
-(void)getApplicationCheckZWList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
//提交申领审核
-(void)ApplicationCheckWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取物品分类
//-(void)getGoodsKindList:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;
-(void)getGoodsKindListWithOutWarehouseID:(NSString *)outwarehouseID and:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取物品分类的详情
-(void)getGoodsDetailListWithGoodsID:(NSString *)goodsId andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

//获取申领发放信息
-(void)getApplyDiliverMainInfoWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful,WHMyApplicationDetailModel *model))status failure:(void (^)(NSError *error))failure;
//获取申领发放的申请物品清单
-(void)getApplyDiliverGoodsListWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful,NSMutableArray *dataSourceUseKind,NSMutableArray *dataSourceChecker,NSMutableArray *wareHouseListArray))status failure:(void (^)(NSError *error))failure;

//获取申领发放的部门列表
-(void)getApplyDepartmentListWithApplyID:(NSString *)applyID andStatus:(void (^)(BOOL successful, NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;


//申请发放提交
-(void)submitApplicationDiliverWithResultJson:(NSDictionary *)resultDic andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure;

@end
