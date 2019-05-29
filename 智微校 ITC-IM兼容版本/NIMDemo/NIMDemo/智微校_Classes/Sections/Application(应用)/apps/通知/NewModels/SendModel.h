//
//  SendModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/29.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendModel : NSObject
/**
 * 发/转发 通知
 * @param baseUrl
 * @param subject 主题
 content 内容
 receiveUserId 接收人id 逗号分隔
 attIds 原附件id 逗号分隔
 sourceId 原通知id
 
 /no/noticeMobile!sendNotice.action
 */
@property (nonatomic, copy) NSString * subject;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * receiveUserId;

@property (nonatomic, copy) NSString * attIds;

@property (nonatomic, copy) NSString * sourceId;

@end
