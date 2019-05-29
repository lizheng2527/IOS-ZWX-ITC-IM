//
//  MyRepairServiceDetailController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MyRepairServiceDetailController.h"

#import <UIView+Toast.h>

#import "TYHRepairNetRequestHelper.h"
#import "RepairManagementModel.h"
#import "MRADetailCell.h"
#import "MRDMainController.h"
#import "MyRepairServiceFeedBackController.h"
#import "LYEmptyViewHeader.h"

@interface MyRepairServiceDetailController ()<UITableViewDelegate,UITableViewDataSource,MRADetailCellDelegate>

@property(nonatomic,retain)NSMutableArray *allArray;
@property(nonatomic,retain)NSMutableArray *wxzArray;
@property(nonatomic,retain)NSMutableArray *yfkArray;

@end

@implementation MyRepairServiceDetailController
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
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    
    NSInteger tmpViewTag = 1001;
    if (self.viewTag == 1002) {
        tmpViewTag = 1003;
    }
    else if(self.viewTag == 1003)
    {
        tmpViewTag = 1004;
    }
    else tmpViewTag = 1001;
    [helper getMyServerListWithType:[NSString stringWithFormat:@"%ld",(long)tmpViewTag - 1001] andStatus:^(BOOL successful, NSMutableArray *dataSource, NSMutableArray *wxzSource, NSMutableArray *yfkSource) {
        self.allArray = [NSMutableArray arrayWithArray:dataSource];
        self.wxzArray = [NSMutableArray arrayWithArray:wxzSource];
        self.yfkArray = [NSMutableArray arrayWithArray:yfkSource];
        [SVProgressHUD dismiss];
        [mainTableView reloadData];
        
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
//    noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width, 40)];
//    noDatalabel.text = @"暂无更多";
//    CGPoint centerPoint = CGPointMake(mainTableView.center.x, mainTableView.center.y - 30);
//    noDatalabel.center = centerPoint;
//    noDatalabel.textColor = [UIColor grayColor];
//    noDatalabel.textAlignment = NSTextAlignmentCenter;
//    noDatalabel.font = [UIFont boldSystemFontOfSize:17];
//    if (!noDatalabel.superview && !array.count) {
//        [self.view addSubview:noDatalabel];
//    }
//    else [noDatalabel removeFromSuperview];
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
            return self.wxzArray.count;
        }
            break;
        case 1003:
        {
            return self.yfkArray.count;
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
            cell.myServerModel = self.allArray[indexPath.row];
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
            cell.myServerModel = self.wxzArray[indexPath.row];
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
            cell.myServerModel = self.yfkArray[indexPath.row];
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
- (void)LookBtnClicked:(MRADetailCell *)cell
{
    MRDMainController *mrdView = [MRDMainController new];
    mrdView.defaultIndex = 0;
    mrdView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:mrdView animated:YES];
}

- (void)FeedBackClicked:(MRADetailCell *)cell
{
    MyRepairServiceFeedBackController *fbView = [MyRepairServiceFeedBackController new];
    fbView.repairID = cell.cellRepairID;
    [self.navigationController pushViewController:fbView animated:YES];
    
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
