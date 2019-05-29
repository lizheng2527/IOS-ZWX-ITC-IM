//
//  WHMyApplicationModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHMyApplicationModel.h"

@implementation WHMyApplicationModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"applyID":@"id"};
}

@end

@implementation WHMyApplicationDetailModel

@end

@implementation WHMyDetailModel

@end


@implementation WHMyItemListModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"itemId":@"id"};
}

@end


@implementation WHMyApplicationUseKindModel

@end

@implementation WHMyApplicationCheckModel

@end

