//
//  TYHRepairDefine.h
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#ifndef TYHRepairDefine_h
#define TYHRepairDefine_h

#pragma mark - Colors
#define TabBarColorRepair colorWithRed:116/255.0 green:139/255.0 blue:216/255.0 alpha:0.8

#define RepairBGColor colorWithRed:234/255.0 green:239/255.0 blue:242/255.0 alpha:1

#define RepairStatisticsColor colorWithRed:241/255.0 green:251/255.0 blue:255/255.0 alpha:1


#pragma mark - URLs
#define url_RepairMainIndex @"/re/repairsRecordMobile!getIndexData.action" //报修首页

//我要报修
//提交报修流程
#define url_RepairEquipmentTeamList @"/re/repairsRecordMobile!getMaintenanceTeamList.action"//获取维修组集合
#define url_RepairEquipmentTypeLvOne @"/re/repairsRecordMobile!getDeviceKindLevelOneList.action" //一级列表
#define url_RepairEquipmentTypeLvTwo @"/re/repairsRecordMobile!getDeviceKindLevelTwoList.action" //二级列表
#define url_MalfunctionPlaceList @"/re/repairsRecordMobile!getMalfunctionPlaceList.action" //设备故障列表
#define url_MyRepairItem @"/re/repairsRecordMobile!getMyDeviceList.action" //获取我的设备列表
#define url_submitRepairApplication @"/re/repairsRecordMobile!submitRepairApply.action" //提交维修申请

//我的报修单
#define url_myRepairApplicationList @"/re/repairsRecordMobile!getRepairRequestListByStatus.action" //获取我的报修单列表
#define url_myRepairApplicationDetail @"/re/repairsRecordMobile!getRepairDetail.action" //我的报修详情
#define url_myRepairApplicationSevice @"/re/repairsRecordMobile!getRepairRecord.action" //我的报修的维修记录
#define url_myRepairApplicationFeedBack @"/re/repairsRecordMobile!getFeedbackContentList.action"//获取反馈项
#define url_myRepairApplicationFeedBackContentList @"/re/repairsRecordMobile!getFeedbackContentList.action" //获取提交的反馈分数
#define url_submitMyApplicationFeedBack @"/re/repairsRecordMobile!saveFeedBack.action" //提交反馈


//报修管理
#define url_RepairManegementMainList @"/re/repairsRecordMobile!getManageRepairListByStatus.action"//保修管理首页list
#define url_DelRepairApplication @"/re/repairsRecordMobile!repairRecordDelete.action" //删除报修单
#define url_getPaiPersonList @"/re/repairsRecordMobile!getCanDoWorkerList.action" //获取可派人员列表
#define url_getYunXinID @"/bd/user/getAccIdByV3Id" //获取云信ID
#define url_submitPaiWorker @"/re/repairsRecordMobile!saveSendRequest.action" //提交派单
#define url_submitChargeHandler @"/re/repairsRecordMobile!saveCostCheck.action" //提交费用审批
#define url_receiveRequest @"/re/repairsRecordMobile!receiveRequest.action" //接单


//我的维修
#define url_MySeverList @"/re/repairsRecordMobile!getMyRepairListByStatus.action" //获取我的维修单列表
#define url_submitMySeverFeedBack @"/re/repairsRecordMobile!saveWokerFeedBack.action" //提交我的维修反馈

#endif /* TYHRepairDefine_h */
