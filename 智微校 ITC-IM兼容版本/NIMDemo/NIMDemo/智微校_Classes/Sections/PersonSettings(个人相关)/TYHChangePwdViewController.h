//
//  TYHChangePwdViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/7.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHChangePwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTf;

@property (weak, nonatomic) IBOutlet UITextField *newpasswordTf;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTf;

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *organizationID;
@property(nonatomic,copy)NSString *voipAcount;
@property(nonatomic,copy)NSString *baseUrlString;
@property(nonatomic,copy)NSString *loginID;
@property(nonatomic,copy)NSString *V3ID;


@property(nonatomic,assign)BOOL isRegisterWithLogin;

@end
