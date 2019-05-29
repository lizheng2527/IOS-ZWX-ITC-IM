//
//  TYHClassAttendanceController.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "TYHClassAttendanceController.h"
#import "KPDropMenu.h"
#import "WebViewJavascriptBridge.h"
#import "CAMainListController.h"
#import "ClassAttendanceNetHelper.h"
#import "ClassAttendanceModel.h"

@interface TYHClassAttendanceController ()<UIWebViewDelegate,KPDropMenuDelegate>

@property WebViewJavascriptBridge* bridge;

@property(nonatomic,retain)NSMutableArray *dataSource;
@end

@implementation TYHClassAttendanceController
{
    KPDropMenu *dropNew;
    UIWebView *mainWebview;
    UIImageView *leftIconView;
    UIImageView *rightIconView;
    
    __block NSString *chooseStartWeek;
    __block NSString *chooseEndWeek;
    
    NSString *nodeURL;
    NSString *nodeSever;
    
    NSString *weekNum;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课堂考勤";
    self.view.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
    weekNum = @"";
    
    nodeURL = [[NSUserDefaults standardUserDefaults] valueForKey:NODE_SERVER_URL];
    nodeSever = [[NSUserDefaults standardUserDefaults] valueForKey:NODE_SERVER_PARAM];
    [self DataConfig];
    // Do any additional setup after loading the view.
    
}

-(void)DataConfig
{
    ClassAttendanceNetHelper *helper = [ClassAttendanceNetHelper new];
    [helper getAllClassWeeksWithJson:^(BOOL successful, NSMutableArray *DataSource) {
        
        _dataSource = [NSMutableArray arrayWithArray:DataSource];
        
        if (_dataSource.count) {
            [_dataSource enumerateObjectsUsingBlock:^(CAWeekModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    weekNum = model.number;
                }
                if ([model.isCurrent isEqualToString:@"1"]) {
                    weekNum = model.number;
                    *stop = YES;
                }
            }];
        }
        
        [self initDropMenuAndWebView];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)initDropMenuAndWebView
{
    
    dropNew = [[KPDropMenu alloc] initWithFrame:CGRectMake(0, 14, [UIScreen mainScreen].bounds.size.width, 56)];
    dropNew.delegate = self;
    dropNew.items = [self DealDatasource:_dataSource];
    dropNew.title = [self DealMennuTitle:_dataSource];
    dropNew.itemBackground = [UIColor whiteColor];
    dropNew.backgroundColor = [UIColor whiteColor];
//    dropNew.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:14.0];
    dropNew.titleFontSize = 13;
    dropNew.itemFontSize = 13;
    dropNew.titleTextAlignment = NSTextAlignmentCenter;
    dropNew.DirectionDown = YES;
    if (!dropNew.superview) {
        [self.view addSubview:dropNew];
    }
    
    leftIconView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 19, 18, 18)];
    leftIconView.image = [UIImage imageNamed:@"CA_screening"];
    [dropNew addSubview:leftIconView];
    
    rightIconView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, 9, 30, 38)];
    rightIconView.image = [UIImage imageNamed:@"CA_DOWN"];
    [dropNew addSubview:rightIconView];
    
    
    mainWebview = [[UIWebView alloc]initWithFrame:CGRectMake(10, 84,SCREEN_WIDTH - 20, SCREEN_HEIGHT - 84 - 64 - 14)];
    mainWebview.scrollView.bounces = NO;
    mainWebview.delegate = self;
    [mainWebview sizeToFit];
    
    //拼接课表URL
//    nodeServerUrl + "/mobile/classAttendance/classList?" + nodeParam + "&weekNum=" + weekNum
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/mobile/classAttendance/classList.html?%@&weekNum=%@&userId=%@",nodeURL,nodeSever,weekNum,userId];
    
    [mainWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    if (!mainWebview.superview) {
        [self.view addSubview:mainWebview];
    }
    
    //开启JS和OC交互
    if (_bridge) return;
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:mainWebview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"toAttendance" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *urlString = [data objectForKey:@"url"];
//        NSString *urlString = @"";
        
        CAMainListController *mainlistView = [[CAMainListController alloc]init];
        mainlistView.requestURL = urlString;
        [self.navigationController pushViewController:mainlistView animated:YES];
        
    }];
}

#pragma mark - KPDropMenu Delegate Methods

-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex{
   
    CAWeekModel *model = _dataSource[atIntedex];
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/mobile/classAttendance/classList.html?%@&weekNum=%@&userId=%@",nodeURL,nodeSever,model.number,userId];
    [mainWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    
    //已在内部修改实现
//    dropNew.title = [NSString stringWithFormat:@"教学周: %@",dropMenu.items[atIntedex]];
    
}

-(void)didShow:(KPDropMenu *)dropMenu{
    NSLog(@"didShow");
    rightIconView.image = [UIImage imageNamed:@"CA_UP"];
}

-(void)didHide:(KPDropMenu *)dropMenu{
    NSLog(@"didHide");
    rightIconView.image = [UIImage imageNamed:@"CA_DOWN"];
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



#pragma mark - Privare
-(NSMutableArray *)DealDatasource:(NSMutableArray *)data
{
    NSMutableArray *menuSource = [NSMutableArray array];
    
    for (CAWeekModel *model in data) {
        [menuSource addObject:[NSString stringWithFormat:@"第%@周 (%@ ~ %@)",model.number,model.startDate,model.endDate]];
    }
    return menuSource;
}

-(NSString *)DealMennuTitle:(NSMutableArray *)data
{
    __block NSString *menuTitle = @"暂无";
    
    if (_dataSource.count) {
        [_dataSource enumerateObjectsUsingBlock:^(CAWeekModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                menuTitle =  [NSString stringWithFormat:@"教学周: 第%@周 (%@ ~ %@)",model.number,model.startDate,model.endDate];
            }
            if ([model.isCurrent isEqualToString:@"1"]) {
                menuTitle =  [NSString stringWithFormat:@"教学周: 第%@周 (%@ ~ %@)",model.number,model.startDate,model.endDate];
                *stop = YES;
            }
        }];
    }

    return menuTitle;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
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
