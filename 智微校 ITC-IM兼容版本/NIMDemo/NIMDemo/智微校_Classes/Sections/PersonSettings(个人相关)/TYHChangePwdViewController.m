//
//  TYHChangePwdViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/7.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "TYHChangePwdViewController.h"
#import <UIView+Toast.h>
#import <AFNetworking.h>
#import "TYHHttpTool.h"
@interface TYHChangePwdViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    MBProgressHUD *_mbHud;
    
}
//@property(nonatomic,retain)UIButton *confirmBtn;
@end

@implementation TYHChangePwdViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isRegisterWithLogin = NO;
    }
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBar];
    self.title = @"修改密码";
    
        self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        self.oldPasswordTf.delegate = self;
        self.confirmPasswordTf.delegate = self;
        self.oldPasswordTf.secureTextEntry = YES;
        self.newpasswordTf.secureTextEntry = YES;
        self.confirmPasswordTf.secureTextEntry = YES;
    [self BaseData];
}


- (void)confirmBtnClick:(UIButton *)sender {
    if ([self isSomeInfoNil]) {
        [self.view endEditing:YES];
        [self.view makeToast:@"部分密码信息不完整" duration:0.8 position:CSToastPositionCenter];
        return;
    }
    else if(![self.oldPasswordTf.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_PASSWORD]])
    {
        [self.view makeToast:@"旧密码错误" duration:0.8 position:CSToastPositionCenter];
        [self.view endEditing:YES];
        return;
    }
    
    
        if (self.newpasswordTf.text.length <= 12 && self.newpasswordTf.text.length >= 6) {
            if ([self.newpasswordTf.text isEqualToString:self.confirmPasswordTf.text]) {
                _mbHud.labelText = @"保存中";
                [_mbHud show:YES];
                if ([self editPassword]) {
                    [_mbHud removeFromSuperview];
                    [_oldPasswordTf resignFirstResponder];
                    [_newpasswordTf resignFirstResponder];
                    [_confirmPasswordTf resignFirstResponder];
                    [self.view makeToast:@"修改成功" duration:1.5 position:CSToastPositionCenter] ;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                    [[NSUserDefaults standardUserDefaults]setValue:self.newpasswordTf.text forKey:USER_DEFAULT_PASSWORD];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else
                {
                    [_mbHud removeFromSuperview];
                    [self.view makeToast:@"修改失败" duration:1.5 position:CSToastPositionCenter];
                }
//                [UserLog editPasswordWithOldPassword:self.oldPasswordTf.text andNewPassword:self.confirmPasswordTf.text anddelegate:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                self.confirmPasswordTf.text = @"";
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为6-12位" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }

}
-(void)BaseData
{
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGINNAME];
    _password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    _organizationID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_ORIGANIZATION_ID];
    _voipAcount = [[NSUserDefaults standardUserDefaults]objectForKey:USER_DEFAULT_VOIP];
    _baseUrlString = BaseURL;
    _loginID = [[NSUserDefaults standardUserDefaults]valueForKey:@"LoginID"];
    _V3ID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];

}


-(BOOL)isSomeInfoNil
{
    
    BOOL oldISNull = [self isBlankString:_oldPasswordTf.text];
    BOOL newISNull = [self isBlankString:_newpasswordTf.text];
    BOOL confirmISNull = [self isBlankString:_confirmPasswordTf.text];
    if (oldISNull || newISNull || confirmISNull) {
        return YES;
    }
    else
    return NO;
}


-(BOOL)editPassword
{
    [self BaseData];
    if (_isRegisterWithLogin) {
        NSDictionary *dic = @{@"password":_newpasswordTf.text,@"userId":_loginID};
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,@"bd/activation/resetPassword"];
        [TYHHttpTool get:urlString params:dic success:^(id json) {
            if ([(NSDictionary *)json objectForKey:@"successStatus"]) {
                [self.view endEditing:YES];
                _isRegisterWithLogin = YES;
                [[NSUserDefaults standardUserDefaults]setValue:_newpasswordTf.text forKey:USER_DEFAULT_PASSWORD];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        } failure:^(NSError *error) {
            _isRegisterWithLogin = NO;
            [self.view endEditing:YES];
        }];
        return _isRegisterWithLogin;
    }
    else
    {
        NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/mobile/mobileWelcome!modifyUserPsw.action?sys_username=%@&sys_auto_authenticate=true&userId=%@&psw=%@&sys_password=%@",_userName,_loginID,_confirmPasswordTf.text,_oldPasswordTf.text]];
            NSLog(@"=-=%@",ContactUrl);
        
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[
                                                        NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        request.HTTPMethod = @"GET";
        
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        [request setTimeoutInterval:10.0f];
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response error:&error];
        
        
        NSString *V3Pwd = [NSString stringWithFormat:@"V3%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_LOGINNAME]];
        NSLog(@"old V3PWD%@",[[NSUserDefaults standardUserDefaults] valueForKey:V3Pwd]);
        
        if (![self isBlankString:V3Pwd]) {
            NSString *ContactUrl = [k_V3ServerURL stringByAppendingString:[NSString stringWithFormat:@"/bd/mobile/mobileWelcome!modifyUserPsw.action?psw=%@&userId=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true",_confirmPasswordTf.text, _V3ID,_userName,_password]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest
                                            requestWithURL:[
                                                            NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
            request.HTTPMethod = @"GET";
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            [request setTimeoutInterval:10.0f];
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response error:&error];
            if(!error && data && response.statusCode==200)
            {
                NSString *V3Pwd = [NSString stringWithFormat:@"V3%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_LOGINNAME]];
                [[NSUserDefaults standardUserDefaults]setValue:_confirmPasswordTf.text forKey:V3Pwd];
//                [[NSUserDefaults standardUserDefaults]setValue:_confirmPasswordTf.text forKey:USER_DEFAULT_PASSWORD];
                [[NSUserDefaults standardUserDefaults]synchronize];
//                [self.view makeToast:@"V3密码修改成功" duration:1 position:nil];
                NSLog(@"New V3PWD%@",[[NSUserDefaults standardUserDefaults] valueForKey:V3Pwd]);
            }
            else
//                [self.view makeToast:@"V3密码修改失败" duration:1 position:nil];
                NSLog(@"123");
        }
        if(!error && data && response.statusCode==200)
        {
            return YES;
        }
        else
            return NO;
    }
    
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


#pragma mark - 代理函数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.confirmPasswordTf == textField) {
        if ([string isEqualToString:@"\n"]) {
            return YES;
        }
        if (self.oldPasswordTf.text) {
//            self.confirmBtn.selected = YES;
//            [self.view endEditing:YES];
        }
    }
    return YES;
}
- (void)refreshDataWithDictionary:(NSDictionary *)dict andOtherString:(NSString *)otherString {
    [_mbHud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    alert.tag = 1000;
    if (dict[@"data"][0]) {
        alert.title = @"修改成功";
    } else {
        alert.title = @"修改失败";
    }
    [alert show];
}


- (void)receiveErrorCode:(NSString *)message {
    _mbHud.mode = MBProgressHUDModeText;
    _mbHud.labelText = message;
    [_mbHud hide:YES afterDelay:2];
}

- (void)connectionFailedWithError:(NSError *)error {
    //    [CustomAlert showAlertWithMessage:error.localizedDescription];
    _mbHud.mode = MBProgressHUDModeText;
    _mbHud.labelText = @"网络不好";
    [_mbHud hide:YES afterDelay:2];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.oldPasswordTf endEditing:YES];
    [self.newpasswordTf endEditing:YES];
    [self.confirmPasswordTf endEditing:YES];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        if ([alertView.title isEqualToString:@"修改成功"]) {
            [self.view makeToast:@"修改成功" duration:0.5 position:CSToastPositionCenter];
        }
    }
}


-(void)createLeftBar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
