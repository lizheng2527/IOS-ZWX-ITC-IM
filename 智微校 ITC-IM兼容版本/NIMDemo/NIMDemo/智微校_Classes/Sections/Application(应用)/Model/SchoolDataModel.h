//
//  SchoolDataModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/14/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolDataModel : NSObject
/*
 carData =         (
 );
 isScope = 1;
 schoolId = 20150702162118397551505993240121;
 schoolName = "\U660c\U5e73\U897f\U6821\U521d\U4e2d\U90e8";
 */


@property (nonatomic, assign) BOOL isScope;
@property (nonatomic, assign) BOOL isCurrSchool;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *schoolName;

// 模型数组
@property (nonatomic, copy) NSArray *carData;

@end
