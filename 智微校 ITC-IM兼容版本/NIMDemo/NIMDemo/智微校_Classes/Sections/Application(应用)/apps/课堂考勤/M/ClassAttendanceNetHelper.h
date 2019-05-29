//
//  ClassAttendanceNetHelper.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CAEvaluateMainModel;


@interface ClassAttendanceNetHelper : NSObject


//获取所有的教学周
-(void)getAllClassWeeksWithJson:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//按教学周获取教师课表
-(void)getTeacherTimeTableURLWithWeek:(NSString *)weekNum andResult:(void (^)(BOOL successful,NSString *requestURL))status;


//获取学生打分项
-(void)getEvaluationItemAndRecordWithAttendanceId:(NSString *)attendanceId studentId:(NSString *)studentId andResult:(void (^)(BOOL successful,CAEvaluateMainModel *dataModel))status;

//删除打分项
-(void)delEvaluationItemAndRecordWithItemId:(NSString *)EvaluationItemID  andResult:(void (^)(BOOL successful))status;

//提交打分项
-(void)submitEvaluationItemAndRecordSumDic:(NSDictionary *)sumDic  andResult:(void (^)(BOOL successful))status;

@end
