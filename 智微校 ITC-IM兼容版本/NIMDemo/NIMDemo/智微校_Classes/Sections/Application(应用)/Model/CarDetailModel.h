//
//  CarDetailModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/12/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarDetailModel : NSObject
/*
address = "\U56fe\U56fe";
arriveTime = "09:59";
attachments =     (
);
backAddress = "<null>";
backCount = "<null>";
backDate = "<null>";
backPerson = "<null>";
backTime = "<null>";
carUserName = "\U59da\U601d\U8fc8";
checkAdvice = "\U5230\U8fd9\U8fb9";
checkFlag = 1;
checkStatus = 1;
checkStatusView = "\U5ba1\U6838\U901a\U8fc7";
checkUser = "\U767d\U5b50\U529b";
departmentName = "\U5408\U4f17\U5b66\U6821";
instruction = "";
oaCarData =     (
);
orderTime = "2016-04-11 10:00:27";
orderUser = "\U59da\U601d\U8fc8";
personList = "\U67d0\U65b0\U5e74\U5feb\U4e50\n\U770b\U89c1\U4e86";
reason = "";
telephone = 18612345678;
userCount = 555;
userDate = "2016-04-12";
*/

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * arriveTime;

// 嵌套模型数组
@property (nonatomic, strong) NSArray * attachments;

@property (nonatomic, copy) NSString * backAddress;
@property (nonatomic, copy) NSString * backCount;
@property (nonatomic, copy) NSString * backDate;
@property (nonatomic, copy) NSString * backPerson;
@property (nonatomic, copy) NSString * backTime;
@property (nonatomic, copy) NSString * carUserName;
@property (nonatomic, copy) NSString * checkAdvice;
@property (nonatomic, copy) NSString * checkFlag; // BOOL
@property (nonatomic, copy) NSString * checkStatus; // BOOL
@property (nonatomic, copy) NSString * checkStatusView;
@property (nonatomic, copy) NSString * checkUser;
@property (nonatomic, copy) NSString * departmentName;
@property (nonatomic, copy) NSString * instruction;
@property (nonatomic, copy) NSString *startTime;

// 模型数组
@property (nonatomic, strong) NSArray * oaCarData;

@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * orderUser;
@property (nonatomic, copy) NSString * personList;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * userCount;
@property (nonatomic, copy) NSString * userDate;

@end
