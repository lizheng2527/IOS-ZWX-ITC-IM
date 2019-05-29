//
//  WHApplicationDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationDetailController.h"

#import "WHApplicationDetailMainCell.h"
#import "WHApplicationDetailItemCell.h"
#import "WHApplicationDetailHeaderView.h"
#import "WHCheckController.h"
#import "TYHWarehouseDefine.h"

#import "WHMyApplicationModel.h"
#import "WHNetHelper.h"

#import <UIView+Toast.h>

@interface WHApplicationDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)WHMyApplicationDetailModel *mainModel;
@end

@implementation WHApplicationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    [self requestData];
}

#pragma mark - DataRequest
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getMyApplicationDetailWithApplyID:_applyID.length?_applyID:@"" andStatus:^(BOOL successful, WHMyApplicationDetailModel *model) {
        _mainModel = [WHMyApplicationDetailModel new];
        _mainModel = model;
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
    
    self.title = @"申请详情";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden1 = @"WHApplicationDetailMainCell";
        WHApplicationDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationDetailMainCell" owner:self options:nil].firstObject;
        }
        cell.model = _mainModel.detailArray[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *iden2 = @"WHApplicationDetailItemCell";
        WHApplicationDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationDetailItemCell" owner:self options:nil].firstObject;
        }
        cell.model = _mainModel.itemListArray[indexPath.row];
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = [UIColor WarehouseStatisticsColor];
        }
        if (indexPath.row == _mainModel.itemListArray.count - 1 && indexPath.row % 2 == 0) {
            cell.lineLabel.backgroundColor = [UIColor TabBarColorWarehouse];
        }
        return cell;
    }
    else return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        WHApplicationDetailHeaderView *headView = [[WHApplicationDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 48)];
        return headView;
    }
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 290;
    }
    else if(indexPath.section == 1)
        return 35;
    else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else return _mainModel.itemListArray.count;
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
