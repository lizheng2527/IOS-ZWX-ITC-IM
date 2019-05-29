//
//  TYHReverseCarController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/6/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendBlock)(NSDictionary * json);


@interface TYHReverseCarController : UIViewController

@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* password;

@property (nonatomic, copy) NSString * department;
@property (nonatomic, copy) NSString * departmentId;

@property (nonatomic, copy) SendBlock sendBlock;

-(void)didselectedCarDepartment:(NSString *)departID DepartmentName:(NSString *)name;

@end
