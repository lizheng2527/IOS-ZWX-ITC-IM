//
//  TYHRepairNetRequestHelper.h
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYHRepairMainModel;
@class MRAFeedBackInfoModel;


@interface TYHRepairNetRequestHelper : NSObject

//获取报修首页Info
-(void)getRepairMainIndexInfo:(void (^)(BOOL successful,NSMutableArray  *repairItemArray,NSString *describitionString))status failure:(void (^)(NSError *error))failure;


//报修申请
//获取维修组列表
-(void)getRepairEquipmentTeamList:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取设备分类列表 - 第一级
-(void)getRepairEquipmentTypeLvOneListWithID:(NSString *)groupID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取设备分类列表 - 第二级
-(void)getRepairEquipmentTypeLvTwoListWithLvOneID:(NSString *)levelOneId andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取设备常见故障列表以及故障地点
-(void)getMalfunctionPlaceListWithGoodsID:(NSString *)goodsID andStatus:(void (^)(BOOL successful,NSMutableArray  *placeSource,NSMutableArray *errorSource))status failure:(void (^)(NSError *error))failure;
//上传维修申请
-(void)submitRepairApplicationWithResultJson:(NSDictionary *)resultDic ImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;


//我的报修
//获取我的报修单列表
-(void)getMyRepairApplicationListWithType:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wjdSource,NSMutableArray *wxzSource,NSMutableArray *dfkSource,NSMutableArray *yxhSource))status failure:(void (^)(NSError *error))failure;
//获取我的报修单详情
-(void)getMyRepairApplicationDetailWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取我的报修单维修记录
-(void)getMyRepairApplicationServerDetailWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//删除报修单
-(void)delRepairApplicationWithRepairID:(NSString *)repairID  andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//提交反馈
-(void)saveMyRepairApplicationFeedbackWithFeedbackDic:(NSMutableDictionary *)dictionary imageArray:(NSMutableArray *)repairImageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//获取提交后的评价列表
-(void)getMyRepairApplicationFeedBackContentListWithReportId:(NSString *)reportID andStatus:(void (^)(BOOL successful,MRAFeedBackInfoModel  *feedBackModel))status failure:(void (^)(NSError *error))failure;

//报修管理
//获取报修管理列表
-(void)getRepairManageMentListWithRequestTpe:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wjdSource,NSMutableArray *wxzSource,NSMutableArray *dfkSource,NSMutableArray *yxhSource))status failure:(void (^)(NSError *error))failure;
//获取可派维修人员列表
-(void)getServerPersonListWithRepairID:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//通过userID获取云信ID
-(void)getYunXinIDWithUserID:(NSString *)v3ID andStatus:(void (^)(BOOL successful,NSString  *yunxinID))status failure:(void (^)(NSError *error))failure;
//派单给相关维修人员
-(void)submitPaiRequestWithRepairID:(NSString *)repairID WorkerID:(NSString *)workerID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;
//费用审批
-(void)submitChargeWithRepairID:(NSString *)repairID YESorNO:(BOOL)handler reasonText:(NSString *)text andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//接单
-(void)acceptOrdersWith:(NSString *)repairID andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

//我的维修
-(void)getMyServerListWithType:(NSString *)type andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource,NSMutableArray *wxzSource,NSMutableArray *yfkSource))status failure:(void (^)(NSError *error))failure;
-(void)submitMyServerFeedBackWithResultJson:(NSDictionary *)resultDic ImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

@end
