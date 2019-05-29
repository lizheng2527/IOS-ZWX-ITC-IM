//
//  TYHAttendanceController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHAttendanceController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *attendanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationClickBtn;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *remarksBtn;


@end
