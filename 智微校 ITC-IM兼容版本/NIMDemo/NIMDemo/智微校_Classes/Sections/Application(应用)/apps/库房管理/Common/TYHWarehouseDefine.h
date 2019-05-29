//
//  TYHWarehouseDefine.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/14.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#ifndef TYHWarehouseDefine_h
#define TYHWarehouseDefine_h



#pragma mark - Colors
#define TabBarColorWarehouse colorWithRed:43/255.0 green:100/255.0 blue:150/255.0 alpha:0.8

#define WarehouseBGColor colorWithRed:234/255.0 green:239/255.0 blue:242/255.0 alpha:1

#define WarehouseStatisticsColor colorWithRed:241/255.0 green:251/255.0 blue:255/255.0 alpha:1

#pragma mark - URLDefines
#define url_GetMainPageNum @"/sr/storeroom!getUserOperation.action" //获取首页数字信息

#define url_ApplyRecordInfo @"/sr/storeroom!getNewApplyRecordInfo.action" //开始申领物品
#define url_MyApplicationList @"/sr/applyReceiveRecord!listData.action" //申领列表
#define url_MyApplicationDetail @"/sr/storeroom!getApplyRecordView.action" // 申领详情
#define url_OutList @"/sr/applyReceiveList!listData.action" //出库列表

#define url_GoodsStastics @"/sr/storeroom!getGoodsStatistics.action" //物品统计
#define url_GoodsCountDetail @"/sr/storeroom!getGoodsStock.action"//库存详情
#define url_GoodsInHouseDetail @"/sr/storeroom!getGoodsIntoWarehouseDetal.action" //入库详情
#define url_GoodsOutHouseDetail @"/sr/storeroom!getGoodsOutWarehouseDetal.action" //出库详情

#define url_ApplicationCheckBM @"/sr/applyReceiveRecord!auditListData.action" //申领审核-部门
#define url_ApplicationCheckZW @"/sr/applyReceiveRecord!auditZWListData.action" //申领审核-总务

#define url_goodsKindList @"/sr/storeroom!getGoodsKindJson.action" //物品分类
#define url_goodsDetailInfoList @"/sr/storeroom!getGoodsInfoPage.action" //物品详情

#define url_applyDiliverMainInfo @"/sr/storeroom!getApplyRecordView.action" //申领发放-主
#define url_applyDiliverItemInfoList @"/sr/storeroom!getProvideGoodsDetal.action" //申领发放-物品清单

#define url_applyDepartmentList @"/sr/storeroom!getDepartmentTreeIOS.action" //选择部门列表

#define url_SubmitApply @"/sr/storeroom!saveApplyReceiveRecord.action" //提交申请
#define url_ApplicationCheckSubmit @"/sr/storeroom!saveCheckApplyReceiveRecord.action" //提交申领审核
#define url_ApplicationDiliverSubmit @"/sr/storeroom!saveProvideGoods.action" //申请发放提交


//易耗品管理补充接口
#define url_getOutWarehouseList @"/sr/storeroom!getOutWarehouseList.action" //获取出库单列表
#define url_getReSignDetail @"/sr/storeroom!getReSignDetail.action"  //获取补签详情
#define url_saveReSign @"/sr/storeroom!saveReSign.action" //提交补签
#define url_getOutListDetail @"/sr/storeroom!OutWareDetail.action" //获取出库单列表详情
#define url_searchByUserName @"/sr/storeroom!searchGetOutByUserName.action" //按申领人姓名搜索出库单
#endif /* TYHWarehouseDefine_h */
