//
//  AttendanceModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceModel.h"

@implementation AttendanceModel

@end

@implementation AttendanceListModel

@end

@implementation AttendanceRemarkModel

@end

@implementation AttendanceRemarkCostModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"costID":@"id"};
}
@end
