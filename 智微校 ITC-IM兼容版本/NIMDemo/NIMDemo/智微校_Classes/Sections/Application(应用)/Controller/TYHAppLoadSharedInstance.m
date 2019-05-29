//
//  TYHAppLoadSharedInstance.m
//  NIM
//
//  Created by 中电和讯 on 2017/6/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHAppLoadSharedInstance.h"

static TYHAppLoadSharedInstance *_instance = nil;


@implementation TYHAppLoadSharedInstance

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.appViewLoadSuccessful = NO;
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


-(BOOL)appWebViewLoadSuccessful:(BOOL)successful
{
    self.appViewLoadSuccessful = successful;
    return successful;
}

@end
