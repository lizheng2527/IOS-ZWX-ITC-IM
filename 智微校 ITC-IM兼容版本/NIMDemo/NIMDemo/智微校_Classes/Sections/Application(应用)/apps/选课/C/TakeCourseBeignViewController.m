//
//  TakeCourseBeignViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#import "TYHTakeCourseViewController.h"
#import "TakeCourseBeignViewController.h"
#import "TakeCourseMineViewController.h"
#import "TakeCourseHelper.h"
#import "TakeCourseModel.h"
#import <UIView+Toast.h>
@interface TakeCourseBeignViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>{
    UIWebView *mainWebview;
    UIButton *beiginChooseCourseBtn;
    
    BeginTakeCourseModel *courseNoteModel;
    NSTimer *timer;
    NSInteger repeatTimes;
}

@end

@implementation TakeCourseBeignViewController
#pragma mark - initData
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self requestData];
        repeatTimes = 5;
    }
    return self;
}

-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    courseNoteModel = [[BeginTakeCourseModel alloc]init];
    TakeCourseHelper *helper = [[TakeCourseHelper alloc]init];
    [helper getCourseNote:^(BOOL successful, BeginTakeCourseModel *dataSource) {
        courseNoteModel = dataSource;
        [mainWebview loadHTMLString:courseNoteModel.ecActivityNote baseURL:nil];
        
        [self initChooseBtn];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}

#pragma mark - viewDidLoad
-(void)viewDidLoad
{
    self.title = @"选课说明";
    [self initWebview];
    [self createLeftBarItem];
}



#pragma mark - initView
-(void)initWebview
{
    mainWebview = [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, HEIGHT - 20 - 120)];
    [mainWebview setDelegate:self];
    mainWebview.backgroundColor = [UIColor lightGrayColor];
    mainWebview.userInteractionEnabled = YES;
//    [mainWebview setScalesPageToFit:YES];
    mainWebview.scrollView.bounces = NO;
    [mainWebview loadHTMLString:courseNoteModel.ecActivityNote baseURL:nil];
    [self.view addSubview:mainWebview];
}

-(void)initChooseBtn
{
    beiginChooseCourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beiginChooseCourseBtn.frame = CGRectMake(40, mainWebview.frame.size.height + 10 + 10, WIDTH - 80, 40);
    beiginChooseCourseBtn.layer.masksToBounds = YES;
    beiginChooseCourseBtn.layer.cornerRadius = 3;
    [beiginChooseCourseBtn setBackgroundColor:[UIColor lightGrayColor]];
    beiginChooseCourseBtn.enabled = NO;
    timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repateAction) userInfo:nil repeats:5];
    [beiginChooseCourseBtn setTitle:@"开始选课(5)" forState:UIControlStateNormal];
    [beiginChooseCourseBtn addTarget:self action:@selector(beiginChooseCourse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beiginChooseCourseBtn];
    
}

-(void)createLeftBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    
    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"我的选课" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(chooseCourseAction)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}
#pragma mark - webView Delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}



#pragma mark - Action
-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)beiginChooseCourse
{
    if(![self isBlankString:courseNoteModel.ecActivityId] )
        {
            TYHTakeCourseViewController *takeCourseView = [[TYHTakeCourseViewController alloc]initWithEcID:courseNoteModel.ecActivityId];
            takeCourseView.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:takeCourseView animated:YES];
        }
        else
        {
            [self.view makeToast:@"暂无选课" duration:1 position:nil];
    
        }
}
-(void)repateAction
{
    repeatTimes --;
    [beiginChooseCourseBtn setTitle:[NSString stringWithFormat:@"开始选课(%ld)",(long)repeatTimes] forState:UIControlStateNormal];
    if (repeatTimes == 0) {
        [timer invalidate];
        [beiginChooseCourseBtn setTitle:[NSString stringWithFormat:@"开始选课"] forState:UIControlStateNormal];
        beiginChooseCourseBtn.enabled = YES;
        [beiginChooseCourseBtn setBackgroundColor:[UIColor TabBarColorGreen]];
    }
}
-(void)chooseCourseAction
{
    TakeCourseMineViewController *mineView = [[TakeCourseMineViewController alloc]initWithEcID:@""];
    [self.navigationController pushViewController:mineView animated:YES];
  
    //临时注释
//    if(![self isBlankString:courseNoteModel.ecActivityId] )
//    {
//        
//    }
//    else
//    {
//        [self.view makeToast:@"暂无选课" duration:1 position:nil];
//
//    }
    
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



#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
