//
//  SSChatHandler.m
//  NIM
//
//  Created by 中电和讯 on 2018/12/8.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "SSChatHandler.h"
#import "TYHHttpTool.h"
#import "SSChatModel.h"
#import <MJExtension.h>
#import "NSTimer+SSAdd.h"
#import <NIMKitUtil.h>

#import "SSChatIMEmotionModel.h"

//发送留言
#define sendMessage @"/bd/mobile/leavingMessage!save.action"
//获取与某人留言列表
#define getMessageList @"/bd/mobile/leavingMessage!getMessagePage.action"
//设置留言已读
#define setMessageRead @"/bd/mobile/leavingMessage!update.action"
//获取全部留言列表汇总
#define getChatList @"/bd/mobile/leavingMessage!getChatFriendPage.action"


@implementation SSChatHandler
{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *dataSourceName;
    NSDictionary *userInfoDic;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getNeedData];
    }
    return self;
}

#pragma mark - 获取用户基础数据
-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName};
}


#pragma mark - 方法

#pragma mark - 获取消息列表

#pragma mark - 发送消息

#pragma mark - 设置已读




//获取聊天列表
-(void)getChatListWithUserID:(NSString *)userIDD PageNum:(NSString *)pageNum andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,getChatList];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:pageNum.length?pageNum:@"" forKey:@"pageNum"];
    
    __block SSChartEmotionImages *modelHelper = [[SSChartEmotionImages alloc]init];
    [modelHelper initEmotionImages];
    [modelHelper initSystemEmotionImages];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *weekArray = [NSMutableArray arrayWithArray:[SSChatListModel mj_objectArrayWithKeyValuesArray:json]];
        
        [weekArray enumerateObjectsUsingBlock:^(SSChatListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.attContent = [modelHelper emotionImgsWithStringMessageCenterList:obj.content];
            
        }];
        
        status(YES,weekArray);
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        
    }];
    
}

//发送信息
-(void)sendMessageWithContent:(NSString *)content ReceiveID:(NSString *)receiverID  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,sendMessage];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    
//    NSString *dealContent = [self DataTOjsonString:content];
    
    [dic setValue:receiverID.length?receiverID:@"" forKey:@"receiverUserId"];
    [dic setValue:content.length?content:@"" forKey:@"content"];
    
    [TYHHttpTool posts:requestURL params:dic success:^(id json) {
        
        NSMutableArray *weekArray = [NSMutableArray arrayWithArray:[SSChatMessageModel mj_objectArrayWithKeyValuesArray:json]];
                status(YES,weekArray);
        NSLog(@"123");
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        
    }];
    
}

-(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}




//获取与某人会话列表
-(void)getMessageListWithUserID:(NSString *)userID PageNum:(NSString *)pageNum  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,getMessageList];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID.length?userID:@"" forKey:@"userId"];
    [dic setValue:pageNum.length?pageNum:@"0" forKey:@"pageNum"];
    //    [dic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:NODE_SERVER_PARAM] forKey:@"reqParam"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
                NSMutableArray *weekArray = [NSMutableArray arrayWithArray:[SSChatMessageModel mj_objectArrayWithKeyValuesArray:json]];
        weekArray=(NSMutableArray *)[[weekArray reverseObjectEnumerator] allObjects];
        
                status(YES,weekArray);
        NSLog(@"success");
        
    } failure:^(NSError *error) {
                status(NO,[NSMutableArray array]);
        NSLog(@"failed");
    }];
    
}


//设置已读
-(void)setMessageReadWithReceiverID:(NSString *)mesID  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,setMessageRead];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:mesID.length?mesID:@"" forKey:@"id"];
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray *weekArray = [NSMutableArray arrayWithArray:[SSChatMessageModel mj_objectArrayWithKeyValuesArray:json]];
        weekArray=(NSMutableArray *)[[weekArray reverseObjectEnumerator] allObjects];
        status(YES,weekArray);
        NSLog(@"success");
        
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
        NSLog(@"failed");
    }];
}


+(void)handlerPushNotification:(NSDictionary *)userInfo
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:userInfo];
    if (userInfoDic.allKeys) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[userInfoDic objectForKey:@"aps"]];
        NSString *strrrr = [dic objectForKey:@"sound"];
        NSDictionary *dictemp = [self dictionaryWithJsonString:strrrr];
        
        if ([[dictemp objectForKey:@"code"]isEqualToString:@"lm"]) {
            
            NSString *saveTimeString = [NSTimer getChatTimeStr:[NSTimer getStampWithTime:[dictemp objectForKey:@"sendTime"]]];
            NSString *saveSendUser = [NSTimer getChatTimeStr:[NSTimer getStampWithTime:[dictemp objectForKey:@"sendUserName"]]];
            NSString *saveContent = [dic objectForKey:@"alert"];
            
            
            NSString *userIDString = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
            NSString *headerContentKey = [NSString stringWithFormat:@"%@%@",NewV3PushMessageContent,userIDString];
            NSString *headerTimeKey = [NSString stringWithFormat:@"%@%@",NewV3PushMessageTime,userIDString];
            
            [[NSUserDefaults standardUserDefaults]setValue:saveTimeString forKey:headerTimeKey];
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@: %@",saveSendUser,saveContent] forKey:headerContentKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
