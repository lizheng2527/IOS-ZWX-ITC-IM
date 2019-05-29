//
//  TakeCourseModelHandler.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/30.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TakeCourseModel;

@interface TakeCourseModelHandler : NSObject
//每次选中cell,都需要过滤一下规则
+(TakeCourseModel *)returnTakeCourseModelWithDeal:(TakeCourseModel *)model;

//处理规则model,变成一句话
+(NSString *)dealRuleStringWithTakeCourseModel:(TakeCourseModel *)model;

//判定某个规则的最小选中
+(NSString *)haveSelectedLowestCourse:(TakeCourseModel *)model;

@end
