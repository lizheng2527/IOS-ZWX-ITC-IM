//
//  TYHRepairMainModel.h
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHRepairMainModel : NSObject

@end

//我的报修
@interface myRepairModel : NSObject
@property(nonatomic,copy)NSString *dfk;  //待反馈
@property(nonatomic,copy)NSString *wjd; //未接单
@property(nonatomic,copy)NSString *wxz; //维修中
@property(nonatomic,copy)NSString *yxh; //已修好
@end

//我的任务（权限及待办)
@interface myTaskModel : NSObject
@property(nonatomic,copy)NSString *wjd;  //未接单
@property(nonatomic,copy)NSString *wxz; //维修中
@property(nonatomic,copy)NSString *yfk; //yfk
@end

//报修管理
@interface repairManageModel : NSObject
@property(nonatomic,copy)NSString *dcl;  //待处理
@property(nonatomic,copy)NSString *fysp; //费用审批
@property(nonatomic,copy)NSString *ypd; //已派单
@property(nonatomic,copy)NSString *ywc; //已完成
@end

@interface repairEquipmentTypeModel : NSObject
@property(nonatomic,copy)NSString *itemID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imageUrl;
@end
