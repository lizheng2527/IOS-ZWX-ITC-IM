//
//  PInMainController.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/23.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PInMainController : UIViewController

@property (strong, nonatomic)UIScrollView *topScrollView;
@property (strong, nonatomic)UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger viewTag;

@property(nonatomic,copy)NSString *navTitle;

@property(nonatomic,copy)NSString *projectID;
@end
