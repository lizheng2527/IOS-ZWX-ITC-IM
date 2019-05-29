//
//  TYHCommentRecordViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHCommentRecordViewController.h"
#import "AreaHelper.h"
#import "CommentRecordListModel.h"
#import "TYHRecordListCell.h"
#import "TYHZhuYeDetailViewController.h"
#import "FriendAreaDefine.h"
@interface TYHCommentRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *commentRecordListDataSource;
}
@end

@implementation TYHCommentRecordViewController
-(instancetype)initWithKind:(NSString *)kind requestTime:(NSString *)requestTime
{
    self = [super init];
    if (self) {
        self.title = @"相关消息";
        _kind = kind;
        _requestTime = requestTime;
        
    }
    return self;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createLeftBarItem];
    [self initTableView];
    [self getCommentRecordListData];
}


#pragma mark - 数据
-(void)getCommentRecordListData
{
    AreaHelper *helper = [[AreaHelper alloc]init];
    [helper getNewMomentRecordListWithSchoolKind:_kind  requsetTime:_requestTime Status:^(BOOL successful, NSMutableArray *dataSource) {
        commentRecordListDataSource = [NSMutableArray arrayWithArray:dataSource];
        if ([_kind isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults]setValue:[(CommentRecordListModel *)commentRecordListDataSource[0] time] forKey:Area_personRecordTime];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:[(CommentRecordListModel *)commentRecordListDataSource[0] time] forKey:Area_classRecordTime];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
            
        [mainTableView reloadData];
    } failure:^(NSError *error) {
        commentRecordListDataSource = [NSMutableArray array];
    }];
}


#pragma mark -  TableView Delegate and Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentRecordListModel *model = commentRecordListDataSource[indexPath.row];
    static NSString *iden = @"TYHRecordListCell";
    TYHRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TYHRecordListCell" owner:self options:nil].firstObject;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setRecordModel:model withKind:_kind];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ClassAdmin ＝ 1  NomorUser ＝ 0 判定是班级列表还是个人列表
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentRecordListModel *model = commentRecordListDataSource[indexPath.row];
    TYHZhuYeDetailViewController *detailView = [[TYHZhuYeDetailViewController alloc]initWithCommentID:model.momentId ClassAdminOrNomorUser:[_kind integerValue] headUrl:@""];
    detailView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detailView animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentRecordListDataSource.count == 0 || !commentRecordListDataSource) {
        return 0;
    }else return commentRecordListDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark - 视图相关
-(void)initTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:mainTableView];
}
-(void)createLeftBarItem
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
