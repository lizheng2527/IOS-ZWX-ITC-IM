//
//  ContactModelListHelper.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModelListHelper : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *organizationID;
@property(nonatomic,copy)NSString *voipAcount;
@property(nonatomic,copy)NSString *baseUrlString;

@property(nonatomic,retain)NSMutableArray *dataSource;

@property(nonatomic,retain)NSMutableArray *nameSource;

@property (nonatomic ,retain)NSData * userHeaderImage;

- (void)getContactCompletionWIthSchool:(void (^)(BOOL, NSMutableArray *))completion;


-(void)getContactCompletionWithFriend:(void (^)(BOOL, NSMutableArray *))completion;


-(void)getContactCompletionWithClasses:(void (^)(BOOL, NSMutableArray *))completion;

- (void)getContactCompletionNoticeContact:(NSString *)strUrl block:(void (^)(BOOL, NSMutableArray *))completion;
@end
