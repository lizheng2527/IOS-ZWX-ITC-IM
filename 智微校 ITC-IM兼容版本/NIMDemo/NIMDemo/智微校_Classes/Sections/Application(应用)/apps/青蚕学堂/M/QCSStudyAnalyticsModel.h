//
//  QCSStudyAnalyticsModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/28.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSStudyAnalyticsModel : NSObject

@property(nonatomic,retain)NSMutableArray *courseData;
@property(nonatomic,retain)NSMutableArray *courseDataModelArray;

@property(nonatomic,retain)NSMutableArray *gradeData;
@property(nonatomic,retain)NSMutableArray *gradeDataModelArray;

@property(nonatomic,retain)NSMutableArray *shcoolData;
@property(nonatomic,retain)NSMutableArray *shcoolDataModelArray;


@property(nonatomic,assign)BOOL isGroupSchool;
@property(nonatomic,assign)BOOL ws_analysisClass;
@property(nonatomic,assign)BOOL ws_analysisIndex;
@property(nonatomic,assign)BOOL ws_analysisSchool;
@property(nonatomic,assign)BOOL ws_analysisSchoolGroup;
@property(nonatomic,assign)BOOL ws_analysisStudent;

@end

@interface QCSStudyAnalyticsItemModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *schoolFlag;

@end

//@interface QCSStudyAnalyticsSchoolModel : NSObject
//
//
//@end

