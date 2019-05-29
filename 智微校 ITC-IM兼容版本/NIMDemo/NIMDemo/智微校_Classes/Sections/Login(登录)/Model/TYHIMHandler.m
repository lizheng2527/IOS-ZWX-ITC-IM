//
//  TYHIMHandler.m
//  NIM
//
//  Created by 中电和讯 on 2019/2/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "TYHIMHandler.h"

static TYHIMHandler *_instance = nil;


@implementation TYHIMHandler

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.IMShouldEnabled = NO;
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

-(BOOL)IMShouldEnabled:(BOOL)isEnable
{
    self.IMShouldEnabled = isEnable;
    
    [[NSUserDefaults standardUserDefaults]setBool:isEnable forKey:USER_DEFARLT_AutoLogin];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return isEnable;
}

@end
