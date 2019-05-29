//
//  CAEvaluateController.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/24.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEvaluateController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIButton *AddScoreButton;
@property (weak, nonatomic) IBOutlet UIView *AddScoreLineView;

@property (weak, nonatomic) IBOutlet UIButton *DisScoreButton;
@property (weak, nonatomic) IBOutlet UIView *DisScoreLineView;



@property(copy,nonatomic)NSString *attendanceId;
@property(copy,nonatomic)NSString *studentId;
@property(copy,nonatomic)NSString *studentName;

@end
