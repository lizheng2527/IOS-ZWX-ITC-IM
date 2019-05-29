//
//  HomeWorkViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#define kAdmin [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME]

#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1

#import "HomeWorkViewController.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "TYHHttpTool.h"
#import "homeworkListCell.h"
#import "HWCourseModel.h"
#import "HWListModel.h"
#import "PopoverView.h"
#import "TitleButton.h"
#import "HWNetWorkHandler.h"
#import "lookHomeworkViewController.h"
#import <MBProgressHUD.h>

#import "LYEmptyViewHeader.h"

@interface HomeWorkViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) TitleButton * titleButton;
@end

@implementation HomeWorkViewController{
    NSInteger pageNum;
    NSString *ownerVoip;
    NSString *courseID;
    NSInteger titleIndex;
    NSMutableArray *titleIndexArray;
    UILabel *noDatalabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.title = @"作业";
    [self changeLeftBar];
    [self creatTitleView];
    [self initData];
    [self initTableView];
    [self configCourseData:courseID];
//    [self configHomeworkListData:courseID page:1];
    
    [self setupDownRefresh];
    [self setupUpRefresh];
}

#pragma mark - 初始化
-(instancetype)initWithVoipAccount:(NSString *)voipAccount userName:(NSString*)userName headIconImage:(UIImage *)image teacherOrUser:(BOOL)teacherOrUser
{
    self = [super init];
    _voipAccount = voipAccount;
    _userName = userName;
    _headIconImage = image;

    return self;
}

-(void)initData
{
    pageNum = 1;
    titleIndex = 0;
    _dataSource = [NSMutableArray array];
    _ListArray = [NSMutableArray array];
    courseID = @"";
    
}
-(void)configCourseData:(NSString *)tmpCourseID
{
    HWNetWorkHandler *Helper = [[HWNetWorkHandler alloc]init];
    [Helper getCourseListWithStudentID:courseID Status:^(BOOL successful, NSMutableArray *dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:dataSource];

            } failure:^(NSError *error) {
        
        _dataSource = nil;
    }];
}

-(void)configHomeworkListData:(NSString *)tmpCourseID page:(NSInteger )page
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    HWNetWorkHandler *Helper = [[HWNetWorkHandler alloc]init];
    [Helper getHomeWorkListWithPage:1 CourseID:courseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _ListArray  = [NSMutableArray arrayWithArray:dataSource];
        [_mainTableView reloadData];
        [_mainTableView.mj_header endRefreshing];
         [_mainTableView.mj_footer endRefreshing];
        [self shouldCreateNoData:dataSource];
        [hud removeFromSuperview];
        
    } failure:^(NSError *error) {
        _ListArray = nil;
         [hud removeFromSuperview];
    }];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
  
}


#pragma mark - 初始化TableView
-(void)initTableView
{
//    _mainTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 24) style:UITableViewStylePlain];
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.layer.masksToBounds = YES;
    _mainTableView.layer.borderWidth = 0.3f;
    _mainTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.navigationController.delegate = self;
    [self.view addSubview:_mainTableView];
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}

#pragma mark - TableViewDelegate And TableViewDataSource;


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HWListModel *model = _ListArray[indexPath.row];
    static NSString *iden = @"homeworkListCell";
    
    homeworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"homeworkListCell" owner:self options:nil].firstObject;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
    }
    //判断是否是同一天
    if (indexPath.row >0) {
        HWListModel *modelPre = _ListArray[indexPath.row - 1];
        HWListModel *modelNext = _ListArray[indexPath.row];
        if ([[self dealPublishSring:modelPre.setTime] isEqualToString:[self dealPublishSring:modelNext.setTime]] ) {
            cell.mutableTimeLabel_Left.hidden = YES;
            cell.mutableTimeLabel_Right.hidden = YES;
            cell.dayTimeLabel.hidden = YES;
        }
    }
    if (indexPath.row == 0 && [self checkTheDate:model.setTime]) {
        cell.mutableTimeLabel_Right.hidden = YES;
        cell.mutableTimeLabel_Left.hidden = YES;
    }
    else
    {
        cell.dayTimeLabel.hidden = YES;
    }
    return cell;
}


-(BOOL )checkTheDate:(NSString *)string{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    
    return [[NSCalendar currentCalendar] isDateInToday:date];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HWListModel *model = _ListArray[indexPath.row];
    lookHomeworkViewController *lookView = [[lookHomeworkViewController alloc]init];
    lookView.homeworkID = model.studentWorkId;
    [self.navigationController pushViewController:lookView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_ListArray.count > 0) {
        return _ListArray.count;
    }
    else
        return 0;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - 方法

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

-(NSString *)dealPublishSring:(NSString *)string
{
    NSString *tmpString = [string substringWithRange:NSMakeRange(0, 10)];
    return tmpString;
}

#pragma mark - 创建返回NavBarItem
-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HomeWork_returns"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeWork_returns"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -  下拉刷新新数据
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
    // 2.进入刷新状态
    [_mainTableView.mj_header beginRefreshing];
}

- (void)loadNewStatus {
    [self configHomeworkListData:courseID page:1];
}
#pragma mark  -  上拉加载
- (void)setupUpRefresh {
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
}

-(void)loadMoreStatus
{
    pageNum ++;
    [self configHomeworkListData:courseID page:pageNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果进入的是当前视图控制器
    
    if (viewController == self) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor myCyanColor]}];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}


#pragma mark   -------  定义titleView下拉菜单
- (void)creatTitleView {
    _titleButton = [[TitleButton alloc] init];
    _titleButton.titleTypeByV3App = @"homework";
    _titleButton.selected = NO;
    [_titleButton setTitle:@"全部" forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor myCyanColor] forState:UIControlStateNormal];
    
    [_titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
}

#pragma mark   ======  titleView的菜单设置
- (void)titleClick:(UIButton *)btn{
    CGPoint point = CGPointMake(btn.frame.origin.x + btn.frame.size.width/2, btn.frame.origin.y + btn.frame.size.height + 20);
    titleIndexArray = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%ld",(long)titleIndex]];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:_dataSource images:titleIndexArray];
    NSLog(@"titleIndexArray : %@",titleIndexArray);
    
    pop.selectRowAtIndex = ^(NSInteger index){
        [_titleButton setTitle:[_dataSource[index] courseName] forState:UIControlStateNormal];
        courseID = [_dataSource[index] courseId];
        [self configHomeworkListData:courseID page:1];
        titleIndex = index;
    };
    [pop show];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewStatus) name:@"HWrefresh" object:nil];
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
