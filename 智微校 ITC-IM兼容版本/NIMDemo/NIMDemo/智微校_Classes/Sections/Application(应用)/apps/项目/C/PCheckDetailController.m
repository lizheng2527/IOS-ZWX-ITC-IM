//
//  PCheckDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/23.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PCheckDetailController.h"

#import <UIView+Toast.h>

#import "PServiceApplyMainCell.h"
#import "PProjectApprovalCheckController.h"
#import "PServiceApplicationDetailController.h"

#import "TYHRepairNetRequestHelper.h"
#import "RepairManagementModel.h"

#import "MRDMainController.h"
#import "MyRepairServiceFeedBackController.h"

#import "PCheckMainCell.h"
#import "ProjectNetHelper.h"
#import "ProjectMainModel.h"

@interface PCheckDetailController ()<UITableViewDelegate,UITableViewDataSource,PCheckMainCellDelegate>

@property(nonatomic,retain)NSMutableArray *allArray;
@property(nonatomic,retain)NSMutableArray *wshArray;
@property(nonatomic,retain)NSMutableArray *ytgArray;

@end

@implementation PCheckDetailController
{
    UITableView *mainTableView;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

#pragma mark - initData
-(void)setViewTag:(NSInteger)viewTag
{
    _viewTag = viewTag;
}

-(void)requestData
{
    _allArray = [NSMutableArray array];
    _wshArray = [NSMutableArray array];
    _ytgArray = [NSMutableArray array];
    
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    if (_viewTag == 1001) {
        [helper getCheckListWithCheckStatus:@"" andStatus:^(BOOL successful, NSMutableArray *dataSourceALL) {
            _allArray = [NSMutableArray arrayWithArray:dataSourceALL];
            
            
            [mainTableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    else if(_viewTag == 1002)
    {
        [helper getCheckListWithCheckStatus:@"0" andStatus:^(BOOL successful, NSMutableArray *dataSourceWSH) {
            _wshArray = [NSMutableArray arrayWithArray:dataSourceWSH];
            [SVProgressHUD dismiss];
            [mainTableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    else if (_viewTag == 1003)
    {
        [helper getCheckListWithCheckStatus:@"1" andStatus:^(BOOL successful, NSMutableArray *dataSourceYTG) {
            _ytgArray = [NSMutableArray arrayWithArray:dataSourceYTG];
            [SVProgressHUD dismiss];
            [mainTableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
//        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 70) style:UITableViewStylePlain];
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
    switch (self.viewTag) {
        case 1001:
        {
            return _allArray.count;
        }
            break;
        case 1002:
        {
            return self.wshArray.count;
        }
            break;
        case 1003:
        {
            return self.ytgArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 197.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            static NSString *iden1 = @"PCheckMainCell1";
            PCheckMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PCheckMainCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            cell.model = _allArray[indexPath.row];
            return cell;
        }
            break;
        case 1002:
        {
            
            //未接单
            static NSString *iden2 = @"PCheckMainCell2";
            PCheckMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PCheckMainCell" owner:self options:nil].firstObject;
            }
            
            cell.delegate = self;
            cell.model = _wshArray[indexPath.row];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 1003:
        {
            
            //维修中
            static NSString *iden3 = @"PCheckMainCell3";
            PCheckMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PCheckMainCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _ytgArray[indexPath.row];
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

#pragma mark - MRADetailCellDelegate
- (void)CheckClicked:(PCheckMainCell *)cell
{
    PProjectApprovalCheckController *checkView = [PProjectApprovalCheckController new];
    checkView.projectID = cell.model.id;
    [self.navigationController pushViewController:checkView animated:YES];
    
}

- (void)DetailBtnClicked:(PCheckMainCell *)cell
{
    PServiceApplicationDetailController *applyDetailView = [PServiceApplicationDetailController new];
    applyDetailView.projectApplyID = cell.model.id;
    [self.navigationController pushViewController:applyDetailView animated:YES];
}

#pragma mark -Actions



#pragma mark -Other
-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
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
