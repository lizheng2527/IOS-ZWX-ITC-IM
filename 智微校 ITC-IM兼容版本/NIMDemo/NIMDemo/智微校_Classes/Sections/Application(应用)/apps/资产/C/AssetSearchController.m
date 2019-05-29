//
//  AssetSearchController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetSearchController.h"
#import "AssetMineDetailCell.h"
#import "AssetSearchConditionController.h"
#import <UIView+Toast.h>
#import "AssetDetailController.h"
#import "TYHAssetModel.h"
#import "AssetSearchConditionController.h"
#import "AssetDiliverDetailController.h"
#import "AssetDiliverWaitController.h"
#import "AssetNetWorkHelper.h"
#import "NSString+Empty.h"


@interface AssetSearchController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,AssetMineDetaitCellDelegate>
@end

@implementation AssetSearchController
{
    UITableView *mainTableView;
    UIAlertView *alert;
    
    NSMutableArray *dataSource;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDataArray:_dataArray];
    [self initView];
    [self createBarItem];
    
    [self requestData];
    
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


-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取统计数据中";
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getSearchAssetListsJsonnWithLocationID:_IDarea kitFlag:_typeStringWithChoose assetKindId:_IDtype purchaseDateEnd:_endDateString brandId:_IDBrand name:_searchNameString purchaseDateStart:_startDateString code:_searchCodeString patternId:_IDguige andStatus:^(BOOL successful, NSMutableArray *tmpDataSource) {
        dataSource = [NSMutableArray arrayWithArray:tmpDataSource];
        [self shouldCreateNoData:dataSource];
        [hud removeFromSuperview];
        [mainTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
    if (array.count == 0 ) {
        if (!noDatalabel.superview) {
            noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 70, [UIScreen mainScreen].bounds.size.width, 40)];
            noDatalabel.text = @"查询不到对应资产";
            CGPoint centerPoint = CGPointMake(self.view.center.x, self.view.center.y - 68);
            noDatalabel.center = centerPoint;
            noDatalabel.textColor = [UIColor grayColor];
            noDatalabel.textAlignment = NSTextAlignmentCenter;
            noDatalabel.font = [UIFont boldSystemFontOfSize:16];
            [self.view addSubview:noDatalabel];
        }
    }
    if (array.count > 0 && noDatalabel.superview ) {
        [noDatalabel removeFromSuperview];
    }
}



#pragma mark - initView
-(void)initView
{
    self.title = @"检索结果";
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 20) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:mainTableView];
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
    if (dataSource.count && dataSource) {
       return dataSource.count;
    }
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 189.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetMineDetailModel *model = dataSource[indexPath.row];
    static NSString *iden = @"AssetMineDetailCell";
        AssetMineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AssetMineDetailCell" owner:self options:nil].firstObject;
            cell.delegate = self;
//            [cell.assetAddBtn addTarget:self action:@selector(cellBtnClicked:eventAdd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.assetCheckBtn addTarget:self action:@selector(cellBtnClicked:eventCheck:) forControlEvents:UIControlEventTouchUpInside];
        }
    cell.model = model;
    cell.assetDateLabel.text = @"借用日期:";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -Actions
-(void)returnClick:(id)sender
{
    
    AssetSearchConditionController
    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    takeView.tmpDataArray = [NSMutableArray arrayWithArray:_dataArray];
    [self.navigationController
     popToViewController:takeView animated:true];
}

- (void)cellBtnClicked:(id)sender eventCheck:(id)event
{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        AssetMineDetailModel *model = dataSource[indexPath.row];
        AssetDetailController *dView = [AssetDetailController new];
        dView.assetCode = model.code;
        [self.navigationController pushViewController:dView animated:YES];
    }
}

//cell代理方法
-(void)assetAddBtnClickkkkk:(AssetMineDetailCell *)cell
{
    
    NSIndexPath *indexPath = [mainTableView indexPathForCell:cell];
    AssetMineDetailModel *model = [dataSource objectAtIndex:indexPath.row];
    
    if ([cell.assetAddBtn.titleLabel.text isEqualToString:@"添加"]) {
        [self.view makeToast:@"已添加到待发放列表" duration:1 position:nil];
        [cell.assetAddBtn setTitle:@"移除" forState:UIControlStateNormal];
        [_dataArray addObject:model];
    }
   else if ([cell.assetAddBtn.titleLabel.text isEqualToString:@"移除"]) {
       if ([_dataArray containsObject:model]) {
           [_dataArray removeObject:model];
           [cell.assetAddBtn setTitle:@"添加" forState:UIControlStateNormal];
//           [mainTableView reloadData];
           [self.view makeToast:@"已从待发放列表中移除" duration:1 position:nil];
       }
//       for (AssetMineDetailModel *tmpModel in _dataArray) {
//           if ([tmpModel.assetId isEqual:model.assetId]) {
//               [_dataArray removeObjectAtIndex:indexPath.row];
//               [mainTableView reloadData];
//           }
//       }
   }
}


#pragma mark - Other

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIView appearance] setTintColor:[UIColor redColor]];
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
}



-(void)setIDschool:(NSString *)IDschool
{
    if ([NSString isBlankString:IDschool]) {
        _IDschool = nil;
    }
    else _IDschool = IDschool;
}
-(void)setIDarea:(NSString *)IDarea
{
    if ([NSString isBlankString:IDarea]) {
        _IDarea = nil;
    }
    else _IDarea = IDarea;
}
-(void)setIDtype:(NSString *)IDtype
{
    if ([NSString isBlankString:IDtype]) {
        _IDtype = nil;
    }
    else _IDtype = IDtype;
}
-(void)setIDguige:(NSString *)IDguige
{
    if ([NSString isBlankString:IDguige]) {
        _IDguige = nil;
    }
    else _IDguige = IDguige;
}
-(void)setIDBrand:(NSString *)IDBrand
{
    if ([NSString isBlankString:IDBrand]) {
        _IDBrand = nil;
    }
    else _IDBrand = IDBrand;
}

-(void)setStartDateString:(NSString *)startDateString
{
    if ([NSString isBlankString:startDateString] || [startDateString isEqualToString:@"起始日期"]) {
        _startDateString = nil;
    }
    else _startDateString = startDateString;
}
-(void)setEndDateString:(NSString *)endDateString
{
    if ([NSString isBlankString:endDateString] || [endDateString isEqualToString:@"结束日期"]) {
        _endDateString = nil;
    }
    else _endDateString = endDateString;
}

-(void)setSearchCodeString:(NSString *)searchCodeString
{
    if ([NSString isBlankString:searchCodeString]) {
        _searchCodeString = nil;
    }
    else _searchCodeString = searchCodeString;
}

-(void)setSearchNameString:(NSString *)searchNameString
{
    if ([NSString isBlankString:searchNameString]) {
        _searchNameString = nil;
    }
    else _searchNameString = searchNameString;
}

-(void)setTypeStringWithChoose:(NSString *)typeStringWithChoose
{
    if ([NSString isBlankString:typeStringWithChoose]) {
        _typeStringWithChoose = nil;
    }
    else _typeStringWithChoose = typeStringWithChoose;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
