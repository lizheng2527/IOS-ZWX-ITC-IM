//
//  QCSMainModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


//首页Info Model
@interface QCSMainModel : NSObject

@property(nonatomic,assign)BOOL isStudentOrParent;
@property(nonatomic,assign)BOOL ws_classanalysis;
@property(nonatomic,assign)BOOL ws_classlessions;
@property(nonatomic,assign)BOOL ws_classroomreview;

@property(nonatomic,copy)NSString *eclassId;
@property(nonatomic,copy)NSString *studentId;
@property(nonatomic,copy)NSString *tempEclassID;//自己拼接
@property(nonatomic,copy)NSString *tempCourseID;//自己拼接
@property(nonatomic,retain)NSMutableArray *studentArray; //自己拼接


@property(nonatomic,retain)NSMutableArray *stuCourses;
@property(nonatomic,retain)NSMutableArray *stuCoursesModelArray;
@property(nonatomic,retain)NSMutableArray *resultGrade;
@property(nonatomic,retain)NSMutableArray *resultGradeModelArray;
@end



@interface QCSMainCLassModel : NSObject

@property(nonatomic,copy)NSString *blackboardWriteId;
@property(nonatomic,copy)NSString *classDate;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *classTime;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *questTotal;

@property(nonatomic,copy)NSString *courseID;
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *eclassID;
@property(nonatomic,copy)NSString *mobileName;


@property(nonatomic,retain)NSDictionary *course;
@property(nonatomic,retain)NSDictionary *eclass;
@end


@interface QCSMainStudentModel : NSObject

@property(nonatomic,copy)NSString *chooseSize;
@property(nonatomic,copy)NSString *classDate;
@property(nonatomic,copy)NSString *classTime;
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *stuChooseSize;
@property(nonatomic,copy)NSString *totalScore;
@property(nonatomic,copy)NSString *evaluate;
@property(nonatomic,copy)NSString *blackboardWriteId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *quickAnswer;
@property(nonatomic,copy)NSString *mobileName;

@property(nonatomic,copy)NSString *studentName;//自己拼接
@property(nonatomic,copy)NSString *studentID;//自己拼接

@property(nonatomic,retain)NSMutableArray *handwriteList;
@property(nonatomic,retain)NSMutableArray *handwriteListModelArray;
@property(nonatomic,retain)NSMutableArray *chooseList;
@property(nonatomic,retain)NSMutableArray *chooseListModelArray;

@end


@interface QCSMainStudentSXBJModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *picUrl;
@end

@interface QCSMainStudentXZTJModel : NSObject

@property(nonatomic,copy)NSString *useTime;
@property(nonatomic,copy)NSString *allPersonNum;
@property(nonatomic,copy)NSString *rightPersonNum;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *picUrl;
@property(nonatomic,copy)NSString *rightAnswer;
@property(nonatomic,copy)NSString *stuAnswer;

@property(nonatomic,retain)NSMutableArray *questUrl;

@end



//首页Info InsideModel
@interface QCSMainResultGradeModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *idMobile;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,retain)NSMutableArray *childrenEclass;
@property(nonatomic,retain)NSMutableArray *childrenEclassModelArray;

@property(nonatomic,copy)NSString *parentId;
@end


@interface QCSMainChildrenEclassModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *idMobile;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,retain)NSMutableArray *childrenCourse;
@property(nonatomic,retain)NSMutableArray *childrenCourseModelArray;

@property(nonatomic,copy)NSString *parentId;

@property(nonatomic,assign)BOOL Selected;
@end

@interface QCSMainChildrenCourseModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *idMobile;
@property(nonatomic,copy)NSString *id;

@property(nonatomic,copy)NSString *parentId;
@property(nonatomic,copy)NSString *parentMobileID;
@end

//InsideUSERModel
@interface QCSMainUserModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *displayName;
@property(nonatomic,copy)NSString *pinyin;
@property(nonatomic,copy)NSString *id;

@property(nonatomic,assign)BOOL Selected;

@end

//师生互动表

@interface QCSMainInteractionModel : NSObject

@property(nonatomic,copy)NSString *cnt;
@property(nonatomic,copy)NSString *type;

@end


//tempModel

@interface JXZTreeMainModel : NSObject

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSMutableArray *userList;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@property(nonatomic,strong) NSMutableArray *childs;

@property(nonatomic,copy)NSString *parentMobileID;

@property(nonatomic,assign)BOOL isChoose;
@end

@interface JXZTreeDetailModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *parentId;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@property (strong, nonatomic) NSString *name;

@end







