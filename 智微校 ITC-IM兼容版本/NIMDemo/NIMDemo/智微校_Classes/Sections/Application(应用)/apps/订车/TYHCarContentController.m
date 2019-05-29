//
//  TYHCarContentController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarContentController.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "CarStatusModel.h"
#import "CarStatusCell.h"
#import "TYHCarChooseManagerController.h"
#import <UIView+Toast.h>
#import "TYHCheckViewController.h"
#import "UIView+Extention.h"
#import "TYHPaiViewController.h"
#import "TYHFeedBackCotroller.h"
#import "TYHFeedBackViewController.h"
#import "CarStatustaskCell.h"
#import <MJRefresh.h>
#import "UIView+ButtonInCell.h"

#define CHECKSTATUS_ASSIGNING @"0"
#define CHECKSTATUS_DRAFT @"1"
#define CHECKSTATUS_PASS @"2"
#define CHECKSTATUS_UNPASS @"3"  //
#define CHECKSTATUS_FINISH @"4"

#define CHECKSTATUS_CANCEL @"5"
#define CHECKSTATUS_CHECK @"uncheck"

#define CHECKSTATUS_DQR @"0"
#define CHECKSTATUS_DJS @"1"
#define CHECKSTATUS_DPJ @"2" //反馈
#define CHECKSTATUS_YPJ @"3"
#define CHECKSTATUS_ALL @""

@interface TYHCarContentController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, assign) NSInteger pageFlag;
@property (nonatomic, copy) NSString *strUrl2;
@property (nonatomic, strong) UIButton * tagButton;

@property(nonatomic,copy)NSString *dataSourceName;
@end

@implementation TYHCarContentController

static NSString * const cellID = @"CarStatusCell";

static NSString * const cellID2 = @"CarStatustaskCell";


- (MBProgressHUD *)hub {

    if (_hub == nil) {
        MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
        hub.alpha = 0.5;
        hub.backgroundColor = [UIColor lightGrayColor];
        hub.minSize = CGSizeMake(200.0f, 30.0f);
        hub.labelText = @"正在获取信息";
        self.hub = hub;
    }
    return _hub;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    
    // cell 的注册
    if (self.tag == 1001) {
        
        [self.tableView registerNib:[UINib nibWithNibName:cellID2 bundle:nil] forCellReuseIdentifier:cellID2];
    } else {
        
        [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    [self.tableView setBounces:NO];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds  设置响应时间
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr]; //启用长按事件
    
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self getNetData];
    
}
- (void)setupUpRefresh {

     self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
}
- (void)loadMoreStatus {

    _pageFlag++;
    NSString * upUrl = [NSString stringWithFormat:@"%@%ld",self.strUrl,(long)_pageFlag];
    
    [TYHHttpTool gets:upUrl params:nil success:^(id json) {
        
        NSArray * newArray = [CarStatusModel objectArrayWithKeyValuesArray:json];
        [self.dataArray addObjectsFromArray:newArray];
        
        [self.tableView reloadData];
        [self.hub removeFromSuperview];
        
        // 结束刷新
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
//        NSLog(@"error == %@",[error localizedDescription]);
        
        // 结束刷新
        [self.tableView.footer endRefreshing];
    }];
}

- (void)getNetData {
    
    _pageFlag = 1;
    
    NSString * upUrl = [NSString stringWithFormat:@"%@%ld",self.strUrl,(long)_pageFlag];
    
    [self.view addSubview:self.hub];
    [self.dataArray removeAllObjects];
    
//    NSLog(@"self.strUrl222  =  %@",upUrl);
    
    [TYHHttpTool gets:upUrl params:nil success:^(id json) {
       
        self.dataArray = [CarStatusModel objectArrayWithKeyValuesArray:json];

        [self.tableView reloadData];
        [self.hub removeFromSuperview];
        
    } failure:^(NSError *error) {
        
        [self.hub removeFromSuperview];
//        NSLog(@"error == %@",[error localizedDescription]);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return self.view.frame.size.height;
    }
    
    if (self.tag == 1001) {
        return 246.f;
    } else {
    
        return 196.0f;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count == 0) {
        
        static NSString *noMessageCellid = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height / 2 - 50,[UIScreen mainScreen].bounds.size.width, 50.0f)];
            noMsgLabel.text = @"暂无订车单";
            noMsgLabel.font = [UIFont systemFontOfSize:15];
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1]];
            [cell.contentView addSubview:noMsgLabel];
            tableView.showsVerticalScrollIndicator = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    CarStatusModel * model = self.dataArray[indexPath.row];
    
    if(self.tag == 1001) {
    
        CarStatustaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell = [[CarStatustaskCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID2];
        }
        
//        [cell cellConfigueWithModel:model];
        cell.orderCarId = model.assignCarId;
        cell.time.text = model.orderTime;
        cell.status.text = model.checkStatusView;
        cell.name.text = model.carUserName;
        // model.evaluateFlag 评价选项  checkStatus 1  orderCarId
        cell.department.text = model.leaveDate; // 出车日期
        cell.arriveTime.text = model.leaveTime;
        cell.arrivePlace.text = model.address;
        cell.telephone.text = model.telephone;
        
        cell.useTime.text = model.useAddress; // 上车地点
        cell.carNum.text = model.carNum;
        cell.orderCar.text = model.startTime; // 到达时间
        cell.checkStatus = model.checkStatus;
        cell.lastLabel.text = model.carName;
        
        cell.arriveTimeLabel.text = model.arriveTime;
        cell.detailCar.layer.borderWidth = 0.5;
        cell.detailCar.layer.cornerRadius = 4;
        
        cell.detailCar.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        [cell.detailCar addTarget:self action:@selector(didClickEnterDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if ([model.checkStatus isEqualToString:CHECKSTATUS_DQR]){

            cell.optionalTwo.hidden = YES;
            cell.optionalOne.hidden = NO;
            cell.optionalThree.hidden = YES;
            [cell.optionalOne setTitle:@"确认出车" forState:(UIControlStateNormal)];
            
            cell.optionalOneFrame.constant = 60;
        }
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_DJS]) {
//            else if ([self.title isEqualToString:@"待结束"]) {
            cell.optionalOne.hidden = NO;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            [cell.optionalOne setTitle:@"结束任务" forState:(UIControlStateNormal)];
            cell.optionalOneFrame.constant = 60;
        }
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_DPJ]) {
        
            cell.optionalOne.hidden = NO;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            [cell.optionalOne setTitle:@"反馈" forState:(UIControlStateNormal)];
            cell.optionalOneFrame.constant = 50;
            
        }
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_YPJ]) {
            
            cell.optionalOne.hidden = YES;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            
        }
        // CHECKSTATUS_YPJ
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_ALL]){
        
           
            
        }
//        NSLog(@"model.checkStatus = %@",model.checkStatus);
        cell.optionalOne.layer.borderWidth = 0.5;
        cell.optionalOne.layer.cornerRadius = 4;
        
        cell.optionalOne.tag = indexPath.row;
        cell.optionalTwo.tag = indexPath.row;
        cell.optionalThree.tag = indexPath.row;
        cell.detailCar.tag = indexPath.row;
        
        cell.optionalTwo.layer.borderWidth = 0.5;
        cell.optionalTwo.layer.cornerRadius = 4;
        
        cell.optionalTwo.layer.borderWidth = 0.5;
        cell.optionalTwo.layer.cornerRadius = 4;
        
        cell.optionalThree.layer.borderWidth = 0.5;
        cell.optionalThree.layer.cornerRadius = 4;
        
        cell.optionalThree.backgroundColor = [UIColor whiteColor];
        
        cell.optionalOne.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        cell.optionalTwo.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        cell.optionalThree.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        
        [cell.optionalOne addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.optionalTwo addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.optionalThree addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        
        return cell;
    } else {
    
        CarStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[CarStatusCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        cell.orderCarId = model.orderCarId;
        cell.time.text = model.orderTime;
        cell.status.text = model.checkStatusView;
        cell.name.text = model.carUserName;
        // model.evaluateFlag 评价选项  checkStatus 1  orderCarId
        cell.department.text = model.departmentName;
        cell.arriveTime.text = model.startTime;
        cell.arrivePlace.text = model.address;
        cell.telephone.text = model.telephone.length?model.telephone:@"无";
        cell.useTime.text = model.userDate;
        cell.checkStatus = model.checkStatus;
        
        cell.arriveTimeLabel.text = model.arriveTime;
        
        cell.detailCar.layer.borderWidth = 0.5;
        cell.detailCar.layer.cornerRadius = 4;
        
        cell.detailCar.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        [cell.detailCar addTarget:self action:@selector(didClickEnterDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if ([model.checkStatus isEqualToString:CHECKSTATUS_ASSIGNING]) {
            
            if (self.tag == 1005) {
                
                cell.optionalOne.hidden = YES;
                cell.optionalTwo.hidden = YES;
                cell.optionalThree.hidden = YES;
//                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
                
            } else {
            
                cell.optionalOne.hidden = NO;
                cell.optionalTwo.hidden = NO;
                cell.optionalThree.hidden = NO;
                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
                [cell.optionalTwo setTitle:@"结束派车" forState:(UIControlStateNormal)];
                [cell.optionalThree setTitle:@"继续派车" forState:(UIControlStateNormal)];
                
            }
        }
        
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_DRAFT]) {
            // 未派车
            if (self.tag == 1005) {
                
                cell.optionalTwo.hidden = YES;
                cell.optionalOne.hidden = NO;
                cell.optionalThree.hidden = YES;
                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
                
            } else {
                cell.optionalTwo.hidden = NO;
                cell.optionalOne.hidden = NO;
                cell.optionalThree.hidden = NO;
                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
                [cell.optionalTwo setTitle:@"不予派车" forState:(UIControlStateNormal)];
                [cell.optionalThree setTitle:@"派车" forState:(UIControlStateNormal)];
                
                
                cell.optionalThreeFrame.constant = 50;
            }

        }
        // 管理员触发  CHECKSTATUS_PASS 已派车
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_PASS]) {
            
            if (self.tag == 1005) {
                
                cell.optionalOne.hidden = YES;
                cell.optionalTwo.hidden = YES;
                cell.optionalThree.hidden = YES;
                
//                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
                
            } else {
            
                cell.optionalOne.hidden = NO;
                cell.optionalTwo.hidden = YES;
                cell.optionalThree.hidden = YES;
                
                [cell.optionalOne setTitle:@"取消订车单" forState:(UIControlStateNormal)];
            }
        }
        
        // 订车单已取消
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_CANCEL]) {
            
            cell.optionalOne.hidden = YES;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            
        }
        // 未设置
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_UNPASS]) {
            // 不予派车 // 已评价
            cell.optionalOne.hidden = YES;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            
        }
        // 未审核
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_CHECK]) {
            
            cell.optionalOne.hidden = NO;
            cell.optionalTwo.hidden = YES;
            cell.optionalThree.hidden = YES;
            [cell.optionalOne setTitle:@"审核" forState:(UIControlStateNormal)];
            
            cell.optionalOneFrame.constant = 50;
        }
        // 已评价
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_FINISH]) {
            
            if (self.tag == 1005 && [model.evaluateFlag isEqualToString:@"0"]) {
                cell.optionalTwo.hidden = YES;
                cell.optionalOne.hidden = NO;
                cell.optionalThree.hidden = YES;
                cell.evaluateFlag = model.evaluateFlag;
                [cell.optionalOne setTitle:@"评价" forState:(UIControlStateNormal)];
                
                cell.optionalOneFrame.constant = 50;
            } else {
                cell.optionalTwo.hidden = YES;
                cell.optionalOne.hidden = YES;
                cell.optionalThree.hidden = YES;
            }
            
        }
        else if ([model.checkStatus isEqualToString:CHECKSTATUS_ALL]){
        
            
        }
        
        cell.optionalOne.layer.borderWidth = 0.5f;
        cell.optionalOne.layer.cornerRadius = 4.0f;
        
        cell.optionalOne.tag = indexPath.row;
        cell.optionalTwo.tag = indexPath.row;
        cell.optionalThree.tag = indexPath.row;
        cell.detailCar.tag = indexPath.row;
        
        cell.optionalTwo.layer.borderWidth = 0.5f;
        cell.optionalTwo.layer.cornerRadius = 4;
        
        
        cell.optionalThree.layer.borderWidth = 0.5f;
        cell.optionalThree.layer.cornerRadius = 4;
        
        cell.optionalOne.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        cell.optionalTwo.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        cell.optionalThree.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        
        [cell.optionalOne addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.optionalTwo addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.optionalThree addTarget:self action:@selector(didClickEnterOneDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        
        return cell;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {

    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    CarStatusCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        cell.colorLabel.backgroundColor = [UIColor TabBarColorOrange];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
//        cell.colorLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
}
#pragma mark  ----  alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        [self getHUB];
        
        [TYHHttpTool gets:self.strUrl2 params:nil success:^(id json) {
            if ([self.title isEqualToString:@"全部"]) {
                
                // 获取新的数据
            
                
            } else {
                if (self.dataArray && self.dataArray.count) {
                    [self.dataArray removeObjectAtIndex:self.tagButton.tag];
                }
                
            }
            [self.tableView reloadData];
            [self.hub removeFromSuperview];
            
        } failure:^(NSError *error) {
//            NSLog(@"error == %@",[error localizedDescription]);
        }];
        
    }
}
- (void)getHUB {

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [window addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在操作";
    self.hub = hub;
}
- (void)didClickNewButton:(UIButton *)btn{

    NSString * name = [NSString stringWithFormat:@"%@", btn.currentTitle];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:btn.currentTitle message:name preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self getHUB];
            //                NSLog(@"strUrl = = %@",strUrl);
            [TYHHttpTool gets:self.strUrl2 params:nil success:^(id json) {
                
                if ([self.title isEqualToString:@"全部"]) {
                    
                    [self.hub removeFromSuperview];
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
                    CarStatusModel * model = self.dataArray[indexPath.row];
                    
                    //
                    if ([btn.currentTitle isEqualToString:@"取消订车单"]) {
                        
                        model.checkStatusView = @"订车单已取消";
                        model.checkStatus = CHECKSTATUS_CANCEL;
                        
                    } else if ([btn.currentTitle isEqualToString:@"不予派车"]) {
                    
                        
                        //
                        model.checkStatusView = @"不予派车";
                        model.checkStatus = CHECKSTATUS_UNPASS;
                    }
                    
                    // 遗留问题 不清楚什么情况 checkStatusView 显示已完成
                    
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    
                } else {
                    [self.hub removeFromSuperview];
                    [self.dataArray removeObjectAtIndex:btn.tag];
                    [self.tableView reloadData];
                }
                
            } failure:^(NSError *error) {
                //                        NSLog(@"error == %@",[error localizedDescription]);
            }];
            
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:btn.currentTitle   message:name delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }
    
}

- (void)didClickEnterOneDetail:(UIButton *)btn {
    
    if (self.tag == 1001) {
        
        [self getHUB];
        
        CarStatustaskCell * cell = (CarStatustaskCell *)[btn getSuperViewInButtonCell];
        
        if([btn.currentTitle isEqualToString:@"结束派车"]) {
            
            NSString * baseUrl = @"/cm/carMobile!passOrderCar.action";
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
//            NSLog(@"endUrl = %@",endUrl);
            // 结束需要将此 cell 移除
            [TYHHttpTool get:endUrl params:nil success:^(id json) {
                [self.hub removeFromSuperview];
//                NSLog(@"json = %@ %@",[json class], json);
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                 [self.hub removeFromSuperview];
                
                NSLog(@"error结束派车 = %@",[error localizedDescription]);
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
            }];
            
        }
        else if([btn.currentTitle isEqualToString:@"结束任务"]) {
            
            NSString * baseUrl = @"/cm/carMobile!driverEndTask.action";
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
            // 结束需要将此 cell 移除
            [TYHHttpTool get:endUrl params:nil success:^(id json) {
                 [self.hub removeFromSuperview];
//                NSLog(@"json = %@ %@",[json class], json);
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
                
                // 结束后到反馈页面
                NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
                //  assignCarId，realCount，realTime，realAddress，note
               NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
                
                TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
                feedback.urlStr = endUrl2;
                [self.navigationController pushViewController:feedback animated:YES];

                
            } failure:^(NSError *error) {
                
                [self.hub removeFromSuperview];
                
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];// 结束后到反馈页面
                NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
                //  assignCarId，realCount，realTime，realAddress，note
                NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
                
                TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
                feedback.urlStr = endUrl2;
                [self.navigationController pushViewController:feedback animated:YES];
                NSLog(@"error结束任务 = %@",[error localizedDescription]);
            }];
            
        } else if([btn.currentTitle isEqualToString:@"确认出车"]) {
            
            NSString * baseUrl = @"/cm/carMobile!driverEnsureBus.action";
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
            // 结束需要将此 cell 移除
            [TYHHttpTool get:endUrl params:nil success:^(id json) {
                
                [self.hub removeFromSuperview];
//                NSLog(@"json = %@ %@",[json class], json);
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                
//                NSLog(@"error确认出车 = %@",[error localizedDescription]);
                
                [self.hub removeFromSuperview];
                
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
            }];
            
        } else if([btn.currentTitle isEqualToString:@"反馈"]) {
            
            // 司机反馈
            NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
            //  assignCarId，realCount，realTime，realAddress，note
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
            TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
            
            feedback.urlStr = endUrl;
            feedback.returnCheckSuccess2 = ^(BOOL success){
                if(success) {
                    
                    [self.dataArray removeObjectAtIndex:btn.tag];
                    // 刷新列表
                    [self.tableView reloadData];
                }
            };
            [self.hub removeFromSuperview];
            [self.navigationController pushViewController:feedback animated:YES];
        }

        
    } else {
    
        
        CarStatusCell * cell = (CarStatusCell *)[btn getSuperViewInButtonCell];;
        if ([btn.currentTitle isEqualToString:@"派车"]||[btn.currentTitle isEqualToString:@"继续派车"]) {
            
            TYHPaiViewController * paiVc = [[TYHPaiViewController alloc] init];
            
            NSString * baseUrl = @"/cm/carMobile!getCarsInfo.action";
            paiVc.urlStr  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&operationCode=carmanage&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
            paiVc.username = _username;
            paiVc.password = _password;
            paiVc.carOrderId = cell.orderCarId;
            
            self.tagButton = btn;
           // 跨页面 使用通知比较合适
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCurrentDetailCell) name:@"detail" object:nil];
            
            [self.navigationController pushViewController:paiVc animated:YES];
            
        } else if([btn.currentTitle isEqualToString:@"审核"]) {
            // id，status( 1通过  2不通过) ，advice
            TYHCheckViewController * checkVc = [[TYHCheckViewController alloc] init];
            checkVc.title  = @"订车单审核";
            NSString * baseUrl = @"/cm/carMobile!checkOrderCar.action";
            
            checkVc.urlStr  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            // 返回刷新
            checkVc.returnCheckSuccess = ^(BOOL success){
                if(success) {
                    [self.dataArray removeObjectAtIndex:btn.tag];
                    // 刷新列表
                    [self.tableView reloadData];
                }
            };
            
            [self.navigationController pushViewController:checkVc animated:YES];
        } else if ([btn.currentTitle isEqualToString:@"取消订车单"]) {
            // 取消订车单
            // 如果 title 是全部则不需要移除 但得重新获取一下数组 显示状态
            
            NSString *baseUrl = @"/cm/carMobile!cancelOrderCar.action";
            
            NSString *strUrl2 = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , self.username, self.password,cell.orderCarId,_dataSourceName];
            self.strUrl2 = strUrl2;
            self.tagButton.tag = btn.tag;
            
            [self didClickNewButton:btn];
        }
        
        else if([btn.currentTitle isEqualToString:@"不予派车"]) {
            
            NSString *baseUrl = @"/cm/carMobile!unPassOrderCar.action";
            
             NSString *strUrl2 = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , self.username, self.password,cell.orderCarId,_dataSourceName];
            
            self.strUrl2 = strUrl2;
            self.tagButton.tag = btn.tag;
            
            [self didClickNewButton:btn];
        
        }
        else if([btn.currentTitle isEqualToString:@"结束派车"]) {
            
            NSString * baseUrl = @"/cm/carMobile!passOrderCar.action";
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            
//            NSLog(@"endUrl = %@",endUrl);
            // 结束需要将此 cell 移除
            [TYHHttpTool gets:endUrl params:nil success:^(id json) {
                
                [self.dataArray removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                
                NSLog(@"%@",[error localizedDescription]);
            }];
            
        } else if([btn.currentTitle isEqualToString:@"评价"]) {
            
            NSString * baseUrl = @"/cm/carMobile!toCarUserFeedback.action";// 获取评价页某些数据
            NSString * baseUrl2 = @"/cm/carMobile!saveCarUserFeedback.action"; // 提交评价
            
            NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl , _username, _password,cell.orderCarId,_dataSourceName];
            NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@", k_V3ServerURL, baseUrl2 , _username, _password,cell.orderCarId,_dataSourceName];
            
            TYHFeedBackCotroller * feedBack = [[TYHFeedBackCotroller alloc] init];
            feedBack.title = @"用车评价";
            feedBack.returnCheckSuccess2 = ^(BOOL success){
                if(success) {
                    
                    [self.dataArray removeObjectAtIndex:btn.tag];
                    // 刷新列表
                    [self.tableView reloadData];
                }
            };
            // 也可以转成模型传过去
            [TYHHttpTool get:endUrl params:nil success:^(id json) {
                
                [self.hub removeFromSuperview];
                
                feedBack.urlStr = endUrl;
                feedBack.urlStr2 = endUrl2;
                
                feedBack.starData = json[@"starData"];
                feedBack.assignData = json[@"assignData"];
                
                [self.navigationController pushViewController:feedBack animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}


- (void)deleteCurrentDetailCell {
    
    if ([self.title isEqualToString:@"全部"]) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.tagButton.tag inSection:0];
        CarStatusModel * model = self.dataArray[indexPath.row];
        model.checkStatusView = @"订车单已取消";
        model.checkStatus = CHECKSTATUS_CANCEL;
        
        // 遗留问题 不清楚什么情况 checkStatusView 显示订车单已完成
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        
        if (self.dataArray && self.dataArray.count) {
            [self.dataArray removeObjectAtIndex:self.tagButton.tag];
        }
        [self.tableView reloadData];
    }
    
    
}
- (void)didClickEnterDetail:(UIButton *)btn {
    
    TYHCarChooseManagerController * ChooseManager = [[TYHCarChooseManagerController alloc] init];
    self.tagButton = btn;
    
    ChooseManager.tag = self.tag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCurrentDetailCell) name:@"detail" object:nil];
    
    
    if (self.tag == 1001) {
        
        // __kindof 表示如果是子类 不需要强转
        CarStatustaskCell * cell = [btn getSuperViewInButtonCell];
        
        ChooseManager.carOrderId = cell.orderCarId;
        ChooseManager.optionalOne = cell.optionalOne;
        ChooseManager.optionalTwo = cell.optionalTwo;
        ChooseManager.optionalThree = cell.optionalThree;
        
        if ([cell.checkStatus isEqualToString:CHECKSTATUS_YPJ]) {
            // 已评价
            
        
        } else if ([cell.checkStatus isEqualToString:CHECKSTATUS_DPJ] || [cell.checkStatus isEqualToString:CHECKSTATUS_DJS]|| [cell.checkStatus isEqualToString:CHECKSTATUS_DQR]) {
            
            // 已派车 取消按钮
            // 待审核 审核按钮
            ChooseManager.optionalOneStr = cell.optionalOne.currentTitle;
            
        }
        
    } else {
    
        CarStatusCell * cell = [btn getSuperViewInButtonCell];
        
        ChooseManager.carOrderId = cell.orderCarId;
        ChooseManager.optionalOne = cell.optionalOne;
        ChooseManager.optionalTwo = cell.optionalTwo;
        ChooseManager.optionalThree = cell.optionalThree;
        ChooseManager.dataArray = self.dataArray;
    
        // CHECKSTATUS_CANCEL
        if ([cell.checkStatus isEqualToString:CHECKSTATUS_FINISH]) {
            // 完成不需要传 // 评价需要传 evaluateFlag
            if (self.tag == 1005 && [cell.evaluateFlag isEqualToString:@"0"]) {
                
                ChooseManager.optionalOneStr = cell.optionalOne.currentTitle;
            }
            
        }
        else if ([cell.checkStatus isEqualToString:CHECKSTATUS_CANCEL] ) {
        
            
        }
//        else if ([cell.checkStatus isEqualToString:CHECKSTATUS_PASS] || [cell.checkStatus isEqualToString:CHECKSTATUS_CHECK] || cell.optionalTwo.hidden == YES) {
        
        else if ([cell.checkStatus isEqualToString:CHECKSTATUS_PASS] || [cell.checkStatus isEqualToString:CHECKSTATUS_CHECK] || cell.optionalTwo.hidden == YES) {
            
            if (self.tag == 1005) {
                
                
            } else {
                
                ChooseManager.optionalOneStr = cell.optionalOne.currentTitle;
            }
        
            // 已派车 取消按钮
            // 待审核 审核按钮
        
        } else if ([cell.checkStatus isEqualToString:CHECKSTATUS_ASSIGNING]||[cell.checkStatus isEqualToString:CHECKSTATUS_DRAFT]) {
            // 派车中
            // 继续派车按钮
            if (self.tag == 1005) {
                
                
            } else {
                
                ChooseManager.optionalOneStr = cell.optionalOne.currentTitle;
                ChooseManager.optionalTwoStr = cell.optionalTwo.currentTitle;
                ChooseManager.optionalThreeStr = cell.optionalThree.currentTitle;
            }
            
        }
     
        else { //optionalOne
            
            ChooseManager.optionalOneStr = cell.optionalOne.currentTitle;
            ChooseManager.optionalTwoStr = cell.optionalTwo.currentTitle;
        }
    }
    
    [self.navigationController pushViewController:ChooseManager animated:YES];
    
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
