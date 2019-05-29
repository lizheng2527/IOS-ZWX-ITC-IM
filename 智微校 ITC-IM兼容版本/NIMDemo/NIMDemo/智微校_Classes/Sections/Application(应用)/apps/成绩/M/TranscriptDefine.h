//
//  TranscriptDefine.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#ifndef TranscriptDefine_h
#define TranscriptDefine_h
/**
 * 获取个人成绩
 * @param examId
 * @param studentId
 */
#define getStudentScoreJson	@"/ex/mobile/examMobileTerminal!getStudentScoreJson.action"
/**
 * 获 年级成绩
 * @param kind
 */
#define getGradeScoreJson @"/ex/mobile/examMobileTerminal!getGradeScoreJson.action"
/**
* 获 班级成绩
* @param eclassId
*/
#define getEclassScoreList   @"/ex/mobile/examMobileTerminal!getEclassScoreList.action"
/**
* 获取学期集合
* @param baseUrl
* @param map
*/
#define getSchoolTermAllJson @"/bd/mobile/baseData!getSchoolTermAllJson.action"

/**
* 获取exam
* @param schoolTermId
*/
#define getExamListJsonWithSchoolTermId   @"/ex/mobile/examMobileTerminal!getExamListJsonWithSchoolTermId.action"


#endif /* TranscriptDefine_h */
