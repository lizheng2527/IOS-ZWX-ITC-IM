//
//  DriverDataModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/18/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverDataModel : NSObject
/*
 "phone": "15844089162",
 "driverId": "20151224175430461983512574868864",
 "driverName": "姚思迈"
 */
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * driverId;
@property (nonatomic, copy) NSString * driverName;

@end
