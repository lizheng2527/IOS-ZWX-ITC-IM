//
//  CarStatusModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarStatusModel : NSObject
/*
 
 // 管理员
 "userDate": "2016-03-23",
 "checkStatusView": "未派车",
 "carUserName": "庄严",
 "evaluateFlag": "0",
 "checkStatus": "1",
 "reason": "",
 "address": "?????????¨?????????±?",
 "arriveTime": "14:00",
 "orderCarId": "20160322150904142555740353396000",
 "orderTime": "2016-03-23 17:48:15",
 "telephone": "13853656565",
 "departmentName": "校领导"
 
 // 普通用户
 "userDate": "2016-04-19",
 "checkStatusView": "未派车",
 "carUserName": "白子力",
 "evaluateFlag": "0",
 "checkStatus": "1",
 "reason": "",
 "address": "北京",
 "arriveTime": "12:53",
 "orderCarId": "20160418125506064124085001024194",
 "orderTime": "2016-04-18 12:55:06",
 "telephone": "18518055361",
 "departmentName": "合众学校"
 
 // 司机
 "checkStatusView": "已确认出车",
 "assignCarId": "20160415141000126171402566251556",
 "departmentName": "合众学校",
 "carUserName": "姚思迈",
 "checkStatus": "1",
 "arriveTime": "11:29",
 "address": "哦婆婆做最切",
 "carNum": "B4113",
 "leaveTime": "14:10",
 "carName": "阿斯顿.马丁",
 "useAddress": "北京",
 "telephone": "18612345678",
 "useTime": "14:10",
 "leaveDate": "2016-04-16"
 
 */


@property (nonatomic, copy) NSString * evaluateFlag;
@property (nonatomic, copy) NSString * reason;

@property (nonatomic, copy) NSString * userDate;
@property (nonatomic, copy) NSString * checkStatusView;
@property (nonatomic, copy) NSString * carUserName;
@property (nonatomic, copy) NSString * checkStatus;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * arriveTime;
@property (nonatomic, copy) NSString * orderCarId;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * departmentName;

@property(nonatomic,copy)NSString *startTime;

@property (nonatomic, copy) NSString * assignCarId;
@property (nonatomic, copy) NSString * carNum;
@property (nonatomic, copy) NSString * carName;
@property (nonatomic, copy) NSString * leaveDate;
@property (nonatomic, copy) NSString * useAddress;
@property (nonatomic, copy) NSString * useTime;
@property (nonatomic, copy) NSString * leaveTime;

@end
