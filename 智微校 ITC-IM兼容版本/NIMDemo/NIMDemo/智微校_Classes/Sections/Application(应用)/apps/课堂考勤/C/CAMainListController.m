//
//  CAMainListController.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CAMainListController.h"

#import "WebViewJavascriptBridge.h"
#import "CAEvaluateController.h"
#import "CAClassDetailController.h"


@interface CAMainListController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;

@end


@implementation CAMainListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"课堂考勤";
    [_mainWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
    _mainWebview.delegate = self;
    _mainWebview.scrollView.bounces = NO;
    [_mainWebview sizeToFit];
    
    //开启JS和OC交互
    if (_bridge) return;
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_mainWebview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    
    [_bridge registerHandler:@"toEvaluate" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        CAEvaluateController *mainlistView = [[CAEvaluateController alloc]init];
        mainlistView.studentId = [data objectForKey:@"studentId"];
        mainlistView.studentName = [data objectForKey:@"studentName"];
        mainlistView.attendanceId = [data objectForKey:@"attendanceId"];
        
        [self.navigationController pushViewController:mainlistView animated:YES];
    }];
    
    
    [_bridge registerHandler:@"toClassDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *urlString = [data objectForKey:@"url"];
        CAClassDetailController *mainlistView = [[CAClassDetailController alloc]init];
        mainlistView.requestURL = urlString;
        mainlistView.titleString = [data objectForKey:@"title"];
        [self.navigationController pushViewController:mainlistView animated:YES];
    }];
}


#pragma mark - WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载中"];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self.view makeToast:@"加载失败,请重试" duration:1.5 position:CSToastPositionCenter];
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
