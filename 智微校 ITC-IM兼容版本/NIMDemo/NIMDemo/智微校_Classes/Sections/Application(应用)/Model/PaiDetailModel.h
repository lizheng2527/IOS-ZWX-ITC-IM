//
//  PaiDetailModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiDetailModel : NSObject
/*
 "userDate": "2016-04-15",
 "userCount": 699,
 "limitCount": 3,
 "carPicUrl": "/component/attachment!showPic.action?checkUser=false&period=&downloadToken=201604071953480189068062078940326210e537ab7425ada8f8cd2430ccb36f&configCode=carManagePic",
 "carId": "20160407195411220530147588478587",
 "personList": "jjnn",
 "reason": "jjn",
 "orderTime": "2016-04-14 15:18:37",
 "backCount": null,
 "departmentName": "合众学校",
 "backTime": null,
 "driverData"
 "carUserName": "张珊珊",
 "arriveTime": "15:07",
 "address": "ggg",
 "carNum": "B4113",
 "backAddress": null,
 "carName": "阿斯顿.马丁",
 "instruction": "",
 "backDate": null,
 "telephone": "18812345678",
 "noAssignCount": 699,
 "assignCount": 0,
 "backPerson": null
 */
@property (nonatomic, copy) NSString * userDate;
@property (nonatomic, copy) NSString * userCount;
@property (nonatomic, copy) NSString * limitCount;
@property (nonatomic, copy) NSString * carPicUrl;
@property (nonatomic, copy) NSString * carId;
@property (nonatomic, copy) NSString * personList;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * departmentName;
@property (nonatomic, copy) NSString * backTime;
// 数组模型
@property (nonatomic,  strong) NSArray * driverData;

@property (nonatomic, copy) NSString * carUserName;
@property (nonatomic, copy) NSString * arriveTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * carNum;
@property (nonatomic, copy) NSString * instruction;
@property (nonatomic, copy) NSString * backDate;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * noAssignCount;
@property (nonatomic, copy) NSString * assignCount;
@property (nonatomic, copy) NSString * backPerson;
@end
