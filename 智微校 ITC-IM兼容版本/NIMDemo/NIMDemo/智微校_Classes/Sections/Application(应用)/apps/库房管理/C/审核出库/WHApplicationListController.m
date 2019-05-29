//
//  WHApplicationListController.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WHApplicationListController.h"
#import "WHOutListCell.h"
#import "WHDiliverController.h"
#import "WHApplicationDetailController.h"

#import "WHMyApplicationModel.h"
#import "WHNetHelper.h"

#import <UIView+Toast.h>
#import "WHAddApplicationDiliverController.h"
#import "LYEmptyViewHeader.h"


@interface WHApplicationListController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation WHApplicationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestData];
}

#pragma mark - DataRequest
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在获取数据";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    
    [helper getApplicationList:^(BOOL successful, NSMutableArray *dataSource) {
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
    self.title = @"申请单";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"WHOutListCell";
    WHOutListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHOutListCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        cell.model = _dataArray[indexPath.row];
    });
    
    [cell.checkBtn addTarget:self action:@selector(cellBtnClicked:eventCheck:) forControlEvents:UIControlEventTouchUpInside];
    
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
        WHDiliverController *whdView = [WHDiliverController new];
        WHMyApplicationModel *model = _dataArray[indexPath.row];
        whdView.applyID = model.applyID;
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
        WHApplicationDetailController *dView = [WHApplicationDetailController new];
        dView.applyID = [_dataArray[indexPath.row] applyID];
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
    
     leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
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
