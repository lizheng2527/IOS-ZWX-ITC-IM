//
//  PAddServiceApplyCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAddServiceApplyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyUserPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeButton;

@property (weak, nonatomic) IBOutlet UITextField *serviceWaysTextfield;
@property (weak, nonatomic) IBOutlet UITextField *servicePlaceTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceSchoolTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceCustomTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceLinkerTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceLinkerPhoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *serviceLinkerMailTextfield;



@property (weak, nonatomic) IBOutlet UITextView *textView_Jianshu;
@property (weak, nonatomic) IBOutlet UITextView *textView_Target;
@property (weak, nonatomic) IBOutlet UITextView *textView_Member;
@property (weak, nonatomic) IBOutlet UITextView *textView_Remark;

@end
