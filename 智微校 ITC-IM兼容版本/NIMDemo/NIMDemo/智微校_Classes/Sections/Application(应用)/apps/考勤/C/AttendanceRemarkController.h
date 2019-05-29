//
//  AttendanceRemarkController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceRemarkController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
