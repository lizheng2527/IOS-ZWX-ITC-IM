//
//  TYHUploadNewStateController.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class classModel;

@interface TYHUploadNewStateController : UIViewController

@property(assign,nonatomic)BOOL isClassPaper;

@property(nonatomic,retain)classModel *tmpClassModel;

@property(nonatomic,retain)NSMutableArray *classArray;

@end
