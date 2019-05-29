//
//  UserModel.m
//  JingJingCampusOfYTX
//
//  Created by hzth-mac3 on 15/4/15.
//  Copyright (c) 2015年 hzth-mac3. All rights reserved.
//

#import "UserModel.h"
#import <MJExtension.h>
@implementation UserModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{@"strId":@"id"};
}
//@property (strong, nonatomic) NSString *friendlyName;
//@property (strong, nonatomic) NSString *userId;
//@property (strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSString *terminalId;
//@property (strong, nonatomic) NSString *subToken;
//@property (strong, nonatomic) NSString *voipAccount;
//@property (strong, nonatomic) NSString *voipPwd;
//@property (nonatomic) NSUInteger IndentationLevel;

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.friendlyName forKey:@"friendlyName"];
//    [aCoder encodeObject:self.userId forKey:@"userId"];
//    [aCoder encodeObject:self.isMyBuddy forKey:@"isMyBuddy"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.terminalId forKey:@"terminalId"];
//    [aCoder encodeObject:self.subToken forKey:@"subToken"];
//    [aCoder encodeObject:self.voipAccount forKey:@"voipAccount"];
//    [aCoder encodeObject:self.voipPwd forKey:@"voipPwd"];
//    [aCoder encodeInteger:self.IndentationLevel forKey:@"indentationLevel"];
//    
//    [aCoder encodeObject:self.imageName forKey:@"imageName"];
//}
//
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        self.friendlyName = [aDecoder decodeObjectForKey:@"friendlyName"];
//        self.userId = [aDecoder decodeObjectForKey:@"userId"];
//        self.isMyBuddy = [aDecoder decodeObjectForKey:@"isMyBuddy"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.terminalId = [aDecoder decodeObjectForKey:@"terminalId"];
//        self.subToken = [aDecoder decodeObjectForKey:@"subToken"];
//        self.voipAccount = [aDecoder decodeObjectForKey:@"voipAccount"];
//        self.voipPwd = [aDecoder decodeObjectForKey:@"voipPwd"];
//        self.IndentationLevel = [aDecoder decodeIntegerForKey:@"indentationLevel"];
//        
//        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
//    }
//    return self;
//}

@end
