//
//  AssetSearchController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetSearchController : UIViewController
@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *typeStringWithChoose;
@property(nonatomic,copy)NSString *startDateString;
@property(nonatomic,copy)NSString *endDateString;
@property(nonatomic,copy)NSString *IDschool;
@property(nonatomic,copy)NSString *IDarea;
@property(nonatomic,copy)NSString *IDtype;
@property(nonatomic,copy)NSString *IDBrand;
@property(nonatomic,copy)NSString *IDguige;

@property(nonatomic,copy)NSString *searchNameString;
@property(nonatomic,copy)NSString *searchCodeString;

@end
