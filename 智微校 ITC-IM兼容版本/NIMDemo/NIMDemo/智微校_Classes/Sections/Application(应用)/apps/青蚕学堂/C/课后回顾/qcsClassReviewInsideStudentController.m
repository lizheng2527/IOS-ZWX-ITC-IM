//
//  qcsClassReviewInsideStudentController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/12.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewInsideStudentController.h"

#import "QCSchoolDefine.h"

#import "qcsClassReviewInsideClassCell.h"
#import "qcsClassReviewInsideStudentCell.h"

#import "qcsClassDetailMainController.h"
#import "qcsClassStasticMainController.h"
#import "qcsClassInteractionMainController.h"

#import "QCSNetHelper.h"
#import "QCSMainModel.h"
#import "qcsClassReviewSearchController.h"

#import <MJRefresh.h>



@interface qcsClassReviewInsideStudentController ()<UITableViewDelegate,UITableViewDataSource,qcsClassReviewInsideStudentCellDelegate>

@property(nonatomic,retain)NSMutableArray *rightDataSource;

@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation qcsClassReviewInsideStudentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"课堂回顾";
    
    [self initView];
    [self getData];
    
    [self createBarItem];
    
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = NO;
//    _mainTableView.bounces = NO;
    _mainTableView.backgroundColor = [UIColor QCSBackgroundColor];
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _mainTableView.delaysContentTouches =NO;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
}

-(void)createBarItem
{
    
    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_query"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_query"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    }
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)searchAction:(id)sender
{
    
        qcsClassReviewSearchController *searchView = [[qcsClassReviewSearchController alloc]init];
        searchView.userType = @"student";
        searchView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        [self.navigationController pushViewController:searchView animated:YES];

}




-(void)getData{
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    _pageNum = 1;
    __weak typeof(self) weakSelf = self;
    
    _rightDataSource = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
        [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
            if (dataSource.count) {
                
                __block QCSMainUserModel *model = [QCSMainUserModel new];
                
                [dataSource enumerateObjectsUsingBlock:^(QCSMainUserModel *studentObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([_studentId isEqualToString:studentObj.id]) {
                        model = studentObj;
                        
                        [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:@"1" startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                            _rightDataSource = dataSource;
                            [_rightDataSource enumerateObjectsUsingBlock:^(QCSMainStudentModel  *studentObj, NSUInteger idx, BOOL * _Nonnull stop) {
                                studentObj.studentID = model.id;
                                studentObj.studentName = model.name;
                            }];
                            [weakSelf.mainTableView.mj_header endRefreshing];
                            [_mainTableView reloadData];
                            [SVProgressHUD dismiss];
                        } failure:^(NSError *error) {
                            [SVProgressHUD dismiss];
                            [weakSelf.mainTableView.mj_header endRefreshing];
                        }];
                        
                    }
                }];
                
                
                
            }
        }];
    
    
}

#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return self.rightDataSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
            static NSString *iden2 = @"qcsClassReviewInsideStudentCell";
            qcsClassReviewInsideStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassReviewInsideStudentCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            if (self.rightDataSource.count) {
                cell.model = self.rightDataSource[indexPath.row];
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
            });
            return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - qcsClassReviewInsideStudentCellDelegate
-(void)DetailBtnClicked:(qcsClassReviewInsideStudentCell *)cell
{
    qcsClassDetailMainController *dmView = [qcsClassDetailMainController new];
    dmView.wisdomclassId = cell.model.id;
    dmView.userType = @"student";
    
    dmView.studentSXBJDatasource = [NSMutableArray arrayWithArray:cell.model.handwriteListModelArray];
    dmView.studentXZTDatasource = [NSMutableArray arrayWithArray:cell.model.chooseListModelArray];
    [self.navigationController pushViewController:dmView animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


#pragma mark - getChooseData

-(void)getChooseData{
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getChooseMoreData)];
    
    _pageNum = 1;
    _rightDataSource = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
        if (dataSource.count) {
            
            __block QCSMainUserModel *model = [QCSMainUserModel new];
            [dataSource enumerateObjectsUsingBlock:^(QCSMainUserModel *studentObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.studentId isEqualToString:studentObj.id]) {
                    model = studentObj;
                }
            }];
            
            [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:@"1" startTime:self.chooseStartTime endTime:self.chooseEndTime studentID:model.id studentName:model.name courseID:self.chooseCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _rightDataSource = dataSource;
                [_mainTableView reloadData];
                [SVProgressHUD dismiss];
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        }else
        {
            _rightDataSource = [NSMutableArray array];
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
        }
            
    }];
}

-(void)getChooseMoreData{
    
    _pageNum ++;
    
    __weak typeof(self) weakSelf = self;
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
        if (dataSource.count) {
            
            __block QCSMainUserModel *model = [QCSMainUserModel new];
            [dataSource enumerateObjectsUsingBlock:^(QCSMainUserModel *studentObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.studentId isEqualToString:studentObj.id]) {
                    model = studentObj;
                }
            }];
            
            [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNum] startTime:self.chooseStartTime endTime:self.chooseEndTime studentID:model.id studentName:model.name courseID:self.chooseCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                if(!dataSource.count)
                {
                    _pageNum --;
                    [self.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
                }
                [_rightDataSource addObjectsFromArray:dataSource];
                
                [weakSelf.mainTableView.mj_footer endRefreshing];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                 _pageNum --;
            }];
            
        }else
        {
            _rightDataSource = [NSMutableArray array];
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    }];
}




-(void)getMoreData{
    
    _pageNum ++;
    __weak typeof(self) weakSelf = self;
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
        if (dataSource.count) {
            
            QCSMainUserModel *model = dataSource[0];
            [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNum] startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                if(!dataSource.count)
                {
                    _pageNum --;
                    [self.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
                }
                [_rightDataSource addObjectsFromArray:dataSource];
                
                [weakSelf.mainTableView.mj_footer endRefreshing];
                [_mainTableView reloadData];
                
            } failure:^(NSError *error) {
                _pageNum --;
                [weakSelf.mainTableView.mj_footer endRefreshing];
            }];
            
        }
    }];
    
    
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
