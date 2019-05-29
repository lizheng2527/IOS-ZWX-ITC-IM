//
//  TYHNewAPPViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/13.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHNewAPPViewController.h"
#import "WebViewJavascriptBridge.h"
#import "TYHHttpTool.h"
#import "TYHBasePersonController.h"
#import "TYHChooseTeacherController.h"
#import "SingleManager.h"
#import <UIView+Toast.h>
#import "TYHDocumentController.h"

#import "NSString+NTES.h"

@interface TYHNewAPPViewController ()<UIWebViewDelegate , ChoosePersonDelete>

@property (nonatomic, strong) WebViewJavascriptBridge * bridge;
@property (nonatomic, copy)  NSString * rangeString;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString * stringWeb;

@end

@implementation TYHNewAPPViewController
{
    CGFloat progre;
}

- (UIWebView *)webView {
    
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
        self.webView.scrollView.bounces = NO;
        [self.view addSubview:self.webView];
    }
    return _webView;
}

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name {
    
    
    NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title isEqualToString:@"课表"]) {
        
        _userId = urlId;
        self.stringWeb = [NSString stringWithFormat:@"com.ue.bd.module.mobile.course.table.getUserCourseTable('%@','%@');",urlId, name];
        
        // 服务器端 可能有误
        [self.webView stringByEvaluatingJavaScriptFromString:self.stringWeb];
        //        [self getWebView];
        
    } else {
        
        self.stringWeb = [NSString stringWithFormat:@"com.ue.bd.module.mobile.course.table.getUserCourseTable('%@','%@');",urlId, name];
        
        //        self.stringWeb = [NSString stringWithFormat:@"getIOSData('%@','%@');",urlId,name];
        
        NSLog(@"id :%@ name:%@",urlId,name);
        
        // 服务器端 可能有误
        [self.webView stringByEvaluatingJavaScriptFromString:self.stringWeb];
    }
    
}

-(void) hideNavBar {
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWebView];
    //开启JS和OC交互
    if (_bridge) return;
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //        NSLog(@"responseCallback000 == %@",responseCallback);
        responseCallback(@"Response for message from ObjC");
        
    }];
    
    
    [_bridge registerHandler:@"toFinishActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //        NSLog(@"responseCallback111 == %@",responseCallback);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    [_bridge registerHandler:@"openTreeList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //        NSLog(@"responseCallback222 == %@",responseCallback);
        
        TYHChooseTeacherController * baseVc = [[TYHChooseTeacherController alloc] init];
        
        baseVc.userId = self.userId;
        baseVc.userName = self.userName;
        baseVc.password = self.password;
        baseVc.urlStr = @"/bd/mobile/baseData!getTeacherTreeIOS.action";
        baseVc.title = @"教师";
        baseVc.delegate = self;
        baseVc.whoWillIn = YES;
        NSLog(@"%-@%-@%@",self.userId,self.userName,baseVc.urlStr);
        
        [self.navigationController pushViewController:baseVc animated:YES];
        //        [self presentViewController:baseVc animated:YES completion:nil];
        
    }];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIBarButtonItem   *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)returnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWebView {
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
//    NSString * url = [NSString stringWithFormat:@"%@&userId=%@&dataSourceName=%@",_urlstr,_userId,dataSourceName];
    
//    NSString *url = _urlstr;
  
    if ([NSString isBlankString:self.sourceId]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlstr]]];
    }
    else
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&userId=%@",_urlstr,_userId]]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]){
//        [storage deleteCookie:cookie];
//    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    NSLog(@"webViewDidStartLoad");
    self.navigationController.navigationBarHidden = YES;
    
    [SVProgressHUD showWithStatus:@"加载数据中"];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if([error code] == NSURLErrorCancelled) {
        
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD dismiss];
        //        NSLog(@"Canceled request request: %@", [webView.request.URL absoluteString]);
        return;
    } else {
        [self returnClicked];
        [SVProgressHUD dismiss];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    self.rangeString = nil;
    NSString * strUrl = request.URL.absoluteString;
    //    NSLog(@"strUrl222 == %@",strUrl);
    NSString * rangeStr = @"download.action?checkUser=false&period=&downloadToken";
    NSRange  range = [strUrl rangeOfString:rangeStr];
    
    NSString * rangeNewStr = @"weekRecordData!input.action";
    NSRange rangNew = [strUrl rangeOfString:rangeNewStr];
    
    if (rangNew.location != NSNotFound) {
        
        //        NSLog(@"%@",);
    }
    
    if (range.location != NSNotFound) {
        //        自定义下载附件操作
        //        self.rangeString = [strUrl substringWithRange:NSMakeRange(104, 36)];
        //        NSLog(@"rangeString == %@",self.rangeString);
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        self.fileManager = fileManager;
        //        [self downLoadData:strUrl];
        [self openThirdApp:strUrl];
        
        return NO;
        
    }
    return YES;
}

- (void)openThirdApp:(NSString*)path {
    
    TYHDocumentController * doucumentVc = [[TYHDocumentController alloc] init];
    
    doucumentVc.url = [NSURL URLWithString:path];
    
    [self presentViewController:doucumentVc animated:YES completion:nil];
}
- (void)downLoadData:(NSString *)strUrl {
    
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.rangeString];
    
    //    NSURL *url = [NSURL fileURLWithPath:paths];
    //    NSLog(@"%@",paths);
    
    if ([self.fileManager fileExistsAtPath:paths]) {
        
        [self openThirdApp:paths];
        
    } else {
        
        NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.rangeString];
        
        TYHHttpTool * http = [[TYHHttpTool alloc] init];
        
        [http downloadInferface:strUrl downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData * data = (NSData *)responseObject;
            //            NSLog(@"%@",data);
            [data writeToFile:path atomically:YES];
            
        } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        } progress:^(float progress) {
            
            if (progress == 1) {
                progre = progress;
            }
        }];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self performSelector:@selector(hideNavBar) withObject:nil afterDelay:0.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [SVProgressHUD dismiss];
}




@end
