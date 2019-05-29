//
//  TakeCourseModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseModel.h"

@implementation TakeCourseModel


@end



@implementation ecElectiveGroupListModel

@end


@implementation EcActivityCourseListModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ecActivityID":@"id"};
}
@end

@implementation ecActivityModel

@end


@implementation BeginTakeCourseModel

@end


@implementation SchoolTermInfoListModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"schoolTermID":@"id"};
}
@end

@implementation schoolTermStudentCourseModel

@end


@implementation EcRuleModel

@end


@implementation EcRuleCourseListModel

@end

@implementation courseModel  //ruleList里的courseModel

@end

