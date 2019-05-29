//
//  TYHCarChooseManagerController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHCarChooseManagerController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, copy) NSString * carOrderId;

@property (nonatomic, assign) int  tag;

@property (nonatomic, strong) UIButton * optionalOne;
@property (nonatomic, strong) UIButton * optionalTwo;
@property (nonatomic, strong) UIButton * optionalThree;

@property (nonatomic, strong) NSString * optionalOneStr;
@property (nonatomic, strong) NSString * optionalTwoStr;
@property (nonatomic, strong) NSString * optionalThreeStr;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, copy) NSString * tempStatus;


@end
