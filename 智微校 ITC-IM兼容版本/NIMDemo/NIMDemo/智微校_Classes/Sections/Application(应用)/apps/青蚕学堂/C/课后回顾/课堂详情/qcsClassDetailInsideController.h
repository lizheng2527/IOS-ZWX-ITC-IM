//
//  qcsClassDetailInsideController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassDetailInsideController : UIViewController

@property(nonatomic,assign)NSInteger viewTag;
@property(nonatomic,copy)NSString *viewTitle;

@property(nonatomic,copy)NSString *wisdomclassId;
@property(nonatomic,copy)NSString *userType;

@property(nonatomic,retain)NSMutableArray *studentSXBJDatasource;
@property(nonatomic,retain)NSMutableArray *studentXZTDatasource;

@end
