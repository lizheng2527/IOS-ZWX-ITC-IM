//
//  PAddServerRecordCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAddServerRecordCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *applyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyUserPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeButton;

@property (weak, nonatomic) IBOutlet UITextField *serviceWaysTextfield;
@property (weak, nonatomic) IBOutlet UITextField *servicePlaceTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceCustomTextfield;
@property (weak, nonatomic) IBOutlet UITextField *schoolLinkerTextfield;
@property (weak, nonatomic) IBOutlet UITextField *schoolLinkerPhoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceAddPersonTextfield;

@property (weak, nonatomic) IBOutlet UITextView *textView_Jianshu;
@property (weak, nonatomic) IBOutlet UITextView *textView_Target;
@property (weak, nonatomic) IBOutlet UITextView *textView_Member;
@property (weak, nonatomic) IBOutlet UITextView *textView_SelfGrade;
@property (weak, nonatomic) IBOutlet UITextView *textView_Remark;

@end
