//
//  DriverDetailModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/26/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverDetailModel : NSObject
/*
 carName = "\U5170\U535a\U57fa\U5c3c";
 carNum = "\U4eacB46454";
 driver = "\U767d\U5b50\U529b";
 leaveDate = "2016-04-13";
 leaveTime = "09:50";
 note = "<null>";
 oaCarData =     (
 {
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
 }
 );
 realAddress = "<null>";
 realCount = "<null>";
 realTime = "<null>";
 */
@property (nonatomic, copy) NSString * carName;
@property (nonatomic, copy) NSString * carNum;
@property (nonatomic, copy) NSString * driver;
@property (nonatomic, copy) NSString * leaveDate;
@property (nonatomic, copy) NSString * leaveTime;
@property (nonatomic, copy) NSString * note;

// 模型数组
@property (nonatomic, copy) NSArray * oaCarData;

@property (nonatomic, copy) NSString * realAddress;
@property (nonatomic, copy) NSString * realCount;
@property (nonatomic, copy) NSString * realTime;
@end
