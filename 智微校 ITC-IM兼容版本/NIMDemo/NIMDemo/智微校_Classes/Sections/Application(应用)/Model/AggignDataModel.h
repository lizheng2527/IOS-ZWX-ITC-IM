//
//  AggignDataModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AggignDataModel : NSObject
/*
 "phone": "15844089162",
 "count": 3,
 "leaveTime": "15:32",
 "driver": "姚思迈"
 */

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *leaveTime;
@property (nonatomic, copy) NSString *driver;

@end
