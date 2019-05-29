//
//  ContactModel.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSMutableArray *userList;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@property(nonatomic,strong) NSMutableArray *childs;

@property (strong, nonatomic) NSMutableArray *goodsCountArray;
@end


//易耗品count,临时添加
@interface ContactGoodsCountModel : NSObject

@property (strong, nonatomic) NSString *goodsCount;
@property (strong, nonatomic) NSString *goodsID;

@end

