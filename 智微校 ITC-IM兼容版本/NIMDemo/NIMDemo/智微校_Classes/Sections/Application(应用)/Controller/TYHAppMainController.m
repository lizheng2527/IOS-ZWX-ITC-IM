//
//  TYHAppMainController.m
//  NIM
//
//  Created by 中电和讯 on 2017/5/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHAppMainController.h"
#import "WebViewJavascriptBridge.h"
#import "TYHNewAPPViewController.h"

#import "TYHNewNoticeViewController.h"
#import "TYHAssetViewController.h"
#import "TYHNewReceptionViewController.h"
#import "TYHTranscriptViewController.h"
#import "TYHAttendanceController.h"
#import "TakeCourseBeignViewController.h"
#import "TYHRepairMainController.h"
#import "TYHKeYanController.h"
#import "TYHWarehouseManagementController.h"
#import "TYHRecordController.h"
#import "TYHProjectController.h"
#import "TYHClassAttendanceController.h"
#import "HomeWorkViewController.h"

#import "QCSchoolMainController.h"


#import "AppModelArrayHandler.h"
#import "AppModel.h"
#import <MJExtension.h>
#import <AudioToolbox/AudioToolbox.h>

#import "TYHAppLoadSharedInstance.h"

#import "NTESLoginViewController.h"


#import "CAEvaluateController.h"

@interface TYHAppMainController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;
@end

@implementation TYHAppMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用";
//    [self webViewConfig];
}


-(void)webViewConfig
{
    _mainWebView.scrollView.bounces = NO;
    _mainWebView.backgroundColor = [UIColor whiteColor];
    _mainWebView.opaque = NO;
    _mainWebView.delegate = self;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_appCenterUrl]];
    
    //JSBridage 教程
    //    http://blog.csdn.net/uitguyrff/article/details/50879139
    
    // Do any additional setup after loading the view from its nib.
    
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]]];
    
    //开启JS和OC交互
    if (_bridge) return;
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_mainWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    
    [_bridge registerHandler:@"openEdit" handler:^(id data, WVJBResponseCallback responseCallback) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }];
    
    
    [_bridge registerHandler:@"openNativeApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];

        [self openNativeApp:[dic objectForKey:@"code"]];
    }];
    
    [_bridge registerHandler:@"openWebApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];

        NSString *url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
        
        TYHNewAPPViewController *appView = [TYHNewAPPViewController new];
        appView.urlstr = url;
        
//        NSString *mobileFlag = @"%mobileFlag=iPhone";
        
        appView.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USERID];
        appView.userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGINNAME];
        appView.password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_V3PWD];
        [self.navigationController pushViewController:appView animated:YES];
        
        NSLog(@"%@",url);
        
    }];
    
    [_bridge registerHandler:@"tokenTimeOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NTESNotificationLogout" object:nil];
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"用户信息失效,请重新登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        
        NTESLoginViewController * mainTab = [[NTESLoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
        
        [[TYHAppLoadSharedInstance sharedInstance]appWebViewLoadSuccessful:NO];
        
    }];
    
}


#pragma mark - WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"加载数据中"];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [[TYHAppLoadSharedInstance sharedInstance]appWebViewLoadSuccessful:YES];
    [SVProgressHUD dismiss];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.8];
//    self.navigationController.navigationBar.translucent = NO; //translucent 临时注释
    [[NSNotificationCenter defaultCenter]postNotificationName:NewCommentOrReplyNotifion object:nil];
    
    if (![[TYHAppLoadSharedInstance sharedInstance]appViewLoadSuccessful]) {
        [self webViewConfig];
    }
    
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:USER_DEFAULT_FIRST_LOGIN]) {
////        UIAlertView *altert = [[UIAlertView alloc]initWithTitle:@"提示" message:@" 1.长按应用图标可开启编辑模式\n 2.编辑模式下点击图标可将应用从常用应用分组中添加,移除\n 3.编辑模式下常用应用分组图标可拖动排序" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
////        [altert show];
//
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@" 1.长按应用图标可开启编辑模式\n\n 2.编辑模式下点击图标可将应用从常用应用分组中添加,移除\n\n 3.编辑模式下常用应用分组图标可拖动排序" preferredStyle:UIAlertControllerStyleAlert];
//        UIView *subView1 = alertController.view.subviews[0];
//        UIView *subView2 = subView1.subviews[0];
//        UIView *subView3 = subView2.subviews[0];
//        UIView *subView4 = subView3.subviews[0];
//        UIView *subView5 = subView4.subviews[0];
//        NSLog(@"%@",subView5.subviews);
//        //取title和message：
////        UILabel *title = subView5.subviews[0];
//        UILabel *message = subView5.subviews[1];
//        message.textAlignment = NSTextAlignmentLeft;
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
//        [alertController addAction:cancelAction];
//
//
//        [self presentViewController:alertController animated:YES completion:^{
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_DEFAULT_FIRST_LOGIN];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }];
//    }
}


#pragma mark - PrivateActions
-(void)openNativeApp:(NSString *)code
{
    
    //临时注释
//    TYHProjectController *projectView = [TYHProjectController new];
//    [self.navigationController pushViewController:projectView animated:YES];
//    return;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"appSourceITC.plist" ofType:nil];
     NSArray *appArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray  *appModelArray = [AppModel mj_objectArrayWithKeyValuesArray:appArray];
//    for (AppModel *appModel in appModelArray) {
//        if ([code isEqualToString:appModel.code]) {
//            code = appModel.name;
//        }
//    }
//    我的通知
    if ([code isEqualToString:@"no"]) {
        
        TYHNewNoticeViewController * noticeVc = [[TYHNewNoticeViewController alloc] init];
        noticeVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        [noticeVc setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:noticeVc animated:YES];
    }
//    资产管理
    else if ([code isEqualToString:@"ao"]) {
        TYHAssetViewController * receptVC = [[TYHAssetViewController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([code isEqualToString:@"青蚕学堂"])
    {
        
        QCSchoolMainController *qcView = [QCSchoolMainController new];
        [self.navigationController pushViewController:qcView animated:YES];
        

//        NSURL * myURL_APP_A = [NSURL URLWithString:@"PushXLTWithZWX://"];
//        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
//            [[UIApplication sharedApplication] openURL:myURL_APP_A];
//        }
//        else
//        {
//            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未安装青蚕学堂,是否前去下载" preferredStyle:UIAlertControllerStyleAlert];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/xlt-iOS"]];
//            }]];
//            [self presentViewController: alertController animated: YES completion: nil];
//        }
    }
    
//    订车管理
    else if ([code isEqualToString:@"carmanage"]) {
        TYHNewReceptionViewController * receptVC = [[TYHNewReceptionViewController alloc] init];
        
        receptVC.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([code isEqualToString:@"成绩单"])
    {
        TYHTranscriptViewController *transcriptView = [[TYHTranscriptViewController alloc]init];
        [transcriptView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:transcriptView animated:YES];
    }
//    考勤
    else if([code isEqualToString:@"ta"])
    {
        TYHAttendanceController *aView = [TYHAttendanceController new];
        [aView setHidesBottomBarWhenPushed:YES];
        aView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:aView animated:YES];
    }
//    学生选课-ITC版本跳H5,所以注释
//    else if([code isEqualToString:@"xk"])
//    {
//        TakeCourseBeignViewController *aView = [TakeCourseBeignViewController new];
//        [aView setHidesBottomBarWhenPushed:YES];
//        aView.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:aView animated:YES];
//    }
//    报修
    else if([code isEqualToString:@"re"])
    {
        TYHRepairMainController *repairView = [TYHRepairMainController new];
        [repairView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:repairView animated:YES];
    }
    else if([code isEqualToString:@"教科研"])
    {
        TYHKeYanController *keyanView = [TYHKeYanController new];
        [keyanView setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:keyanView animated:YES];
    }
//    易耗品管理
    else if([code isEqualToString:@"sr"])
    {
        TYHWarehouseManagementController * receptVC = [[TYHWarehouseManagementController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([code isEqualToString:@"项目"])
    {
        TYHProjectController * receptVC = [[TYHProjectController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([code isEqualToString:@"日志"])
    {
        TYHRecordController * receptVC = [[TYHRecordController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
//    课堂考勤
    else if([code isEqualToString:@"ca"])
    {
        TYHClassAttendanceController * receptVC = [[TYHClassAttendanceController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
        
//        CAEvaluateController * receptVC = [[CAEvaluateController alloc] init];
//        [receptVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:receptVC animated:YES];
    }
    
    //作业
    else if([code isEqualToString:@"bd_module_wk"])
    {
        HomeWorkViewController * receptVC = [[HomeWorkViewController alloc] initWithVoipAccount:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID] userName:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME] headIconImage:[UIImage new] teacherOrUser:NO];
        
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    
    
}


-(void)openWebApp:(NSString *)url
{
    
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
