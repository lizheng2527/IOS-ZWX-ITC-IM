//
//  AssetModelHandler.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetModelHandler.h"
#import "TYHAssetModel.h"
#import "WHApplicationModel.h"
#import <MJExtension.h>

static id _instance;

@implementation AssetModelHandler
//单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


#pragma mark - 根据权限返回Item个数
+(NSMutableArray *)getAssetManagerItemArrayWithUserKind:(NSInteger)kind
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    //    NSArray *dicArray = [NSArray arrayWithObjects:@{@"name":@"我的",@"num":@"0",@"imageName":@"icon_我的"},@{@"name":@"待审核",@"num":@"3",@"imageName":@"icon_审核"},@{@"name":@"待发放",@"num":@"2",@"imageName":@"icon_发放"},nil];
    NSArray *dicArray = [NSArray arrayWithObjects:@{@"name":@"我的",@"num":@"0",@"imageName":@"icon_as_me"},@{@"name":@"待审核",@"num":@"0",@"imageName":@"icon_cm_wsh_b"},@{@"name":@"待发放",@"num":@"0",@"imageName":@"icon_cm_wpc_b"},@{@"name":@"已发放",@"num":@"0",@"imageName":@"icon_cm_ypc_a"},nil];
    for (NSDictionary *dic in dicArray) {
        TYHAssetManagerItemModel *model = [TYHAssetManagerItemModel new];
        model.itemName = [dic objectForKey:@"name"];
        model.itemNum = [dic objectForKey:@"num"];
        model.itemImage = [dic objectForKey:@"imageName"];
        [tmpArray addObject:model];
    }
    
    // kind:0 管理员
    if (kind == 0) {
        
    }
    else
    {
        for (int i = 0; i <= 2; i++) {
            [tmpArray removeLastObject];
        }
    }
    return tmpArray;
}

+(NSMutableArray *)getWareHouseItemArrayWithUserKind:(NSInteger)kind
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSArray *dicArray = [NSArray arrayWithObjects:@{@"name":@"我的",@"num":@"0",@"imageName":@"icon_as_me"},@{@"name":@"待审核",@"num":@"0",@"imageName":@"icon_cm_wsh_b"},@{@"name":@"出库",@"num":@"0",@"imageName":@"icon_cm_wpc_b"},@{@"name":@"统计",@"num":@"0",@"imageName":@"icon_cm_ypc_a"},nil];
    for (NSDictionary *dic in dicArray) {
        TYHAssetManagerItemModel *model = [TYHAssetManagerItemModel new];
        model.itemName = [dic objectForKey:@"name"];
        model.itemNum = [dic objectForKey:@"num"];
        model.itemImage = [dic objectForKey:@"imageName"];
        [tmpArray addObject:model];
    }
    
    // kind:0 管理员
    if (kind == 0) {
        
    }
    else
    {
        for (int i = 0; i <= 2; i++) {
            [tmpArray removeLastObject];
        }
    }
    return tmpArray;
}

+(NSMutableArray *)getWareHouseItemArrayWithWHMainPageModel:(WHMainPageModel *)model
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    /**
     * zwslsh : 1    总务的审核权限   1有 0无
     * zwCount : 8     总务待审核数量
     * sr_statistics : 1    查看统计权限
     * sr_warehouseManage : 1    发放物品权限  出库
     * deptslsh : 1  部门审核权限
     * deptCount : 4    部门待审核数量
     */
    
    [tmpArray addObject:@{@"itemName":@"我的",@"itemNum":model.myCount.length?model.myCount:@"0",@"itemImage":@"icon_as_me"}];
    
    if ([model.zwslsh integerValue] || [model.deptslsh integerValue]) {
        NSInteger num = [model.zwCount integerValue] + [model.deptCount integerValue];
        NSString *numString = [NSString stringWithFormat:@"%ld",(long)num];
        [tmpArray addObject:@{@"itemName":@"待审核",@"itemNum":numString,@"itemImage":@"icon_cm_wsh_b"}];
    }
    if ([model.sr_warehouseManage integerValue]) {
        [tmpArray addObject:@{@"itemName":@"发放",@"itemNum":model.provideCount,@"itemImage":@"icon_sm_fafang"}];
        
        [tmpArray addObject:@{@"itemName":@"出库",@"itemNum":model.outWareCount,@"itemImage":@"icon_sm_chuku"}];
        
    }
    if ([model.sr_statistics integerValue]) {
        [tmpArray addObject:@{@"itemName":@"统计",@"itemNum":@"0",@"itemImage":@"icon_sm_tongji"}];
    }
    
    tmpArray = [TYHAssetManagerItemModel mj_objectArrayWithKeyValuesArray:tmpArray];
    return tmpArray;
    
}


@end
