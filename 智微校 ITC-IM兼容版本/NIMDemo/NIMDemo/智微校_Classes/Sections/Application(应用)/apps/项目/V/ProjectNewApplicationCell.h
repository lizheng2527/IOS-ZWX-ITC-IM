//
//  ProjectNewApplicationCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectNewApplicationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyUserPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *projectFromButton;
@property (weak, nonatomic) IBOutlet UITextField *projectBitRateTextfield;
@property (weak, nonatomic) IBOutlet UIButton *projectBidDateButton;

@property (weak, nonatomic) IBOutlet UITextField *clientNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *clientPersonTextfield;
@property (weak, nonatomic) IBOutlet UITextField *clientPhoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *contractAmountTextfield; //预估合同额
@property (weak, nonatomic) IBOutlet UITextField *preCostTextfield;
@property (weak, nonatomic) IBOutlet UITextField *maoliTextfield;
@property (weak, nonatomic) IBOutlet UITextField *maoLiLvTextfield;

@property (weak, nonatomic) IBOutlet UIButton *bidYESButton;
@property (weak, nonatomic) IBOutlet UILabel *bidYESLabel;
@property (weak, nonatomic) IBOutlet UIButton *bidNoButton;
@property (weak, nonatomic) IBOutlet UILabel *bidNoLabel;


@property (weak, nonatomic) IBOutlet UITextView *textView_Describe;
@property (weak, nonatomic) IBOutlet UITextView *textView_Opponent;
@property (weak, nonatomic) IBOutlet UITextView *textView_Partner;
@end
