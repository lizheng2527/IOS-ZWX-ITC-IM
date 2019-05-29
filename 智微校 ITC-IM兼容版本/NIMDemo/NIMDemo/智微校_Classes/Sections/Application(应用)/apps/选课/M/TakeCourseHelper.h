//
//  TakeCourseHelper.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class BeginTakeCourseModel;
@class EcRuleModel;
@class TakeCourseModel;

@interface TakeCourseHelper : NSObject
//进行学生选课
-(void)getChooseCourseWithEcID:(NSString *)ecid and:(void(^)(BOOL successful,TakeCourseModel *takeModel))status failure:(void(^)(NSError *error))failure;

//提交学生选课
-(void)saveEcCourseWithCourseIDs:(NSString *)courseIDs ecActivityIDs:(NSString *)ecActivityIDs and:(void(^)(BOOL successful,NSMutableArray *dataSource))status failure:(void(^)(NSError *error))failure;

//获取选课说明
-(void)getCourseNote:(void (^)(BOOL ,BeginTakeCourseModel *))status failure:(void (^)(NSError *error))failure;
//我的选课
-(void)getMineCourse:(void (^)(BOOL successful,NSMutableArray *mineCourseDatasource))status failure:(void (^)(NSError *error))failure;

@end
