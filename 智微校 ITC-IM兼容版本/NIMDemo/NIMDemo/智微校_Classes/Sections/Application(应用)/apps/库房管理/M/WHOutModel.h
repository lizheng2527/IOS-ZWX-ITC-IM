//
//  WHOutModel.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHOutModel : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *outKindValue;
@property(nonatomic,copy)NSString *receiverName;
@property(nonatomic,copy)NSString *signatureFlag;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *warehouseName;

@property(nonatomic,copy)NSString *outID;


//因为出库列表详情添加
@property(nonatomic,copy)NSString *productDate;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *departmentName;

@property(nonatomic,retain)NSMutableArray *goodsList;
@property(nonatomic,retain)NSMutableArray *goodsListModelArray;
@end

@interface WHOutResignModel : NSObject

@property(nonatomic,copy)NSString *department;
@property(nonatomic,copy)NSString *grantTime;
@property(nonatomic,copy)NSString *userName;

@property(nonatomic,retain)NSMutableArray *goodsList;
@property(nonatomic,retain)NSMutableArray *goodsListModelArray;

@end

//出库列表补签 - 查看物品的详情
@interface WHOutGoodsListModel : NSObject

@property(nonatomic,copy)NSString *goodsCount;
@property(nonatomic,copy)NSString *goodsName;

@end
//出库列表查看 - 物品的详情
@interface WHOutDetailoodsListModel : NSObject

@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sum;

@end
