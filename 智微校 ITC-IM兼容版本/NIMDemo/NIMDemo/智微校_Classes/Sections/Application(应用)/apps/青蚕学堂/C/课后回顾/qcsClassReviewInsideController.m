//
//  qcsClassReviewInsideController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewInsideController.h"
#import "QCSchoolDefine.h"

#import "qcsClassReviewInsideClassCell.h"
#import "qcsClassReviewInsideStudentCell.h"

#import "qcsClassDetailMainController.h"
#import "qcsClassStasticMainController.h"
#import "qcsClassInteractionMainController.h"

#import "QCSNetHelper.h"
#import "QCSMainModel.h"
#import <MJRefresh.h>


#import "qcsClassReviewSearchController.h"
#import "qcsClassReviewSearchStudentController.h"

#import "qcsClassReviewMainController.h"


@interface qcsClassReviewInsideController ()<UITableViewDelegate,UITableViewDataSource,qcsClassReviewInsideClassCellDelegate,qcsClassReviewInsideStudentCellDelegate,tagChangeDelegate>

@property(nonatomic,retain)NSMutableArray *leftDataSource;
@property(nonatomic,retain)NSMutableArray *rightDataSource;

@property(nonatomic,assign)NSInteger pageNumClass;
@property(nonatomic,assign)NSInteger pageNumStudent;

@property(nonatomic,assign)NSInteger tempViewTag;
@end

@implementation qcsClassReviewInsideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    [self getData];
    
    [self createBarItem];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getChooseDataClass:) name:@"shouldRefrshClass" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getChooseDataStudent:) name:@"shouldRefrshStudent" object:nil];
}

-(void)tagDidChange:(NSInteger)tag
{
//    self.viewTag = tag;
    self.tempViewTag = tag;
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor clearColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = NO;
//    _mainTableView.bounces = NO;
    _mainTableView.backgroundColor = [UIColor QCSBackgroundColor];
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _mainTableView.delaysContentTouches =NO;
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    if (self.viewTag == 1001) {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataClass)];
    }else
    {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataStudent)];
    }
}


-(void)createBarItem
{

    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_query"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_query"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    }
    
    self.parentViewController.navigationItem.rightBarButtonItem = rightItem;
}


-(void)searchAction:(id)sender
{
    
    if (self.tempViewTag == 1002) {
        
        qcsClassReviewSearchStudentController *searchView = [[qcsClassReviewSearchStudentController alloc]init];
        searchView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        [self.navigationController pushViewController:searchView animated:YES];
    }
    else
    {
        qcsClassReviewSearchController *searchView = [[qcsClassReviewSearchController alloc]init];
        
        searchView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        [self.navigationController pushViewController:searchView animated:YES];
    }
}



-(void)getData{
    
    if (self.viewTag == 1001) {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataClass)];
    }else
    {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataStudent)];
    }
    
    __weak typeof(self) weakSelf = self;
    _leftDataSource = [NSMutableArray array];
    _rightDataSource = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    if (self.viewTag == 1001) {
        _pageNumClass = 1;
        
        [helper getClassListWithEclassID:self.eclassID pageNum:@"1" startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] andStatus:^(BOOL successful, NSMutableArray *tempDataSource) {
            _leftDataSource = tempDataSource;
            
            [weakSelf.mainTableView.mj_header endRefreshing];
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            [weakSelf.mainTableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }];
    }else if(self.viewTag == 1002)
    {
        _pageNumStudent = 1;
        [SVProgressHUD showWithStatus:@"获取数据中"];
        
        [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
            if (dataSource.count) {
                QCSMainUserModel *model = dataSource[0];
                [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:@"1" startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                    _rightDataSource = dataSource;
//                    [_rightDataSource enumerateObjectsUsingBlock:^(QCSMainStudentModel  *studentObj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        studentObj.studentID = model.id;
//                        studentObj.studentName = model.name;
//                    }];
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
    
}

#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewTag == 1001) {
        return self.leftDataSource.count;
    }else
        return self.rightDataSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
            return 115.f;
            break;
            case 1002:
            return 230.f;
            break;
        default:return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.viewTag) {
        case 1001:
        {
            static NSString *iden1 = @"qcsClassReviewInsideClassCell";
            qcsClassReviewInsideClassCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassReviewInsideClassCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            
            if (self.leftDataSource.count) {
                cell.model = self.leftDataSource[indexPath.row];
            }
            
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 1002:
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
            default:return [UITableViewCell new];
    }
    
            
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - qcsClassReviewInsideClassCellDelegate
-(void)StasticsBtnClicked:(qcsClassReviewInsideClassCell *)cell
{
    qcsClassStasticMainController *smView = [qcsClassStasticMainController new];
    smView.wisdomclassId = cell.model.id;
    [self.navigationController pushViewController:smView animated:YES];
}

-(void)InteractionBtnClicked:(qcsClassReviewInsideClassCell *)cell
{
    qcsClassInteractionMainController *interView =[qcsClassInteractionMainController new];
    interView.wisdomclassId = cell.model.id;
    [self.navigationController pushViewController:interView animated:YES];
}

-(void)ClassDetailBtnClicked:(qcsClassReviewInsideClassCell *)cell
{
    qcsClassDetailMainController *dmView = [qcsClassDetailMainController new];
    dmView.wisdomclassId = cell.model.id;
    dmView.userType = @"teacher";
    [self.navigationController pushViewController:dmView animated:YES];
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


#pragma mark - private

-(void)getChooseDataClass:(NSNotification *)user
{
    _pageNumClass = 1;
    
    if (self.viewTag == 1001) {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChooseDataClass)];
    }else
    {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChooseDataStudent)];
    }
    
    
    NSDictionary *dic = user.userInfo;
    
    self.chooseEndTime = [dic objectForKey:@"chooseEndTime"];
    self.chooseStartTime = [dic objectForKey:@"chooseStartTime"];
    self.chooseCourseID = [dic objectForKey:@"chooseCourseID"];
    self.chooseEclassID = [dic objectForKey:@"chooseEclassID"];
    
    __weak typeof(self) weakSelf = self;
    _leftDataSource = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getClassSearchListWithEclassID:self.chooseEclassID courseID:self.chooseCourseID pageNum:@"1" startTime:self.chooseStartTime endTime:self.chooseEndTime andStatus:^(BOOL successful, NSMutableArray *tempDataSource) {
            _leftDataSource = tempDataSource;
            
            [weakSelf.mainTableView.mj_header endRefreshing];
            [_mainTableView reloadData];
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            [weakSelf.mainTableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }];
    
}


-(void)getChooseDataStudent:(NSNotification *)user
{
    
    _pageNumStudent = 1;
    
    if (self.viewTag == 1001) {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChooseDataClass)];
    }else
    {
        self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChooseDataStudent)];
    }
    
    NSDictionary *dic = user.userInfo;
    
    self.chooseEndTime = [dic objectForKey:@"chooseEndTime"];
    self.chooseStartTime = [dic objectForKey:@"chooseStartTime"];
    self.chooseCourseID = [dic objectForKey:@"chooseCourseID"];
    self.chooseEclassID = [dic objectForKey:@"chooseEclassID"];
    self.chooseStudentID = [dic objectForKey:@"chooseStudentID"];
    self.chooseStudentName = [dic objectForKey:@"chooseStudentName"];
    
    
    __weak typeof(self) weakSelf = self;
    _rightDataSource = [NSMutableArray array];
    
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    [SVProgressHUD setMaxSupportedWindowLevel:UIWindowLevelAlert];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
            [helper getStudentAndClassListWithEclassID:self.chooseEclassID pageNum:@"1" startTime:self.chooseStartTime endTime:self.chooseEndTime studentID:self.chooseStudentID studentName:self.chooseStudentName courseID:self.chooseCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {

                _rightDataSource = dataSource;
                [weakSelf.mainTableView.mj_header endRefreshing];
                [_mainTableView reloadData];
                [SVProgressHUD dismiss];
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                [weakSelf.mainTableView.mj_header endRefreshing];
            }];
}




#pragma mark -LoadMoreData

-(void)loadMoreDataClass
{
    _pageNumClass++;
    
    __weak typeof(self) weakSelf = self;
    
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getClassListWithEclassID:self.eclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNumClass] startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] andStatus:^(BOOL successful, NSMutableArray *tempDataSource) {
        [_leftDataSource addObjectsFromArray:tempDataSource];
        if (!tempDataSource.count) {
            _pageNumClass --;
            [self.parentViewController.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
        }
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [_mainTableView reloadData];

        } failure:^(NSError *error) {
            [weakSelf.mainTableView.mj_footer endRefreshing];
            _pageNumClass --;
        }];
    
}

-(void)loadMoreDataStudent
{
    _pageNumStudent ++;
    __weak typeof(self) weakSelf = self;
    
    QCSNetHelper *helper = [QCSNetHelper new];
        
        [helper getUserModelArrayWithEclassId:self.eclassID status:^(NSMutableArray *dataSource) {
            if (dataSource.count) {
                QCSMainUserModel *model = dataSource[0];
                [helper getStudentAndClassListWithEclassID:self.eclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNumStudent] startTime:[QCSSourceHandler getDateOneYearBefore] endTime:[QCSSourceHandler getDateToday] studentID:model.id  studentName:model.name courseID:self.tempCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                    if (!dataSource.count) {
                        _pageNumStudent--;
                        [self.parentViewController.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
                    }

                    [_rightDataSource addObjectsFromArray:dataSource];
                    [weakSelf.mainTableView.mj_footer endRefreshing];
                    [_mainTableView reloadData];
                } failure:^(NSError *error) {
                    [weakSelf.mainTableView.mj_footer endRefreshing];
                    _pageNumStudent--;
                }];
                
            }
        }];
}

#pragma mark -
-(void)loadMoreChooseDataClass
{
    _pageNumClass++;
    
    __weak typeof(self) weakSelf = self;
    
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getClassListWithEclassID:self.chooseEclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNumClass] startTime:self.chooseStartTime endTime:self.chooseEndTime andStatus:^(BOOL successful, NSMutableArray *tempDataSource) {
        [_leftDataSource addObjectsFromArray:tempDataSource];
        if (!tempDataSource.count) {
            _pageNumClass --;
            [self.parentViewController.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
        }
        [weakSelf.mainTableView.mj_footer endRefreshing];
        [_mainTableView reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf.mainTableView.mj_footer endRefreshing];
        _pageNumClass --;
    }];
    
}

-(void)loadMoreChooseDataStudent
{
    _pageNumStudent ++;
    __weak typeof(self) weakSelf = self;
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
            [helper getStudentAndClassListWithEclassID:self.chooseEclassID pageNum:[NSString stringWithFormat:@"%ld",(long)_pageNumStudent] startTime:self.chooseStartTime endTime:self.chooseEndTime studentID:self.chooseStudentID studentName:self.chooseStudentName courseID:self.chooseCourseID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                if (!dataSource.count) {
                    _pageNumStudent--;
                    [self.parentViewController.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
                }
                
                [_rightDataSource addObjectsFromArray:dataSource];
                [weakSelf.mainTableView.mj_footer endRefreshing];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                [weakSelf.mainTableView.mj_footer endRefreshing];
                _pageNumStudent--;
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
