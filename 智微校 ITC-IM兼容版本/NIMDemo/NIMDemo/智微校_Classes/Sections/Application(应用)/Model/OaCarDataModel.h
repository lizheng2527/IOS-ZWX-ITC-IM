//
//  OaCarDataModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/18/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OaCarDataModel : NSObject
/*
 carName = "\U963f\U65af\U987f.\U9a6c\U4e01";
 carNum = B4113;
 driver = "\U767d\U5b50\U529b";
 feedBackFlag = 0;
 note = "<null>";
 phone = 13823653623;
 realAddress = "<null>";
 realCount = "<null>";
 realTime = "<null>";
 status = 0;
 useAddress = "\U5317\U4eac";
 useTime = "14:10";
 */

@property (nonatomic, copy) NSString * carName;
@property (nonatomic, copy) NSString * carNum;
@property (nonatomic, copy) NSString * driver;
@property (nonatomic, copy) NSString * feedBackFlag; // BOOL

// starData
@property (nonatomic, strong) NSArray * starData;

@property (nonatomic, copy) NSString * note;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * realAddress;
@property (nonatomic, copy) NSString * realCount;
@property (nonatomic, copy) NSString * realTime;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * useAddress;

@property (nonatomic, copy) NSString * feedBackAdvice;
@property (nonatomic, copy) NSString * useTime;

@end
