//
//  PCheckSearchListController.m
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PCheckSearchListController.h"

#import "PServerRecordCell.h"
#import "PServiceApplyMainCell.h"
#import "PVisitRecordCell.h"
#import "ProjectMainModel.h"

#import "ProjectNetHelper.h"
#import "PAddVisitRecordController.h"
#import "PVisitRecordDetailController.h"

#import "PAddServerApplicationController.h"
#import "PServerRecordDetailController.h"

#import "PAddServerRecordController.h"
#import "PServerRecordDetailController.h"

@interface PCheckSearchListController ()<UITableViewDelegate,UITableViewDataSource,PVisitRecordCellDelegate,PServiceApplyMainCellDelegate,PServerRecordCellDelegate>

@property(nonatomic,retain)NSMutableArray *searchDatasource;

@end

@implementation PCheckSearchListController
{
    UITableView *mainTableView;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    self.title = @"搜索结果";
}

#pragma mark - initData

-(void)requestData
{
    _searchDatasource = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [SVProgressHUD showWithStatus:@"正在搜索..."];
    [helper getSearchListWithProjectID:_projectID StartDate:_startTime EndDate:_endTime DocumentKind:_typeID UserID:_userID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _searchDatasource = [NSMutableArray arrayWithArray:dataSource];
        [SVProgressHUD dismiss];
        [mainTableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    [self.view addSubview:mainTableView];
}


-(void)shouldCreateNoData:(NSMutableArray *)array
{
    noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width, 40)];
    noDatalabel.text = @"暂无更多";
    CGPoint centerPoint = CGPointMake(mainTableView.center.x, mainTableView.center.y - 30);
    noDatalabel.center = centerPoint;
    noDatalabel.textColor = [UIColor grayColor];
    noDatalabel.textAlignment = NSTextAlignmentCenter;
    noDatalabel.font = [UIFont boldSystemFontOfSize:17];
    if (!noDatalabel.superview && !array.count) {
        [self.view addSubview:noDatalabel];
    }
    else [noDatalabel removeFromSuperview];
}


#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDatasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([_typeID integerValue]) {
        case 1:
        {
            //            return self.allArray.count;
            return 140;
        }
            break;
        case 2:
        {
            return 169;
        }
            break;
        case 3:
        {
            return 169;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([_typeID integerValue]) {
        case 1:
        {
            //全部
            static NSString *iden1 = @"PVisitRecordCell";
            PVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PVisitRecordCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _searchDatasource[indexPath.row];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 2:
        {
            
            //未接单
            static NSString *iden2 = @"PServiceApplyMainCell";
            PServiceApplyMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PServiceApplyMainCell" owner:self options:nil].firstObject;
            }
            
            cell.delegate = self;
            cell.model = _searchDatasource[indexPath.row];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 3:
        {
            
            //维修中
            static NSString *iden3 = @"PServerRecordCell";
            PServerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PServerRecordCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _searchDatasource[indexPath.row];
            
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PVisitRecordCellDelegate

- (void)CheckClickedInVisitRecord:(PVisitRecordCell *)cell
{
    
}

- (void)DetailBtnClickedInVisitRecord:(PVisitRecordCell *)cell
{
    PVisitRecordDetailController *detailView = [PVisitRecordDetailController new];
    detailView.projectID = cell.model.id;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - PServiceApplyMainCellDelegate

- (void)CheckClickedInServiceApply:(PServiceApplyMainCell *)cell
{
    
    
}

- (void)DetailBtnClickedInServiceApply:(PServiceApplyMainCell *)cell
{
    
    PServerRecordDetailController *detailView = [PServerRecordDetailController new];
    detailView.projectID = cell.model.id;
    [self.navigationController pushViewController:detailView animated:YES];
}


#pragma mark - PServerRecordCellDelegate

- (void)CheckClickedInServerRecord:(PServerRecordCell *)cell
{
    
}

- (void)DetailBtnClickedInServerRecord:(PServerRecordCell *)cell
{
    PServerRecordDetailController *detailView = [PServerRecordDetailController new];
    detailView.projectID = cell.model.id;
    [self.navigationController pushViewController:detailView animated:YES];
}




#pragma mark -Actions



#pragma mark -Other
-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
}

@end
