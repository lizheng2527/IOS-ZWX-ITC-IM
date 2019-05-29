//
//  WHOutListController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHOutListController.h"
#import "WHOutListCell.h"
#import "WHDiliverController.h"
#import "WHOutDetailController.h"
#import "WHOutListSearchController.h"
#import "WHMyApplicationModel.h"
#import "WHNetHelper.h"

#import "WHOutDetailController.h"
#import <UIView+Toast.h>
#import "WHAddApplicationDiliverController.h"
#import "WHOutResignController.h"
#import "WHOutResignCell.h"
#import "WHOutModel.h"
#import <MJRefresh.h>


@interface WHOutListController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation WHOutListController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    _searchBgView.layer.masksToBounds = YES;
    _searchBgView.layer.cornerRadius = 6.f;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.pageNum = 1;
    _dataArray = [NSMutableArray array];
    [self requestData];
}


#pragma mark - DataRequest
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在获取数据";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    
    [helper getOutListWithPageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        [self.dataArray addObjectsFromArray:dataSource];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
        self.pageNum ++;
        if (!dataSource.count) {
            [self.view makeToast:@"暂无更多数据" duration:1 position:nil];
            [self.mainTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取数据失败" duration:1 position:nil];
        [hud removeFromSuperview];
    }];
    
    
}


#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"出库单";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"WHOutResignCell";
    WHOutResignCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHOutResignCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        cell.model = _dataArray[indexPath.row];
    });
    
    [cell.resignBtn addTarget:self action:@selector(cellBtnClicked:eventCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lookBtn addTarget:self action:@selector(cellBtnClicked:eventLook:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
        WHOutResignController *whdView = [WHOutResignController new];
        WHOutModel *model = _dataArray[indexPath.row];
        whdView.outID = model.outID;
        [self.navigationController pushViewController:whdView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLook:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableView];
    NSIndexPath *indexPath= [_mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        WHOutDetailController *dView = [WHOutDetailController new];
        dView.outID = [_dataArray[indexPath.row] outID];
        [self.navigationController pushViewController:dView animated:YES];
    }
}


-(void)addAction:(id)sender
{
    WHAddApplicationDiliverController *WHaddView = [WHAddApplicationDiliverController new];
    [self.navigationController pushViewController:WHaddView animated:YES];
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)searchAction:(id)sender
{
    WHOutListSearchController *searchView =[WHOutListSearchController new];
    [self.navigationController pushViewController:searchView animated:YES];
}
- (IBAction)searchActionn:(id)sender {
    WHOutListSearchController *searchView =[WHOutListSearchController new];
    [self.navigationController pushViewController:searchView animated:YES];
}


#pragma mark - Other
-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    
    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(addAction:)];
    

    self.navigationItem.leftBarButtonItem =leftItem;
    
    self.navigationItem.rightBarButtonItem =rightItem;
}

#pragma mark - BtnClick

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
