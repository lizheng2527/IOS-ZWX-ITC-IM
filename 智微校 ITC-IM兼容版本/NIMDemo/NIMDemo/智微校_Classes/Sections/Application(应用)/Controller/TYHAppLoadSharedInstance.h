//
//  TYHAppLoadSharedInstance.h
//  NIM
//
//  Created by 中电和讯 on 2017/6/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHAppLoadSharedInstance : NSObject

+ (instancetype)sharedInstance;


-(BOOL)appWebViewLoadSuccessful:(BOOL)successful;


@property(nonatomic,assign)BOOL appViewLoadSuccessful;
@end
