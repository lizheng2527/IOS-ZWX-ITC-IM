//
//  TYHTranscriptViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHTranscriptViewController.h"
#import "TranscriptHelper.h"
#import "TranscriptModel.h"
#import "TranscriptHeaderView.h"
#import "JSDropDownMenu.h"
#import "TranscriptCell.h"
#import <MBProgressHUD.h>


@interface TYHTranscriptViewController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate,MBProgressHUDDelegate>

@end

@implementation TYHTranscriptViewController
{
    UITableView *mainTableView;
    JSDropDownMenu *menu;
    
    
    NSMutableArray *schoolTerminalArray; //学期数组
    NSMutableArray *examListArray; //考试列表数组
    NSMutableArray *studentScoreArray; //学生成绩数组
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _tmpStatusFlag;
    UILabel *noDatalabel;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _currentData1Index = 0;
        _currentData2Index = 0;
        _tmpStatusFlag = 0;
        [self requestData];
    }
    return self;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成绩单";
    [self initTableView];
    [self createLeftBarItem];
//    [self initDropMenu];
}

#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    TranscriptHelper *helper = [[TranscriptHelper alloc]init];
    [helper getAllSchoolTermJson:^(BOOL successful, NSMutableArray *dataSource) {
        if (!(_tmpStatusFlag > 0)) {
            for (TranscriptModel *model in dataSource) {
                if ([model.status isEqualToString:@"1"]) {
                    _currentData1Index = _tmpStatusFlag;
                }
                _tmpStatusFlag++;
            }
        }
        TranscriptModel *model = dataSource[_currentData1Index];
        schoolTerminalArray = [NSMutableArray arrayWithArray:dataSource];
        [helper getExamListWithSchoolTermId:model.terminalID Status:^(BOOL successful , NSMutableArray *examDatasource) {
            if (examDatasource.count > 0 && examDatasource) {
                ExamListModel *examModel  = examDatasource[_currentData2Index];
                examListArray  = [NSMutableArray arrayWithArray:examDatasource];
                [helper getgetStudentScoreWithExamID:examModel.examID Status:^(BOOL successful , NSMutableArray *studentScoreDatasource) {
                    studentScoreArray = [NSMutableArray arrayWithArray:studentScoreDatasource];
                    [self initDropMenu];
                    [mainTableView reloadData];
                    [hud removeFromSuperview];
                    [self shouldCreateNoData:studentScoreArray];
                } failure:^(NSError *error) {
                    studentScoreArray = [NSMutableArray array];
                    [hud removeFromSuperview];
                }];
            }
            else
            {
                ExamListModel *model = [ExamListModel new];
                model.name = @"暂无考试";
                model.examID = @"";
                examListArray = [NSMutableArray arrayWithObject:model];
                studentScoreArray = [NSMutableArray array];
                [self shouldCreateNoData:studentScoreArray];
                [hud removeFromSuperview];
                [self initDropMenu];
                [mainTableView reloadData];
            }
           
        } failure:^(NSError *error) {
            examListArray = [NSMutableArray array];
            [hud removeFromSuperview];
        }];
    } failure:^(NSError *error) {
        schoolTerminalArray = [NSMutableArray array];
        [hud removeFromSuperview];
    }];
}


#pragma mark - initView
-(void)initTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    mainTableView.separatorStyle = NO;
    [mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:mainTableView];
}

-(void)initDropMenu
{
    if (menu.superview && menu.tag == 1001) {
        [menu removeFromSuperview];
    }
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.tag = 1001;
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
    if (array.count == 0 ) {
        if (!noDatalabel.superview) {
            noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 50, [UIScreen mainScreen].bounds.size.width, 40)];
            noDatalabel.text = @"暂无成绩数据";
            noDatalabel.textColor = [UIColor grayColor];
            noDatalabel.textAlignment = NSTextAlignmentCenter;
            noDatalabel.font = [UIFont boldSystemFontOfSize:15];
            [self.view addSubview:noDatalabel];
        }
    }
    if (array.count > 0 && noDatalabel.superview ) {
        [noDatalabel removeFromSuperview];
    }
}

-(void)createLeftBarItem
{
    UIBarButtonItem * leftItem = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

#pragma mark - tableview datasource delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         return [UITableViewCell new];
    }
    else
    {
        StudentScoreModel *model = studentScoreArray[indexPath.row];
        static NSString *iden2 = @"TranscriptCell";
        TranscriptCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[TranscriptCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden2];
        }
        cell.model = model;
        if (indexPath.row % 2 ==1) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:0/255 blue:0/255 alpha:0.1];
        }else
            cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        TranscriptHeaderView *headerView = [[TranscriptHeaderView alloc]init];
        return headerView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }
    else
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 0.0f;
    }
    else
        return 30.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if (studentScoreArray && studentScoreArray.count > 0) {
            return studentScoreArray.count;
        }
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - JSDropMenu
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0){
        return schoolTerminalArray.count;
    } else if (column==1){
        return examListArray.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return [(TranscriptModel *)schoolTerminalArray[_currentData1Index] fullName];
            break;
        case 1: return [(ExamListModel *)examListArray[_currentData2Index] name];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return [(TranscriptModel *)schoolTerminalArray[indexPath.row] fullName] ;
        
    } else {
        
        return [(ExamListModel *)examListArray[indexPath.row] name];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if(indexPath.column == 0){
        _currentData1Index = indexPath.row;
        _currentData2Index = 0;
        [self requestData];
    } else{
        _currentData2Index = indexPath.row;
        [self requestData];
    }
}

#pragma mark - Action
-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    menu.frame = CGRectMake(menu.frame.origin.x, -y, menu.frame.size.width, menu.frame.size.height);
}

#pragma mark - Other

-(void)viewWillAppear:(BOOL)animated
{
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
