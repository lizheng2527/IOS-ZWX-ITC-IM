//
//  TeacherModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubTeachModel.h"
#import <MJExtension.h>
@interface TeacherModel : NSObject
/*
"id": "20121010135643197633054088551466",
"parentId": "0",
"name": "合众学校",
"userList": [
             {
                 "id": "20121128101024269739607672137452",
                 "mobileNum": "",
                 "name": "admin"
             },
 */
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray * userList;

@end
