//
//  HWNetWorkHandler.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWNetWorkHandler : NSObject
//获取作业列表
- (void)getHomeWorkListWithPage:(NSInteger )page CourseID:(NSString *)courseID andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;
//获取课程列表
-(void)getCourseListWithStudentID:(NSString *)studentID Status:(void (^)(BOOL,NSMutableArray *))status failure:(void(^)(NSError *))failure;

//获取课程详情
-(void)getCourseDetailWithHomeworkID:(NSString *)homeWorkID Status:(void (^)(BOOL,NSMutableArray *))status failure:(void(^)(NSError *))failure;

-(void)uploadHomeworkandContentWith:(NSString *)content tadID:(NSString *)tagId uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;


@end
