//
//  NTESLoginViewController.m
//  NIMDemo
//
//  Created by ght on 15-1-26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESLoginViewController.h"
#import "NTESSessionViewController.h"
#import "NTESSessionUtil.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESMainTabController.h"
#import "UIView+Toast.h"
#import "NSString+NTES.h"
#import "SVProgressHUD.h"
#import "NTESService.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESNotificationCenter.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESLogManager.h"

#import "TYHFindPasswordController.h"
#import <CZPicker.h>
#import "TYHLoginAjaxHandler.h"
#import "TYHLoginInfoModel.h"
#import <UIImageView+WebCache.h>

#import "JPUSHService.h"
#import "TYHHttpTool.h"

NSString *TokenCheckFalse = @"TokenCheckFalse";

@interface NTESLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,CZPickerViewDelegate,CZPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldBGview;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseOrganizationBtn;


@property (nonatomic,retain)CZPickerView *picker;
@property (nonatomic,retain)NSMutableArray *organizationArray;
@end

@implementation NTESLoginViewController
{
    TYHLoginInfoModel *loginModel;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


NTES_USE_CLEAR_BAR
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configNav];
    [self configStatusBar];
    [self configView];
    [self setDefaultTextFieldString];
    [self requestOrganizationData];
    
    
    if ([NSString isBlankString:BaseURL]) {
        
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"配置服务器地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * textField) {
                textField.placeholder = @"请输入服务器地址";
                textField.text = @"http://";
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.keyboardType = UIKeyboardTypeURL;
            }];
            
            [alert addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSArray * textfields = alert.textFields;
                UITextField * inputAddressField  = textfields[0];
                
                [self saveBaseURL:inputAddressField];
            }]];
            
            [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated: YES completion: nil];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TokenCheckFalseAlert) name:@"TokenCheckFalse" object:nil];

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"noTokenRequest"]) {
        [self TokenCheckFalseAlert];
    }
}


#pragma mark - RequsetData
-(void)requestOrganizationData
{
    
    TYHLoginAjaxHandler *handler = [[TYHLoginAjaxHandler alloc]init];
    [handler getOrganizationArrayWithStatus:^(BOOL Successful, NSMutableArray *orgaArray) {
        _organizationArray = [NSMutableArray arrayWithArray:orgaArray];
        
        NSString *organizationName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_NAME];
        NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
        if ([NSString isBlankString:organizationName] && [NSString isBlankString:organizationID] && _organizationArray.count) {
            [_chooseOrganizationBtn setTitle:[(TYHOranizationModel *)_organizationArray[0]organizationName ] forState:UIControlStateNormal]; 
            [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[0]organizationName ] forKey:USER_DEFAULT_ORIGANIZATION_NAME];
            [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[0]organizationID ] forKey:USER_DEFAULT_ORIGANIZATION_ID];
            [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[0]dataSourceName ] forKey:USER_DEFAULT_DataSourceName];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - ViewInit
-(void)configView
{
    [_loginBtn setBackgroundColor:[UIColor TabBarColorGreen]];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 3;
    
    _passwordTextField.delegate = self;
    _usernameTextField.delegate = self;
//    [_registerButton setHidden:![[NIMSDK sharedSDK] isUsingDemoAppKey]];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _textFieldBGview.layer.masksToBounds = YES;
    _textFieldBGview.layer.cornerRadius = 4;
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
    gesture.delegate = self;
    _logo.layer.masksToBounds = YES;
    _logo.layer.cornerRadius = 50;
    gesture.minimumPressDuration = 1;
    self.logo.userInteractionEnabled = YES;
    [self.logo addGestureRecognizer:gesture];
}

- (void)configNav{
    self.navigationItem.title = @"";
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(0, 0);
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)configStatusBar{
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}


//设置默认输入信息 和 头像信息
-(void)setDefaultTextFieldString
{
    NSString *username = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_NAME];
    if (![NSString isBlankString:username]) {
        _usernameTextField.text = username;
        _passwordTextField.text = password;
    }
    if (![NSString isBlankString:organizationName]) {
        [_chooseOrganizationBtn setTitle:organizationName forState:UIControlStateNormal];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_DEFAULT_HEADIMAGE_DATA] != nil) {
        self.logo.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:USER_DEFAULT_HEADIMAGE_DATA]];
    }
}

-(NSString *)delKongge:(NSString *)string
{
    NSString *content = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return content;
}

#pragma mark - ClickActions
//点击登录
- (IBAction)loginBtnClickAction:(id)sender {
    
    [self.view endEditing:YES];
    
    TYHLoginAjaxHandler *handler = [TYHLoginAjaxHandler new];
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    NSString *loginName = [_loginName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //此处修改为USER_DEFAULT_DataSourceName,仅ITC版本使用
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    
    [SVProgressHUD showWithStatus:@"正在验证用户信息"];
    
    
    if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
        [handler LoginWithUserName:username Password:password OrganizationID:organizationID andStatus:^(BOOL successful, TYHLoginInfoModel *tmpLoginInfoModel) {
            loginModel = [TYHLoginInfoModel new];
            loginModel = tmpLoginInfoModel;
            [SVProgressHUD showWithStatus:@"正在登录"];
            if ([loginModel.successStatus isEqualToString:@"0"]) {
                            [[[NIMSDK sharedSDK] loginManager] login:loginModel.accId
                                                               token:loginModel.neteaseToken
                                                          completion:^(NSError *error) {
                                                              if (error == nil) {
                [SVProgressHUD dismiss];
                LoginData *sdkData = [[LoginData alloc] init];
                sdkData.account   = loginModel.accId;
                sdkData.token = loginModel.neteaseToken;
                [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                [[NTESServiceManager sharedManager] start];
                
                NTESMainTabController * mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
                
                //保存登录信息
                [self saveUserInfoWithLoginModel:loginModel];
                [[NSUserDefaults standardUserDefaults]setValue:username forKey:USER_DEFAULT_LOGINNAME];
                [[NSUserDefaults standardUserDefaults]setValue:password forKey:USER_DEFAULT_PASSWORD];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self resigisterDevice];
                //提交登录状态
                [handler submitLoginStatusWithLoginName:username PassWord:password UserID:loginModel.userID terminalStatus:@"1"];
                                                              }
                                                              else
                                                              {
                                                                  [SVProgressHUD dismiss];
                                                                  NSString *toast = [NSString stringWithFormat:@"连接通讯服务器失败 code: %zd",error.code];
                                                                  [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                                              }
                
                                                          }];
            }
            else
            {
                [SVProgressHUD dismiss];
                [self.view makeToast:loginModel.errorMsg duration:2.0 position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"无法连接到服务器,请检查网络" duration:2.0 position:CSToastPositionCenter];
        }];
    }else
    {
        [handler LoginWithUserName:username Password:password OrganizationID:organizationID andStatus:^(BOOL successful, TYHLoginInfoModel *tmpLoginInfoModel) {
            loginModel = [TYHLoginInfoModel new];
            loginModel = tmpLoginInfoModel;
            [SVProgressHUD showWithStatus:@"正在登录"];
            if ([loginModel.successStatus isEqualToString:@"0"]) {
                //            [[[NIMSDK sharedSDK] loginManager] login:loginModel.accId
                //                                               token:loginModel.neteaseToken
                //                                          completion:^(NSError *error) {
                //                                              if (error == nil) {
                [SVProgressHUD dismiss];
                LoginData *sdkData = [[LoginData alloc] init];
                sdkData.account   = loginModel.accId;
                sdkData.token = loginModel.neteaseToken;
                [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                [[NTESServiceManager sharedManager] start];
                
                NTESMainTabController * mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
                
                //保存登录信息
                [self saveUserInfoWithLoginModel:loginModel];
                [[NSUserDefaults standardUserDefaults]setValue:username forKey:USER_DEFAULT_LOGINNAME];
                [[NSUserDefaults standardUserDefaults]setValue:password forKey:USER_DEFAULT_PASSWORD];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self resigisterDevice];
                //提交登录状态
                [handler submitLoginStatusWithLoginName:username PassWord:password UserID:loginModel.userID terminalStatus:@"1"];
                //                                              }
                //                                              else
                //                                              {
                //                                                  [SVProgressHUD dismiss];
                //                                                  NSString *toast = [NSString stringWithFormat:@"连接通讯服务器失败 code: %zd",error.code];
                //                                                  [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                //                                              }
                //
                //                                          }];
            }
            else
            {
                [SVProgressHUD dismiss];
                [self.view makeToast:loginModel.errorMsg duration:2.0 position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"无法连接到服务器,请检查网络" duration:2.0 position:CSToastPositionCenter];
        }];
    }
    
    
    
    
}

- (IBAction)onTouchLogin:(id)sender {
    NSLog(@"我是完成");
}

-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"配置服务器地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * textField) {
            textField.placeholder = @"请输入服务器地址";
            textField.text = BaseURL;
            if ([NSString isBlankString:BaseURL]) {
                textField.text = @"http://";
            }
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeURL;
        }];
        
        [alert addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSArray * textfields = alert.textFields;
            UITextField * inputAddressField  = textfields[0];
            [self saveBaseURL:inputAddressField];
        }]];
        
        [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated: YES completion: nil];
    }
}

-(void)TokenCheckFalseAlert
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您的用户信息已失效,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"noTokenRequest"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - CZPicker Delegate & Datasource
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    NSLog(@"Canceled.");
}

- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    [self.view endEditing:YES];
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:[(TYHOranizationModel *)_organizationArray[row] organizationName]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    TYHOranizationModel *oraModel = _organizationArray[row];
    return oraModel.organizationName;
}


- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return _organizationArray.count;
}

- (IBAction)chooseOrgAction:(id)sender {
    //带确认和离开的FooterView
    _picker = [[CZPickerView alloc] initWithHeaderTitle:@"学校选择" cancelButtonTitle:@"离开" confirmButtonTitle:@"确认"];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.needFooterView = YES;
    [_picker show];
}
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    [_chooseOrganizationBtn setTitle:[(TYHOranizationModel *)_organizationArray[row] organizationName] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[row] organizationName] forKey:USER_DEFAULT_ORIGANIZATION_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[row] organizationID] forKey:USER_DEFAULT_ORIGANIZATION_ID];
    [[NSUserDefaults standardUserDefaults]setValue:[(TYHOranizationModel *)_organizationArray[row] dataSourceName] forKey:USER_DEFAULT_DataSourceName];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 保存用户数据
-(void)saveUserInfoWithLoginModel:(TYHLoginInfoModel *)model
{
    [[NSUserDefaults standardUserDefaults] setValue:model.token forKey:USER_DEFAULT_TOKEN];
    [[NSUserDefaults standardUserDefaults] setValue:model.v3Url forKey:USER_DEFAULT_V3ServerURL];
    [[NSUserDefaults standardUserDefaults] setValue:model.v3pwd forKey:USER_DEFAULT_V3PWD];
    [[NSUserDefaults standardUserDefaults] setValue:model.voipAccount forKey:USER_DEFAULT_VOIP];
    [[NSUserDefaults standardUserDefaults]setValue:model.dataSourceName forKey:USER_DEFAULT_DataSourceName];
    [[NSUserDefaults standardUserDefaults]setValue:model.appCenterUrl forKey:USER_DEFAULT_appCenterUrl];
    [[NSUserDefaults standardUserDefaults]setValue:model.messageDetailUrl forKey:USER_DEFAULT_MessageDetailUrl];
    [[NSUserDefaults standardUserDefaults] setValue:model.v3Id forKey:USER_DEFAULT_V3ID];
    [[NSUserDefaults standardUserDefaults]setValue:model.kind forKey:USER_DEFAULT_KIND];
//    [[NSUserDefaults standardUserDefaults]setValue:model.appCode forKey:USER_DEFARLT_APPCODE];
    [[NSUserDefaults standardUserDefaults]setValue:model.codes forKey:USER_DEFARLT_APPCODE];
    [[NSUserDefaults standardUserDefaults]setValue:model.name forKey:USER_DEFAULT_USERNAME];
    [[NSUserDefaults standardUserDefaults]setValue:model.userID forKey:USER_DEFAULT_USERID];
    [[NSUserDefaults standardUserDefaults]setValue:model.mobileNum forKey:USER_DEFAULT_MOBIENUM];
    
    [[NSUserDefaults standardUserDefaults]setValue:model.nodeServerUrl forKey:NODE_SERVER_URL];
    [[NSUserDefaults standardUserDefaults]setValue:model.nodeParam forKey:NODE_SERVER_PARAM];
    
//    model.qcxtUrl = @"http://192.168.1.119:81/dubbo-wisdomclass/";
//    [[NSUserDefaults standardUserDefaults] setValue:@"20181214091703603068069982839059" forKey:USER_DEFAULT_TOKEN];
    
    
    [[NSUserDefaults standardUserDefaults]setValue:model.qcxtUrl forKey:USER_DEFAULT_QCXT_URL ];
    
    //ITC版本添加
    [[NSUserDefaults standardUserDefaults]setValue:model.sex forKey:USER_DEFAULT_SEX ];
    [[NSUserDefaults standardUserDefaults]setValue:model.birthDate forKey:USER_DEFAULT_BIRTHDAY ];
    [[NSUserDefaults standardUserDefaults]setValue:model.autograph forKey:USER_DEFAULT_SIGNATURE ];
    [[NSUserDefaults standardUserDefaults]setValue:model.email forKey:USER_DEFAULT_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:model.headPortraitUrl forKey:USER_DEFAULT_HeadPortraitUrl];
     [[NSUserDefaults standardUserDefaults]setValue:model.sys_token forKey:USER_DEFAULT_SYS_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString * headerImage =  [NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl];
    
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:headerImage] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [[NSUserDefaults standardUserDefaults]setObject:UIImageJPEGRepresentation(image, 1) forKey:USER_DEFAULT_HEADIMAGE_DATA];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
}

-(void)saveBaseURL:(UITextField *)inputAddressField
{
    [SVProgressHUD showWithStatus:@"验证服务器地址中..."];
    NSString *tempString = @"";
    if ([inputAddressField.text isEqualToString:@"Test"] || [inputAddressField.text isEqualToString:@"test"] || [inputAddressField.text isEqualToString:@"TEST"]) {
        tempString = appUrlZWX;
    }
    else if ([NSString isBlankString:inputAddressField.text]) {
        tempString = appUrlZWX_ZS;
    }
    else tempString = [NSString stringWithFormat:@"%@",inputAddressField.text];
    
    if ([TYHLoginAjaxHandler  AjaxURL:tempString]) {
        [self.view makeToast:@"配置服务器地址成功" duration:1 position:nil];
        if ([inputAddressField.text isEqualToString:@"Test"] || [inputAddressField.text isEqualToString:@"test"] || [inputAddressField.text isEqualToString:@"TEST"]) {
            [[NSUserDefaults standardUserDefaults]setValue:appUrlZWX forKey:USER_DEFAULT_BASEURL];
        }
        else if ([NSString  isBlankString:inputAddressField.text]) {
            [[NSUserDefaults standardUserDefaults]setValue:appUrlZWX_ZS forKey:USER_DEFAULT_BASEURL];
        }
        else
        {
            NSString *tmpString = [NSString stringWithFormat:@"%@",inputAddressField.text];
            [[NSUserDefaults standardUserDefaults]setValue:tmpString forKey:USER_DEFAULT_BASEURL];
        }
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:USER_DEFAULT_ORIGANIZATION_ID];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:USER_DEFAULT_ORIGANIZATION_NAME];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self requestOrganizationData];
        
        [SVProgressHUD dismiss];
    }
    else {
        [self.view makeToast:@"验证服务器地址失败" duration:1.5f position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    CGFloat bottomSpacing = 10.f;
    UIView *inputView = self.passwordTextField.superview;
    if (inputView.bottom + bottomSpacing > CGRectGetMinY(keyboardFrame)) {
        CGFloat delta = inputView.bottom + bottomSpacing - CGRectGetMinY(keyboardFrame);
        inputView.bottom -= delta;
    }
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(NSNotification*)notification{
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _usernameTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _passwordTextField) {
        [self loginBtnClickAction:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_usernameTextField == textField) {
        _passwordTextField.text = @"";
        self.logo.image = [UIImage imageNamed:@"mk-photo"];
    }
    return YES;
}

#pragma mark - Private
- (IBAction)findPasswordBack:(id)sender {
    TYHFindPasswordController *passwordView = [TYHFindPasswordController new];
    passwordView.orgaArray = [NSMutableArray arrayWithArray:_organizationArray];
    [self.navigationController pushViewController:passwordView animated:YES];
    
}


-(void)resigisterDevice
{
    
    NSString *loginName = [self delKongge:_usernameTextField.text];
    NSString *userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    NSString *V3PWD = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    __block NSString * regId = [JPUSHService registrationID];
    NSString * urlStr = [NSString stringWithFormat:@"%@/bd/mobile/baseData!setUserMobileFlag.action",BaseURL];
    NSString * url = [NSString stringWithFormat:@"%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&mobileKind=0&mobileFlag=%@;%@",urlStr,loginName,V3PWD,userId,regId,regId];
    
    [self.view makeToast:regId duration:15 position:CSToastPositionCenter];
    
    [TYHHttpTool get:url params:nil success:^(id json) {
        NSLog(@"绑定推送成功 == %@",json);
        
        [[NSUserDefaults standardUserDefaults]setValue:regId forKey:USER_DEFAULT_PushRegID];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    } failure:^(NSError *error) {
        NSLog(@"绑定推送失败 ");
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
