//
//  WHGoodsModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHGoodsKindModel : NSObject

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *parentId;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,retain)NSMutableArray *nodes;
@property(nonatomic,retain)NSMutableArray *nodesModelArray;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *value;
@property(nonatomic,copy)NSString *isParent;
@property(nonatomic,copy)NSString *nocheck;
@property(nonatomic,copy)NSString *url_;

// 是否是展开的
@property (nonatomic, assign) BOOL isExpanded;

@end

@interface WHGoodsKindInnerModel : NSObject

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *name;

@end


@interface WHGoodsDetailModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *enName;
@property(nonatomic,copy)NSString *brand;
@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *unit;

@property(nonatomic,copy)NSString *goodsInfoId;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *inventory;
@property(nonatomic,copy)NSString *cost;
@property(nonatomic,copy)NSString *Money;
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *goodsInfoName;
@property(nonatomic,copy)NSString *sum;//同上

@property(nonatomic,copy)NSString *hasSelected;//同上 1= 选择 0 = 未选择
@end
