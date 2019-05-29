//
//  TakeCourseDetailViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseDetailViewController.h"
#import "TYHTakeCourseViewController.h"
@interface TakeCourseDetailViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>{
    UIWebView *mainWebview;
    MBProgressHUD *hud;
    
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    
    UIButton *submitButton;
    
}

@end

@implementation TakeCourseDetailViewController

-(void)setEcActivityCourseId:(NSString *)ecActivityCourseId
{
    _ecActivityCourseId = ecActivityCourseId;
    [self getNeedData];
}

-(void)setIndexPathRowArray:(NSMutableArray *)indexPathRowArray
{
    _indexPathRowArray = [NSMutableArray arrayWithArray:indexPathRowArray];
}

-(void)setIsTakeCourseViewGoin:(BOOL)isTakeCourseViewGoin
{
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _isTakeCourseViewGoin = isTakeCourseViewGoin;
}
-(void)setTypeString:(NSString *)typeString
{
    if ([typeString isEqualToString:@"学分上限"] || [typeString isEqualToString:@"选课上限"] || [typeString isEqualToString:@"课时上限"] || [typeString isEqualToString:@"时间冲突"] || [typeString isEqualToString:@"选课冲突"]) {
        _typeString = @"不可选";
        [submitButton setTitle:@"不可选" forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor lightGrayColor]];
        submitButton.userInteractionEnabled = NO;
    }
    else if([typeString isEqualToString:@"已满"])
    {
        _typeString = @"已满";
        [submitButton setTitle:@"已满" forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor lightGrayColor]];
        submitButton.userInteractionEnabled = NO;
    }
    else
    {
        if ([typeString isEqualToString:@"已选"])
        {
            _typeString = @"取消选课";
            [submitButton setTitle:@"取消选课" forState:UIControlStateNormal];
            [submitButton setBackgroundColor:[UIColor TabBarColorGreen]];
        }
        else
        {
            _typeString = @"确认选课";
            [submitButton setTitle:@"确认选课" forState:UIControlStateNormal];
            [submitButton setBackgroundColor:[UIColor TabBarColorGreen]];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebview];
    [self createLeftBarItem];
    self.title = @"课程详情";
}
#pragma mark - initData
-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
}

#pragma mark - initView
-(void)initWebview
{
    mainWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    if (_isTakeCourseViewGoin) {
        mainWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 120)];
        [self initSubmitButton];
    }
    
    [mainWebview setDelegate:self];
    mainWebview.backgroundColor = [UIColor lightGrayColor];
    mainWebview.userInteractionEnabled = YES;
//    mainWebview.detectsPhoneNumbers = YES;
    mainWebview.scrollView.bounces = NO;
    mainWebview.scalesPageToFit = YES;
    [self.view addSubview:mainWebview];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ec/mobile/ecMobileTerminal!info.action?ecActivityCourseId=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true",k_V3ServerURL,_ecActivityCourseId,userName,password];
    [mainWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void)initSubmitButton
{
    
    submitButton.frame = CGRectMake(40, mainWebview.frame.size.height + 10 + 10, [UIScreen mainScreen].bounds.size.width - 80, 40);
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = 3;
    [submitButton addTarget:self action:@selector(chooseCourseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];
}

-(void)createLeftBarItem
{
    UIBarButtonItem * leftItem = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

#pragma mark - webView delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud removeFromSuperview];
}

-(void)chooseCourseAction:(UIButton *)btn
{
    
    TYHTakeCourseViewController
    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //初始化其属性
//    takeView.tmpClassModel
//    = nil;
//    //传递参数过去
//    
//    takeView.tmpClassModel
//    = model;
//    //使用popToViewController返回并传值到上一页面
    if ([submitButton.titleLabel.text isEqualToString:@"确认选课"]) {
        _indexPathRowArray[2] = @"已选";
    }
    else
    {
        _indexPathRowArray[2] = @"未选";
    }
    takeView.tempIndexPathAndModeltypeArray = [NSMutableArray arrayWithArray:_indexPathRowArray];
    [self.navigationController
     popToViewController:takeView animated:true];
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
