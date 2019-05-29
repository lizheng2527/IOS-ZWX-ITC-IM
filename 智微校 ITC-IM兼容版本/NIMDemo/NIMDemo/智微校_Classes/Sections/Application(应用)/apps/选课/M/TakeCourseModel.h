//
//  TakeCourseModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ecActivityModel;
@class EcRuleModel;

@interface TakeCourseModel : NSObject

@property(nonatomic,copy)NSString *currentUser;
@property(nonatomic,retain)NSDictionary *ecActivity;
@property(nonatomic,retain)NSDictionary *ecAlternativeCourse;
@property(nonatomic,retain)NSMutableArray *ecElectiveGroupList;
@property(nonatomic,retain)ecActivityModel *ecActivitymodel;
@property(nonatomic,retain)EcRuleModel *ecRuleModel;
@end

@interface ecElectiveGroupListModel : NSObject

@property(nonatomic,retain)NSMutableArray *ecActivityCourseList;
@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,copy)NSString *groupName;
@property(nonatomic,copy)NSString *groupNum;
@end

@interface EcActivityCourseListModel : NSObject

@property(nonatomic,strong)NSString *courseDisplayName;
@property(nonatomic,strong)NSString *teacherName;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *scoreStr;
@property(nonatomic,strong)NSString *hourStr;
@property(nonatomic,strong)NSString *maxCount;
@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSString *courseId;
@property(nonatomic,strong)NSString *selectedNum;
@property(nonatomic,strong)NSString *selected; // 0 代表未选中,1代表选中
@property(nonatomic,strong)NSString *ecCourseId;
@property(nonatomic,strong)NSString *classTimeOfWeekStr;
@property(nonatomic,strong)NSString *ecActivityID;
@property(nonatomic,strong)NSString *versioned;
@property(nonatomic,strong)NSString *limited;

//自己添加的model属性
@property(nonatomic,copy)NSString *limit_labelString;  //不符合规则label的string提示
@property(nonatomic,copy)NSString *limit_alertString; //点击不符合规则图像的提示语
@property(nonatomic,copy)NSString *limit_type; //不符合类型

@end

@interface ecActivityModel : NSObject
@property(nonatomic,copy)NSString *ecActivityID;
@property(nonatomic,copy)NSString *ecActivityKind;
@end

#pragma mark - 开始选课model
@interface BeginTakeCourseModel : NSObject
@property(nonatomic,copy)NSString *ecActivityId;
@property(nonatomic,copy)NSString *ecActivityNote;
@property(nonatomic,copy)NSString *userId;
@end

#pragma mark - 我的选课model
@interface SchoolTermInfoListModel : NSObject
@property(nonatomic,copy)NSString *schoolTermID;
@property(nonatomic,copy)NSString *fullName;
@property(nonatomic,copy)NSString *startDate;

@property(nonatomic,copy)NSString *sumScore; //额外添加

@property(nonatomic,retain)NSMutableArray *courseArray; //额外添加

@end

@interface schoolTermStudentCourseModel : NSObject
@property(nonatomic,copy)NSString *courseDisplayName;
@property(nonatomic,copy)NSString *ecActivityCourseId;
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *teacherName;
@property(nonatomic,copy)NSString *schoolTermStartDate;
@property(nonatomic,copy)NSString *scoreStr;
@property(nonatomic,copy)NSString *evaluate; //0 1 2 3  优秀 良好 及格 不及格
@end


#pragma mark - 学生选课相关model
// 以下三个是规则相关Model
@interface EcRuleModel : NSObject
@property(nonatomic,copy)NSString *classTimeFlag;
@property(nonatomic,copy)NSString *maxCount;
@property(nonatomic,copy)NSString *maxHour;
@property(nonatomic,copy)NSString *maxScore;

@property(nonatomic,retain)NSMutableArray *courseList;
@end

@interface EcRuleCourseListModel : NSObject    //EcRuleModel里的ruleListModel

@property(nonatomic,retain)NSMutableArray *ruleListArray;
@property(nonatomic,copy)NSString *maxQuantity;
@property(nonatomic,copy)NSString *minQuantity;

@end

@interface courseModel : NSObject  //ruleList里的courseModel

@property(nonatomic,copy)NSString *courseId;
@property(nonatomic,copy)NSString *courseName;

@end
