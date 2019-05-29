//
//  WHMyApplicationModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
//我的申领列表model
@interface WHMyApplicationModel : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *departmentName;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *kindValue; //领用类型
@property(nonatomic,copy)NSString *checkStatusValue; //使用类型
@property(nonatomic,copy)NSString *provideStatusValue; //审核状态

@property(nonatomic,copy)NSString *deptCheckStatusValue; //部门审核状态
@property(nonatomic,copy)NSString *zwCheckStatusValue; //总务审核状态;

@property(nonatomic,assign)NSInteger checkKind; //0代表部门,1代表总务;

@property(nonatomic,copy)NSString *applyID;
@end

//我的申领详情model
@interface WHMyApplicationDetailModel : NSObject

@property(nonatomic,retain)NSMutableArray *detailArray; //里面放WHMyDetailModel
@property(nonatomic,retain)NSMutableArray *itemListArray; //里面放WHMyItemListModel

@end

@interface WHMyDetailModel : NSObject

@property(nonatomic,copy)NSString *kindValue;
@property(nonatomic,copy)NSString *zwCheckStatus;
@property(nonatomic,copy)NSString *deptAuditOpinition;
@property(nonatomic,copy)NSString *applyDate;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *totalMoney;
@property(nonatomic,copy)NSString *zwAuditOpinition;
@property(nonatomic,copy)NSString *zwCheckUser;
@property(nonatomic,copy)NSString *departCheckUserName;
@property(nonatomic,copy)NSString *deptCheckStatus;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *reason;
@property(nonatomic,copy)NSString *deptCheckUser;
@property(nonatomic,copy)NSString *departmentName;

@end

@interface WHMyItemListModel : NSObject

@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *cost;
@property(nonatomic,copy)NSString *Money;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *goodsInfoName;

@property(nonatomic,assign)BOOL hasChooseWareHouse;
@property(nonatomic,copy)NSString *goodsInfoId; //为了提交方便,特意添加
@property(nonatomic,copy)NSString *sum;//同上
@property(nonatomic,copy)NSString *maxCount; //不可超出库房上限
@end

@interface  WHMyApplicationUseKindModel: NSObject

//@property(nonatomic,copy)NSString *grly; //个人领用
//@property(nonatomic,copy)NSString *bmly; //部门领用
//@property(nonatomic,copy)NSString *hdly; //活动领用
//@property(nonatomic,copy)NSString *pk; //盘亏
//@property(nonatomic,copy)NSString *qt; //其他

//修改为:
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@end



@interface  WHMyApplicationCheckModel: NSObject

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *makerUserName;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *warehouseId;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *productDate;
@property(nonatomic,copy)NSString *makerUserId;

@end



