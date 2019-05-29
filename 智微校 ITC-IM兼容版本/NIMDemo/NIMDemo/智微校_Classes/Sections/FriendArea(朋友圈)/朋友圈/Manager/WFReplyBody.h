//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFReplyBody : NSObject

/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUser;

/**
 *  评论者ID
 */
@property (nonatomic,copy) NSString *replyUserID;

/**
 *  回复该评论者的人
 */
@property (nonatomic,copy) NSString *repliedUser;

/**
 *  回复该评论者的人ID
 */
@property (nonatomic,copy) NSString *repliedUserID;

/**
 *  回复该评论的内容ID
 */
@property (nonatomic,copy) NSString *replyID;


/**
 *  回复内容
 */
@property (nonatomic,copy) NSString *replyInfo;


/**
 *  回复内容ID
 */
@property (nonatomic,copy) NSString *replyInfoID;



@end
