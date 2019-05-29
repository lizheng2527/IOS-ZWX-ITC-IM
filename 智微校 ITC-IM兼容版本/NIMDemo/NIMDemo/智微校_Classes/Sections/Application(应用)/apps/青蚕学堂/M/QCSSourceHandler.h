//
//  QCSSourceHandler.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSSourceHandler : NSObject

+(NSMutableArray *)getMainItemSourceWithUserKind:(NSString *)userKind;

+(NSMutableArray *)getCommonItemSource;

+(NSString *)getImageBaseURL;

+(NSString *)getSubjectBackgroundImageWithCourseName:(NSString *)courseName;

+(NSString *)getDateToday;

+(NSString *)getDateOneYearBefore;

+(NSMutableArray *)getTreeArrayAfterDeal:(NSMutableArray *)needDealArray;

+(NSMutableArray *)getHomeworkChooseTypeArray;



+(NSMutableArray *)getStudyAnalyticsArrayClass;
+(NSMutableArray *)getStudyAnalyticsArrayStudent;


+(UIImage *)getCoverImageByVideoURL:(NSURL *)url;
@end

@interface QCSSourceModel : NSObject

@property(nonatomic,copy)NSString *itemTitle;
@property(nonatomic,copy)NSString *itemDescribition;
@property(nonatomic,copy)NSString *itemImageString;

@property(nonatomic,copy)NSString *typeNum;


//临时添加
@property(nonatomic,assign)BOOL isExpand;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *parentLevel;

@end


