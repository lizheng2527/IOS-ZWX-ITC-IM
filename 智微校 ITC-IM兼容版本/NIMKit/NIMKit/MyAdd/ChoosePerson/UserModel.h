//
//  UserModel.h
//  JingJingCampusOfYTX
//
//  Created by hzth-mac3 on 15/4/15.
//  Copyright (c) 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString * strId;
@property (nonatomic, copy) NSString * mobileNum;
@property (nonatomic, copy) NSString * kind;

@property (strong, nonatomic) NSString *friendlyName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *isMyBuddy;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *terminalId;
@property (strong, nonatomic) NSString *subToken;
@property (strong, nonatomic) NSString *voipAccount;
@property (strong, nonatomic) NSString *voipPwd;
@property (nonatomic,assign) NSUInteger IndentationLevel;

@property (strong, nonatomic) NSString *imageName;
@property(strong,nonatomic)NSString *headPortraitUrl;
@property(nonatomic,copy)NSString *accId;
@end
