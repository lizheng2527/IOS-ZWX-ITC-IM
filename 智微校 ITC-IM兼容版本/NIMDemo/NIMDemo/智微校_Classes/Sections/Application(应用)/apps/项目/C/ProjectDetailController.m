//
//  ProjectDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectDetailController.h"
#import "ProjectDetailCell.h"
#import "ProjectNetHelper.h"
#import "ProjectMainModel.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface ProjectDetailController()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProjectDetailController
{
    ProjectListDetailModel *mainModel;
    ProjectDetailCell *mainCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"服务申请详情";
    //    [self createApplyButton];
    
    [self requestData];
}

#pragma mark - configData
-(void)requestData
{
    mainModel = [ProjectListDetailModel new];
    [SVProgressHUD showWithStatus:@"获取数据中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper getMyProjectDetailWithProjectID:self.projectID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        if (dataSource.count) {
            mainModel = dataSource[0];
        }
        [_mainTableview reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}


#pragma mark - initView
-(void)initTableView
{
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.separatorStyle = NO;
    _mainTableview.bounces = NO;
    _mainTableview.estimatedRowHeight = 600;
    _mainTableview.rowHeight = UITableViewAutomaticDimension;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
    
    [_mainTableview registerNib:[UINib nibWithNibName:@"ProjectDetailCell" bundle:nil] forCellReuseIdentifier:@"ProjectDetailCell"];
    
}


//-(void)createApplyButton
//{
//    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    applyButton.frame = CGRectMake(self.view.width / 2, self.view.height - 30, 60, 20);
//    [applyButton setTitle:@"申请立项" forState: UIControlStateNormal];
//    [applyButton setBackgroundColor:[UIColor lightGrayColor]];
//
//    [self.view addSubview:applyButton];
//}


#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ProjectDetailCell";
    ProjectDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProjectDetailCell" owner:self options:nil].firstObject;
    }
    cell.model = mainModel;
    
    mainCell = cell;
    
//    [mainCell layoutIfNeeded];
//    [mainCell updateConstraintsIfNeeded];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ProjectDetailCell" cacheByIndexPath:indexPath configuration:^(ProjectDetailCell *cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        cell.model = mainModel;
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
