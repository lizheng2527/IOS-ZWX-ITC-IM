//
//  AssetMyAssetsDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/9.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetMyAssetsDetailController.h"
#import "AssetDetailController.h"
#import "AssetNetWorkHelper.h"
#import "TYHAssetModel.h"
#import "NSString+Empty.h"

@interface AssetMyAssetsDetailController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation AssetMyAssetsDetailController
{
    NSMutableArray *dataArray;
    AssetMineReturnModel *model;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发放详情";
    [self requestData];
    [self createBarItem];
}

#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getGrantDetailJsonWithReturnId:_returnID andStatus:^(BOOL successful, AssetMineReturnModel *returnModel) {
        model = [AssetMineReturnModel new];
        model = returnModel;
        [self initView];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    }];
    
}

-(void)setReturnID:(NSString *)returnID
{
    _returnID = returnID;
}

#pragma mark - initView

-(void)initView
{
    _rerurnDateLabel.text = model.operateDate;
    _returnPersonLabel.text = model.user;
    _returnHandlePersonLabel.text = model.operator;
    _returnOrganizationLabel.text = model.department;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 50;
    _mainTableView.bounces = NO;
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
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


#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (model.returnAssetsArray.count > 0) {
        return model.returnAssetsArray.count;
    }else
        return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celll"];
    AssetDetailModel *detailModel = [model.returnAssetsArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"celll"];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row + 1,detailModel.name];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AssetDetailModel *detailModel = [model.returnAssetsArray objectAtIndex:indexPath.row];
    AssetDetailController *dView = [AssetDetailController new];
    dView.assetCode = detailModel.code;
    [self.navigationController pushViewController:dView animated:YES];
}


#pragma mark - Actions
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
