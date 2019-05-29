//
//  AssetMineDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/24.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetMineDetailController.h"
#import "AssetMineDetailCell.h"
#import "AssetMineApplyCell.h"
#import "AssetNetWorkHelper.h"
#import "TYHAssetModel.h"
#import "AssetDetailController.h"
#import "AssetApplyDetailController.h"
#import "AssetReturnDetailController.h"
#import "AssetMineReturnCell.h"
#import "LYEmptyViewHeader.h"

@interface AssetMineDetailController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AssetMineDetailController
{
    UITableView *mainTableView;
    
    NSMutableArray *dataArray;
    AssetMineModel *mineModel;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetData];
    // Do any additional setup after loading the view.
    [self initView];
    [self createBarItem];
}

#pragma mark - initData
-(void)setViewTag:(NSInteger)viewTag
{
    _viewTag = viewTag;
}

-(void)requsetData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    AssetNetWorkHelper *netHelper = [AssetNetWorkHelper new];
    mineModel = [AssetMineModel new];
    [netHelper getMyAssetListJson:^(BOOL successful, AssetMineModel *assetMineModel) {
        mineModel = assetMineModel;
        [hud removeFromSuperview];
        [mainTableView reloadData];
        
        if (!assetMineModel.myAssetListArray.count && self.viewTag == 1001) {
            [self shouldCreateNoData:assetMineModel.myAssetListArray];
        }
        if (!assetMineModel.returnAssetsArray.count && self.viewTag == 1003) {
            [self shouldCreateNoData:assetMineModel.returnAssetsArray];
        }
        if (!assetMineModel.applicationRecordsArray.count && self.viewTag == 1002) {
            [self shouldCreateNoData:assetMineModel.applicationRecordsArray];
        }
        
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}

#pragma mark -  initView
-(void)initView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 70) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    self.view.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:mainTableView];
    
    mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}

-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
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
    if (self.viewTag == 1001) {
        return mineModel.myAssetListArray.count;
    }
    else if(self.viewTag == 1002)
        return mineModel.applicationRecordsArray.count;
    else
        return mineModel.returnAssetsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewTag == 1001) {
        return 188.0f;
    }
    else if(self.viewTag == 1002)
        return 135;
    else
        return 164;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"AssetMineDetailCell";
    if (self.viewTag == 1001) {
        //mineDetailModel
        AssetMineDetailModel *modelMine = mineModel.myAssetListArray[indexPath.row];
        AssetMineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AssetMineDetailCell" owner:self options:nil].firstObject;
            cell.assetAddBtn.hidden = YES;
            
            [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:eventLookMineAll:) forControlEvents:UIControlEventTouchUpInside];
        }
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            //子线程异步执行下载任务，防止主线程卡顿
            cell.model = modelMine;
        });
        
        return cell;
    }
    else if(self.viewTag  == 1002)
    {
        //mineApplyModel
        AssetMineApplyModel *applyModel = mineModel.applicationRecordsArray[indexPath.row];
        AssetMineApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AssetMineApplyCell" owner:self options:nil].firstObject;
            [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:eventLookMineApplicationList:) forControlEvents:UIControlEventTouchUpInside];
        }
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            //子线程异步执行下载任务，防止主线程卡顿
             cell.model = applyModel;
        });
        return cell;
    }
    else
    {
        //mineReturnModel
        AssetMineReturnModel *returnModel = mineModel.returnAssetsArray[indexPath.row];
        AssetMineReturnCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AssetMineReturnCell" owner:self options:nil].firstObject;
            [cell.returnLookBTN addTarget:self action:@selector(cellBtnClicked:eventLookMineReturn:) forControlEvents:UIControlEventTouchUpInside];
        }
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            //子线程异步执行下载任务，防止主线程卡顿
            cell.rModel = returnModel;
        });
        return cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.viewTag ) {
        case 1001:
        {
            AssetMineDetailModel *modelMine = mineModel.myAssetListArray[indexPath.row];
            AssetDetailController *dView = [AssetDetailController new];
            dView.assetCode = modelMine.code;
            [self.navigationController pushViewController:dView animated:YES];
        }
            break;
        case 1002:
        {
            AssetMineApplyModel *applyModel = mineModel.applicationRecordsArray[indexPath.row];
            AssetApplyDetailController *dView = [AssetApplyDetailController new];
            dView.applyID = applyModel.assetId;
            [self.navigationController pushViewController:dView animated:YES];
        }
            break;
        case 1003:
        {
            AssetMineReturnModel *returnModel = mineModel.returnAssetsArray[indexPath.row];
            AssetReturnDetailController *dView = [AssetReturnDetailController new];
            dView.returnID = returnModel.assetId;
            [self.navigationController pushViewController:dView animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -Actions

- (void)cellBtnClicked:(id)sender eventLookMineAll:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineDetailModel *modelMine = mineModel.myAssetListArray[indexPath.row];
        AssetDetailController *dView = [AssetDetailController new];
        dView.assetCode = modelMine.code;
        [self.navigationController pushViewController:dView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLookMineApplicationList:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineApplyModel *applyModel = mineModel.applicationRecordsArray[indexPath.row];
        AssetApplyDetailController *dView = [AssetApplyDetailController new];
        dView.applyID = applyModel.assetId;
        [self.navigationController pushViewController:dView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLookMineReturn:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineReturnModel *returnModel = mineModel.returnAssetsArray[indexPath.row];
        AssetReturnDetailController *dView = [AssetReturnDetailController new];
        dView.returnID = returnModel.assetId;
        [self.navigationController pushViewController:dView animated:YES];
    }
}





-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -Other


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
