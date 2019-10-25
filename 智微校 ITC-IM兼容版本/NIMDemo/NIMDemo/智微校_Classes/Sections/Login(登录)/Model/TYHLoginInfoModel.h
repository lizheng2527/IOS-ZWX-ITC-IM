//
//  TYHLoginInfoModel.h
//  NIM
//
//  Created by 中电和讯 on 16/12/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHLoginInfoModel : NSObject
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *terminalId;
@property(nonatomic,copy)NSString *accId;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *v3Id;
@property(nonatomic,copy)NSString *v3Url;
@property(nonatomic,copy)NSString *v3pwd;
@property(nonatomic,copy)NSString *voipAccount;
@property(nonatomic,copy)NSString *appCode;
@property(nonatomic,copy)NSString *neteaseToken;
@property(nonatomic,copy)NSString *openId;
@property(nonatomic,copy)NSString *mobileNum;
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *headPortraitUrl;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *messageDetailUrl;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *birthDate;

@property(nonatomic,copy)NSString *dataSourceName;
@property(nonatomic,copy)NSString *successStatus;
@property(nonatomic,copy)NSString *errorMsg;

@property(nonatomic,copy)NSString *nodeServerUrl;
@property(nonatomic,copy)NSString *nodeParam;

@property(nonatomic,copy)NSString *appCenterUrl;

@property(nonatomic,copy)NSString *otherUrl;
@property(nonatomic,copy)NSString *qcxtUrl;

@property(nonatomic,copy)NSString *codes;
@property(nonatomic,copy)NSString *autograph;
@property(nonatomic,copy)NSString *sys_token;

@end

//组织机构Model
@interface TYHOranizationModel : NSObject

@property(nonatomic,copy)NSString *organizationName;
@property(nonatomic,copy)NSString *organizationID;
@property(nonatomic,copy)NSString *v3Url;
@property(nonatomic,copy)NSString *dataSourceName;
@end
