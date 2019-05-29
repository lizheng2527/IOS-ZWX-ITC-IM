//
//  ClassAttendanceModel.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "ClassAttendanceModel.h"
#import <MJExtension.h>

@implementation ClassAttendanceModel

@end

@implementation CAWeekModel

@end


@implementation CAEvaluateMainModel

@end

@implementation CAEvaluateRecordModel

@end

@implementation CAEvaluateItemModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"defaultNum":@"default",@"itemId":@"id"};
}

@end




