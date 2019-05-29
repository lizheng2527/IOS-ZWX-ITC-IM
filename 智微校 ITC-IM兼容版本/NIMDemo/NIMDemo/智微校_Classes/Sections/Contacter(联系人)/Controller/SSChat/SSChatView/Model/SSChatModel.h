//
//  SSChatModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/12/8.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSChatModel : NSObject

@end


@interface SSChatListModel : NSObject

@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *friendId;
@property(nonatomic,retain)NSString *count;
@property(nonatomic,retain)NSString *sendTime;
@property(nonatomic,retain)NSString *photoUrl;

@property(nonatomic,retain)NSAttributedString *attContent;
@end


@interface SSChatMessageModel : NSObject

@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *kind;
@property(nonatomic,retain)NSString *photoUrl;
@property(nonatomic,retain)NSString *sendTime;

@property(nonatomic,retain)NSString *sendUserId;
@end
