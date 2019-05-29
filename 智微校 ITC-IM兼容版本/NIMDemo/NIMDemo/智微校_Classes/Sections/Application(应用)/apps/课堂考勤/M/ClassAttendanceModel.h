//
//  ClassAttendanceModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CAEvaluateRecordModel;

@interface ClassAttendanceModel : NSObject

@end


@interface CAWeekModel: NSObject

@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *isCurrent;
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *number;

@end

@interface CAEvaluateMainModel: NSObject

@property(nonatomic,retain)NSMutableArray *deductionListModelArray;
@property(nonatomic,retain)NSMutableArray *deductionList;

@property(nonatomic,retain)NSMutableArray *bonusPointListModelArray;
@property(nonatomic,retain)NSMutableArray *bonusPointList;

@property(nonatomic,retain)CAEvaluateRecordModel *recordModel;
@property(nonatomic,retain)CAEvaluateRecordModel *recordList;
@end

@interface CAEvaluateRecordModel: NSObject

@property(nonatomic,retain)NSMutableArray *detailListListModelArray;
@property(nonatomic,retain)NSMutableArray *detailList;

@property(nonatomic,copy)NSString *addScore;
@property(nonatomic,copy)NSString *minusScore;
@end

@interface CAEvaluateItemModel: NSObject

@property(nonatomic,copy)NSString *defaultNum;
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *score;

@property(nonatomic,copy)NSString *max;
@property(nonatomic,copy)NSString *min;

@property(nonatomic,assign)BOOL isSelected;
@end




