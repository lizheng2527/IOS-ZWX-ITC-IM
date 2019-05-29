//
//  AttendanceNetHelper.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AttendanceModel;
@class AttendanceRemarkModel;

@interface AttendanceNetHelper : NSObject

//开始考勤上下班
-(void)doAttendanceActionWithAddress:(NSString *)address andFlag:(NSString *)timeFlag status:(void (^)(BOOL ,AttendanceModel *))status failure:(void (^)(NSError *error))failure;

//获取当天考勤记录
-(void)getAttendanceActionListWithStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//获取当天统计
-(void)getAttendanceDateListWithDate:(NSString *)Date andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//补签
-(void)doBuqianActionWithAddress:(NSString *)address note:(NSString *)sayNote andFlag:(NSString *)timeFlag status:(void (^)(BOOL ,AttendanceModel *))status failure:(void (^)(NSError *error))failure;

//外出报销列表
-(void)getCostInfoWithStatus:(void (^)(BOOL successful,AttendanceRemarkModel *remarkModel))status failure:(void (^)(NSError *error))failure;

//保存备注和报销
-(void)saveRemarkItemsWithRemarkText:(NSString *)text CoustType:(NSString *)coustType Coust:(NSString *)coust andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure;

@end
