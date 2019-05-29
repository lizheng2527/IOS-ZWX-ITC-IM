//
//  RecordNetHelper.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordNetHelper : NSObject

//获取我的工作日志列表
-(void)getMyRecordListWithDate:(NSString *)Date andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;


//提交工作日志
-(void)saveWorkLogWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure;

@end
