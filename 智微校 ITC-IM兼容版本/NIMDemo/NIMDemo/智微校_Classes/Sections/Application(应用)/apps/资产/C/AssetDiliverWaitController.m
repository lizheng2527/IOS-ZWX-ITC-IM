//
//  AssetDiliverWaitController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetDiliverWaitController.h"
#import "AssetMineDetailCell.h"
#import "AssetSearchConditionController.h"
#import "LXDScanView.h"
#import "LXDScanCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "AssetDiliverDetailController.h"
#import <UIView+Toast.h>
#import "TYHAssetModel.h"
#import "AssetDetailController.h"
#import "AssetNetWorkHelper.h"
#import "NSString+Empty.h"
#import "AssetDetailController.h"

@interface AssetDiliverWaitController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,LXDScanViewDelegate, LXDScanCodeControllerDelegate,AssetMineDetaitCellDelegate>

@property (nonatomic, strong) LXDScanView * scanView;

@end

@implementation AssetDiliverWaitController
{
    UIAlertView *alert;
    BOOL isScaning;
}

-(void)setAssetID:(NSString *)assetID
{
    _assetID = assetID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setDataArray:_dataArray];
    [self initView];
    [self createBarItem];
    [self setDataArray:_dataArray];
    isScaning = NO;
}


#pragma mark - initData
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count > 0 && dataArray) {
        
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    else
        _dataArray = [NSMutableArray array];
}

#pragma mark - initView
-(void)initView
{
    self.title = @"待发放资产";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = NO;
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


#pragma mark - tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetMineDetailModel *model = _dataArray[indexPath.row];
    
    static NSString *iden = @"AssetMineDetailCell";
    AssetMineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AssetMineDetailCell" owner:self options:nil].firstObject;
        cell.delegate = self;
        [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:eventCheck:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.model = model;
    cell.assetDateLabel.text = @"借用日期:";
    [cell.assetAddBtn setTitle:@"移除" forState:UIControlStateNormal];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Actions
- (void)cellBtnClicked:(id)sender eventCheck:(id)event
{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableView];
    NSIndexPath *indexPath= [_mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineDetailModel *model = _dataArray[indexPath.row];
        AssetDetailController *dView = [AssetDetailController new];
        dView.assetCode = model.code;
        [self.navigationController pushViewController:dView animated:YES];
    }
}
//cell代理方法
-(void)assetAddBtnClickkkkk:(AssetMineDetailCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if (_dataArray[indexPath.row]) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_mainTableView reloadData];
    }
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![alert pointInside:[alert convertPoint:location fromView:alert.window] withEvent:nil]){
            [alert.window removeGestureRecognizer:sender];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

- (IBAction)assetAddAction:(id)sender {
    alert = [[UIAlertView alloc]initWithTitle:@"查找资产" message:@"请选择查找方式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"条件查找",@"扫码查找", nil];
    alert.delegate = self;
    [alert show];
    
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
}

- (IBAction)assetDiliverAction:(id)sender {
    if (_dataArray.count > 0) {
        AssetDiliverDetailController *ddView = [AssetDiliverDetailController new];
        ddView.returnID = @"";
        ddView.assetUser = _assetUser;
        ddView.assetDepartmentName = _assetDepartmentName;
        ddView.applicationRecordId = _applicationRecordId;
        ddView.departmentId = _departmentId;
        ddView.applyUserID = _applyUserID;
        ddView.dataArray = _dataArray;
        [self.navigationController pushViewController:ddView animated:YES];
    }
    else
        [self.view makeToast:@"未添加待发放资产" duration:1 position:nil];
}

-(void)returnClick:(id)sender
{
    if (isScaning) {
        [_scanView stop];
        [_scanView removeFromSuperview];
        isScaning = NO;
    }
    else
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cellBtnClicked:(id)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableView];
    NSIndexPath *indexPath= [_mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        if (_dataArray.count > 0 ) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_mainTableView reloadData];
            [self.view makeToast:@"移除成功" duration:1 position:nil];
        }
    }
}



-(void)addObecjtToDataArray:(NSObject *)modelObject
{
    [_dataArray addObject:modelObject];
}
-(void)delObjectFromDataArray:(NSObject *)modelObject
{
    [_dataArray removeObject:modelObject]
    ;
}


#pragma mark -  scanView
-(void)scanAction
{
    //直接扫描
//    
//    
    _scanView = [LXDScanView scanViewShowInController: self];
    [self.view addSubview: self.scanView];
    [self.scanView start];
}


- (void)scanView:(LXDScanView *)scanView codeInfo:(NSString *)codeInfo
{
//    NSURL * url = [NSURL URLWithString: codeInfo];
//    if ([[UIApplication sharedApplication] canOpenURL: url]) {
//        [[UIApplication sharedApplication] openURL: url];
//    } else {
// 
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"获取数据中";
        AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
        [helper getAssetDetailJsonWithAssetId:codeInfo andStatus:^(BOOL successful, AssetDetailModel *detailModel) {
            if (![NSString isBlankString:detailModel.assetKindName]) {
                AssetDetailController *assdView = [AssetDetailController new];
                assdView.assetCode = codeInfo;
                assdView.whoGoinType = @"扫码进入";
                assdView.dataArray = [NSMutableArray arrayWithArray:_dataArray];
                [self.navigationController pushViewController:assdView animated:YES];
            }
            else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"警告" message: [NSString stringWithFormat: @"%@:%@", @"无效的二维码", codeInfo] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
                [alertView show];
            }
            [hud removeFromSuperview];
        } failure:^(NSError *error) {
            [hud removeFromSuperview];
        }];
//    }
}


// LXDScanCodeControllerDelegate

- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo
{
    NSURL * url = [NSURL URLWithString: codeInfo];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"获取数据中";
        AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
        [helper getAssetDetailJsonWithAssetId:codeInfo andStatus:^(BOOL successful, AssetDetailModel *detailModel) {
            if (![NSString isBlankString:detailModel.assetKindName]) {
                AssetDetailController *assdView = [AssetDetailController new];
                assdView.assetCode = codeInfo;
                assdView.whoGoinType = @"扫码进入";
                [self.navigationController pushViewController:assdView animated:YES];
            }
            else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"警告" message: [NSString stringWithFormat: @"%@:%@", @"无效的二维码", codeInfo] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
                [alertView show];
            }
            [hud removeFromSuperview];
        } failure:^(NSError *error) {
            [hud removeFromSuperview];
        }];
    }
}

#pragma mark - Other
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        AssetSearchConditionController *scView = [AssetSearchConditionController new];
        scView.tmpDataArray = [NSMutableArray arrayWithArray:_dataArray];
        [self.navigationController pushViewController:scView animated:YES]
        ;
    }
    else if(buttonIndex == 1)
    {
        [self scanAction];
        isScaning = YES;
//        [self.scanView removeFromSuperview];
//        LXDScanCodeController * scanCodeController = [LXDScanCodeController scanCodeController];
//        scanCodeController.scanDelegate = self;
//        [self presentViewController:scanCodeController animated:YES completion:nil];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIView appearance] setTintColor:[UIColor redColor]];
    [_mainTableView reloadData];
    if (_dataArray.count > 0)
        _assetUnAddLabel.hidden = YES;
    else
        _assetUnAddLabel.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //恢复默认的颜色
    [[UIView appearance] setTintColor:[UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.scanView stop];
    
}

- (void)dealloc
{
    [self.scanView stop];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
