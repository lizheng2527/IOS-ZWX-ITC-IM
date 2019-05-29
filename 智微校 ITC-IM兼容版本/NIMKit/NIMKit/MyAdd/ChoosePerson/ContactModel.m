//
//  ContactModel.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.contactId forKey:@"contactId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.parentId forKey:@"parentId"];
    [aCoder encodeObject:self.userList forKey:@"userList"];
    [aCoder encodeInteger:self.IndentationLevel forKey:@"indentationLevel"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.contactId = [aDecoder decodeObjectForKey:@"contactId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.parentId = [aDecoder decodeObjectForKey:@"parentId"];
        self.userList = [aDecoder decodeObjectForKey:@"userList"];
        self.IndentationLevel = [aDecoder decodeIntegerForKey:@"indentationLevel"];
    }
    return self;
}

@end

@implementation ContactGoodsCountModel

@end
