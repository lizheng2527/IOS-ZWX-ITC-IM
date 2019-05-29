//
//  qcsHomeworkModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/21.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface qcsHomeworkModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *idFile;
@property(nonatomic,copy)NSString *dateEnd;
@property(nonatomic,copy)NSString *dateStart;
@property(nonatomic,copy)NSString *idIcon;
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *dboGradeID;
@property(nonatomic,retain)NSDictionary *dboGrade;
@property(nonatomic,copy)NSString *dboCourseName;
@property(nonatomic,retain)NSDictionary *dboCourse;


@property(nonatomic,retain)NSMutableArray *attachmentVos;
@property(nonatomic,retain)NSMutableArray *attachmentVosModelArray;

@property(nonatomic,retain)NSMutableArray *homeworkEclasses;
@property(nonatomic,retain)NSMutableArray *homeworkEclassesModelArray;

@property(nonatomic,retain)NSMutableArray *homeworkTypes;
@property(nonatomic,retain)NSMutableArray *homeworkTypesModelArray;


@property(nonatomic,assign)BOOL shouldShowMoreButton;
@property (nonatomic, assign) BOOL isOpening;
@end


@interface qcsHomeworkItemModel : NSObject

@property(nonatomic,copy)NSString *size;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *picUrl;

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *ft;

@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *content;

@property(nonatomic,retain)NSDictionary *dboEclass;
@property(nonatomic,copy)NSString *dboEclassID;
@property(nonatomic,copy)NSString *dboEclassName;
@end


@interface qcsHomeworkMediaModel : NSObject

@property(nonatomic,copy)NSString *type;  //image Video Audio
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSURL *URL;
@property(nonatomic,copy)NSString *CoverImageName;
@property(nonatomic,retain)UIImage *CoverImage;

@property (nonatomic, copy) NSString *soundFilePath;
@property (nonatomic, assign) NSTimeInterval seconds;
@property (nonatomic, copy) NSString *mp3FilePath;
@end

//@interface LGMessageModel : NSObject
//
//@property (nonatomic, copy) NSString *soundFilePath;
//@property (nonatomic, assign) NSTimeInterval seconds;
//@property (nonatomic, copy) NSString *mp3FilePath;
//
//@end

