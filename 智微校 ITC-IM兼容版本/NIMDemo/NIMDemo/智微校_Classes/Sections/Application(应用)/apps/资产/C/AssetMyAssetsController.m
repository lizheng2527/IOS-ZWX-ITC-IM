//
//  AssetMyAssetsController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/9.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetMyAssetsController.h"
#import "AssetDiliverCell.h"
#import "TYHAssetModel.h"
#import "AssetDiliverDetailController.h"
#import "AssetMyAssetsDetailController.h"
#import "AssetNetWorkHelper.h"
#import "TYHAssetModel.h"
#import "LYEmptyViewHeader.h"

@interface AssetMyAssetsController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation AssetMyAssetsController
{
    NSMutableArray *dataSource;
    UILabel *noDatalabel;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBarItem];
    [self initView];
}

#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取统计数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getGrantListJson:^(BOOL successful, NSMutableArray *tmpDataSource) {
        dataSource = [NSMutableArray arrayWithArray:tmpDataSource];
        [hud removeFromSuperview];
        [self shouldCreateNoData:dataSource];
        [_mainTableview reloadData];
    } failure:^(NSError *error) {
        dataSource = [NSMutableArray array];
        [hud removeFromSuperview];
        [_mainTableview reloadData];
    }];
}


#pragma mark - initView
-(void)initView
{
    self.title = @"已发放资产";
    _mainTableview.dataSource = self;
    _mainTableview.delegate = self;
    _mainTableview.rowHeight = 165.0f;
    _mainTableview.tableFooterView = [UIView new];
    _mainTableview.separatorStyle = NO;
    _mainTableview.bounces = NO;
    _mainTableview.backgroundColor = [UIColor TabBarColorGray];
    
    _mainTableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
  
}


-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

#pragma mark - tableView Datasource & delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetMineReturnModel *model = dataSource[indexPath.row];
    static NSString *iden = @"AssetDiliverCell";
    AssetDiliverCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AssetDiliverCell" owner:self options:nil].firstObject;
    }
    [cell.assetLookBtn addTarget:self action:@selector(cellBtnClicked:eventLook:) forControlEvents:UIControlEventTouchUpInside];
    [cell.assetBuqianBtn addTarget:self action:@selector(cellBtnClicked:eventBuQian:) forControlEvents:UIControlEventTouchUpInside];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        cell.model = model;
    });
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions
-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cellBtnClicked:(id)sender eventLook:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableview];
    NSIndexPath *indexPath= [_mainTableview indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineReturnModel *model = dataSource[indexPath.row];
        
        AssetMyAssetsDetailController *dcView = [AssetMyAssetsDetailController new];
        dcView.returnID = model.assetId;
        [self.navigationController pushViewController:dcView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventBuQian:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableview];
    NSIndexPath *indexPath= [_mainTableview indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineReturnModel *model = dataSource[indexPath.row];
        AssetDiliverDetailController *addView = [AssetDiliverDetailController new];
        addView.returnID = model.assetId;
        addView.applicationRecordId = model.assetId;
        addView.departmentId = model.departmentId;
        addView.applyUserID = model.userId;
        addView.whoGoinType = @"补签";
        
        [self.navigationController pushViewController:addView animated:YES];
    }
}

#pragma mark - other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
