//
//  WHGoodsStasticsModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

//商品统计列表Model
@interface WHGoodsStasticsModel : NSObject

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *outWarehouseCount;
@property(nonatomic,copy)NSString *intoWarehouseMoney;
@property(nonatomic,copy)NSString *intoWarehouseCount;
@property(nonatomic,copy)NSString *goodsInfoName;
@property(nonatomic,copy)NSString *outWarehouseMoney;
@property(nonatomic,copy)NSString *inventory;

@end

//库存model
@interface WHGoodsStasticsStockModel : NSObject

@property(nonatomic,copy)NSString *warehouseName;
@property(nonatomic,copy)NSString *schoolName;
@property(nonatomic,copy)NSString *count;

@end


//出库入库model
@interface WHGoodsStasticsInOutHouseModel : NSObject

@property(nonatomic,copy)NSString *moneycount;
@property(nonatomic,copy)NSString *warehouseName;
@property(nonatomic,copy)NSString *schoolName;
@property(nonatomic,copy)NSString *count;

@end

