//
//  MyRepairApplicationModel.h
//  NIM
//
//  Created by 中电和讯 on 17/3/23.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRepairApplicationModel : NSObject

@property(nonatomic,copy)NSString *DeviceName;	//报修物品名称
@property(nonatomic,copy)NSString *applyTime;	//报修时间
@property(nonatomic,copy)NSString *faultDescription;	//故障描述
@property(nonatomic,copy)NSString *repairID;	//报修单Id
@property(nonatomic,copy)NSString *malfunction;	//故障现象
@property(nonatomic,copy)NSString *placeName; //报修地点名称

@property(nonatomic,copy)NSString *statusCode;
@property(nonatomic,copy)NSString *checkStatus;
@property(nonatomic,copy)NSString *statusView;
@property(nonatomic,copy)NSString *userId;

//@property(nonatomic,retain)NSMutableArray *status; //报修单状态Array
//@property(nonatomic,retain)NSMutableArray *statusModelArray; ////报修单状态modelArray
@end


@interface MRAServerInfoModel : NSObject //维修信息

@property(nonatomic,copy)NSString *costApplication;
@property(nonatomic,copy)NSString *malfunctionKind;
@property(nonatomic,copy)NSString *malfunctionReason;
@property(nonatomic,copy)NSString *repairStatus;
@property(nonatomic,copy)NSString *repairTime;
@property(nonatomic,copy)NSString *workerName;

@property(nonatomic,retain)NSMutableArray *repairImageList;
@property(nonatomic,retain)NSMutableArray *goodsSum;
@property(nonatomic,retain)NSMutableArray *goodsSumModelArray;
@end




@interface MRARequestInfoModel : NSObject //报修信息
@property(nonatomic,copy)NSString *deviceName;
@property(nonatomic,copy)NSString *faultDescription;
@property(nonatomic,copy)NSString *malfunction;
@property(nonatomic,copy)NSString *malfunctionPlace;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *requestTime;
@property(nonatomic,copy)NSString *requestUserName;

@property(nonatomic,retain)NSMutableArray *imageList;
@end


@interface MRAFeedBackInfoModel : NSObject //维修信息

@property(nonatomic,copy)NSString *attitudeStr;
@property(nonatomic,copy)NSString *qualityStr;
@property(nonatomic,copy)NSString *scoreStr;
@property(nonatomic,copy)NSString *speedStr;
@property(nonatomic,copy)NSString *technicalLevelStr;

@property(nonatomic,copy)NSString *suggestion;

@property(nonatomic,copy)NSString *repairFlag;

@property(nonatomic,retain)NSMutableArray *repairImageList;
//@property(nonatomic,retain)NSMutableArray *repairImageListModelArray;
@end


@interface MRAServerReocrdModel : NSObject //维修记录
@property(nonatomic,copy)NSString *recordContent;
@property(nonatomic,copy)NSString *recordTime;
@end
