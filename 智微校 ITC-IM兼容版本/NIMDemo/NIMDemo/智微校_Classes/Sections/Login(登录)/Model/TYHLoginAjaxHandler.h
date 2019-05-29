//
//  TYHLoginAjaxHandler.h
//  NIM
//
//  Created by 中电和讯 on 16/12/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYHLoginInfoModel;

@interface TYHLoginAjaxHandler : NSObject

//获取组织机构(学校)信息
-(void)getOrganizationArrayWithStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//获取登录信息
-(void)LoginWithUserName:(NSString *)username Password:(NSString *)password OrganizationID:(NSString *)organizationId andStatus:(void (^)(BOOL ,TYHLoginInfoModel *))status failure:(void (^)(NSError *error))failure;

//验证服务器地址
+(BOOL)AjaxURL:(NSString *)url;

//统计登录
-(void)submitLoginStatusWithLoginName:(NSString *)userName PassWord:(NSString *)password UserID:(NSString *)userID terminalStatus:(NSString *)terminal;

//修改手机号
-(void)changeMobiePhoneNum:(NSString *)phoneNum andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure;

//修改用户信息
-(void)changeUserInfoWithSex:(NSString *)Sex BirthDay:(NSString *)birthday Email:(NSString *)email MobiePhone:(NSString *)phoneNum Signature:(NSString *)sign andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure;

//获取用户信息
-(void)getUserInfoWithUserId:(NSString *)userId  andStatus:(void (^)(BOOL ,NSDictionary *))status failure:(void (^)(NSError *error))failure;

//退出登录
+(void)logout:(void (^)(NSError *error))failure;
@end
