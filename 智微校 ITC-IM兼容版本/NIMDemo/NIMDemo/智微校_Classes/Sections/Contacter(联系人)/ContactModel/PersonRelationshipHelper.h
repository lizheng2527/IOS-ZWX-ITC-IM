//
//  PersonRelationshipHelper.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/9.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonRelationshipHelper : NSObject
- (void)isMybuddyWithSessionID:(NSString *)sessionID andDeal:(void (^)(BOOL, NSMutableArray *))completion;
+(BOOL)addBuddyWithSessionID:(NSString *)sessionID;
+(BOOL)deleteBuddyWithSessionId:(NSString *)sessionID;



-(void)addFriendWithKeyWord:(NSString *)keyWord andDeal:(void(^)(BOOL,NSMutableArray *))completion;


+(BOOL)addPhoneNumWithKey:(NSString *)phoneNum;



@property(nonatomic,retain)NSMutableArray *array;

@end
