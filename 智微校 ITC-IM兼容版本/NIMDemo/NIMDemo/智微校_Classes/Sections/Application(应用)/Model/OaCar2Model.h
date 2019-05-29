//
//  OaCar2Model.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/26/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OaCar2Model : NSObject
/*
 address = "\U5317\U4eac";
 arriveTime = "16:00";
 attachments =             (
 );
 backAddress = "<null>";
 backCount = "<null>";
 backDate = "<null>";
 backPerson = "<null>";
 backTime = "<null>";
 carUserName = "\U767d\U5b50\U529b";
 departmentName = "\U5408\U4f17\U5b66\U6821";
 feedBackFlag = 0;
 instruction = "";
 orderTime = "2016-04-12 16:00:11";
 orderUser = "\U767d\U5b50\U529b";
 personList = "";
 reason = "";
 telephone = "\U65e0";
 useAddress = "";
 useTime = "09:50";
 userCount = 5;
 userDate = "2016-04-13";
 */

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * arriveTime;
@property (nonatomic, copy) NSString * note;
@property (nonatomic, copy) NSString * backAddress;
@property (nonatomic, copy) NSString * backCount;
@property (nonatomic, copy) NSString * backDate;
@property (nonatomic, copy) NSString * backPerson;
@property (nonatomic, copy) NSString * backTime;
@property (nonatomic, copy) NSString * carUserName;
@property (nonatomic, copy) NSString * checkAdvice;
@property (nonatomic, copy) NSString * checkFlag;
@property (nonatomic, copy) NSString * checkStatus;
@property (nonatomic, copy) NSString * checkStatusView;
@property (nonatomic, copy) NSString * checkUser;
@property (nonatomic, copy) NSString * departmentName;
@property (nonatomic, copy) NSString * feedBackFlag;
@property (nonatomic, copy) NSString * instruction;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * orderUser;
@property (nonatomic, copy) NSString * personList;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * useAddress;
@property (nonatomic, copy) NSString * useTime;
@property (nonatomic, copy) NSString * userCount;
@property (nonatomic, copy) NSString * userDate;
@property(nonatomic,copy)NSString *startTime;

@property (nonatomic, copy) NSString * status;

@property (nonatomic, copy) NSArray * starData;

@property (nonatomic, copy) NSString * feedBackAdvice;

@end
