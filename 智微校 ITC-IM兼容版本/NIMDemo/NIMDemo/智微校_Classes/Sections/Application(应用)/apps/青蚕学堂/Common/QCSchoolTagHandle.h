//
//  QCSchoolTagHandle.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSchoolTagHandle : NSObject

+ (instancetype)sharedInstance;


-(NSInteger )getCurrentViewTagOfAnalytic:(NSInteger )tag;

@property(nonatomic,assign)NSInteger currentViewTagOfAnalytic;


-(NSString *)getCurrentViewTypeOfAnalytic:(NSString *)type;

@property(nonatomic,copy)NSString *currentViewTypeOfAnalytic;


@end
