//
//  MyReairApplicationDetailController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MyReairApplicationDetailController.h"
#import "MRADetailCell.h"

#import "TYHRepairNetRequestHelper.h"
#import "MyRepairApplicationModel.h"
#import <UIView+Toast.h>
#import "MRDMainController.h"

#import "UIAlertView+NTESBlock.h"
#import "MRFeedBackController.h"
#import "LYEmptyViewHeader.h"

@interface MyReairApplicationDetailController ()<UITableViewDelegate,UITableViewDataSource,MRADetailCellDelegate>

@property(nonatomic,retain)NSMutableArray *allArray;
@property(nonatomic,retain)NSMutableArray *wjdArray;
@property(nonatomic,retain)NSMutableArray *wxzArray;
@property(nonatomic,retain)NSMutableArray *dfkArray;
@property(nonatomic,retain)NSMutableArray *yxhArray;

@property(nonatomic,retain)UILabel *noDatalabel;
@end

@implementation MyReairApplicationDetailController
{
    UITableView *mainTableView;
    
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
    [SVProgressHUD showWithStatus:@"获取数据中"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    
    [helper getMyRepairApplicationListWithType:[NSString stringWithFormat:@"%ld",(long)self.viewTag - 1001] andStatus:^(BOOL successful, NSMutableArray *dataSource, NSMutableArray *wjdSource, NSMutableArray *wxzSource, NSMutableArray *dfkSource, NSMutableArray *yxhSource) {
        self.allArray = [NSMutableArray arrayWithArray:dataSource];
        self.wjdArray = [NSMutableArray arrayWithArray:wjdSource];
        self.wxzArray = [NSMutableArray arrayWithArray:wxzSource];
        self.dfkArray = [NSMutableArray arrayWithArray:dfkSource];
        self.yxhArray = [NSMutableArray arrayWithArray:yxhSource];
        [mainTableView reloadData];
        [SVProgressHUD dismiss];
        
        if (!dataSource.count) {
            [self shouldCreateNoData:dataSource];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];

    }];
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
    
    mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
   
}


#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
        {
            return self.allArray.count;
        }
            break;
        case 1002:
        {
            return self.wjdArray.count;
        }
            break;
        case 1003:
        {
            return self.wxzArray.count;
        }
            break;
        case 1004:
        {
            return self.dfkArray.count;
        }
            break;
        case 1005:
        {
            return self.yxhArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            static NSString *iden1 = @"MRADetailCell1";
            MRADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = self.allArray[indexPath.row];
            [cell.feedBackBtn setTitle:@"评价" forState:UIControlStateNormal];
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
         
            //未接单
            static NSString *iden2 = @"MRADetailCell2";
            MRADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = self.wjdArray[indexPath.row];
            [cell.feedBackBtn setTitle:@"评价" forState:UIControlStateNormal];
            
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
            static NSString *iden3 = @"MRADetailCell3";
            MRADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = self.wxzArray[indexPath.row];
            [cell.feedBackBtn setTitle:@"评价" forState:UIControlStateNormal];
            return cell;
        }
            break;
        case 1004:
        {
            
            //待反馈
            static NSString *iden4 = @"MRADetailCell4";
            MRADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden4];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = self.dfkArray[indexPath.row];
            [cell.feedBackBtn setTitle:@"评价" forState:UIControlStateNormal];
            return cell;
        }
            break;
        case 1005:
        {
            //待反馈
            static NSString *iden5 = @"MRADetailCell5";
            MRADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden5];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = self.yxhArray[indexPath.row];
            [cell.feedBackBtn setTitle:@"评价" forState:UIControlStateNormal];
            
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

#pragma mark  - MRADetailCellDelegate

-(void)LookBtnClicked:(MRADetailCell *)cell
{
    MRDMainController *mrdView = [MRDMainController new];
    mrdView.defaultIndex = 0;
    mrdView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:mrdView animated:YES];
}

-(void)FeedBackClicked:(MRADetailCell *)cell
{
    MRFeedBackController *dView = [MRFeedBackController new];
    dView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:dView animated:dView];
}

-(void)DelBtnClicked:(MRADetailCell *)cell
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除此报修单吗" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertWithCompletionHandler:^(NSInteger idx) {
        if (idx == 1) {
            TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
            [helper delRepairApplicationWithRepairID:cell.cellRepairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                [self.view makeToast:@"删除报修单成功" duration:1 position:CSToastPositionCenter];
                [self requestData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"删除报修单失败" duration:1 position:CSToastPositionCenter];
            }];
        }
    }];
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
@end
