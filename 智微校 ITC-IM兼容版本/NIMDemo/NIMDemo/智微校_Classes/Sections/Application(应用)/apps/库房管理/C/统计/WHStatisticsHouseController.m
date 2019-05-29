//
//  WHStatisticsHouseController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHStatisticsHouseController.h"
#import "WHStatisticsHouseCountCell.h"

#import "WHStatisticsHouseHeaderView.h"
#import "TYHWarehouseDefine.h"

#import "WHNetHelper.h"
#import "WHGoodsStasticsModel.h"

#import <UIView+Toast.h>


@interface WHStatisticsHouseController ()<WHStatisticsHouseCountCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *typeURL;
@end

@implementation WHStatisticsHouseController
-(instancetype)initWithGoodsID:(NSString *)goodID requestType:(NSString *)requestType
{
    self = [super init];
    if (self) {
        _goodsID = goodID;
        _houseType = requestType;
    }
    return self;
}


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
    hud.labelText = @"正在获取数据";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getGoodsStasticsInOutHouseListWithgoodsID:_goodsID.length ? _goodsID:@"" RequestType:_houseType andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _dataArray = [NSMutableArray arrayWithArray:dataSource];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取数据失败" duration:1 position:nil];
        [hud removeFromSuperview];
    }];    
}


#pragma mark - ViewConfig
-(void)initView
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
}

- (void)setNavTitle:(NSString *)title secondTitle:(NSString *)secondTitle
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor  whiteColor];
    [bgView addSubview:titleLabel];
    
    UILabel *secondTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 15)];
    
    secondTitleLabel.text = secondTitle;
    secondTitleLabel.textAlignment = NSTextAlignmentCenter;
    secondTitleLabel.textColor = [UIColor  whiteColor];
    secondTitleLabel.font = [UIFont boldSystemFontOfSize:13];
    [bgView addSubview:secondTitleLabel];
    
    self.navigationItem.titleView = bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"WHStatisticsHouseCountCell";
    WHStatisticsHouseCountCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell =[[WHStatisticsHouseCountCell alloc]init];
    }
    cell.delegate = self;
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor WarehouseStatisticsColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WHStatisticsHouseHeaderView *headView = 
    [[WHStatisticsHouseHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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

#pragma mark - WHStatisticsCellDelegate
-(void)countLabelClickWithCell:(WHStatisticsHouseCountCell *)cell
{
    
}

-(void)inHouseLabelClickwithCell:(WHStatisticsHouseCountCell *)cell
{
    
}

-(void)outHouseLabelClickWithCell:(WHStatisticsHouseCountCell *)cell
{
    
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
