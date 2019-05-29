//
//  qcsHomeworkMainController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkMainController.h"
#import "qcsHomeworkReleaseController.h"
#import "qcsHomeworkSearchController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QCSNetHelper.h"
#import "qcsHomeworkModel.h"
#import "qcsHomeworkMainCell.h"
#import "QCSchoolDefine.h"
#import <MJRefresh.h>


@interface qcsHomeworkMainController ()<UITableViewDelegate,UITableViewDataSource,qcsHomeworkMainCellDelegate>

@property(nonatomic,retain)NSMutableArray *itemArray;


@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation qcsHomeworkMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"课后作业";
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    [self createSearchNavBarItem];
    [self tableViewConfig];
    
    [self requestData];
    
}



-(void)requestData
{
    _pageNum = 1;
    
    _itemArray = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper getHomeWorkPageListWithPageNum:@"1" eclassIds:_eclassIDs idGrade:_idGrade idCourses:_idCourses startTime:_startTime endTime:_endTime type:_type andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        _itemArray = dataSource;
        [_mainTableView reloadData];
        [_mainTableView.mj_header endRefreshing];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_mainTableView.mj_header endRefreshing];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
        
    }];
    
}

-(void)loadMoreData
{
    _pageNum ++;
    __weak typeof(self) weakSelf = self;
    
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getHomeWorkPageListWithPageNum:[NSString stringWithFormat:@"%ld",_pageNum] eclassIds:_eclassIDs idGrade:_idGrade idCourses:_idCourses startTime:_startTime endTime:_endTime type:_type andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        if (!dataSource.count) {
            _pageNum--;
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [self.parentViewController.view makeToast:@"暂无更多数据了" duration:1.5 position:CSToastPositionBottom];
        }
        else
        {
            [weakSelf.mainTableView.mj_footer endRefreshing];
            [_itemArray addObjectsFromArray:dataSource];
            [_mainTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.mainTableView.mj_footer endRefreshing];
        _pageNum--;
    }];
}



#pragma mark - tableviewDatasource && Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"qcsHomeworkMainCell";
    qcsHomeworkMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1 forIndexPath:indexPath];
    if (!cell) {
//        cell = [[qcsHomeworkMainCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden1];
        cell = [[NSBundle mainBundle]loadNibNamed:@"qcsHomeworkMainCell" owner:self options:nil].firstObject;
    }
    cell.delegate = self;
    
    cell.model = _itemArray[indexPath.row];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        ////////
        
    });
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"qcsHomeworkMainCell" cacheByIndexPath:indexPath configuration:^(qcsHomeworkMainCell *cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        cell.model = _itemArray[indexPath.row];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}


#pragma mark - qcsHomeworkMainCellDelegate
-(void)didClickDelButtonInCell:(qcsHomeworkMainCell *)cell
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除该条吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        QCSNetHelper *helper = [[QCSNetHelper alloc]init];
        [helper delHomeworkListWithHomeworkID:cell.model.id andStatus:^(BOOL successful) {
            
            if (successful) {
                NSIndexPath *indexPath= [_mainTableView indexPathForCell:cell];
                [_itemArray removeObjectAtIndex: indexPath.row];
                [_mainTableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"删除该条失败" duration:1.5 position:CSToastPositionCenter];
            
        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)didClickEditButtonInCell:(qcsHomeworkMainCell *)cell
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否修改本次作业" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        qcsHomeworkReleaseController *qcView = [[qcsHomeworkReleaseController alloc]init];
        qcView.preDetailModel = cell.model;
        qcView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        [self.navigationController pushViewController:qcView animated:YES];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}






#pragma mark - ButtonClicked

- (IBAction)releaseHomewAction:(id)sender {
    qcsHomeworkReleaseController *homeview = [qcsHomeworkReleaseController new];
    homeview.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
    [self.navigationController pushViewController:homeview animated:YES];
}


-(void)searchAction:(id)sender
{
    qcsHomeworkSearchController *searchView = [qcsHomeworkSearchController new];
    searchView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
    [self.navigationController pushViewController:searchView animated:YES];
}


#pragma mark - ViewConfig
-(void)createSearchNavBarItem
{
    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_query"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_query"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)tableViewConfig
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _mainTableView.backgroundColor = [UIColor QCSBackgroundColor];
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"qcsHomeworkMainCell" bundle:nil] forCellReuseIdentifier:@"qcsHomeworkMainCell"];
    
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
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
