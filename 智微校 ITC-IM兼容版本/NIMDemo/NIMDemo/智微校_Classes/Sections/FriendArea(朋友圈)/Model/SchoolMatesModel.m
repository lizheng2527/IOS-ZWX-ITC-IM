//
//  SchoolMatesModel.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SchoolMatesModel.h"
#import <MJExtension.h>

@implementation SchoolMatesModel
+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"commentsArray":@"comments",@"picUrlsArray":@"picUrls",@"thumbsupsArray":@"thumbsups",@"tempID":@"id"};
}
@end

@implementation commentsModel : NSObject
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"contentID":@"id",@"replysArray":@"replys"};
}
@end

//朋友圈照片的大图和预览小图
@implementation picUrlsModel : NSObject

@end

//点赞
@implementation thumbsupsModel : NSObject

@end

@implementation replyModel : NSObject
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"contentID":@"id"};
}
@end

@implementation momentsModel : NSObject
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"contentID":@"id"};
}
@end

@implementation classModel : NSObject
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"classID":@"id",@"className":@"name"};
}
@end

