//
//  TakeCourseMineViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseMineViewController.h"
#import "TYHTakeCourseViewController.h"
#import "TakeCourseHeaderView.h"
#import "TakeCourseHelper.h"
#import "TakeCourseModel.h"
#import "TakeCourseMineCell.h"
#import "TakeCourseDetailViewController.h"


@interface TakeCourseMineViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *mainTableView;

    NSMutableArray *mineCourseArray;
    NSString *ecActivityId;
}

@end

@implementation TakeCourseMineViewController
-(instancetype)initWithEcID:(NSString *)EcID
{
    self = [super init];
    if (self) {
        ecActivityId = EcID;
        [self requestData];
    }
    return self;
}

#pragma mark -requestData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    TakeCourseHelper *helper = [[TakeCourseHelper alloc]init];
    [helper getMineCourse:^(BOOL successful, NSMutableArray *mineCourseDatasource) {
        mineCourseArray = [NSMutableArray arrayWithArray:mineCourseDatasource];
        
        NSArray *dictArray = [SchoolTermInfoListModel keyValuesArrayWithObjectArray:mineCourseDatasource];
        NSLog(@"%@",dictArray);
        
        [mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        mineCourseArray = [NSMutableArray array];
        [hud removeFromSuperview];
    }];
}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的选课";
    [self createLeftBarItem];
    [self initTableView];
    // Do any additional setup after loading the view.
}


#pragma mark - initView
-(void)initTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30 - 44) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    [mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:mainTableView];
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
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选课" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(chooseCourse)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}

#pragma mark - tableView delegate && datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        SchoolTermInfoListModel *model = mineCourseArray[indexPath.section];
        schoolTermStudentCourseModel *useModel  = model.courseArray[indexPath.row];
            static NSString *iden2 = @"TakeCourseMineCell";
            TakeCourseMineCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TakeCourseMineCell" owner:self options:nil].firstObject;
                cell.model = useModel;
            }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TakeCourseHeaderView *headerView = [[TakeCourseHeaderView alloc]init];
    SchoolTermInfoListModel *model = [mineCourseArray objectAtIndex:section];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@    总学分:%@",model.fullName,model.sumScore];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchoolTermInfoListModel *model = mineCourseArray[indexPath.section];
    schoolTermStudentCourseModel *useModel  = model.courseArray[indexPath.row];
    TakeCourseDetailViewController *detailView = [[TakeCourseDetailViewController alloc]init];
    detailView.ecActivityCourseId = useModel.ecActivityCourseId;
    [self.navigationController pushViewController:detailView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(SchoolTermInfoListModel *)mineCourseArray[section] courseArray].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mineCourseArray.count;
}

#pragma mark - Action
-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)chooseCourse
{
    TYHTakeCourseViewController *takeView = [[TYHTakeCourseViewController alloc]initWithEcID:ecActivityId];
    [self.navigationController pushViewController:takeView animated:YES];
    
}


#pragma mark - Other

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:@"saveCourseSuccessful" object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    如果不想影响其他页面的导航透明度，viewWillDisappear将其设置为nil即可:
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
