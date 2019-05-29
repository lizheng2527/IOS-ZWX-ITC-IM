//
//  AssetModelHandler.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHMainPageModel;


@interface AssetModelHandler : NSObject

+ (instancetype)sharedInstance; //创建单例

//根据权限返回Item个数
+(NSMutableArray *)getAssetManagerItemArrayWithUserKind:(NSInteger)kind;

+(NSMutableArray *)getWareHouseItemArrayWithUserKind:(NSInteger)kind;

+(NSMutableArray *)getWareHouseItemArrayWithWHMainPageModel:(WHMainPageModel *)model;

@property(nonatomic,retain)NSMutableArray *assetAddArray;
@end
