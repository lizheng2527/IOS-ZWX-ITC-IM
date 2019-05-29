//
//  qcsStudyAnalyticStudentController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/3.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsStudyAnalyticStudentController.h"

#import "qcsMenuTableController.h"
#import "UIViewController+CWLateralSlide.h"
#import "QCSchoolDefine.h"
#import "QCSNetHelper.h"
#import "QCSStudyAnalyticsModel.h"
#import "QCSMainModel.h"

#define baseUrl [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_QCXT_URL],@"qc-wisdomClass/mStatistical.html?"]


@interface qcsStudyAnalyticStudentController ()<qcsMenuTableDelegate,WKUIDelegate,WKNavigationDelegate>


@property(nonatomic,retain)NSMutableArray *leftDataSource;
@property(nonatomic,retain)NSMutableArray *rightDataSource;

@property(nonatomic,assign)NSInteger pageNumClass;
@property(nonatomic,assign)NSInteger pageNumStudent;

@property(nonatomic,assign)NSInteger tempViewTag;

@property(nonatomic,retain)NSMutableArray *bigDataArray;


@end

@implementation qcsStudyAnalyticStudentController
{
    UIButton * rightMenuItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"学情分析";
    
    self.chooseStudentName = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERNAME] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self initView];
    
    [self getData];
    
}



-(void)getData{
    
    __weak typeof(self) weakSelf = self;
    _bigDataArray = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [[QCSNetHelper alloc]init];
    
    [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
        if (dataSource.count) {
            QCSMainUserModel *model = dataSource[0];
            [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:@"1" startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                [SVProgressHUD dismiss];
                
                
                [helper getStudyAnalyticsQueryData:^(BOOL successful, QCSStudyAnalyticsModel *mainModel) {
                    weakSelf.bigDataArray = [NSMutableArray arrayWithArray:mainModel.shcoolDataModelArray];
                    [SVProgressHUD dismiss];
                    
                    self.chooseStudentName = [model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
                    
                    NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&subMenuType=%@&eclassId=%@&sys_token=%@&studentName=%@",_studentID,@"mobile",@"true",@"2",@"100",self.eclassID,token,self.chooseStudentName];
                    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
                    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
                    
                    
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
    _mainWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _mainWebView.navigationDelegate = self;
    _mainWebView.UIDelegate = self;
    _mainWebView.scrollView.bounces = NO;
    [self.view addSubview:_mainWebView];
    
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 64)];
    
    rightMenuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightMenuItem.frame = CGRectMake(45,12,40,40);
    //    [rightMenuItem sizeToFit];
    [rightMenuItem setImage:[UIImage imageNamed:@"列表table"] forState:UIControlStateNormal];
    [rightMenuItem addTarget:self action:@selector(menuSowAction:) forControlEvents:UIControlEventTouchUpInside];
    if (!rightMenuItem.superview) {
        [bgview addSubview:rightMenuItem];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgview];
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



#pragma mark - qcsMenuTableDelegate

-(void)menuTableCellSelectedWithIndexpathRowOfStudent:(NSInteger)row
{
    QCSSourceModel *model = [[NSMutableArray arrayWithArray:[QCSSourceHandler getStudyAnalyticsArrayStudent]] objectAtIndex:row];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    
    NSString *urlString = [NSString stringWithFormat:@"studentId=%@&visitFlag=%@&sys_auto_authenticate=%@&pageType=%@&subMenuType=%@&eclassId=%@&sys_token=%@&studentName=%@",_studentID,@"mobile",@"true",@"2",model.typeNum,self.eclassID,token,self.chooseStudentName];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseUrl,urlString];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestString]]];
    
}


#pragma mark - private
-(void)menuSowAction:(id)sender
{
            qcsMenuTableController *vc = [[qcsMenuTableController alloc] init];
            vc.drawerType = DrawerTypeMaskLeft;
            vc.tapType = TapStudent;
            vc.delegate = self;
            [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
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
