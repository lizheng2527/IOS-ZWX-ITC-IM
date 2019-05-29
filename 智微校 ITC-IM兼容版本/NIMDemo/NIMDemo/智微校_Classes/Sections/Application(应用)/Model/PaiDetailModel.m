//
//  PaiDetailModel.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "PaiDetailModel.h"
#import <MJExtension.h>

@implementation PaiDetailModel


+ (NSDictionary *)objectClassInArray {
    
    // 这个 schoolData 数组对应的就是 SchoolDataModel模型
    return @{
             
             @"driverData":@"DriverDataModel"
             
             };
}
@end
