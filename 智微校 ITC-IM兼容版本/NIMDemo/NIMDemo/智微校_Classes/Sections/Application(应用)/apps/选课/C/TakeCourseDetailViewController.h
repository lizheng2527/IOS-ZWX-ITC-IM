//
//  TakeCourseDetailViewController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeCourseDetailViewController : UIViewController
@property(nonatomic,assign)BOOL isTakeCourseViewGoin;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,copy)NSString *ecActivityCourseId;

@property(nonatomic,retain)NSMutableArray *indexPathRowArray;

@end
