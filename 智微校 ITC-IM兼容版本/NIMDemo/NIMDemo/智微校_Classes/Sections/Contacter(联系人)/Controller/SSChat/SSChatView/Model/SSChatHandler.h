//
//  SSChatHandler.h
//  NIM
//
//  Created by 中电和讯 on 2018/12/8.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SSChatHandler : NSObject

//获取聊天列表
-(void)getChatListWithUserID:(NSString *)userID PageNum:(NSString *)pageNum  andStatus:(void (^)(BOOL successful, NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure;

//发送信息
-(void)sendMessageWithContent:(NSString *)content ReceiveID:(NSString *)receiverID  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure;


//获取与某人会话列表
-(void)getMessageListWithUserID:(NSString *)userID PageNum:(NSString *)pageNum  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure;


//设置已读
-(void)setMessageReadWithReceiverID:(NSString *)mesID  andStatus:(void (^)(BOOL successful,NSMutableArray *chatArray))status failure:(void (^)(NSError *error))failure;




+(void)handlerPushNotification:(NSDictionary *)userInfo;

@end

