//
//  TYHZhuYeViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/2/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#define kAdmin [[DemoGlobalClass sharedInstance]getOtherNameWithPhone:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP]]

#import "TYHZhuYeViewController.h"
#import "SchoolMatesHeaderView.h"
#import <UIImageView+WebCache.h>
#import "AreaHelper.h"
#import <MJExtension.h>
#import "SchoolMatesModel.h"
#import "TYHUserListCell.h"
#import <MJRefresh.h>
#import "TYHZhuYeDetailViewController.h"
//#import "TYHPersonDetailController.h"
@interface TYHZhuYeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TYHZhuYeViewController{
    NSInteger num;
    NSString *ownerVoip;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_ClassAdminOrNomorUser) {
        self.title = @"班级主页";
    }
    else
    {
        self.title = @"个人主页";
    }
    
    
    [self changeLeftBar];
    [self initData];
    [self initTableView];
    [self configData];
    [self setupDownRefresh];
    [self setupUpRefresh];
}

#pragma mark - 初始化
-(instancetype)initWithVoipAccount:(NSString *)voipAccount userName:(NSString*)userName headIconImage:(UIImage *)image teacherOrUser:(BOOL)teacherOrUser
{
    self = [super init];
    _voipAccount = voipAccount;
    _userName = userName;
    _headIconImage = image;
    _ClassAdminOrNomorUser = teacherOrUser;
    return self;
}

-(void)initData
{
    num = 1;
    _dataSource = [NSMutableArray array];
}
-(void)configData
{
    //如果是从班级圈进来
    if (_ClassAdminOrNomorUser) {
        AreaHelper *helper = [[AreaHelper alloc]init];
        [helper getClassMomentsWithPagenum:num departmentID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure) {
            self.dataSource = Datasoure;
            [_mainTableView reloadData];
            num = 1;
        } failure:^(NSError *error) {
        }];
    }
    else
    {
        //如果是从朋友圈进来
        AreaHelper *helper = [[AreaHelper alloc]init];
        [helper getUserMomentsWithPagenum:num userID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure,NSString *string) {
            self.dataSource = Datasoure;
            [_mainTableView reloadData];
            num = 1;
            ownerVoip = string;
        } failure:^(NSError *error) {
        }];
    }
}

-(void)initTableView
{
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    _mainTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_mainTableView];
}

#pragma mark - TableViewDelegate And TableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SchoolMatesHeaderView *headerView = [[SchoolMatesHeaderView alloc]init];
    headerView.areaNameLabel.text = _userName;
    [headerView.smallBgView removeFromSuperview];
    if ([self.voipAccount isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID]]) {
        headerView.userIcon.image = [self dealImageWIthVoipAccount:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_VOIP]];
    }
    else
    {
        headerView.userIcon.image = _headIconImage;
    }
    headerView.bgImageView.image = [UIImage imageNamed:@"head_1"];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPersonDedatilView)];
    headerView.userIcon.userInteractionEnabled = YES;
    [headerView.userIcon addGestureRecognizer:ges];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        momentsModel *model = _dataSource[indexPath.row];
        static NSString *iden = @"TYHUserListCell";
    
        TYHUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
        if (!cell) {
            if (model.picUrls.count == 0) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHUserListCell" owner:self options:nil].lastObject;
            }
            else if(model.picUrls.count > 0)
            {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHUserListCell" owner:self options:nil].firstObject;
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageView.clipsToBounds = YES;
            }
            tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell setCellWithMomentModel:model];
        }
    
    //判断是否是同一天
    if (indexPath.row >0) {
        momentsModel *modelPre = _dataSource[indexPath.row - 1];
        momentsModel *modelNext = _dataSource[indexPath.row];
        if ([[self dealPublishSring:modelPre.publishTime] isEqualToString:[self dealPublishSring:modelNext.publishTime]] ) {
            cell.dateLabel.hidden = YES;
            cell.dateLabelImage.hidden = YES;
            cell.monthLabel.hidden = YES;
            cell.monthLabelImage.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.timeLabelImage.hidden = YES;
        }
    }
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    momentsModel *model = _dataSource[indexPath.row];
    TYHZhuYeDetailViewController *detailView = [[TYHZhuYeDetailViewController alloc]initWithCommentID:model.contentID ClassAdminOrNomorUser:_ClassAdminOrNomorUser className:_userName];
    detailView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detailView animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 216.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    momentsModel *model = _dataSource[indexPath.row];
    if (model.picUrls.count == 0) {
        return 60;
    }
    else return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource.count > 0) {
        return _dataSource.count;
    }
    else
        return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - 方法
-(UIImage *)dealImageWIthVoipAccount:(NSString *)voipAccount
{
    UIImage *image = [[UIImage alloc]init];
    image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:voipAccount];
    if (image && ![self isBlankString:voipAccount]) {
        return image;
    }
    else
        return [UIImage imageNamed:@"mk-photo"];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(NSString *)dealPublishSring:(NSString *)string
{
    NSString *tmpString = [string substringWithRange:NSMakeRange(0, 10)];
    return tmpString;
}


-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoPersonDedatilView
{
//    TYHPersonDetailController *dView = [[TYHPersonDetailController alloc]init];
//
//    if (!_ClassAdminOrNomorUser) {
//        dView.sessionID = ownerVoip;
//        dView.whoGoingToIn = YES;
//        dView.sennMessageBtn.hidden = YES;
//        dView.addOrDeleteFriend.hidden = YES;
//        dView.zhuyeByZhuyeView = NO;
//        [self.navigationController pushViewController:dView animated:YES];
//    }
}

#pragma mark  -  下拉刷新新数据
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
    // 2.进入刷新状态
    [_mainTableView.mj_header beginRefreshing];
}

- (void)loadNewStatus {
    AreaHelper *helper = [[AreaHelper alloc]init];
    
    if (_ClassAdminOrNomorUser) {
        [helper getClassMomentsWithPagenum:0 departmentID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure) {
            self.dataSource = Datasoure;
            [_mainTableView reloadData];
            [_mainTableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
        }];
    }
    else
    {
        [helper getUserMomentsWithPagenum:0 userID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure,NSString *string) {
            self.dataSource = Datasoure;
            [_mainTableView reloadData];
            [_mainTableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
        }];
    }
}
#pragma mark  -  上拉加载
- (void)setupUpRefresh {
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
}

-(void)loadMoreStatus
{
    num ++;
    AreaHelper *helper = [[AreaHelper alloc]init];
    if (_ClassAdminOrNomorUser) {
        [helper getClassMomentsWithPagenum:num departmentID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure) {
            [_dataSource addObjectsFromArray:Datasoure];
            [_mainTableView reloadData];
            [_mainTableView.mj_footer endRefreshing];
        } failure:^(NSError *error) {
            [_mainTableView.mj_footer endRefreshing];
        }];
    }
    else
    {
        [helper getUserMomentsWithPagenum:num userID:_voipAccount andStatus:^(BOOL successful , NSMutableArray *Datasoure,NSString *string) {
            [_dataSource addObjectsFromArray:Datasoure];
            [_mainTableView reloadData];
            [_mainTableView.mj_footer endRefreshing];
        } failure:^(NSError *error) {
            [_mainTableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - other
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
