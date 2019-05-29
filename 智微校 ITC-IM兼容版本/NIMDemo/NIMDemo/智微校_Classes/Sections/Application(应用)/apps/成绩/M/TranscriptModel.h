//
//  TranscriptModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranscriptModel : NSObject
@property(nonatomic,copy)NSString *fullName;
@property(nonatomic,copy)NSString *terminalID;
@property(nonatomic,copy)NSString *status; //0代表非本学期,1代表本学期,只有1个1
@end

@interface ExamListModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *examID;
@end

@interface StudentScoreModel : NSObject
@property(nonatomic,copy)NSString *eclassAvg;
@property(nonatomic,copy)NSString *gradeAvg;
@property(nonatomic,copy)NSString *gradeRank;
@property(nonatomic,copy)NSString *eclassRank;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *gradeMax;
@property(nonatomic,copy)NSString *eclassMax;
@property(nonatomic,copy)NSString *courseName;
@end