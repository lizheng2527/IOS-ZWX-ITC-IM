//
//  WHGoodsModel.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHGoodsModel.h"

@implementation WHGoodsKindModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"goodsID":@"id"};
}
@end

@implementation WHGoodsKindInnerModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"goodsID":@"id"};
}
@end

@implementation WHGoodsDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"goodsID":@"id"};
}
@end
