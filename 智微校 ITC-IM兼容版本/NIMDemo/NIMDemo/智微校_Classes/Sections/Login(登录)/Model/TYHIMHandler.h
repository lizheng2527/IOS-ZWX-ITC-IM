//
//  TYHIMHandler.h
//  NIM
//
//  Created by 中电和讯 on 2019/2/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHIMHandler : NSObject

+ (instancetype)sharedInstance;


-(BOOL)IMShouldEnabled:(BOOL)isEnable;


@property(nonatomic,assign)BOOL IMShouldEnabled;


@end


