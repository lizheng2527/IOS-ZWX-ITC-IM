//
//  TranscriptHelper.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranscriptModel.h"

@interface TranscriptHelper : NSObject
//获取所有的学期
-(void)getAllSchoolTermJson:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;
//获取考试列表
-(void)getExamListWithSchoolTermId:(NSString *)terminalID Status:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;
//获取学生的成绩
-(void)getgetStudentScoreWithExamID:(NSString *)examID Status:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;
@end
