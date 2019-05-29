//
//  ProjectMainModel.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/1.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMainModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *buildDate;
@property(nonatomic,copy)NSString *buildUserName;
@property(nonatomic,copy)NSString *clientName;
@property(nonatomic,copy)NSString *inOrNot;
@property(nonatomic,copy)NSString *projectName;
@property(nonatomic,copy)NSString *status;

@end

@interface ProjectListDetailModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *applyTime;
@property(nonatomic,copy)NSString *applyerName;
@property(nonatomic,copy)NSString *bidOrNot;
@property(nonatomic,copy)NSString *bidRate;
@property(nonatomic,copy)NSString *clientLeader;
@property(nonatomic,copy)NSString *clientLeaderPhone;
@property(nonatomic,copy)NSString *clientName;
@property(nonatomic,copy)NSString *competitors;
@property(nonatomic,copy)NSString *contractAmount;
@property(nonatomic,copy)NSString *getbidTime;
@property(nonatomic,copy)NSString *maoli;
@property(nonatomic,copy)NSString *maoliLv;
@property(nonatomic,copy)NSString *partner;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *preCost;
@property(nonatomic,copy)NSString *projectDescribe;
@property(nonatomic,copy)NSString *projectFrom;
@property(nonatomic,copy)NSString *projectName;

@end




//拜访记录列表
@interface ProjectVisitRecordListModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *visitObject;  //拜访对象
@property(nonatomic,copy)NSString *visitTime;    //拜访时间
@property(nonatomic,copy)NSString *visitor;   //拜访人

@end

//服务记录列表
@interface ProjectServiceRecordListModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *serviceObject;   // 服务对象
@property(nonatomic,copy)NSString *serviceSketch;    //服务简述
@property(nonatomic,copy)NSString *serviceTime;    //服务时间
@property(nonatomic,copy)NSString *serviceor;    //服务人姓名

@property(nonatomic,copy)NSString *applyUserName;
@end

//服务申请列表
@interface ProjectServiceApplyListModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *applyUserName;    //申请人姓名
@property(nonatomic,copy)NSString *checkLimit;   //审核权限
@property(nonatomic,copy)NSString *serviceObject;    //服务对象
@property(nonatomic,copy)NSString *serviceSketch;    //服务简述
@property(nonatomic,copy)NSString *serviceTime;    //服务时间
@property(nonatomic,copy)NSString *status;    //状态

@property(nonatomic,copy)NSString *projectName;  //审核cell添加
@property(nonatomic,copy)NSString *check;   //审核cell添加
@end


@interface ProjectPermissionModel : NSObject

@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *hasPermission;   // 服务对象
@end
