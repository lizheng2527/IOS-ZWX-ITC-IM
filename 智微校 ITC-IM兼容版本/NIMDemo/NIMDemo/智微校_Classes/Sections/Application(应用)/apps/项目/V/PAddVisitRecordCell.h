//
//  PAddVisitRecordCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAddVisitRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseStartDateButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseEndDateButton;

@property (weak, nonatomic) IBOutlet UITextField *visitWaysTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitPlaceTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitSchoolTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitCustomTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitLinkerTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitLinkerPhoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitLinkerEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextView *visitReasonTextView;
@property (weak, nonatomic) IBOutlet UITextView *togetherMemberTextView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextview;
@property (weak, nonatomic) IBOutlet UITextView *visitJianshuTextview;

@end
