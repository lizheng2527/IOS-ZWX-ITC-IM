//
//  QCSchoolTagHandle.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSchoolTagHandle.h"

static QCSchoolTagHandle *_instance = nil;

@implementation QCSchoolTagHandle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.currentViewTagOfAnalytic = 1001;
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(NSInteger )getCurrentViewTagOfAnalytic:(NSInteger )tag
{
    self.currentViewTagOfAnalytic = tag;
    return tag;
}

-(NSString *)getCurrentViewTypeOfAnalytic:(NSString *)type
{
    self.currentViewTypeOfAnalytic = type;
    return type;
}


@end
