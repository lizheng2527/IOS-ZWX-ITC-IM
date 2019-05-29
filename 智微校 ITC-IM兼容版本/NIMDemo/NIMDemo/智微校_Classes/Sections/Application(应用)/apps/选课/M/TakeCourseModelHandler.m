//
//  TakeCourseModelHandler.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/30.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseModelHandler.h"
#import "TakeCourseModel.h"

@implementation TakeCourseModelHandler
//{
//    TakeCourseModel *takeModel;
//}

//limit_type:   已选
//                      未选
//                      不可选:选课上限,课时上限,学分上限,时间冲突
//                      选课最大人数(已满)

+(TakeCourseModel *)returnTakeCourseModelWithDeal:(TakeCourseModel *)model
{
    TakeCourseModel *takeModel = [TakeCourseModel new];
    takeModel = model;
    NSInteger Limit_courseCount; //课时上限
    NSInteger Limit_scoreMax;   //学分上限
    NSInteger Limit_maxChoose;  //选课上限
    Limit_courseCount = [model.ecRuleModel.maxHour integerValue] / 100;
    Limit_scoreMax = [model.ecRuleModel.maxScore integerValue] / 100;
    Limit_maxChoose = [model.ecRuleModel.maxCount integerValue];
    
    NSInteger tempXueFenFlag = 0;
    NSInteger tempXuanKeFlag = 0;
    NSInteger tempKeShiFlag = 0;
//    NSString *limit_typeString = @"";
    

    NSMutableArray *allModelArray = [NSMutableArray array];
    NSMutableArray *modelArraySelect = [NSMutableArray array];
    NSMutableArray *modelArrayUnSelect = [NSMutableArray array];
    
    for (ecElectiveGroupListModel *gModel in takeModel.ecElectiveGroupList) {
        for (EcActivityCourseListModel *cModel in gModel.ecActivityCourseList) {
            [allModelArray addObject:cModel];
        }
    }
    
    //学分规则
    for (EcActivityCourseListModel *model in allModelArray) {
        if (![model.selected isEqualToString:@"0"]) {
            model.limit_type = @"已选";
            tempXueFenFlag += [model.scoreStr integerValue];
            [modelArraySelect addObject:model];
        }
        else
        {
            [modelArrayUnSelect addObject:model];
            model.limit_type = @"未选";
        }
    }
    
    for (EcActivityCourseListModel *model in allModelArray) {
        if ([model.limit_type isEqualToString:@"未选"]) {
            if ([model.scoreStr integerValue] + tempXueFenFlag > Limit_scoreMax) {
                model.limit_type = @"学分上限";
                model.limit_labelString = @"超出学分";
                model.limit_alertString = [NSString stringWithFormat:@"超出学分上限 [%ld]",Limit_scoreMax];
            }
        }
    }
    
    //选课上限
    for (EcActivityCourseListModel *model in allModelArray) {
        if ([model.selectedNum isEqualToString:model.maxCount] && ![self isBlankString:model.maxCount] && [model.selected integerValue] == 0) {
            model.limit_type = @"已满";
            model.limit_labelString = @"已满";
        }
    }
    
    //课时规则
    for (EcActivityCourseListModel *model in allModelArray) {
        if (![model.selected isEqualToString:@"0"]) {
            model.limit_type = @"已选";
            tempKeShiFlag += [model.hourStr integerValue];
        }
        else
        {
            if ([self isBlankString:model.limit_type]) {
                model.limit_type = @"未选";
            }
        }
    }
    for (EcActivityCourseListModel *model in allModelArray) {
        if ([model.limit_type isEqualToString:@"未选"]) {
            if ([model.hourStr integerValue] + tempKeShiFlag > Limit_courseCount) {
                model.limit_type = @"课时上限";
                model.limit_labelString = @"超出课时";
                model.limit_alertString = [NSString stringWithFormat:@"超出课时上限 [%ld]",Limit_courseCount];
            }
        }
    }
    
    
    //选课上限
    tempXuanKeFlag = 0;
    for (EcActivityCourseListModel *sModel in modelArraySelect) {
        tempXuanKeFlag ++;
        if (tempXuanKeFlag == Limit_maxChoose) {
            for (EcActivityCourseListModel *unsModel in modelArraySelect) {
                if ([self isBlankString:unsModel.limit_type]) {
                    unsModel.limit_type = @"选课上限";
                    unsModel.limit_labelString = [NSString stringWithFormat:@"超出选课上限 [%ld]",Limit_maxChoose];
                }
            }
        }
    }
    
    //时间冲突
    if ([model.ecRuleModel.classTimeFlag isEqualToString:@"0"]) {
        for (EcActivityCourseListModel *selectModel in modelArraySelect) {
            if (![self isBlankString:selectModel.time]) {
                NSArray *selectWeek = [(NSString *)[selectModel.time componentsSeparatedByString:@";"][0] componentsSeparatedByString:@","];
                NSArray *selectDay = [(NSString *)[selectModel.time componentsSeparatedByString:@";"][1] componentsSeparatedByString:@","];
                for (EcActivityCourseListModel *unsModel in modelArrayUnSelect) {
                    if (![self isBlankString:unsModel.time]) {
                        NSArray *weeks = [(NSString *)[unsModel.time componentsSeparatedByString:@";"][0] componentsSeparatedByString:@","];
                        NSArray *Days = [(NSString *)[unsModel.time componentsSeparatedByString:@";"][1] componentsSeparatedByString:@","];
                        if ([self is:selectWeek isConflictTo:weeks] && [self is:selectDay isConflictTo:Days]) {
                            unsModel.limit_type = @"时间冲突";
                            unsModel.limit_labelString = @"时间冲突";
                            unsModel.limit_alertString = [NSString stringWithFormat:@"上课时间与 [%@] 冲突",selectModel.courseDisplayName];
                        }
                    }
                }
            }
        }
    }
    
    
    //几选几   提示:课程冲突 - 最大选
    tempXuanKeFlag = 0;
    for (EcRuleCourseListModel *ruleListModel in model.ecRuleModel.courseList) {
        for (courseModel *courseModel in ruleListModel.ruleListArray) {
            for (EcActivityCourseListModel *sModel in modelArraySelect) {
                if ([sModel.courseId isEqualToString:courseModel.courseId]) {
                    tempXuanKeFlag += 1;
                }
            }
        }
        if (tempXuanKeFlag == [ruleListModel.maxQuantity integerValue]) {
            for (EcActivityCourseListModel *unsModel in modelArrayUnSelect ) {
                for (courseModel *courseModel in ruleListModel.ruleListArray) {
                    if ( [courseModel.courseId isEqualToString:unsModel.courseId]) {
                        if (![unsModel.limit_type isEqualToString:@"已满"]) {
                            unsModel.limit_type = @"选课冲突";
                            unsModel.limit_labelString = @"选课冲突";
                            unsModel.limit_alertString = [self dealEcRuleModelWithMaxChoose:ruleListModel];
                        }
                    }
                }
            }
        }
        tempXuanKeFlag = 0;
    }
    
    //封板规则
    for (EcActivityCourseListModel *model in allModelArray) {
        if ([model.versioned isEqualToString:@"1"]) {
            model.limit_type = @"已封版";
//            if (![model.selected isEqualToString:@"0"]) {
//                model.limit_type = @"已选";
//            }else
//                model.limit_type = @"未选";
            model.limit_labelString = [NSString stringWithFormat:@"已封版,%@选",[model.selected isEqualToString:@"0"]?@"未":@"已"] ;
            model.limit_alertString = @"该课程已封版关闭";
        }
    }
    
    return takeModel;
}

+(NSString *)haveSelectedLowestCourse:(TakeCourseModel *)model
{
    TakeCourseModel *takeModel = [TakeCourseModel new];
    takeModel = model;
    NSInteger Limit_courseCount; //课时上限
    NSInteger Limit_scoreMax;   //学分上限
    NSInteger Limit_maxChoose;  //选课上限
    Limit_courseCount = [model.ecRuleModel.maxHour integerValue] / 100;
    Limit_scoreMax = [model.ecRuleModel.maxScore integerValue] / 100;
    Limit_maxChoose = [model.ecRuleModel.maxCount integerValue];
    
    NSInteger tempXuanKeFlag = 0;
    
    
    NSMutableArray *allModelArray = [NSMutableArray array];
    NSMutableArray *modelArraySelect = [NSMutableArray array];
    NSMutableArray *modelArrayUnSelect = [NSMutableArray array];
    
    for (ecElectiveGroupListModel *gModel in takeModel.ecElectiveGroupList) {
        for (EcActivityCourseListModel *cModel in gModel.ecActivityCourseList) {
            [allModelArray addObject:cModel];
        }
    }
    //学分规则
    for (EcActivityCourseListModel *model in allModelArray) {
        if (![model.selected isEqualToString:@"0"]) {
            [modelArraySelect addObject:model];
        }
        else
        {
            [modelArrayUnSelect addObject:model];
        }
    }
    //几选几   提示:课程冲突 - 最小选
    tempXuanKeFlag = 0;
    for (EcRuleCourseListModel *ruleListModel in model.ecRuleModel.courseList) {
        for (courseModel *courseModel in ruleListModel.ruleListArray) {
            for (EcActivityCourseListModel *sModel in modelArraySelect) {
                if ([sModel.courseId isEqualToString:courseModel.courseId]) {
                    tempXuanKeFlag += 1;
                }
            }
        }
        if (tempXuanKeFlag < [ruleListModel.minQuantity integerValue]) {
//            for (EcActivityCourseListModel *unsModel in modelArrayUnSelect ) {
                return [self dealEcRuleModelWithMaxChoose:ruleListModel];
//            }
        }
        tempXuanKeFlag = 0;
    }
        return @"";
}

+(NSString *)dealEcRuleModelWithMaxChoose:(EcRuleCourseListModel *)model
{

    NSMutableString *ruleString = [NSMutableString string];
    NSMutableString *courseNameString = [NSMutableString string];
    NSInteger tmpCount = 0;
        for (courseModel *cmodel in model.ruleListArray) {
            if (tmpCount == 0) {
                [courseNameString appendFormat:@"[ %@",cmodel.courseName];
            }
            else
            {
                if (tmpCount < model.ruleListArray.count - 1) {
                    [courseNameString appendFormat:@",%@",cmodel.courseName];
                }
                else
                    [courseNameString appendFormat:@",%@ ] ",cmodel.courseName];
            }
            tmpCount ++;
        }
            [ruleString appendFormat:@"%@中最少选择%@门最多选择%@门",courseNameString,model.minQuantity,model.maxQuantity];

    NSString *labelString = [NSString stringWithFormat:@"%@",ruleString];
    return labelString;
}


+(NSString *)dealRuleStringWithTakeCourseModel:(TakeCourseModel *)model
{
    //学时上限:10                  Btn
    //学分上限:5分              Arrow
    //最多选课:3门
    //冲突规则:[XXX,XXX,XXX,XXX]中最少选择X门最多选择XX门; ...
    EcRuleModel *ecruleModel = [EcRuleModel new];
    ecruleModel = model.ecRuleModel;
    NSString *scoreString = [NSString stringWithFormat:@"学时上限:%ld\n学分上限:%ld分\n最多选课:%@门\n",[ecruleModel.maxHour integerValue] / 100,[ecruleModel.maxScore integerValue] / 100,ecruleModel.maxCount];
    NSMutableString *ruleString = [NSMutableString string];
    int tmpCount1 = 0;
    for(EcRuleCourseListModel *courseListmodel in ecruleModel.courseList )
    {
        NSMutableString *courseNameString = [NSMutableString string];
        int tmpCount2 = 0;
        for (courseModel *cmodel in courseListmodel.ruleListArray) {
            if (tmpCount2 == 0) {
                [courseNameString appendFormat:@"冲突规则: [%@",cmodel.courseName];
            }
            else
            {
                if (tmpCount2  >= 1 && tmpCount2 < courseListmodel.ruleListArray.count - 1) {
                    [courseNameString appendFormat:@",%@",cmodel.courseName];
                }
                else
                    [courseNameString appendFormat:@",%@] ",cmodel.courseName];
            }
            
            tmpCount2 ++;
        }
        if (tmpCount1 == 0) {
            [ruleString appendFormat:@"%@中最少选择%@门最多选择%@门",courseNameString,courseListmodel.minQuantity,courseListmodel.maxQuantity];
        }
        else
            [ruleString appendFormat:@" ; %@中最少选择%@门最多选择%@门",courseNameString,courseListmodel.minQuantity,courseListmodel.maxQuantity];
        tmpCount1++;
    }
    NSString *labelString = [NSString stringWithFormat:@"%@%@",scoreString,ruleString];
    return labelString;
}


+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(BOOL)is:(NSArray *)Aarray isConflictTo:(NSArray *)Barray
{
    for (int i = 0; i < Aarray.count; i++) {
        for (int j = 0; j < Barray.count; j++) {
            if ([Aarray[i] isEqualToString:Barray[j]]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
