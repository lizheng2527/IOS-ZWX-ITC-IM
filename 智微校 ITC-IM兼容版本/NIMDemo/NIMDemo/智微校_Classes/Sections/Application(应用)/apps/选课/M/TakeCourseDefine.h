//
//  TakeCourseDefine.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#ifndef TakeCourseDefine_h
#define TakeCourseDefine_h

/**
 * 到选课说明页面 参数:无
 * 返回 ecActivityId 选课活动id ecActivityNote 选课说明 userId 当前用户id
*/
#define  courseDetailNote @"/ec/mobile/ecMobileTerminal!toElectiveCourseNote.action"

/**
 *            到我的选课 参数：无
 *            schoolTermInfoList 学期集合 key-id，fullName，startDate
 *            schoolTermStudentCourseMap 学期对应的学生选课，key-学期id，value-学生选的课
 *            schoolTermSumScoreMap 学期对应的总学分，key-学期id，value-总学分
 */
#define myCourse @"/ec/mobile/ecMobileTerminal!toMyElectiveCourse.action"

/**
 * @param baseUrl
 * @param map
 * @return 到学生选课 参数：userId ecActivityId preview
 *         路径：/ec/mobile/ecMobileTerminal!toElectiveCourse.action 返回 .....
 *
 *         ecActivity 选课活动信息key-id，kind（活动类型--0校本选课,1分班选课）
 *
 *         electiveRuleMap
 *         限制条件（课时上限、学分上限、数量上限、几选几、选课最大人数--校本、时间冲突是否允许选择--校本）
 *         key-maxHour课时上限
 *         ，maxScore学分上限，maxCount数量上限，classTimeFlag时间冲突是否允许选择1允许
 *         0不允许，ruleList
 *         ruleList是规则的集合，集合里是map-key：minQuantity（最少选几个），maxQuantity
 *         （最多选几个），courseList（课程集合，内有属性courseId,courseName）
 *
 *         ecElectiveGroupList
 *         所有组的集合，groupId，groupName，groupNum,ecActivityCourseList
 *         (内有属性id-活动课程id，courseId-bd课程，courseDisplayName，selected-学生是否已选
 *         是1（字符串的1），否0，versioned-是否封板 是1，否0，selectedNum-课程已选数量)
 *
 *         ecAlternativeCourse
 *         备选课程key-alternative1Id，alternative2Id（这个就是活动课程的id）
 *
 *         currentUser 当前用户id preview 是否预览，貌似没用
 */
#define  ElectiveCourse @"/ec/mobile/ecMobileTerminal!toElectiveCourse.action"


/**
 *            保存选课结果 参数：courseIds（bd的课程id字符串，以逗号分隔） ecActivityId（选课活动id）
 *            alternativeCourse1（备选课程1id） alternativeCourse2 （备选课程2id）
 *            选课结果信息集合（长度是2），【0】saveSuccessMsg ，【1】saveFailedMsg
 */
#define  saveElectiveCourse @"/ec/mobile/ecMobileTerminal!saveElectiveCourse.action"

#endif
/*
 
 TakeCourseDe
 fine_h */
