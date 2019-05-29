//
//  NoticeModel.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "NoticeModel.h"
#import <MJExtension.h>
#import "AttachmentModel.h"
@implementation NoticeModel
- (NSDictionary *)objectClassInArray
{
    
    return @{@"attachmentFlag":[AttachmentModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}


@end
