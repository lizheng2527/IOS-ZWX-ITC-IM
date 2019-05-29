//
//  AppModelArrayHandler.m
//  NIM
//
//  Created by 中电和讯 on 17/3/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "AppModelArrayHandler.h"
#import "AppModel.h"
#import <MJExtension.h>
#import "NSString+NTES.h"

@implementation AppModelArrayHandler
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.appModelArray = [NSMutableArray array];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"appSource.plist" ofType:nil];
        self.appIconArray = [NSArray arrayWithContentsOfFile:path];
        [self getAppSettingOfServer];
        
        self.appModelArray = [AppModel mj_objectArrayWithKeyValuesArray:self.appArray];
        
        //        AppModel *modelGongWu = [AppModel new];
        //        modelGongWu.name = @"易耗品管理";
        //        modelGongWu.imageStr = @"低值易耗品";
        //        modelGongWu.type = @"校务办公";
        //        [self.appModelArray addObject:modelGongWu];
        //
        //        AppModel *modelRepair = [AppModel new];
        //        modelRepair.name = @"报修";
        //        modelRepair.imageStr = @"报修";
        //        modelRepair.type = @"校务办公";
        //        [self.appModelArray addObject:modelRepair];
    }
    return self;
}



#pragma mark - getSectionArray
-(NSMutableArray *)getSectionArray
{
    NSMutableArray *appModelArray = [NSMutableArray arrayWithArray:_appModelArray];
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    {
        AppMainModel *mainModel = [AppMainModel new];
        mainModel.sectionModelArray = [NSMutableArray array];
        for (AppModel *appModel in appModelArray) {
            if ([appModel.type isEqualToString:@"校务办公"]) {
                mainModel.sectionName = @"校务办公";
                [mainModel.sectionModelArray addObject:appModel];
            }
        }
        if (mainModel.sectionModelArray.count) {
            [sectionArray addObject:mainModel];
        }
    }
    
    {
        AppMainModel *mainModel = [AppMainModel new];
        mainModel.sectionModelArray = [NSMutableArray array];
        
        for (AppModel *appModel in appModelArray) {
            if ([appModel.type isEqualToString:@"教务教学"]) {
                mainModel.sectionName = @"教务教学";
                [mainModel.sectionModelArray addObject:appModel];
            }
        }
        if (mainModel.sectionModelArray.count) {
            [sectionArray addObject:mainModel];
        }
    }
    
    {
        AppMainModel *mainModel = [AppMainModel new];
        mainModel.sectionModelArray = [NSMutableArray array];
        
        for (AppModel *appModel in appModelArray) {
            if ([appModel.type isEqualToString:@"德育管理"]) {
                mainModel.sectionName = @"德育管理";
                [mainModel.sectionModelArray addObject:appModel];
            }
        }
        if (mainModel.sectionModelArray.count) {
            [sectionArray addObject:mainModel];
        }
    }
    
    {
        AppMainModel *mainModel = [AppMainModel new];
        mainModel.sectionModelArray = [NSMutableArray array];
        for (AppModel *appModel in appModelArray) {
            if ([appModel.type isEqualToString:@"其它应用"]) {
                mainModel.sectionName = @"其它应用";
                [mainModel.sectionModelArray addObject:appModel];
            }
        }
        if (mainModel.sectionModelArray.count) {
            [sectionArray addObject:mainModel];
        }
    }
    
    return sectionArray;
}




#pragma mark - 逻辑处理
-(void)getAppSettingOfServer
{
    NSString * appCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFARLT_APPCODE];
    NSArray *array = [appCode componentsSeparatedByString:@","];
    
    self.appArray = [[NSMutableArray alloc] init];
    
    array = [NSMutableArray arrayWithArray:array];
    
    for (NSString * str2 in array) {
        [self.appIconArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * str = dict[@"code"];
            if ([str isEqualToString:str2]) {
                [self.appArray addObject:dict];
            }
        }];
    }
}


@end
