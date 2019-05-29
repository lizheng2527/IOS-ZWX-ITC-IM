//
//  TYHAssetModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -------TYHAssetModel
@interface TYHAssetModel : NSObject

@property(nonatomic,retain)NSMutableArray *assetAllArray;
@property(nonatomic,retain)NSMutableArray *assetUnPassArray;
@property(nonatomic,retain)NSMutableArray *assetCheckArray;
@property(nonatomic,retain)NSMutableArray *assetPassArray;
@property(nonatomic,retain)NSMutableArray *assetDiliverArray;

@end

@interface TYHAssetManagerItemModel : NSObject
@property(nonatomic,copy)NSString *itemName;
@property(nonatomic,copy)NSString *itemImage;
@property(nonatomic,copy)NSString *itemNum;

@property(nonatomic,copy)NSString *check;
@property(nonatomic,copy)NSString *grant;
@property(nonatomic,copy)NSString *num;

@end
#pragma mark ------- 我的资产Models
@interface AssetMineModel : NSObject
//我的资产-所有列表数组
@property(nonatomic,retain)NSMutableArray *myAssetListArray;
//我的资产-已归还列表数组
@property(nonatomic,retain)NSMutableArray *returnAssetsArray;
//我的资产-申请列表数组
@property(nonatomic,retain)NSMutableArray *applicationRecordsArray;
@end
//我的资产-全部
@interface AssetMineDetailModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger originalPrice;
@property (nonatomic, copy) NSString *purchaseFactory;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *assetKindId;
@property (nonatomic, copy) NSString *assetKindName;
@property (nonatomic, assign) NSInteger warrantyPeriod;
@property (nonatomic, copy) NSString *registrationDate;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *patternId;
@property (nonatomic, copy) NSString *increaseWay;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *purchaseDate;
@property (nonatomic, assign) NSInteger unitPrice;
@property (nonatomic, copy) NSString *statusView;
@property (nonatomic, copy) NSString *stockNumber;
@property (nonatomic, copy) NSString *patternName;
@end
//我的资产-申请
@interface AssetMineApplyModel : NSObject
@property (nonatomic, copy) NSString *assetKindName;
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *applyUserName;
@property (nonatomic, copy) NSString *checkDate;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *checkStatus;
@property (nonatomic, copy) NSString *applyUserId;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *checkReason;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *demand;
@property (nonatomic, copy) NSString *assetKindId;
@property (nonatomic, copy) NSString *checkStatusView;
@property (nonatomic, copy) NSString *departmentName;

@end

//我的资产-归还
@interface AssetMineReturnModel : NSObject
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *operateDate;
@property (nonatomic, copy) NSString *departmentParentId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *signatureShow;
@property (nonatomic, copy) NSString *departmentParentName;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, assign) BOOL signatureFlag;
@property (nonatomic, copy) NSString *departmentName;
@property(nonatomic,retain)NSMutableArray *returnAssetsArray;//归还列表详情需要,里面放 AssetDetailModel资产卡片详情

@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *operator;
@property(nonatomic,copy)NSString *department;

@end

#pragma mark ------- 资产卡片详情
//资产卡片详情Model
@interface AssetDetailModel : NSObject
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *purchaseFactory;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *assetKindId;
@property (nonatomic, assign) NSInteger originalPrice;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *useStartDate;
@property (nonatomic, copy) NSString *assetKindName;
@property (nonatomic, copy) NSString *custodyStartDate;
@property (nonatomic, copy) NSString *registrationDate;
@property (nonatomic, assign) NSInteger warrantyPeriod;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *patternId;
@property (nonatomic, copy) NSString *increaseWay;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *kindParentIName;
@property (nonatomic, copy) NSString *departmentParentName;
@property (nonatomic, copy) NSString *purchaseDate;
@property (nonatomic, copy) NSString *custodian;
@property (nonatomic, assign) NSInteger unitPrice;
@property (nonatomic, copy) NSString *kindParentId;
@property (nonatomic, copy) NSString *statusView;
@property (nonatomic, copy) NSString *stockNumber;
@property (nonatomic, copy) NSString *patternName;
@property (nonatomic, copy) NSString *departmentParentId;
@property (nonatomic, copy) NSString *imageURL;
@end

#pragma mark ------- 审核发放List Model
//审核发放的List的model
@interface AssetCheckDiliverModel : NSObject
@property (nonatomic, copy) NSString *assetKindName;
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *applyUserName;
@property (nonatomic, copy) NSString *checkDate;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *checkStatus;
@property (nonatomic, copy) NSString *applyUserId;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *checkReason;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *demand;
@property (nonatomic, copy) NSString *assetKindId;
@property (nonatomic, copy) NSString *checkStatusView;
@property (nonatomic, copy) NSString *departmentName;
@property(nonatomic,copy)NSString *departmentParentId;
@property(nonatomic,copy)NSString *departmentParentName;
@property(nonatomic,copy)NSString *kindParentId;
@property(nonatomic,copy)NSString *kindParentIName;
@end



#pragma mark -申请Model
//
@interface AssetApplySchoolModel : NSObject
@property(nonatomic,retain)NSMutableArray *tmpArray;
@property(nonatomic,retain)NSMutableArray *auditorsArray;
@property(nonatomic,copy)NSString *schoolName;
@property(nonatomic,copy)NSString *schoolID;

@property(nonatomic,retain)NSMutableArray *tmpClassArray;
@property(nonatomic,retain)NSMutableArray *classesArray;
@end

@interface AssetApplySchoolsAuditorModel : NSObject
@property(nonatomic,copy)NSString *auditorID;
@property(nonatomic,copy)NSString *auditorName;
@end

@interface AssetApplyUserDepartmentsModel : NSObject
@property(nonatomic,copy)NSString *userDepartmentsID;
@property(nonatomic,copy)NSString *userDepartmentsName;
@end

#pragma mark -资产列表页上层Model
@interface AssetListModel : NSObject
@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSMutableArray *userList;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@property(nonatomic,strong) NSMutableArray *childs;

@property(nonatomic,strong)NSString *quantity;

@property(nonatomic,retain)NSMutableArray *assetBrandsArray;

@end
#pragma mark -资产列表页最里层Model
@interface AssetListDetailsModel : NSObject
@property(nonatomic,copy)NSString *assetID;
@property(nonatomic,copy)NSString *assetName;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@end

#pragma mark -资产查找界面的Model
@interface AssetListBrandModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *quantity;
@property (nonatomic,retain) NSMutableArray *assetPatterns;
@property(nonatomic,copy)NSString *brandID;
@property(nonatomic,retain)NSMutableArray *pattersArray;


@end

@interface AssetListPatternsModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *quantity;
@property(nonatomic,copy)NSString *PatternsID;
@end



