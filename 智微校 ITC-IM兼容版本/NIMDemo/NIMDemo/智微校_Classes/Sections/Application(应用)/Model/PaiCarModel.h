//
//  PaiCarModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/14/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiCarModel : NSObject <NSCoding>
/*
 "userDate": "2016-04-15",
 "userCount": 699,
 "personList": "jjnn",
 "reason": "jjn",
 "orderTime": "2016-04-14 15:18:37",
 "backCount": null,
 "departmentName": "合众学校",
 "backTime": null,
 "carUserName": "张珊珊",
 "arriveTime": "15:07",
 "address": "ggg",
 "backAddress": null,
 
 "instruction": "",
 "backDate": null,
 "telephone": "18812345678",
 "noAssignCount": 699,
 "assignCount": 0,
 "backPerson": null
 */

@property (nonatomic, copy) NSString * noAssignCount;
@property (nonatomic, copy) NSString * assignCount;
@property (nonatomic, copy) NSString * userCount;

// 模型数组
@property (strong, nonatomic) NSArray *schoolsData;

@property (nonatomic, copy) NSString * userDate;
@property (nonatomic, copy) NSString * personList;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * backCount;
@property (nonatomic, copy) NSString * departmentName;
@property (nonatomic, copy) NSString * backTime;
@property (nonatomic, copy) NSString * carUserName;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * backAddress;
@property (nonatomic, copy) NSString * instruction;
@property (nonatomic, copy) NSString * backDate;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * backPerson;



@end
