//
//  qcsClassStasticInsideController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassStasticInsideController.h"
#import "QCSchoolDefine.h"

#import "qcsClassStasticInsideXTTJCell.h"
#import "qcsClassStasticInsideDTBCell.h"
#import "qcsClassStasticInsideXTTJHeader.h"
#import "qcsClassStasticInsideDTBHeader.h"

#import "QCSNetHelper.h"
#import "QCSStasticModel.h"


@interface qcsClassStasticInsideController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)NSMutableArray *XTTJDataSource;
@property(nonatomic,retain)NSMutableArray *DTBDataSource;
@property(nonatomic,retain)NSMutableArray *QDBDataSource;
@property(nonatomic,retain)NSMutableArray *PJBDataSource;
@property(nonatomic,retain)NSMutableArray *ZongHeDataSource;

@end

@implementation qcsClassStasticInsideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    [self getData];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _mainTableView.delaysContentTouches =NO;
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
}


-(void)getData{
    
    _XTTJDataSource = [NSMutableArray array];
    _DTBDataSource = [NSMutableArray array];
    _QDBDataSource = [NSMutableArray array];
    _PJBDataSource = [NSMutableArray array];
    _ZongHeDataSource = [NSMutableArray array];
    
    //    answerNum 答题榜
    //    quickAnswerNum 抢答榜
    //    evaluateCount 评价榜
    
    QCSNetHelper *helper =[QCSNetHelper new];
    
    switch (self.viewTag) {
        case 1001:
            {
                [SVProgressHUD showWithStatus:@"获取数据中"];
                [helper getStasticXTTJListWithID:self.wisdomclassId andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                    
                    _XTTJDataSource = dataSource;
                    [SVProgressHUD dismiss];
                    [_mainTableView reloadData];
                    
                } failure:^(NSError *error) {
                    [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                    [SVProgressHUD dismiss];
                }];
            }
            break;
        case 1002:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getStasticBangDanListWithID:self.wisdomclassId Type:@"answerNum" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _DTBDataSource = dataSource;
                [SVProgressHUD dismiss];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                
            }];
        }
            break;
        case 1003:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getStasticBangDanListWithID:self.wisdomclassId Type:@"quickAnswerNum" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _QDBDataSource = dataSource;
                [SVProgressHUD dismiss];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
            }];
        }
            break;
        case 1004:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getStasticBangDanListWithID:self.wisdomclassId Type:@"evaluateCount" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _PJBDataSource = dataSource;
                [SVProgressHUD dismiss];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
            }];
        }
            break;
        case 1005:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getStasticZongHeListWithID:self.wisdomclassId andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _ZongHeDataSource = dataSource;
                [SVProgressHUD dismiss];
                [_mainTableView reloadData];
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
            return _XTTJDataSource.count;
            break;
        case 1002:
            return _DTBDataSource.count;
            break;
        case 1003:
            return _QDBDataSource.count;
            break;
        case 1004:
            return _PJBDataSource.count;
            break;
        case 1005:
            return _ZongHeDataSource.count;
            break;
        default:return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            static NSString *iden1 = @"qcsClassStasticInsideXTTJCell";
            qcsClassStasticInsideXTTJCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassStasticInsideXTTJCell" owner:self options:nil].firstObject;
            }
            
            if (_XTTJDataSource.count) {
                cell.model = _XTTJDataSource[indexPath.row];
            }
            
            return cell;
        }
            break;
        case 1002:
        {
            static NSString *iden2 = @"qcsClassStasticInsideDTBCell2";
            qcsClassStasticInsideDTBCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassStasticInsideDTBCell" owner:self options:nil].firstObject;
            }
            if (_DTBDataSource.count) {
                cell.model = _DTBDataSource[indexPath.row];
            }
            return cell;
        }
            break;
        case 1003:
        {
            static NSString *iden3 = @"qcsClassStasticInsideDTBCell3";
            qcsClassStasticInsideDTBCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassStasticInsideDTBCell" owner:self options:nil].firstObject;
            }
            if (_QDBDataSource.count) {
                cell.model = _QDBDataSource[indexPath.row];
            }
            return cell;
        }
            break;
        case 1004:
        {
            static NSString *iden4 = @"qcsClassStasticInsideDTBCell4";
            qcsClassStasticInsideDTBCell *cell = [tableView dequeueReusableCellWithIdentifier:iden4];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassStasticInsideDTBCell" owner:self options:nil].firstObject;
            }
            if (_PJBDataSource.count) {
                cell.model = _PJBDataSource[indexPath.row];
            }
            return cell;
        }
            break;
        case 1005:
        {
            static NSString *iden5 = @"qcsClassStasticInsideXTTJCell";
            qcsClassStasticInsideXTTJCell *cell = [tableView dequeueReusableCellWithIdentifier:iden5];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsClassStasticInsideXTTJCell" owner:self options:nil].firstObject;
            }
            if (_ZongHeDataSource.count) {
                cell.cModel = _ZongHeDataSource[indexPath.row];
            }
            return cell;
        }
            break;
            
        default:return [UITableViewCell new];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
        {
            qcsClassStasticInsideXTTJHeader *header = [[qcsClassStasticInsideXTTJHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 44)];
            header.itemRankLabel.text = @"序号";
            header.itemNameLabel.text = @"正确选项";
            header.itemScoreLabel.text = @"人数/总人数";
            header.itemLevelLabel.text = @"正确率";
            return header;
        }
            break;
        case 1002:
        {
            qcsClassStasticInsideDTBHeader *header = [[qcsClassStasticInsideDTBHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 44)];
            return header;
        }
            break;
        case 1003:
        {
            qcsClassStasticInsideDTBHeader *header = [[qcsClassStasticInsideDTBHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 44)];
            return header;
        }
            break;
        case 1004:
        {
            qcsClassStasticInsideDTBHeader *header = [[qcsClassStasticInsideDTBHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 44)];
            return header;
        }
            break;
        case 1005:
        {
            qcsClassStasticInsideXTTJHeader *header = [[qcsClassStasticInsideXTTJHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, 44)];
            header.itemRankLabel.text = @"排名";
            header.itemNameLabel.text = @"学生姓名";
            header.itemScoreLabel.text = @"学生得分";
            header.itemLevelLabel.text = @"等级";
            return header;
        }
            break;
            
        default: return [UIView new];
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
