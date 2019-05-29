//
//  PInDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/23.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PInDetailController.h"

#import "PServerRecordCell.h"
#import "PServiceApplyMainCell.h"
#import "PVisitRecordCell.h"
#import "ProjectMainModel.h"

#import "PProjectApprovalCheckController.h"
#import "ProjectNetHelper.h"
#import "PAddVisitRecordController.h"
#import "PVisitRecordDetailController.h"

#import "PAddServerApplicationController.h"
#import "PServerRecordDetailController.h"

#import "PAddServerRecordController.h"
#import "PServerRecordDetailController.h"

#import "PServerApplicationDetailController.h"





@interface PInDetailController ()<UITableViewDelegate,UITableViewDataSource,PVisitRecordCellDelegate,PServiceApplyMainCellDelegate,PServerRecordCellDelegate>

@property(nonatomic,retain)NSMutableArray *serviceRecordDatasource;
@property(nonatomic,retain)NSMutableArray *serviceApplyDatasource;
@property(nonatomic,retain)NSMutableArray *visitRecordDatasource;

@end

@implementation PInDetailController
{
    UITableView *mainTableView;
    UILabel *noDatalabel;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

#pragma mark - initData
-(void)setViewTag:(NSInteger)viewTag
{
    _viewTag = viewTag;
}

-(void)requestData
{
    _serviceRecordDatasource = [NSMutableArray array];
    _serviceApplyDatasource = [NSMutableArray array];
    _visitRecordDatasource = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    
    __block NSString *projectID = _projectID;
    
    
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper getVisitRecordListWithProjectID:projectID andStatus:^(BOOL successful, NSMutableArray *dataSourceVisitRecord) {
        
        _visitRecordDatasource = [NSMutableArray arrayWithArray:dataSourceVisitRecord];
        
         [mainTableView reloadData];
        
        [helper getServiceApplyListWithProjectID:projectID andStatus:^(BOOL successful, NSMutableArray *dataSourceServiceApply) {
            
            _serviceApplyDatasource = [NSMutableArray arrayWithArray:dataSourceServiceApply];
            
            [mainTableView reloadData];
            
            [helper getServiceRecordListWithProjectID:projectID andStatus:^(BOOL successful, NSMutableArray *dataSourceServiceRecord) {
                
                _serviceRecordDatasource = [NSMutableArray arrayWithArray:dataSourceServiceRecord];
                
                 [mainTableView reloadData];
                
                [SVProgressHUD dismiss];
//                [self.view makeToast:@"获取数据成功" duration:1.5 position:CSToastPositionCenter];
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 70) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    [self.view addSubview:mainTableView];
}


-(void)shouldCreateNoData:(NSMutableArray *)array
{
    noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width, 40)];
    noDatalabel.text = @"暂无更多";
    CGPoint centerPoint = CGPointMake(mainTableView.center.x, mainTableView.center.y - 30);
    noDatalabel.center = centerPoint;
    noDatalabel.textColor = [UIColor grayColor];
    noDatalabel.textAlignment = NSTextAlignmentCenter;
    noDatalabel.font = [UIFont boldSystemFontOfSize:17];
    if (!noDatalabel.superview && !array.count) {
        [self.view addSubview:noDatalabel];
    }
    else [noDatalabel removeFromSuperview];
}


#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
        {
            //            return self.allArray.count;
            return _visitRecordDatasource.count;
        }
            break;
        case 1002:
        {
            return _serviceApplyDatasource.count;
        }
            break;
        case 1003:
        {
            return _serviceRecordDatasource.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //            return self.allArray.count;
            return 140;
        }
            break;
        case 1002:
        {
            return 169;
        }
            break;
        case 1003:
        {
            return 169;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            //全部
            static NSString *iden1 = @"PVisitRecordCell";
            PVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PVisitRecordCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _visitRecordDatasource[indexPath.row];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 1002:
        {
            
            //未接单
            static NSString *iden2 = @"PServiceApplyMainCell";
            PServiceApplyMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PServiceApplyMainCell" owner:self options:nil].firstObject;
            }
            
            cell.delegate = self;
            cell.model = _serviceApplyDatasource[indexPath.row];
            
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                //子线程异步执行下载任务，防止主线程卡顿
                ////////
            });
            return cell;
        }
            break;
        case 1003:
        {
            
            //维修中
            static NSString *iden3 = @"PServerRecordCell";
            PServerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden3];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"PServerRecordCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _serviceRecordDatasource[indexPath.row];
            
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PVisitRecordCellDelegate

- (void)CheckClickedInVisitRecord:(PVisitRecordCell *)cell
{

}

- (void)DetailBtnClickedInVisitRecord:(PVisitRecordCell *)cell
{
    PVisitRecordDetailController *detailView = [PVisitRecordDetailController new];
    detailView.projectID = cell.model.id;
    detailView.visitor = cell.model.visitor;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - PServiceApplyMainCellDelegate

- (void)CheckClickedInServiceApply:(PServiceApplyMainCell *)cell
{
    PProjectApprovalCheckController *checkView = [PProjectApprovalCheckController new];
    checkView.projectID = cell.model.id;
    [self.navigationController pushViewController:checkView animated:YES];
    
}

- (void)DetailBtnClickedInServiceApply:(PServiceApplyMainCell *)cell
{
    
    PServerApplicationDetailController *detailView = [PServerApplicationDetailController new];
    detailView.projectID = cell.model.id;
    [self.navigationController pushViewController:detailView animated:YES];
}


#pragma mark - PServerRecordCellDelegate

- (void)CheckClickedInServerRecord:(PServerRecordCell *)cell
{
    
}

- (void)DetailBtnClickedInServerRecord:(PServerRecordCell *)cell
{
    PServerRecordDetailController *detailView = [PServerRecordDetailController new];
    detailView.projectID = cell.model.id;
    [self.navigationController pushViewController:detailView animated:YES];
}




#pragma mark -Actions



#pragma mark -Other
-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
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
