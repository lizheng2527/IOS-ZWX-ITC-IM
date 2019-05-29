//
//  WHGoodsKindListController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHGoodsKindListController.h"

#import "WHNetHelper.h"
#import "WHGoodsModel.h"

#import <UIView+Toast.h>
#import "WHGoodsDetailListController.h"
#import "WHGoodsKindHeaderView.h"

static NSString *kCellIdentfier = @"WHMineListCell";
static NSString *kHeaderIdentifier = @"WHGoodsKindHeaderView";

@interface WHGoodsKindListController ()<UITableViewDelegate,UITableViewDataSource,WHGoodsKindHeaderViewDelegate>

@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation WHGoodsKindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    [self dataRequest];
    
    [self.mainTableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentfier];
    [self.mainTableView registerClass:[WHGoodsKindHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setGoodsArray:(NSMutableArray *)goodsArray
{
    if (goodsArray.count) {
        _goodsArray = [NSMutableArray arrayWithArray:goodsArray];
    }else goodsArray = [NSMutableArray array];
}

#pragma mark - DataRequest
-(void)dataRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在获取数据";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getGoodsKindListWithOutWarehouseID:_warehouseID.length?_warehouseID:@"" and:^(BOOL successful, NSMutableArray *dataSource) {
        
        _dataArray = [NSMutableArray arrayWithArray:dataSource];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取数据失败" duration:1 position:nil];
        [hud removeFromSuperview];
    }];
    
}


#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"物品分类";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.bounces = NO;
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentfier
                                                            forIndexPath:indexPath];
    WHGoodsKindModel *sectionModel = self.dataArray[indexPath.section];
    WHGoodsKindInnerModel *cellModel = sectionModel.nodesModelArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@",cellModel.name];
    
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    WHGoodsKindModel *sectionModel = self.dataArray[indexPath.section];
    WHGoodsKindInnerModel *model = sectionModel.nodesModelArray[indexPath.row];
    
    WHGoodsDetailListController *dlView = [WHGoodsDetailListController new];
    dlView.goodsID = model.goodsID;
    dlView.tmpDataArray = [NSMutableArray arrayWithArray:_goodsArray];
    [self.navigationController pushViewController:dlView animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    WHGoodsKindModel *sectionModel = self.dataArray[section];
    return sectionModel.isExpanded ? sectionModel.nodesModelArray.count : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WHGoodsKindHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
    view.delegate = self;
    WHGoodsKindModel *sectionModel = self.dataArray[section];
    view.model = sectionModel;
    view.expandCallback = ^(BOOL isExpanded) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                 withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


#pragma mark - WHGoodsKindHeaderViewDelegate

-(void)likeRowCellClicker:(WHGoodsKindHeaderView *)headerView
{
    WHGoodsDetailListController *dlView = [WHGoodsDetailListController new];
    dlView.goodsID = headerView.model.goodsID;
    dlView.tmpDataArray = [NSMutableArray arrayWithArray:_goodsArray];
    [self.navigationController pushViewController:dlView animated:YES];
}


#pragma mark - Other
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

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
