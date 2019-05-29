//
//  TranscriptModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TranscriptModel.h"
#import <MJExtension.h>

@implementation TranscriptModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"terminalID":@"id"};
}
@end

@implementation ExamListModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"examID":@"id"};
}
@end

@implementation StudentScoreModel

@end
