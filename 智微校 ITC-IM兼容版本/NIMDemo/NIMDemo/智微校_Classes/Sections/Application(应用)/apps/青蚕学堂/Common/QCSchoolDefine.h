//
//  QCSchoolDefine.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#ifndef QCSchoolDefine_h
#define QCSchoolDefine_h

#import "LYEmptyViewHeader.h"
#import "QCSSourceHandler.h"
#import "QCSchoolTagHandle.h"


#pragma mark - Colors

//主题色
#define QCSThemeColor colorWithRed:95/255.0 green:206/255.0 blue:156/255.0 alpha:1

#define QCSBackgroundColor colorWithRed:241/255.0 green:247/255.0 blue:255/255.0 alpha:1

#define QCSTitleTextColor colorWithRed:183/255.0 green:241/255.0 blue:213/255.0 alpha:0.9




#pragma mark - URLs
//--首页以及课程和学生
#define url_GetBaseDataInfo @"ws/wisdomclass/getBaseDataInfo" //首页info
#define url_GetStudentLists @"ws/wisdomclass/getStudentsWithEclassId" //获取学生列表
#define url_GetClassList @"ws/wisdomclass/getWisdomclassWithOptions" //获取课程列表
#define url_GetStudentClassList @"ws/wisdomclass/getWisdomclassWithOptionsStudentId" //获取学生和其课程列表


//--统计报表
#define url_GetStasticXTTJ @"ws/wisdomclassstatis/chooseQuestionStatistics" ////习题统计
#define url_GetStasticBangDan @"ws/wisdomclassstatis/studentStatistics" //答题榜,抢答榜,评价榜
#define url_GetStasticZongHe @"ws/wisdomclassstatis/comprehensiveStatistics" //综合评价


//--课堂详情
#define url_GetClassDetailSXBJ_JXKJ @"ws/wisdomclass/getWisdomclassDetailWithType" //手写笔记   和  教学课件
#define url_GetClassDetailXZT @"ws/wisdomclass/getQuestionChooseDetailWithwisdomclassId" //选择题
#define url_GetClassDetailBSJL @"ws/wisdomclass/getAttachmentsBlackboardWriteWithWisdomclassId" //板书记录

#define url_GetClassDetailSXBJDetail @"ws/wisdomclass/getQuestionDetailWithInteractionId" //如果是课堂进来 - 有课堂手写笔记列表


//--师生互动表
#define url_GetTeacherStudentInteraction @"ws/wisdomclassstatis/interactionStatistics"


//--学情分析基础数据
#define url_GetStudyAnalysisbaseQueryData @"ws/wisdomclassAnalysis/baseQueryData"




//--课后作业
#define url_GetCoursesByGradeId @"ws/wisdomclassexternal/getCoursesByGradeId"

#define url_GetHomeworkPage @"ws/homework/getHomeworkPage" //获取作业主页作业列表

#define url_DelHomeworkItem @"ws/homework/delete" //删除作业主页作业列表的某项

#define url_SaveOrUpdateMobile @"ws/homework/saveOrUpdateMobile" //提交作业

#endif /* QCSchoolDefine_h */
