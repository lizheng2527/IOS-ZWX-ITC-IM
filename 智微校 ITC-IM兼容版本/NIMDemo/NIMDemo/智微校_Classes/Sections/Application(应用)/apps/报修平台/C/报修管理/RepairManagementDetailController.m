//
//  RepairManagementDetailController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RepairManagementDetailController.h"
#import "RepairManagementListCell.h"

#import "RepairManagementListCell.h"
#import "RepairManagementModel.h"

#import <UIView+Toast.h>

#import "TYHRepairNetRequestHelper.h"
#import "MyRepairApplicationModel.h"
#import "RMPaiController.h"
#import "MRDMainController.h"
#import "RMChargeDealController.h"
#import "NSString+Empty.h"
#import "LYEmptyViewHeader.h"

#import "NIMSessionViewController.h"

#import "NTESPersonalCardViewController.h"


@interface RepairManagementDetailController ()<UITableViewDelegate,UITableViewDataSource,RepairManagementListCellDelegate>

@property(nonatomic,retain)NSMutableArray *allArray;
@property(nonatomic,retain)NSMutableArray *dclArray;
@property(nonatomic,retain)NSMutableArray *ypdArray;
@property(nonatomic,retain)NSMutableArray *ywcArray;
@property(nonatomic,retain)NSMutableArray *fyspArray;

@property(nonatomic,retain)UILabel *noDatalabel;
@end

@implementation RepairManagementDetailController
{
    UITableView *mainTableView;
    
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    [self requestData];
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
    [helper getRepairManageMentListWithRequestTpe:[NSString stringWithFormat:@"%ld",(long)self.viewTag - 1001] andStatus:^(BOOL successful, NSMutableArray *dataSource, NSMutableArray *wjdSource, NSMutableArray *wxzSource, NSMutableArray *dfkSource, NSMutableArray *yxhSource) {
        self.allArray = [NSMutableArray arrayWithArray:dataSource];
        self.dclArray = [NSMutableArray arrayWithArray:wjdSource];
        self.ypdArray = [NSMutableArray arrayWithArray:wxzSource];
        self.ywcArray = [NSMutableArray arrayWithArray:dfkSource];
        self.fyspArray = [NSMutableArray arrayWithArray:yxhSource];
        [mainTableView reloadData];
        [SVProgressHUD dismiss];
        
//        if (!dataSource.count) {
//            [self shouldCreateNoData:dataSource];
//        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
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
    
//    mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
    
    [self.view addSubview:mainTableView];
}


-(void)shouldCreateNoData:(NSMutableArray *)array
{
//    _noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width, 40)];
////    _noDatalabel.text = @"暂无数据";
//    CGPoint centerPoint = CGPointMake(mainTableView.center.x, mainTableView.center.y - 68);
//    _noDatalabel.center = centerPoint;
//    _noDatalabel.textColor = [UIColor grayColor];
//    _noDatalabel.textAlignment = NSTextAlignmentCenter;
//    _noDatalabel.font = [UIFont boldSystemFontOfSize:17];
//    if (!_noDatalabel.superview && !array.count) {
//        [self.view addSubview:_noDatalabel];
//    }
//    else [mainTableView removeFromSuperview];
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
            return self.dclArray.count;
        }
            break;
        case 1003:
        {
            return self.ypdArray.count;
        }
            break;
        case 1004:
        {
            return self.ywcArray.count;
        }
            break;
        case 1005:
        {
            return self.fyspArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            static NSString *iden1 = @"RepairManagementListCell1";
            RepairManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RepairManagementListCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            
            cell.model = self.allArray[indexPath.row];
            
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
            static NSString *iden2 = @"RepairManagementListCell2";
            RepairManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RepairManagementListCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            
            cell.model = self.dclArray[indexPath.row];
            
            
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
            static NSString *iden3 = @"RepairManagementListCell3";
            RepairManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RepairManagementListCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            
            cell.model = self.ypdArray[indexPath.row];
            return cell;
        }
            break;
        case 1004:
        {
            
            //待反馈
            static NSString *iden4 = @"RepairManagementListCell4";
            RepairManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden4];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RepairManagementListCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            
            cell.model = self.ywcArray[indexPath.row];
            return cell;
        }
            break;
        case 1005:
        {
            //待反馈
            static NSString *iden5 = @"RepairManagementListCell5";
            RepairManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden5];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RepairManagementListCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.isFYSP = YES;
            cell.model = self.fyspArray[indexPath.row];
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

#pragma mark - RepairManagementListCellDelegate
-(void)LookBtnClicked:(RepairManagementListCell *)cell
{
    MRDMainController *mrdView = [MRDMainController new];
    mrdView.defaultIndex = 0;
    mrdView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:mrdView animated:YES];
}

-(void)PaiBtnClicked:(RepairManagementListCell *)cell
{
    RMPaiController *paiView = [RMPaiController new];
    paiView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:paiView animated:YES];
}

-(void)MessageBtnClicked:(RepairManagementListCell *)cell
{
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper getYunXinIDWithUserID:cell.userID andStatus:^(BOOL successful, NSString *yunxinID) {
        NSString *string = [[NIMSDK sharedSDK].loginManager currentAccount];
        if ([string isEqualToString:yunxinID]) {
            [self.view makeToast:@"您不能给自己留言" duration:1.5 position:CSToastPositionCenter];
        }else
        {
            if ([yunxinID integerValue]) {
                NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:yunxinID];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self.view makeToast:@"获取通讯账号失败,请稍后再试" duration:1.5 position:CSToastPositionCenter];
            }
            
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取通讯账号失败,请稍后再试" duration:1.5 position:CSToastPositionCenter];
    }];
}

-(void)DealBtnClicked:(RepairManagementListCell *)cell
{
    if ([cell.model.statusCode isEqualToString:@"0"]) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"接单后其他人不能再接此单,您确认接单吗?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
            [helper acceptOrdersWith:cell.model.repairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                [self requestData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"Error" duration:1.5 position:CSToastPositionCenter];
            }];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController: alertController animated: YES completion: nil];
    }
    else
    {
        RMChargeDealController *rmcView = [RMChargeDealController new];
        rmcView.repairID = cell.cellRepairID;
        [self.navigationController pushViewController:rmcView animated:YES];
    }
}


-(void)CallBtnClicked:(RepairManagementListCell *)cell
{
    if ([NSString isBlankString:cell.phoneNumber]) {
        [self.view makeToast:@"该手机号码为空号" duration:1 position:CSToastPositionCenter];
        return;
    }
    else
    {
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",cell.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
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
