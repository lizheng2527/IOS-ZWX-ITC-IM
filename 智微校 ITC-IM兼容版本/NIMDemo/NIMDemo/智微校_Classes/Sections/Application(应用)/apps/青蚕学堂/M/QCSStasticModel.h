//
//  QCSStasticModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

//习题统计
@interface QCSStasticModel : NSObject

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)NSString *countStr;
@property(nonatomic,copy)NSString *option;
@property(nonatomic,copy)NSString *percentStr;
@property(nonatomic,copy)NSString *rightAnswer;
@property(nonatomic,retain)NSMutableArray *optionList;
@property(nonatomic,retain)NSMutableArray *optionListModelArray;

@property(nonatomic,copy)NSString *orderNumber;
@end

//答题榜,抢答榜,评价榜
@interface QCSStasticListModel : NSObject

@property(nonatomic,copy)NSString *displayName;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,retain)NSDictionary *student;

@property(nonatomic,copy)NSString *orderNumber;

@property(nonatomic,copy)NSString *quickAnswerNum;
@property(nonatomic,copy)NSString *evaluateCount;
@property(nonatomic,copy)NSString *answerNum;
@property(nonatomic,copy)NSString *modelType;

@end


//综合评价
@interface QCSStasticComprehensiveModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *range;
@property(nonatomic,copy)NSString *studentName;
@property(nonatomic,copy)NSString *totalScore;

@property(nonatomic,copy)NSString *orderNumber;
@end





