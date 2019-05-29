//
//  qcsStudyAnalyticsInsideController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsStudyAnalyticsInsideController.h"
#import "qcsMenuTableController.h"
#import "UIViewController+CWLateralSlide.h"
#import "QCSchoolDefine.h"
#import "QCSNetHelper.h"
#import "QCSStudyAnalyticsModel.h"
#import "QCSMainModel.h"

#import "qcsStudyAnalyticsSearcuClassController.h"
#import "qcsStudyAnalyticsSearcuStudentController.h"

#import "NSString+NTES.h"

#define baseUrl [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_QCXT_URL],@"qc-wisdomClass/mStatistical.html?"]

@interface qcsStudyAnalyticsInsideController ()<qcsMenuTableDelegate,WKUIDelegate,WKNavigationDelegate>


@property(nonatomic,retain)NSMutableArray *leftDataSource;
@property(nonatomic,retain)NSMutableArray *rightDataSource;

@property(nonatomic,assign)NSInteger pageNumClass;
@property(nonatomic,assign)NSInteger pageNumStudent;

@property(nonatomic,assign)NSInteger tempViewTag;

@end

@implementation qcsStudyAnalyticsInsideController
{
    UIButton * rightSearchItem;
    UIButton * rightMenuItem;
    
    NSString *studentID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
    [self getData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshClass:) name:@"AnalysticShouldRefrshClass" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshStudent:) name:@"AnalysticShouldRefrshStudent" object:nil];
    
}



-(void)getData{
    
    
//    NSString *base = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_QCXT_URL],@"qc-wisdomClass/mStatistical.html?"];
    
    __weak typeof(self) weakSelf = self;
    _bigDataArray = [NSMutableArray array];
    _studentArray = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [[QCSNetHelper alloc]init];
    
    [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
        if (dataSource.count) {
            QCSMainUserModel *model = dataSource[0];
            [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:@"1" startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                _studentArray = dataSource;
                studentID = model.id;
                [SVProgressHUD dismiss];
                
                [helper getStudyAnalyticsQueryData:^(BOOL successful, QCSStudyAnalyticsModel *mainModel) {
                    weakSelf.bigDataArray = [NSMutableArray arrayWithArray:mainModel.shcoolDataModelArray];
                    [SVProgressHUD dismiss];
                    
                    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
                    
                    //    TapBigData = 1, //
                    //    TapClass = 2,    //
                    //    TapStudent = 3
                    
                    if ([self.controllerType isEqualToString:@"TapBigData"]) {
                        
                        QCSStudyAnalyticsItemModel *model = self.bigDataArray[0];
                        NSString *groupSchoolType = @"";
                        if ([model.schoolFlag isEqualToString:@"0"]) {
                            groupSchoolType = @"0";
                        }else groupSchoolType = @"1";
                        
                        NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
                        NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&groupSchoolType=%@&subSchoolId=%@&sys_token=%@",studentID,@"mobile",@"true",@"0",groupSchoolType,model.id,token];
                        
//                        NSString *requestString = @"http://222.128.2.27/dubbo-wisdomclass/qc-wisdomClass/mStatistical.html?pageType=2&menuType=100&studentName=尼泊尔";
//                        NSString* encodedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        
                        NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];

                        [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
                        
                    }else if([self.controllerType isEqualToString:@"TapClass"])
                    {
                        NSString *urlString = [NSString stringWithFormat:@"sys_auto_authenticate=%@&pageType=%@&sys_token=%@&menuType=%@&subMenuType=%@&eclassId=%@",@"true",@"1",token,@"1",@"100",self.tempCourseID];
                        
                        NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
                        [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
                    }
                    else if([self.controllerType isEqualToString:@"TapStudent"])
                    {
                        
                        self.chooseStudentName = [model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&subMenuType=%@&eclassId=%@&sys_token=%@&studentName=%@",studentID,@"mobile",@"true",@"2",@"100",self.eclassID,token,[model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
                        [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
                    }
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    [self.view makeToast:@"获取列表数据失败" duration:1.5 position:CSToastPositionCenter];
                }];
                
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                [self.view makeToast:@"获取学生数据失败" duration:1.5 position:CSToastPositionCenter];
            }];
        }
    }];
    
    
    
}

#pragma mark - initView
-(void)initView
{
        _mainWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
        _mainWebView.navigationDelegate = self;
        _mainWebView.UIDelegate = self;
        _mainWebView.scrollView.bounces = NO;
        if (!_mainWebView.superview) {
            [self.view addSubview:_mainWebView];
        }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 64)];
    
    rightSearchItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSearchItem.frame = CGRectMake(5,12,40,40);
    [rightSearchItem setImage:[UIImage imageNamed:@"btn_query"] forState:UIControlStateNormal];
    [rightSearchItem addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    rightMenuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightMenuItem.frame = CGRectMake(45,12,40,40);
    [rightMenuItem setImage:[UIImage imageNamed:@"列表table"] forState:UIControlStateNormal];
    [rightMenuItem addTarget:self action:@selector(menuSowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[QCSchoolTagHandle sharedInstance].currentViewTypeOfAnalytic isEqualToString:@"TapBigData"]) {
        if (!rightMenuItem.superview) {
            [bgview addSubview:rightMenuItem];
        }
        self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgview];
    }else
    {
        if (!rightSearchItem.superview) {
            [bgview addSubview:rightSearchItem];
        }
        if (!rightMenuItem.superview) {
            [bgview addSubview:rightMenuItem];
        }
        self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgview];
    }
}



#pragma mark -WebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD showWithStatus:@"正在加载"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [self.view makeToast:@"加载失败,请重试" duration:1.5 position:CSToastPositionCenter];
}


#pragma mark - tagDidChangeDelegate
-(void)tagDidChange:(NSInteger)tag
{
    //    self.viewTag = tag;
//    self.tempViewTag = tag;
//    if ([[QCSchoolTagHandle sharedInstance] currentViewTagOfAnalytic] == 1001) {
//        rightSearchItem.hidden = YES;
//    }else
//    {
//        rightSearchItem.hidden = NO;
//    }
}



#pragma mark - qcsMenuTableDelegate

-(void)menuTableCellSelectedWithIndexpathRowOfStudent:(NSInteger)row
{
    QCSSourceModel *model = [[NSMutableArray arrayWithArray:[QCSSourceHandler getStudyAnalyticsArrayStudent]] objectAtIndex:row];
    
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
//    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
//    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
//    NSString *passWord = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    
    NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&subMenuType=%@&eclassId=%@&sys_token=%@&studentName=%@",studentID,@"mobile",@"true",@"2",model.typeNum,self.eclassID,token,self.chooseStudentName];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
//    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    for (UIViewController *tempController in self.parentViewController.childViewControllers) {
        qcsStudyAnalyticsInsideController *controller = (qcsStudyAnalyticsInsideController *)tempController;
        if ([controller.controllerType isEqualToString:@"TapStudent"]) {
            for (UIView *webView in controller.view.subviews) {
                if ([webView isKindOfClass:[WKWebView class]]) {
                    WKWebView *refreshWebView = (WKWebView *)webView;
                    [refreshWebView  loadRequest:request];
                }
            }

        }
    }
    
}

-(void)menuTableCellSelectedWithIndexpathRowOfBigData:(NSInteger)row
{
//    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//
//    //// Date from
//
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//
//    //// Execute
//
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//
//        // Done
//        NSLog(@"清除缓存完毕");
//
//    }];
    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
    
    
    
    QCSStudyAnalyticsItemModel *model = self.bigDataArray[row];
    NSString *groupSchoolType = @"";
    if ([model.schoolFlag isEqualToString:@"0"]) {
        groupSchoolType = @"0";
    }else groupSchoolType = @"1";
    

    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    
    NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&groupSchoolType=%@&subSchoolId=%@&sys_token=%@",studentID,@"mobile",@"true",@"0",groupSchoolType,model.id,token];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
//    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];


    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    for (UIViewController *tempController in self.parentViewController.childViewControllers) {
        qcsStudyAnalyticsInsideController *controller = (qcsStudyAnalyticsInsideController *)tempController;
        if ([controller.controllerType isEqualToString:@"TapBigData"]) {
            for (UIView *webView in controller.view.subviews) {
                if ([webView isKindOfClass:[WKWebView class]]) {
                    WKWebView *refreshWebView = (WKWebView *)webView;
                    [refreshWebView  loadRequest:request];
                }
            }
        }
    }
    
}

- (void)menuTableCellSelectedWithIndexpathRowOfClass:(NSInteger )row
{
    
    QCSSourceModel *model = [[NSMutableArray arrayWithArray:[QCSSourceHandler getStudyAnalyticsArrayClass]] objectAtIndex:row];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    
    NSString *urlString = [NSString stringWithFormat:@"sys_auto_authenticate=%@&pageType=%@&sys_token=%@&menuType=%@&subMenuType=%@&eclassId=%@",@"true",@"1",token,model.parentLevel,model.typeNum,self.tempCourseID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
//    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    
    for (UIViewController *tempController in self.parentViewController.childViewControllers) {
        qcsStudyAnalyticsInsideController *controller = (qcsStudyAnalyticsInsideController *)tempController;
        if ([controller.controllerType isEqualToString:@"TapClass"]) {
            for (UIView *webView in controller.view.subviews) {
                if ([webView isKindOfClass:[WKWebView class]]) {
                    WKWebView *refreshWebView = (WKWebView *)webView;
                    [refreshWebView  loadRequest:request];
                }
            }
        }
    }
    
}


#pragma mark - private
-(void)menuSowAction:(id)sender
{
    
    if ([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic]  isEqualToString:@"TapBigData"]) {
        
        qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
        
        // 这个代码与框架无关，与demo相关，因为有兄弟在侧滑出来的界面，使用present到另一个界面返回的时候会有异常，这里提供各个场景的解决方式，需要在侧滑的界面present的同学可以借鉴一下！处理方式在leftViewController的viewDidAppear:方法内
        vc.drawerType = DrawerTypeMaskLeft;
        vc.tapType = TapBigData;
        vc.delegate = self;
        vc.bigDataArray = [NSMutableArray arrayWithArray:_bigDataArray];
        // 调用这个方法
        [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
        
        
    }else if([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic] isEqualToString:@"TapClass"])
    {
        qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
        vc.drawerType = DrawerTypeMaskLeft;
        vc.tapType = TapClass;
        vc.delegate = self;
        [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
    }
    else if([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic] isEqualToString:@"TapStudent"])
    {
        qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
        vc.drawerType = DrawerTypeMaskLeft;
        vc.tapType = TapStudent;
        vc.delegate = self;
        [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
    }
    
//    switch ([[QCSchoolTagHandle sharedInstance] currentViewTagOfAnalytic] ) {
//        case 1001:
//        {
//            qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
//
//            // 这个代码与框架无关，与demo相关，因为有兄弟在侧滑出来的界面，使用present到另一个界面返回的时候会有异常，这里提供各个场景的解决方式，需要在侧滑的界面present的同学可以借鉴一下！处理方式在leftViewController的viewDidAppear:方法内
//            vc.drawerType = DrawerTypeMaskLeft;
//            vc.tapType = TapBigData;
//            vc.delegate = self;
//            vc.bigDataArray = [NSMutableArray arrayWithArray:_bigDataArray];
//            // 调用这个方法
//            [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
//        }
//            break;
//        case 1002:
//        {
//            qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
//            vc.drawerType = DrawerTypeMaskLeft;
//            vc.tapType = TapClass;
//            vc.delegate = self;
//            [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
//        }
//            break;
//        case 1003:
//        {
//            qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
//            vc.drawerType = DrawerTypeMaskLeft;
//            vc.tapType = TapStudent;
//            vc.delegate = self;
//            [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
//        }
//            break;
//        default:
//            break;
//    }
    
}

-(void)searchAction:(id)sender
{
    
    
    if ([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic]  isEqualToString:@"TapBigData"]) {
        
        
    }else if([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic] isEqualToString:@"TapClass"])
    {
        qcsStudyAnalyticsSearcuClassController *classView = [qcsStudyAnalyticsSearcuClassController new];
        classView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
        [self.navigationController pushViewController:classView animated:YES];
    }
    else if([[[QCSchoolTagHandle sharedInstance] currentViewTypeOfAnalytic] isEqualToString:@"TapStudent"])
    {
        qcsStudyAnalyticsSearcuStudentController *studentView = [qcsStudyAnalyticsSearcuStudentController new];
        studentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
        [self.navigationController pushViewController:studentView animated:YES];
    }
    
    
//    switch ([[QCSchoolTagHandle sharedInstance] currentViewTagOfAnalytic]) {
//        case 1001:
//        {
//
//        }
//            break;
//        case 1002:
//        {
//            qcsStudyAnalyticsSearcuClassController *classView = [qcsStudyAnalyticsSearcuClassController new];
//            classView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
//            [self.navigationController pushViewController:classView animated:YES];
//        }
//            break;
//        case 1003:
//        {
//            qcsStudyAnalyticsSearcuStudentController *studentView = [qcsStudyAnalyticsSearcuStudentController new];
//            studentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
//            [self.navigationController pushViewController:studentView animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
}

#pragma mark - Notifacation
-(void)refreshClass:(NSNotification *)user
{
     if ([self.controllerType isEqualToString:@"TapClass"]) {
         
         NSDictionary *dic = user.userInfo;
         self.tempCourseID =  [dic objectForKey:@"chooseEclassID"];
         
         NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
         
         NSString *urlString = [NSString stringWithFormat:@"sys_auto_authenticate=%@&pageType=%@&sys_token=%@&menuType=%@&subMenuType=%@&eclassId=%@",@"true",@"1",token,@"0",@"100",self.tempCourseID];
         
         NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
         [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
     }
}

-(void)refreshStudent:(NSNotification *)user
{
    
    if ([self.controllerType isEqualToString:@"TapStudent"]) {
        
        NSDictionary *dic = user.userInfo;
        
        self.eclassID =  [dic objectForKey:@"chooseEclassID"];
        studentID = [dic objectForKey:@"chooseStudentID"];
        self.chooseStudentName  = [dic objectForKey:@"chooseStudentName"];
        
        NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
        
        NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&subMenuType=%@&eclassId=%@&sys_token=%@&studentName=%@",studentID,@"mobile",@"true",@"2",@"100",self.eclassID,token,self.chooseStudentName];
        NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
        [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
    }
    
}




-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
