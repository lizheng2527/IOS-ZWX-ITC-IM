//
//  AttendanceModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceModel : NSObject
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@end

@interface AttendanceListModel : NSObject
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endAddress;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *startAddress;
@property(nonatomic,copy)NSString *typeString; //上班 or 下班

@property(nonatomic,copy)NSString *workTime;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *addressName;

@end

@interface AttendanceRemarkModel : NSObject
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *usageType;

@property(nonatomic,retain)NSMutableArray *costList;//上次报销内容
@property(nonatomic,retain)NSMutableArray *costModelArray;
@property(nonatomic,copy)NSString *status; //0代表无报销,1代表有
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,retain)NSMutableArray *costTypeList;//报销类型列表
@property(nonatomic,retain)NSMutableArray *costTypeModelArray;
@end

@interface AttendanceRemarkCostModel : NSObject
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *cost;
@property(nonatomic,copy)NSString *costID;
@end
