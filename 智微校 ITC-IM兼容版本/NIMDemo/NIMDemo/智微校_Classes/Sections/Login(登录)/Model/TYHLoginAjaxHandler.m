//
//  TYHLoginAjaxHandler.m
//  NIM
//
//  Created by 中电和讯 on 16/12/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "TYHLoginAjaxHandler.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "TYHLoginInfoModel.h"
#import "NSString+NTES.h"
#import <AFNetworking.h>


#define OrganizationJsonURL @"/bd/mobile/mobileWelcome!getOrganizationJson.action"
#define UserInfoJson @"/bd/mobile/mobileWelcome!getUserWithLoginNameAndPassword.action"
#define submitLoginStatus @"/bd/loginRecord/saveOrUpdate"
#define submitUserInfo @"/bd/mobile/mobileWelcome!saveUserDetail.action"

#define getUserInfo @"/bd/mobile/baseData!getUserInfo.action"
#define logOut @"/bd/mobile/baseData!logout.action"

@implementation TYHLoginAjaxHandler

//获取组织机构(学校)信息
-(void)getOrganizationArrayWithStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,OrganizationJsonURL];
    
//    数校的一些应用依据的是language，参数约定改为这样吧：language=zh-CN  language=en-US
//    NSDictionary *languageDic = @{@"language":@"zh-CN"};
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:requestURL]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
    
    [TYHHttpTool posts:requestURL params:nil success:^(id json) {
        NSMutableArray * blockArray = [NSMutableArray arrayWithArray:[TYHOranizationModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        UIView *view = [UIApplication sharedApplication].keyWindow;
        [view makeToast:@"无法获取学校数据" duration:2 position:CSToastPositionCenter];
    }];
    
}

//获取登录信息
-(void)LoginWithUserName:(NSString *)username Password:(NSString *)password OrganizationID:(NSString *)organizationId andStatus:(void (^)(BOOL ,TYHLoginInfoModel *))status failure:(void (^)(NSError *error))failure
{
//    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",username],@"sys_password":password,@"organizationId":organizationId};
    
    NSDictionary *dic = @{@"loginName":username.length?username:@"",@"password":password.length?password:@"",@"organizationId":organizationId.length?organizationId:@"",@"terminal":@"iOS"};
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,UserInfoJson];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        TYHLoginInfoModel *loginModel = [TYHLoginInfoModel new];
        loginModel = [TYHLoginInfoModel mj_objectWithKeyValues:[json objectForKey:@"userData"]];
        loginModel.token = [json objectForKey:@"token"];
        loginModel.successStatus = [json objectForKey:@"successStatus"];
        
//        loginModel.accId = @"20161129115023979121532902676091";
        
        id otherURLDic = [json objectForKey:@"otherUrl"];
        if ([otherURLDic isKindOfClass:[NSDictionary class]]) {
            loginModel.qcxtUrl = [otherURLDic objectForKey:@"qcxtUrl"];
        }
    
        if ([NSString isBlankString:loginModel.accId]) {
            [TYHIMHandler sharedInstance].IMShouldEnabled = NO;
        }else [TYHIMHandler sharedInstance].IMShouldEnabled = YES;
        
//        loginModel.otherUrl  = @"http://222.128.2.27/dubbo-wisdomclass/";
        
        //登录失败时
        if ([[json objectForKey:@"successStatus"] isEqualToString:@"1"]) {
            loginModel = [TYHLoginInfoModel mj_objectWithKeyValues:json];
        }
        
        status(YES,loginModel);
    } failure:^(NSError *error) {
        status(NO,[TYHLoginInfoModel new]);
    }];
    
}

//验证服务器地址
+(BOOL)AjaxURL:(NSString *)url
{
    NSString *ContactUrl = [NSString stringWithFormat:@"%@%@",url,OrganizationJsonURL];
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:8.0f];

    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    if(!error && data && response.statusCode==200)
        return YES;
    else
        return NO;
}

//统计登录
-(void)submitLoginStatusWithLoginName:(NSString *)userName PassWord:(NSString *)password UserID:(NSString *)userID terminalStatus:(NSString *)terminal
{
//    terminal     android 0, ios 1, pc 2
    
    NSDictionary *userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID,@"terminal":terminal};
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,submitLoginStatus];
    [TYHHttpTool gets:requestURL params:userInfoDic success:^(id json) {
        
        NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"ok"]) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

//修改手机号
-(void)changeMobiePhoneNum:(NSString *)phoneNum andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *orgId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    
    NSString *imToken = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    NSDictionary *userInfoDic = [NSDictionary dictionary];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@,%@",userName,orgId],@"sys_password":password,@"dataSourceName":dataSourceName,@"userId":userID,@"mobileNum":phoneNum,@"imToken":imToken,@"sys_Token":imToken};
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,@"/bd/user/updateMobileNum"];
    
    [TYHHttpTool gets:requestURL params:userInfoDic success:^(id json) {
        
       NSString *resultSrting = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if ([resultSrting isEqualToString:@"success"]) {
            status(YES);
        }else status(NO);
        
    } failure:^(NSError *error) {
        status(NO);
    }];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



//修改用户信息
-(void)changeUserInfoWithSex:(NSString *)Sex BirthDay:(NSString *)birthday Email:(NSString *)email MobiePhone:(NSString *)phoneNum Signature:(NSString *)sign andStatus:(void (^)(BOOL successful))status failure:(void (^)(NSError *error))failure
{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
//    NSString *orgId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    
    NSString *sexString = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_SEX];
    if ([sexString isEqualToString:@"女"]) {
        Sex = @"0";
    }else if([sexString isEqualToString:@"男"])
    {
        Sex = @"1";
    }
    
    birthday = birthday.length?birthday :[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_BIRTHDAY];
    email = email.length?email :[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_EMAIL];
    phoneNum = phoneNum.length?phoneNum :[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MOBIENUM];
    sign = sign.length?sign :[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_SIGNATURE];
    
    
    NSString *imToken = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    imToken = imToken.length?imToken:@"";
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    NSDictionary *userInfoDic = [NSDictionary dictionary];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName,@"userId":userID,@"mobileNum":phoneNum.length?phoneNum:@"",@"imToken":imToken,@"sys_Token":imToken,@"autograph":sign.length?sign:@"",@"birthDate":birthday.length?birthday:@"",@"email":email.length?email:@"",@"sex":Sex.length?Sex:@""};
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",BaseURL,submitUserInfo,userName,password];
    
    [TYHHttpTool gets:requestURL params:userInfoDic success:^(id json) {
        
        NSString *resultSrting = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//        status(YES);
        if ([resultSrting isEqualToString:@"success"]) {
            status(YES);
        }else status(NO);
        
    } failure:^(NSError *error) {
        status(NO);
    }];
}

//获取用户信息
-(void)getUserInfoWithUserId:(NSString *)userId  andStatus:(void (^)(BOOL ,NSDictionary *))status failure:(void (^)(NSError *error))failure
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    
    NSDictionary *userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":passWord,@"userId":userId};
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,getUserInfo];
    [TYHHttpTool gets:requestURL params:userInfoDic success:^(id json) {
        NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        NSDictionary *infoDic = [self dictionaryWithJsonString:data];
        status(YES,infoDic);
        
    } failure:^(NSError *error) {
        status(NO,[NSDictionary dictionary]);
    }];
    
}


//退出登录
+(void)logout:(void (^)(NSError *error))failure
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
//    NSString  *regIDD = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PushRegID];
    NSString  *userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    NSDictionary *userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":passWord,@"userId":userId};
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,logOut];
    [TYHHttpTool gets:requestURL params:userInfoDic success:^(id json) {
        NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
    } failure:^(NSError *error) {
    }];
}
@end
