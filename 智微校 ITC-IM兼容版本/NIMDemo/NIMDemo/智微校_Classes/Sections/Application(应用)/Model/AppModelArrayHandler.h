//
//  AppModelArrayHandler.h
//  NIM
//
//  Created by 中电和讯 on 17/3/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AppModelArrayHandler : NSObject

@property (nonatomic, strong) NSArray * appIconArray;

@property (nonatomic, strong) NSMutableArray * appArray;

@property (nonatomic, strong) NSMutableArray * appModelArray;


-(NSMutableArray *)getSectionArray;
@end
