//
//  AssetCheckDiliverController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetCheckDiliverController.h"
#import "AssetCheckDiliverCell.h"
#import "AssetApplyCheckController.h"
#import "AssetDiliverWaitController.h"
#import "AssetNetWorkHelper.h"
#import "TYHAssetModel.h"
#import "AssetDetailController.h"
#import "AssetApplyDetailController.h"
#import "LYEmptyViewHeader.h"

@interface AssetCheckDiliverController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AssetCheckDiliverController
{
    UITableView *mainTableView;
    
    TYHAssetModel *tyhAssetModel;
    
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    tyhAssetModel = [TYHAssetModel new];
    [helper getCheckDiliverlJsonWithPageNum:@"" State:@"" andStatus:^(BOOL successful, TYHAssetModel *assetModel) {
        tyhAssetModel = assetModel;

        [self initNoDataView];
        
//        [self shouldCreateNoData:assetModel.assetAllArray];
//        [self shouldCreateNoData:assetModel.assetUnPassArray];
//        [self shouldCreateNoData:assetModel.assetCheckArray];
//        [self shouldCreateNoData:assetModel.assetPassArray];
        
        [mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}

#pragma mark - initView
-(void)initView
{
    self.title = @"我的资产";
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


-(void)initNoDataView
{
    switch (self.viewTag) {
        case 1001:
        {
            [self shouldCreateNoData:tyhAssetModel.assetAllArray];
        }
            break;
        case 1002:
        {
            [self shouldCreateNoData:tyhAssetModel.assetCheckArray];
        }
            break;
        case 1003:
        {
            [self shouldCreateNoData:tyhAssetModel.assetPassArray];
        }
            break;
        case 1004:
        {
            [self shouldCreateNoData:tyhAssetModel.assetUnPassArray];
        }
            break;
        default:
            break;
    }
}


#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
        {
            return tyhAssetModel.assetAllArray.count;
        }
            break;
        case 1002:
        {
            return tyhAssetModel.assetCheckArray.count;
        }
            break;
        case 1003:
        {
            return tyhAssetModel.assetPassArray.count;
        }
            break;
        case 1004:
        {
            return tyhAssetModel.assetUnPassArray.count;
        }
            break;
        case 1005:
        {
            return tyhAssetModel.assetDiliverArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 253.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            
            
            AssetCheckDiliverModel *model1 = tyhAssetModel.assetAllArray[indexPath.row];
            static NSString *iden1 = @"AssetMineDetailCell1";
            AssetCheckDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AssetCheckDiliverCell" owner:self options:nil].firstObject;
                [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetCheckBtn.tag = 1001 + indexPath.row + 1001;
                [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetLookBtn.tag = 1001 + indexPath.row + 1003;
                [cell.assetDiliverBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetDiliverBtn.tag = 1001 + indexPath.row + 1002;
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                cell.model = model1;
            });
            return cell;
        }
            break;
        case 1002:
        {
            
            //未审核
            AssetCheckDiliverModel *model2 = tyhAssetModel.assetCheckArray[indexPath.row];
            static NSString *iden2 = @"AssetMineDetailCell2";
            AssetCheckDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AssetCheckDiliverCell" owner:self options:nil].firstObject;
                [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetCheckBtn.tag = 1002 + indexPath.row + 2001;
                [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetLookBtn.tag = 1002 + indexPath.row + 2003;
                [cell.assetDiliverBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetDiliverBtn.tag = 1002 + indexPath.row + 2002;
                [cell.assetDiliverBtn setHidden:YES];
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                cell.model = model2;
            });
            return cell;
        }
            break;
        case 1003:
        {
            //已通过
            AssetCheckDiliverModel *model3 = tyhAssetModel.assetPassArray[indexPath.row];
            static NSString *iden3 = @"AssetMineDetailCell3";
            AssetCheckDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AssetCheckDiliverCell" owner:self options:nil].firstObject;
                [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetCheckBtn.tag = 1003 + indexPath.row + 3001;
                [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetLookBtn.tag = 1003 + indexPath.row + 3003;
                [cell.assetDiliverBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetDiliverBtn.tag = 1003 + indexPath.row + 3002;
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                cell.model = model3;
            });
            return cell;
        }
            break;
        case 1004:
        {
            
            //未通过
            AssetCheckDiliverModel *model4 = tyhAssetModel.assetUnPassArray[indexPath.row];
            static NSString *iden4 = @"AssetMineDetailCell4";
            AssetCheckDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden4];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AssetCheckDiliverCell" owner:self options:nil].firstObject;
                [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetCheckBtn.tag = 1004 + indexPath.row + 4001;
                [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetLookBtn.tag = 1004 + indexPath.row + 4003;
                [cell.assetDiliverBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetDiliverBtn.tag = 1004 + indexPath.row + 4002;
                cell.assetCheckBtn.hidden = YES;
                cell.assetDiliverBtn.hidden = YES;
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                cell.model = model4;
            });
            return cell;
        }
            break;
        case 1005:
        {
            //已发放
            AssetCheckDiliverModel *model5 = tyhAssetModel.assetDiliverArray[indexPath.row];
            static NSString *iden5 = @"AssetMineDetailCell5";
            AssetCheckDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden5];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AssetCheckDiliverCell" owner:self options:nil].firstObject;
                [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetCheckBtn.tag = 1005 + indexPath.row + 5001;
                [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetLookBtn.tag = 1005 + indexPath.row + 5003;
                [cell.assetDiliverBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                cell.assetDiliverBtn.tag = 1005 + indexPath.row + 5002;
                cell.assetCheckBtn.hidden = YES;
                cell.assetDiliverBtn.hidden = YES;
            }
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                cell.model = model5;
            });
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

#pragma mark -Actions
- (void)cellBtnClicked:(id)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        // do something
//        AssetDiliverWaitController *dwView = [AssetDiliverWaitController new];
//        [self.navigationController pushViewController:dwView animated:YES];

    switch (self.viewTag) {
        case 1001:
        {
            AssetCheckDiliverModel *model1 = tyhAssetModel.assetAllArray[indexPath.row];
            
            UIButton *button = (UIButton *)sender;
            AssetApplyCheckController *checkView = [AssetApplyCheckController new];
            AssetDiliverWaitController *waitDIliverView = [AssetDiliverWaitController new];
            AssetApplyDetailController *detailView = [AssetApplyDetailController new];
            
            if (button.tag == 1001 + indexPath.row + 1001) {
                checkView.assetID = model1.assetId;
                [self.navigationController pushViewController:checkView animated:YES];
            }
            else if(button.tag == 1001 + indexPath.row + 1002) {
                waitDIliverView.assetID = model1.assetId;
                waitDIliverView.assetUser = model1.user;
                waitDIliverView.applicationRecordId = model1.assetId;
                waitDIliverView.departmentId = model1.departmentId;
                waitDIliverView.assetDepartmentName = model1.departmentName;
                waitDIliverView.applyUserID = model1.applyUserId;
                [self.navigationController pushViewController:waitDIliverView animated:YES];
            }
            else if(button.tag == 1001 + indexPath.row + 1003) {
                detailView.applyID = model1.assetId;
                [self.navigationController pushViewController:detailView animated:YES];
            }
        }
            break;
        case 1002:
        {
            AssetCheckDiliverModel *model2 = tyhAssetModel.assetCheckArray[indexPath.row];
            
            UIButton *button = (UIButton *)sender;
            AssetApplyCheckController *checkView = [AssetApplyCheckController new];
            AssetDiliverWaitController *waitDIliverView = [AssetDiliverWaitController new];
            AssetApplyDetailController *detailView = [AssetApplyDetailController new];
            
            if (button.tag == 1002 + indexPath.row + 2001) {
                checkView.assetID = model2.assetId;
                [self.navigationController pushViewController:checkView animated:YES];
            }
            else if(button.tag == 1002 + indexPath.row + 2002) {
                waitDIliverView.assetID = model2.assetId;
                waitDIliverView.assetUser = model2.user;
                waitDIliverView.assetDepartmentName = model2.departmentName;
                waitDIliverView.applicationRecordId = model2.assetId;
                waitDIliverView.departmentId = model2.departmentId;
                waitDIliverView.applyUserID = model2.applyUserId;
                [self.navigationController pushViewController:waitDIliverView animated:YES];
            }
            else if(button.tag == 1002 + indexPath.row + 2003) {
                detailView.applyID = model2.assetId;
                [self.navigationController pushViewController:detailView animated:YES];
            }
        }
            break;
        case 1003:
        {
            AssetCheckDiliverModel *model3 = tyhAssetModel.assetPassArray[indexPath.row];
            
            UIButton *button = (UIButton *)sender;
            AssetApplyCheckController *checkView = [AssetApplyCheckController new];
            AssetDiliverWaitController *waitDIliverView = [AssetDiliverWaitController new];
            AssetApplyDetailController *detailView = [AssetApplyDetailController new];
            
            if (button.tag == 1003 + indexPath.row + 3001) {
                checkView.assetID = model3.assetId;
                [self.navigationController pushViewController:checkView animated:YES];
            }
            else if(button.tag == 1003 + indexPath.row + 3002) {
                waitDIliverView.assetID = model3.assetId;
                waitDIliverView.assetUser = model3.user;
                waitDIliverView.assetDepartmentName = model3.departmentName;
                waitDIliverView.applicationRecordId = model3.assetId;
                waitDIliverView.departmentId = model3.departmentId;
                waitDIliverView.applyUserID = model3.applyUserId;
                [self.navigationController pushViewController:waitDIliverView animated:YES];
            }
            else if(button.tag == 1003 + indexPath.row + 3003) {
                detailView.applyID = model3.assetId;
                [self.navigationController pushViewController:detailView animated:YES];
            }
            
        }
            break;
        case 1004:
        {
            AssetCheckDiliverModel *model4 = tyhAssetModel.assetUnPassArray[indexPath.row];
            
            UIButton *button = (UIButton *)sender;
            AssetApplyCheckController *checkView = [AssetApplyCheckController new];
            AssetDiliverWaitController *waitDIliverView = [AssetDiliverWaitController new];
            AssetApplyDetailController *detailView = [AssetApplyDetailController new];
            
            if (button.tag == 1004 + indexPath.row + 4001) {
                checkView.assetID = model4.assetId;
                [self.navigationController pushViewController:checkView animated:YES];
            }
            else if(button.tag == 1004 + indexPath.row + 4002) {
                waitDIliverView.assetID = model4.assetId;
                waitDIliverView.assetUser = model4.user;
                waitDIliverView.assetDepartmentName = model4.departmentName;
                waitDIliverView.applicationRecordId = model4.assetId;
                waitDIliverView.departmentId = model4.departmentId;
                waitDIliverView.applyUserID = model4.applyUserId;
                [self.navigationController pushViewController:waitDIliverView animated:YES];
            }
            else if(button.tag == 1004 + indexPath.row + 4003) {
                detailView.applyID = model4.assetId;
                [self.navigationController pushViewController:detailView animated:YES];
            }
            
        }
            break;
        case 1005:
        {
            AssetCheckDiliverModel *model5 = tyhAssetModel.assetDiliverArray[indexPath.row];
            
            UIButton *button = (UIButton *)sender;
            AssetApplyCheckController *checkView = [AssetApplyCheckController new];
            AssetDiliverWaitController *waitDIliverView = [AssetDiliverWaitController new];
            AssetApplyDetailController *detailView = [AssetApplyDetailController new];
            
            if (button.tag == 1005 + indexPath.row + 5001) {
                checkView.assetID = model5.assetId;
                [self.navigationController pushViewController:checkView animated:YES];
            }
            else if(button.tag == 1005 + indexPath.row + 5002) {
                waitDIliverView.assetID = model5.assetId;
                [self.navigationController pushViewController:waitDIliverView animated:YES];
            }
            else if(button.tag == 1005 + indexPath.row + 5003) {
                detailView.applyID = model5.assetId;
                [self.navigationController pushViewController:detailView animated:YES];
            }
        }
            break;
        default:
        {}
            break;
    }
    }
    
}

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
