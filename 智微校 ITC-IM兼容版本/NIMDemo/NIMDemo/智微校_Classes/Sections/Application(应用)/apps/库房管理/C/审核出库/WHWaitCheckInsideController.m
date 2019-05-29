//
//  WHWaitCheckInsideController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/17.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHWaitCheckInsideController.h"

#import "WHApplyCheckCell.h"
#import "WHCheckController.h"
#import "WHApplicationDetailController.h"
#import "WHMineListCell.h"

#import <UIView+Toast.h>
#import "WHMyApplicationModel.h"
#import "WHNetHelper.h"
#import "LYEmptyViewHeader.h"

@interface WHWaitCheckInsideController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)NSMutableArray *dataArrayBM;
@property(nonatomic,retain)NSMutableArray *dataArrayZW;

@property(nonatomic,retain)UILabel *noDatalabel;

@end

@implementation WHWaitCheckInsideController
{
    UITableView *mainTableView;
    
    NSMutableArray *dataArray;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];
    [self createBarItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requsetData];
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
    WHNetHelper *helper = [[WHNetHelper alloc]init];
        [helper getApplicationCheckBMList:^(BOOL successful, NSMutableArray *dataSourceBM) {
            _dataArrayBM = [NSMutableArray arrayWithArray:dataSourceBM];
            if (!dataSourceBM.count && self.viewTag == 1001) {
                [self shouldCreateNoData:dataSourceBM];
            }
            
            [helper getApplicationCheckZWList:^(BOOL successful, NSMutableArray *dataSourceZW) {
                _dataArrayZW = [NSMutableArray arrayWithArray:dataSourceZW];
                if (!dataSourceZW.count && self.viewTag == 1002) {
                    [self shouldCreateNoData:dataSourceZW];
                }
                [mainTableView reloadData];
                [hud removeFromSuperview];
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1 position:nil];
                [hud removeFromSuperview];
            }];
            
            
        } failure:^(NSError *error) {
            [self.view makeToast:@"获取数据失败" duration:1 position:nil];
            [hud removeFromSuperview];
        }];
    
}

#pragma mark -  initView
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 70) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    [self.view addSubview:mainTableView];
    
    mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{

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


#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewTag == 1001) {
//        return mineModel.myAssetListArray.count;
        return _dataArrayBM.count;
    }
    else if(self.viewTag == 1002)
        return _dataArrayZW.count;
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewTag == 1001) {
        return 224.0f;
    }
    else if(self.viewTag == 1002)
        return 224;
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"WHMineListCell1";
    static NSString *iden2 = @"WHMineListCell2";
    if (self.viewTag == 1001) {
        //mineDetailModel

        WHMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHMineListCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.checkBtn addTarget:self action:@selector(cellBtnClicked:eventCheckBM:) forControlEvents:UIControlEventTouchUpInside];
            [cell.lookBtn addTarget:self action:@selector(cellBtnClicked:eventLookBM:) forControlEvents:UIControlEventTouchUpInside];
        }
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            //子线程异步执行下载任务，防止主线程卡顿
            cell.model = _dataArrayBM[indexPath.row];
        });
        return cell;
    }
    else if(self.viewTag  == 1002)
    {
        //mineApplyModel
        WHMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHMineListCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.checkBtn addTarget:self action:@selector(cellBtnClicked:eventCheckZW:) forControlEvents:UIControlEventTouchUpInside];
            [cell.lookBtn addTarget:self action:@selector(cellBtnClicked:eventLookZW:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            //子线程异步执行下载任务，防止主线程卡顿
            cell.model = _dataArrayZW[indexPath.row];
        });
        return cell;
    }
    else
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -Actions

- (void)cellBtnClicked:(id)sender eventCheckBM:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        WHCheckController *dView = [WHCheckController new];
        dView.applyID = [_dataArrayBM[indexPath.row] applyID];
        dView.checkKind = @"dept";
        [self.navigationController pushViewController:dView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLookBM:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
         WHApplicationDetailController *dView = [WHApplicationDetailController new];
        dView.applyID = [_dataArrayBM[indexPath.row] applyID];
        [self.navigationController pushViewController:dView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventCheckZW:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil)
    {
        WHCheckController *dView = [WHCheckController new];
        dView.applyID = [_dataArrayZW[indexPath.row] applyID];
        dView.checkKind = @"zw";
        [self.navigationController pushViewController:dView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLookZW:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        WHApplicationDetailController *dView = [WHApplicationDetailController new];
        dView.applyID = [_dataArrayZW[indexPath.row] applyID];
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
