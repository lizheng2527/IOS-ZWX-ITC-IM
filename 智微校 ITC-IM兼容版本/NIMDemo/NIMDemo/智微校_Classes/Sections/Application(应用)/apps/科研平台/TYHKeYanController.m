//
//  TYHKeYanController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/22.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHKeYanController.h"

@interface TYHKeYanController ()<UIWebViewDelegate>
@property(nonatomic,retain)MBProgressHUD *hud;
@property(nonatomic,copy)UIButton *backBtn;
@end

@implementation TYHKeYanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"教科研";
    [self initWebview];
}

-(void)initWebview
{
    _mainWebView.delegate = self;
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://58.132.20.69/iphoneLoginUserCas?loginName=%@",userName]]];
    [_mainWebView loadRequest:request];
//    if (![self.mainWebView canGoBack]) {
//        _backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [_backBtn setTitle:@"Reload webview" forState:UIControlStateNormal];
//        [_backBtn addTarget:_mainWebView action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view insertSubview:_backBtn aboveSubview:_mainWebView];
//        _backBtn.frame = CGRectMake(20, 20, 80, 35);
//        _backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    }
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelFont = [UIFont systemFontOfSize:12];
    _hud.labelText = @"正在加载网页";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud removeFromSuperview];
}

-(void)backAction
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
