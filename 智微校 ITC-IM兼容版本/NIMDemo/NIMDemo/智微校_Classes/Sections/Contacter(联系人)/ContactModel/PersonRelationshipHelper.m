//
//  PersonRelationshipHelper.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/9.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "PersonRelationshipHelper.h"
#import "PersonModel.h"
#import <AFNetworking.h>
#import "TYHHttpTool.h"


@implementation PersonRelationshipHelper
- (void)isMybuddyWithSessionID:(NSString *)sessionID andDeal:(void (^)(BOOL, NSMutableArray *))completion
{
    _array = [NSMutableArray array];
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/isMyBuddy?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccount=%@",userName,passWord,myVoipAccount,sessionID]];
        ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            PersonModel *model = [[PersonModel alloc]init];
            model.departmentName = [responseObject objectForKey:@"departmentName"];
            model.isMyBuddy  = [responseObject objectForKey:@"isMyBuddy"];
            model.voipAccount = [responseObject objectForKey:@"voipAccount"];
            model.name = [responseObject objectForKey:@"name"];
            model.headPortraitUrl = [responseObject objectForKey:@"headPortraitUrl"];
            model.mobieNum = [responseObject objectForKey:@"mobileNum"];
            [_array addObject:model];
            completion(YES,_array);
            
        }else{
            completion(NO,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
        
    }];
}

+(BOOL)addBuddyWithSessionID:(NSString *)sessionID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/addContact?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccount=%@",userName,passWord,myVoipAccount,sessionID]];
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
    }
    else
        return NO;
    
}

+(BOOL)deleteBuddyWithSessionId:(NSString *)sessionID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/deleteContacts?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccounts=%@",userName,passWord,myVoipAccount,sessionID]];
    
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
        
    }
    else
        return NO;
}

-(void)addFriendWithKeyWord:(NSString *)keyWord andStatus:(void (^)(BOOL successful,NSMutableArray *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *imToken = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_TOKEN];
    
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setValue:organizationId forKey:@"organizationId"];
    [requestDic setValue:userName forKey:@"sys_username"];
    [requestDic setValue:passWord forKey:@"sys_password"];
    [requestDic setValue:imToken forKey:@"imToken"];
    [requestDic setValue:imToken forKey:@"sys_Token"];
    [requestDic setValue:keyWord forKey:@"name"];
    [requestDic setValue:@"true" forKey:@"sys_auto_authenticate"];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/user/serachUserWithParam"]];
    
    [TYHHttpTool get:ContactUrl params:requestDic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
//    [TYHHttpTool post:ContactUrl params:requestDic success:^(id json) {
//
//        NSMutableArray *modelArray = [NSMutableArray array];
//        for (NSDictionary *dic in json) {
//            PersonModel *model = [[PersonModel alloc]init];
//            model.personID =  [dic objectForKey:@"id"];
//            model.name = [dic objectForKey:@"name"];
//            model.voipAccount = [dic objectForKey:@"voipAccount"];
//            model.accId = [dic objectForKey:@"accId"];
//            if ([dic objectForKey:@"headPortraitUrl"]) {
//                model.headPortraitUrl = [dic objectForKey:@"headPortraitUrl"];
//            }
//            NSLog(@"%@",model.name);
//            [modelArray addObject:model];
//
//            status(YES,modelArray);
//
//        } failure:^(NSError *error) {
//            status(NO,[NSMutableArray array]);
//        }];
}

-(void)addFriendWithKeyWord:(NSString *)keyWord andDeal:(void(^)(BOOL,NSMutableArray *))completion
{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *imToken = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_TOKEN];
    
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setValue:organizationId forKey:@"organizationId"];
    [requestDic setValue:[NSString stringWithFormat:@"%@,%@",userName,organizationId] forKey:@"sys_username"];
    [requestDic setValue:passWord forKey:@"sys_password"];
    [requestDic setValue:imToken forKey:@"imToken"];
    [requestDic setValue:imToken forKey:@"sys_Token"];
    [requestDic setValue:keyWord forKey:@"name"];
    [requestDic setValue:@"true" forKey:@"sys_auto_authenticate"];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/user/serachUserWithParam"]];
    
    [TYHHttpTool post:ContactUrl params:requestDic success:^(id json) {
        
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dic in json) {
            PersonModel *model = [[PersonModel alloc]init];
            model.personID =  [dic objectForKey:@"id"];
            model.name = [dic objectForKey:@"name"];
            model.voipAccount = [dic objectForKey:@"voipAccount"];
            model.accId = [dic objectForKey:@"accId"];
            if ([dic objectForKey:@"headPortraitUrl"]) {
                model.headPortraitUrl = [dic objectForKey:@"headPortraitUrl"];
            }
            NSLog(@"%@",model.name);
            [modelArray addObject:model];
        }
            completion(YES,modelArray);
            
    } failure:^(NSError *error) {
        
        completion(NO,[NSMutableArray array]);
        
    }];
    
}

+(BOOL)addPhoneNumWithKey:(NSString *)phoneNum
{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
     NSString *loginID = [[NSUserDefaults standardUserDefaults]valueForKey:@"LoginID"];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/user/updateMobileNum?mobileNum=%@&sys_username=%@&sys_auto_authenticate=true&userId=%@&sys_password=%@",phoneNum,userName,loginID,passWord]];
    NSLog(@"my phone url%@",ContactUrl);
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
    }
    else
        return NO;
}



@end
