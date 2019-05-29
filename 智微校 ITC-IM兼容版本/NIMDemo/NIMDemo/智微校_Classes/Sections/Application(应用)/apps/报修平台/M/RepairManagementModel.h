//
//  RepairManagementModel.h
//  NIM
//
//  Created by 中电和讯 on 17/3/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairManagementModel : NSObject

@property(nonatomic,copy)NSString *DeviceName;	//报修物品名称
@property(nonatomic,copy)NSString *applyTime;	//报修时间
@property(nonatomic,copy)NSString *faultDescription;	//故障描述
@property(nonatomic,copy)NSString *repairID;	//报修单Id
@property(nonatomic,copy)NSString *malfunction;	//故障现象
@property(nonatomic,copy)NSString *placeName; //报修地点名称

@property(nonatomic,copy)NSString *statusCode;
@property(nonatomic,copy)NSString *statusView;
@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSString *requestUserName;
@property(nonatomic,copy)NSString *requestUserPhone;

@property(nonatomic,copy)NSString *checkStatus;
@property(nonatomic,copy)NSString *costApplication;
@end


//可派人员Model
@interface RMServerWorkerModel : NSObject

@property(nonatomic,copy)NSString *sameKindWorkCount;
@property(nonatomic,copy)NSString *workerId;
@property(nonatomic,copy)NSString *workerName;
@property(nonatomic,copy)NSString *workingCount;

@property(nonatomic,assign)BOOL isSelected;
@end


