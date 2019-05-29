//
//  SingleManager.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleManager : NSObject

+ (SingleManager *)defaultManager;


@property (nonatomic, copy) NSString * item;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * idStr;

@property (nonatomic, copy) NSString * rangeString;
@property (nonatomic, strong) NSMutableArray * assets;

@property (nonatomic, strong) NSArray * idStrArray;

@property (nonatomic, assign) BOOL webViewOrHidden;
@property (nonatomic, strong) NSMutableArray * selectedSingelArray;

// 保存中间页面数据
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSString * textRecord;
@property (nonatomic, strong) NSString * textEvaluation;


@property (nonatomic, copy) NSString * title;


////// 保存主题和内容
//- (void)savaTextItem:(NSString*)item withTextContent:(NSString *)content;
//
//// 设置附件
//- (void)saveAttachment:(NSMutableArray *)array;
//
//// 保存显示个数
//- (void)saveChooseCount:(NSInteger)count;
//
//// 保存 原通知ID
//- (void)saveNoticeID:(NSString *)idStr;

@end
