//
//  RMPaiController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RMPaiController.h"
#import "TYHRepairDefine.h"
#import "TYHRepairNetRequestHelper.h"
#import "RMPaiCell.h"
#import "RMPaiHeaderView.h"
#import "RepairManagementModel.h"
@interface RMPaiController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)NSMutableArray *workerArray;

@end

@implementation RMPaiController
{
    UITableView *mainTableView;
    
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self createBarItem];
    [self requestData];
}

#pragma mark - initData
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"正在获取维修人员列表"];
    TYHRepairNetRequestHelper *helper= [TYHRepairNetRequestHelper new];
    [helper getServerPersonListWithRepairID:self.repairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        [SVProgressHUD dismiss];
        _workerArray = [NSMutableArray arrayWithArray:dataSource];
        [mainTableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取维修人员列表失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

#pragma mark - initView
-(void)initView
{
    self.title = @"指定维修人员";
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  - 64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    mainTableView.rowHeight = 44;
    mainTableView.editing = YES;
    mainTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:mainTableView];
    
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMServerWorkerModel *model = self.workerArray[indexPath.row];
    static NSString *iden1 = @"RMPaiCell";
    
    RMPaiCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[RMPaiCell alloc]init];
    }
    cell.model = _workerArray[indexPath.row];
    
    
    if (model.isSelected) {
        [mainTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.workerArray enumerateObjectsUsingBlock:^(RMServerWorkerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isSelected = NO;
        if (indexPath.row == idx) {
            model.isSelected = YES;
            [mainTableView reloadData];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMServerWorkerModel *model = _workerArray[indexPath.row];
    model.isSelected = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workerArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RMPaiHeaderView *header = [RMPaiHeaderView new];
    return header;
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
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(submitAction:)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction:(id)sender
{
    static BOOL hasSelected = NO;
    NSString *workerID = @"";
    for (RMServerWorkerModel *model in self.workerArray) {
        if (model.isSelected) {
            hasSelected = YES;
            workerID = model.workerId;
        }
    }
    if (hasSelected) {
        [SVProgressHUD showWithStatus:@"提交服务器中..."];
        TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
        [helper submitPaiRequestWithRepairID:self.repairID WorkerID:workerID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"指定维修人员成功" duration:1.5 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"指定维修人员失败" duration:1.5 position:CSToastPositionCenter];
        }];
    }
    else
    {
        [self.view makeToast:@"请指定维修人员" duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark - Other
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
