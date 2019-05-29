//
//  AssetCheckController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCheckController : UIViewController

@property (strong, nonatomic)UIScrollView *topScrollView;
@property (strong, nonatomic)UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger viewTag;

@end
