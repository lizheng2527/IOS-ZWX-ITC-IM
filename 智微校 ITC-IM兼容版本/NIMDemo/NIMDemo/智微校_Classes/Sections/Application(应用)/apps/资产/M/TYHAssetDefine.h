//
//  TYHAssetDefine.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#ifndef TYHAssetDefine_h
#define TYHAssetDefine_h

#define getMyAssetListJsonn @"/ao/assetMobile!getMyAssetListJson.action" //我的资产列表
#define AssetInfoJson @"/ao/assetMobile!getAssetInfoJson.action" //资产详情
#define CheckInfoJson @"/ao/assetMobile!getCheckInfoJson.action" //资产申请详情
#define ReturnInfoJson @"/ao/assetMobile!getReturnInfoJson.action" //资产归还详情

//资产发放详情
#define GrantInfoJson @"/ao/assetMobile!getGrantInfoJson.action"

#define CheckListJson @"/ao/assetMobile!getCheckListJson.action" //审核发放list

#define  IndexJson @"/ao/assetMobile!getIndexJson.action" //获取首页数据
#define notSignedGrantNumJson @"/ao/assetMobile!getNotSignedGrantNumJson.action"  //获取首页Num


//#define  ApplicationJson @"/ao/assetMobile!getApplicationJson.action" //获取申请界面数据
#define  ApplicationJson @"/ao/assetMobile!getApplication4IOSJson.action" //获取申请界面数据

#define getSearchAssetListJson @"/ao/assetMobile!getInStockAssetListJson.action" //通过条件查找资产

//#define getSearchAssetListJson @"/ao/assetMobile!getInStockNum4IOSJson.action"

//我的发放列表
#define GrantListJson @"/ao/assetMobile!getGrantListJson.action"

//提交申请单
#define saveApplication @"/ao/assetMobile!saveApplication.action"

//获取查找资产结果
#define saveCheck @"/ao/assetMobile!saveCheck.action"

//发放资产提交
#define saveGrant @"/ao/assetMobile!saveGrant.action"

//查找界面获取列表
#define AssetPageJson @"/ao/assetMobile!getAssetPageJson.action"

//查找界面资产列表Json
#define InStockNumJson @"/ao/assetMobile!getInStockNum4IOSJson.action"




#endif /* TYHAssetDefine_h */
