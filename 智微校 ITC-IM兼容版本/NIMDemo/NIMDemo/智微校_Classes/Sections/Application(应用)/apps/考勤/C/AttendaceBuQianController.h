//
//  AttendaceBuQianController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendaceBuQianController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *endTime;
@end
