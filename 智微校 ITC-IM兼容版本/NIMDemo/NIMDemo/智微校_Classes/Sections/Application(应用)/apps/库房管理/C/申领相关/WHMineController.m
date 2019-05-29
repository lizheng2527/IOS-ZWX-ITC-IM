//
//  WHMineController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHMineController.h"
#import "WHMineListCell.h"
#import "WHApplicationDetailController.h"
#import "WHNetHelper.h"
#import "WHMyApplicationModel.h"

#import <UIView+Toast.h>


@interface WHMineController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation WHMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    [self dataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataRequest
-(void)dataRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getMyApplicationList:^(BOOL successful, NSMutableArray *dataSource) {
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
    self.title = @"我的申领";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor TabBarColorGray];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *iden1 = @"WHMineListCell";
        WHMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHMineListCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.lookBtn addTarget:self action:@selector(cellBtnClicked:eventLook:) forControlEvents:UIControlEventTouchUpInside];
    
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
            cell.model = _dataArray[indexPath.row];
            cell.checkBtn.hidden = YES;
        });
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
