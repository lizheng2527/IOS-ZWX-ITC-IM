//
//  TYHAssetModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHAssetModel.h"

@implementation TYHAssetModel

@end

@implementation TYHAssetManagerItemModel

@end

@implementation AssetMineModel

@end
#pragma mark -非申请或查找Model
@implementation AssetMineDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetId":@"id"};
}
@end

@implementation AssetMineApplyModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetId":@"id"};
}
@end

@implementation AssetMineReturnModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetId":@"id"};
}
@end

@implementation AssetDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetId":@"id"};
}
@end

@implementation AssetCheckDiliverModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetId":@"id"};
}
@end



//------------------------------------------------------------------------
#pragma mark -申请Model
@implementation AssetApplySchoolModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"schoolID":@"id",@"schoolName":@"name",@"tmpArray":@"auditors",@"tmpClassArray":@"classrooms"};
}
@end

@implementation AssetApplySchoolsAuditorModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"auditorID":@"id",@"auditorName":@"name"};
}

@end

@implementation AssetApplyUserDepartmentsModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"userDepartmentsID":@"id",@"userDepartmentsName":@"name"};
}
@end


#pragma mark -资产列表页上层Model
@implementation AssetListModel
//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{@"listCount":@"count"};
//}
@end
#pragma mark -资产列表页最里层Model
@implementation AssetListDetailsModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"assetID":@"id",@"assetName":@"name"};
}
@end


#pragma mark -资产查找界面的Model
@implementation AssetListBrandModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"brandID":@"id"};
}
@end

@implementation AssetListPatternsModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"PatternsID":@"id"};
}
@end

