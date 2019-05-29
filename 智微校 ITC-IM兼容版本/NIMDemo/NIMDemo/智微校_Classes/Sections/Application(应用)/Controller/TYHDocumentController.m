//
//  TYHDocumentController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/3/16.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHDocumentController.h"

@interface TYHDocumentController ()

@end

@implementation TYHDocumentController
{

    BOOL ifTouch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topView.backgroundColor = [UIColor TabBarColorGreen];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
//    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:_url encoding:NSUTF8StringEncoding error:nil];
    
//    [webview loadHTMLString:htmlstr baseURL:_url];
}

- (IBAction)didClickClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)openWithSafari:(id)sender {
    
    [[UIApplication sharedApplication] openURL:_url];
}
@end
