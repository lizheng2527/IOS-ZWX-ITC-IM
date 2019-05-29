//
//  TYHProjectController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHProjectController.h"
#import "ProjectMainCell.h"
#import "SDAutoLayout.h"
#import "PInMainController.h"
#import "PCheckMainViewController.h"
#import "ProjectDetailController.h"
#import "ProjectNewApplicationController.h"
#import "ProjectMainModel.h"
#import "ProjectNetHelper.h"


@interface TYHProjectController ()<UITableViewDelegate,UITableViewDataSource,ProjectMainCellDelegate>

@property(nonatomic,retain)NSMutableArray *dataSource;
@end

@implementation TYHProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"公司项目";
    [self createApplyButton];
}

#pragma mark - GetData
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"获取数据中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper getMyProjectListWithStatus:^(BOOL successful, NSMutableArray *dataaSource) {
        _dataSource = [NSMutableArray arrayWithArray:dataaSource];
        [_mainTableview reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
    [helper getCheckPermissionWithStatus:^(BOOL successful, ProjectPermissionModel *model) {
        if ([model.hasPermission isEqualToString:@"1"]) {
            [self createBarItem:model.count];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - initView
-(void)initTableView
{
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.rowHeight = 168;
    _mainTableview.bounces = NO;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
}

-(void)createBarItem:(NSString *)count
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = nil;
    rightItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"待审核 [%@]",count] style:UIBarButtonItemStyleDone target:self
                                               action:@selector(checkAction:)];
    self.navigationItem.rightBarButtonItem =rightItem;
}


-(void)createApplyButton
{
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(self.view.width / 2 - 45, self.view.height - 110, 90, 30);
    if (kDevice_Is_iPhoneX) {
        applyButton.frame = CGRectMake(self.view.width / 2 - 45, self.view.height - 110 - 34, 90, 30);
    }
    applyButton.layer.masksToBounds = YES;
    applyButton.layer.cornerRadius = 4.f;
    [applyButton setTitle:@"添加项目" forState: UIControlStateNormal];
    [applyButton setBackgroundColor:[UIColor blueColor]];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(addItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ProjectMainCell";
    ProjectMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProjectMainCell" owner:self options:nil].firstObject;
    }
    cell.model = _dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma ProjectMainCellDelegate

- (void)InBtnClicked:(ProjectMainCell *)cell
{
    PInMainController *inView = [PInMainController new];
    inView.projectID = cell.model.id;
    inView.title = cell.model.projectName;
    [self.navigationController pushViewController:inView animated:YES];
}

- (void)CheckClicked:(ProjectMainCell *)cell
{
    PCheckMainViewController *checkView =[PCheckMainViewController new];
    [self.navigationController pushViewController:checkView animated:YES];
    
    
}

- (void)DetailBtnClicked:(ProjectMainCell *)cell
{
    
    ProjectDetailController *checkView =[ProjectDetailController new];
    checkView.projectID = cell.model.id;
    [self.navigationController pushViewController:checkView animated:YES];
}



#pragma mark - ClickActions

-(void)checkAction:(id)sender
{
    PCheckMainViewController *checkView =[PCheckMainViewController new];
    [self.navigationController pushViewController:checkView animated:YES];
}

-(void)addItemAction:(id)sender
{
    ProjectNewApplicationController *checkView =[ProjectNewApplicationController new];
    [self.navigationController pushViewController:checkView animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
