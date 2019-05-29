
//
//  AssetApplyController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/22.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface AssetApplyController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *TFApplyDate;
@property (weak, nonatomic) IBOutlet UITextField *TFApplyBuMen;
@property (weak, nonatomic) IBOutlet UITextField *TFApplyType;
@property (weak, nonatomic) IBOutlet UITextField *TFApplyPerson;
@property (weak, nonatomic) IBOutlet UITextField *TFApplySchoolArea;
@property (weak, nonatomic) IBOutlet UITextField *TFApplyNeed;
@property (weak, nonatomic) IBOutlet UITextField *TFApplyUsage;

@property (weak, nonatomic) IBOutlet UIButton *applyDateBtn;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollview;


@property(nonatomic,copy)NSString *tfApplyTypeIDString;
@property(nonatomic,copy)NSString *tfApplyBuMenIDString;
@property(nonatomic,copy)NSString *tfApplySchoolIDString;
@property(nonatomic,copy)NSString *tfApplyPersonIDString;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;


@end
