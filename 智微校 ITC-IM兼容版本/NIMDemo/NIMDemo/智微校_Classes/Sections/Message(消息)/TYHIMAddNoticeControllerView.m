//
//  TYHIMAddNoticeControllerView.m
//  NIM
//
//  Created by 中电和讯 on 2019/2/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "TYHIMAddNoticeControllerView.h"

#import "TYHHttpTool.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "NoticeCell.h"
#import "UIView+Extention.h"
#import "UIBarButtonItem+Extention.h"


#import "NoticeModel.h"
#import <UIView+Toast.h>
#import <MBProgressHUD.h>
#import "TYHNewAPPViewController.h"
#import "TYHNewDetailViewController.h"
#import "TYHNavigationController.h"
#import "TYHNewNoticeViewController.h"
#import "TYHNewReceptionViewController.h"
#import "lookHomeworkViewController.h"
#import "TYHAssetViewController.h"
#import "TYHAttendanceController.h"
#import "TYHWarehouseManagementController.h"
#import "TYHRepairMainController.h"
#import "CANoticeDetailControllerView.h"
#import "TYHClassAttendanceController.h"

#import "UIAlertView+NTESBlock.h"
#import "UITabBar+redBadge.h"
#import "TYHMessageHeaderView.h"
#import "TYHMessageListController.h"
#import <UIImageView+WebCache.h>

#import "TBCityIconFont.h"
#import "TBCityIconInfo.h"
#import "TYHNoticeIconFontDic.h"
#import "TYHNoticeIconFontDictionary.h"
#import "UIImage+TBCityIconFont.h"
#import "UIColor+SDHex.h"
#import "NIMBadgeView.h"

@interface TYHIMAddNoticeControllerView ()
<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,TYHMessageHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray * allMessages;
@property (nonatomic, strong) NSMutableArray * chooseArray;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, assign) NSInteger pageFlag;
@property (nonatomic, strong) UIBarButtonItem * leftItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) NoticeCell * cell ;
@property (nonatomic, strong) NoticeModel * model;
@property (nonatomic, copy) NSString * eachString;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, copy) NSString * titleNew;
@property (nonatomic, strong) NSMutableArray * chooseDic;
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, assign) NSInteger  unReadCount;
@property (nonatomic, copy) NSString * IMURL;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * result;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, assign) int deleteCount;
@property (nonatomic, strong) NSArray * appIconArray;
@property(nonatomic,copy)NSString *dataSourceName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;


@end

@implementation TYHIMAddNoticeControllerView
{
    BOOL isEditing;
}

- (NSArray *)appIconArray {
    
    if (_appIconArray == nil) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"appSourceITC.plist" ofType:nil];
        
        self.appIconArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _appIconArray;
}

static int a = 0, b = 0;
- (NSMutableArray *)chooseDic {
    
    if (_chooseDic == nil) {
        self.chooseDic = [[NSMutableArray alloc] init];
    }
    return _chooseDic;
}
- (NSMutableArray *)allMessages {
    if (_allMessages == nil) {
        self.allMessages = [[NSMutableArray alloc] init];
    }
    return _allMessages;
}
- (NSMutableArray *)chooseArray {
    if (_chooseArray == nil) {
        self.chooseArray = [[NSMutableArray alloc] init];
    }
    return _chooseArray;
}


- (void)initData {
    
    _userName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_LOGINNAME];
    _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    _IMURL = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_BASEURL];
    NSString *V3Pwd = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    if ([self isBlankString:V3Pwd]) {
        V3Pwd = @"";
    }
    _password = V3Pwd;
    _token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    _dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    _dataSourceName = _dataSourceName.length?_dataSourceName:@"";
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    
    
    //  判断 是否有发通知权限
    NSString * urlStr = [NSString stringWithFormat:@"%@/bd/mobile/baseData!ifNewNoticeGranted.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",BaseURL,_userName,_password,_userId,self.token,_dataSourceName];
    
    //    NSLog(@"urlStr = %@",urlStr);
    [TYHHttpTool gets:urlStr params:nil success:^(id json) {
        NSString * result = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        self.result = result;
    } failure:^(NSError *error) {
        
    }];
    // 创建EditItem
    [self creatRightItem];
    // 返回Item
    [self creatLeftItem];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 创建tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing =YES;
    self.tableView.tableFooterView = [UIView new];
    
    adjustsScrollViewInsets_NO(_tableView, self);
    
    
    //    if (@available(iOS 11.0, *)) {
    //        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    } else {
    //        // Fallback on earlier versions
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    //  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeCell" bundle:nil]  forCellReuseIdentifier:@"noticeCell"];
    
    //  初始化开始的全部数据源
    //    self.eachString = [NSString stringWithFormat:@"%@/bd/message/getList",_IMURL];
    self.eachString = [NSString stringWithFormat:@"%@/bd/mobile/baseData!getAllMessageList.action",_IMURL];
    
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewStatus) name:@"NewV3PushMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh)name:@"MessageNotification" object:nil];
    
    
}

-(void)refresh
{
    [_tableView reloadData];
}

// 触发长按手势
-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        isEditing = YES;
        [self editCell];
        
        CGPoint point = [gesture locationInView:_tableView];
        
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:point];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        
        [self.chooseArray addObject:indexPath];
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
    }
}
#pragma mark   -------  定义EditItem
- (void)creatRightItem {
    
    
    _rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_mark_read"] style:UIBarButtonItemStyleDone target:self action:@selector(SetAllNoticeReaded)];
    
    
    
    _rightItem.tintColor = [UIColor whiteColor];
    NSUInteger size = 13;
    UIFont * font = [UIFont boldSystemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [_rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

-(void)SetAllNoticeReaded
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定将所有消息提醒设为已读吗" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertWithCompletionHandler:^(NSInteger idx) {
        if (idx == 0) {
            isEditing = NO;
            return ;
        }
        if (idx == 1) {
            isEditing = YES;
            [self SetAllMessagesReadedToServer];
        }
    }];
    
    
}


-(NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
}
-(NSString *)password
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
}

-(NSString *)token
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
}


-(void)SetAllMessagesReadedToServer
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    __block NSMutableString *readString = [NSMutableString string];
    for (NoticeModel *model in self.allMessages) {
        if ([model.readFlag isEqualToString:@"0"]) {
            [readString appendString:[NSString stringWithFormat:@"%@,",model.ID]];
            model.readFlag = @"1";
        }
    }
    
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":_dataSourceName,@"userId":userID,@"id":readString.length?readString:@""};
    //    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":_dataSourceName,@"userId":userID};
    //    NSString *requestURL = [NSString stringWithFormat:@"%@%@?userId=%@",BaseURL,@"/bd/message/setAllRead",userID];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,@"/bd/mobile/baseData!setMessageRead.action"];
    [SVProgressHUD showWithStatus:@"请稍等"];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    
    // 2.发送请求
    [mgr GET:requestURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已全部设为已读" duration:1.5 position:CSToastPositionCenter];
        
        [self.tableView reloadData];
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        
        //        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        //        if([string isEqualToString:@"ok"])
        //        {
        //            [self loadNewStatus];
        //            [SVProgressHUD dismiss];
        //            [self.view makeToast:@"已全部设为已读" duration:1.5 position:CSToastPositionCenter];
        //            isEditing = NO;
        //            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        //        }
        //        else
        //        {
        //            isEditing = NO;
        //            [SVProgressHUD dismiss];
        //            [self.view makeToast:@"操作失败" duration:1.5 position:CSToastPositionCenter];
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        //        if([string isEqualToString:@"ok"])
        //        {
        //            isEditing = NO;
        //            [self loadNewStatus];
        //            [SVProgressHUD dismiss];
        //            [self.view makeToast:@"已全部设为已读" duration:1.5 position:CSToastPositionCenter];
        //
        //            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        //        }
        //        else
        //        {
        //            isEditing = NO;
        //            [SVProgressHUD dismiss];
        //            [self.view makeToast:@"操作失败,可能是网络问题" duration:1.5 position:CSToastPositionCenter];
        //        }
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已全部设为已读" duration:1.5 position:CSToastPositionCenter];
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        [self.tableView reloadData];
    }];
}


#pragma mark  =========    点击编辑的一些状态变化
- (void)editCell{
    
    if (isEditing) {
        
        if (self.allMessages != nil && ![self.allMessages isKindOfClass:[NSNull class]] && self.allMessages.count != 0) {
            
            //            NSLog(@"%ld",(long)self.allMessages.count);
            [self.tableView setEditing:YES animated:YES];
            
            _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(unEditCell)];
            _rightItem.tintColor = [UIColor whiteColor];
            NSUInteger size = 13;
            UIFont * font = [UIFont boldSystemFontOfSize:size];
            NSDictionary * attributes = @{NSFontAttributeName: font};
            [_rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = _rightItem;
            self.navigationItem.titleView = nil;
            self.navigationItem.title = @"多选";
            self.deleteBtn.hidden = NO;
            self.deleteBtn.frame = CGRectMake(self.deleteBtn.frame.origin.x, [UIScreen mainScreen].bounds.size.height  - self.deleteBtn.frame.size.height, self.deleteBtn.frame.size.width, self.deleteBtn.frame.size.height);
            [self creatLeftItem];
            
        }
        else {
            [self.tableView setEditing:NO animated:YES];
            [self.view makeToast:@"暂无数据无法编辑" duration:2 position:CSToastPositionCenter];
        }
    }
}

#pragma mark   =====  取消编辑恢复原来状态
- (void)unEditCell{
    isEditing = NO;
    [self.tableView setEditing:NO animated:YES];
    
    [self creatRightItem];
    
    self.navigationItem.title = @"消息";
    [self creatLeftItem];
    self.deleteBtn.hidden = YES;
    a = 0;
    b = 0;
    [self.chooseArray removeAllObjects];
}

#pragma mark   -------  定义返回按钮
- (void)creatLeftItem {
    
    if (isEditing) {
        
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"已选择0" style:UIBarButtonItemStyleBordered target:self action:nil];
        _leftItem.tintColor = [UIColor whiteColor];
        
        NSUInteger size = 13;
        UIFont * font = [UIFont boldSystemFontOfSize:size];
        NSDictionary * attributes = @{NSFontAttributeName: font};
        [_leftItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        
        UIBarButtonItem * leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(selectAll:) image:@"cb_fx_normal" highImage:@"cb_fx_checked"];
        
        //        UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(selectAll:) nomalImage:[UIImage imageNamed:@"cb_fx_normal"] higeLightedImage:[UIImage imageNamed:@"cb_fx_checked"] imageEdgeInsets:UIEdgeInsetsZero];
        
        
        self.navigationItem.leftBarButtonItems = @[leftBtn,_leftItem];
        
        
        
    } else {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            _leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        } else {
            _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        }
        
        self.navigationItem.leftBarButtonItems = nil;
        //        self.navigationItem.leftBarButtonItem = _leftItem;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
#pragma mark =======   全选的设置
- (void)selectAll:(id)sender {
    
    UIButton * btn = (id)sender;
    self.button = btn;
    
    if (!self.button.selected) {
        
        if (self.chooseArray.count != self.allMessages.count) {
            
            [self.chooseArray removeAllObjects];
            
            for (int i=0; i<self.allMessages.count; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                
                [self.chooseArray addObject:indexPath];
                
                // 这是标记选中cell 的方法
                if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
                    
                }
                [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
            }
            self.button.selected = !self.button.selected;
        }
    }
    else {
        [self.chooseArray removeAllObjects];
        
        for (int i=0; i<self.allMessages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
                
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
            
            [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
        }
        self.button.selected = !self.button.selected;
        
    }
}
- (void)returnClicked {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark  -----  下拉刷新新数据
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
    // 2.进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewStatus {
    
    [self getNotiveData:self.eachString];
    
}
#pragma mark  -----  上拉刷新
- (void)setupUpRefresh {
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
    
}
// 主要走这里
- (void)loadMoreStatus {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,_userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",_password];
    params[@"userId"] = [NSString stringWithFormat:@"%@",_userId];
    params[@"dataSourceName"] = _dataSourceName;
    _pageFlag ++;
    params[@"pageFlag"] = [NSString stringWithFormat:@"%ld",(long)_pageFlag];
    
    [TYHHttpTool get:self.eachString params:params success:^(id json) {
        
        
        NSArray * newArray = [NoticeModel mj_objectArrayWithKeyValuesArray:json];
        
        [self.allMessages addObjectsFromArray:newArray];
        
        [self.tableView reloadData];
        
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        [newArray enumerateObjectsUsingBlock:^(NoticeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj.readFlag integerValue]) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:0];
                *stop = YES;
            }
        }];
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark   -------  获取所有通知
- (void)getNotiveData:(NSString *)string {
    
    if (!string.length) {
        string = self.eachString;
    }
    
    [self.allMessages removeAllObjects];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,_userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",_password];
    params[@"userId"] = [NSString stringWithFormat:@"%@",_userId];
    _pageFlag = 1;
    params[@"pageFlag"] = [NSString stringWithFormat:@"%ld",(long)_pageFlag];
    params[@"imToken"] = [NSString stringWithFormat:@"%@",_token];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?pageFlag=%@&imToken=%@&userId=%@&sys_username=%@&sys_password=%@&sys_auto_authenticate=true",string,[NSString stringWithFormat:@"%ld",(long)_pageFlag],[NSString stringWithFormat:@"%@",_token],[NSString stringWithFormat:@"%@",_userId],[NSString stringWithFormat:@"%@" ,_userName],[NSString stringWithFormat:@"%@",_password]];
    
    // 全部消息
    [TYHHttpTool get:requestURL params:nil success:^(id json) {
        
        NSArray * newArray = [NoticeModel mj_objectArrayWithKeyValuesArray:json];
        [self.allMessages addObjectsFromArray:newArray];
        [self.tableView reloadData];
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        [newArray enumerateObjectsUsingBlock:^(NoticeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj.readFlag integerValue]) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:0];
                *stop = YES;
            }
        }];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allMessages.count == 0) {
        
        return 1;
    }
    return self.allMessages.count;
}

// 设置header不悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 15;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.allMessages.count == 0) {
        return self.view.height;
    }
    return 69.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    if (self.allMessages.count == 0) return 0;
    return 0; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.allMessages.count == 0) {
        
        static NSString *noMessageCellid = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f,[UIScreen mainScreen].bounds.size.width / 320 * cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"暂无数据";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    static NSString * noticeCell = @"noticeCell";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCell];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle]loadNibNamed:@"NoticeCell" owner:self options:nil].firstObject;
        
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:noticeCell];
    }
    
    cell.tintColor = [UIColor TabBarColorGreen];
    
    NoticeModel * model = self.allMessages[indexPath.section];
    cell.lineImageView.hidden = YES;
    cell.sendUserLabel.text = model.operationName;
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = model.time;
    
    if (model.appIcon.length) {
        [cell.logImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.appIcon]] placeholderImage:[UIImage imageNamed:@"icon_v3_message"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,model.customIcon];
        //        NSLog(@"==-=-=-=-=%@",urlString);
    }
    if (model.icon.length) {
        NSArray *array = [TYHNoticeIconFontDictionary getIconDic].allValues;
        NSArray *array2 = [TYHNoticeIconFontDictionary getIconDic].allKeys;
        __block NSMutableDictionary *dic= [NSMutableDictionary dictionary];
        [array enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dic setValue:array2[idx] forKey:obj];
        }];
        
        
        NSMutableString *infoString = [dic objectForKey:[NSString stringWithFormat:@"%@",[model.icon componentsSeparatedByString:@"&"][1]]];
        TBCityIconInfo *info = [[TBCityIconInfo alloc]initWithText:infoString size:18 color:[UIColor whiteColor]];
        info.backgroundColor =[UIColor colorWithHexString:[model.icon componentsSeparatedByString:@"&"][0]];
        cell.logImage.image = [UIImage iconWithInfo:info];
        
    }
    
    
    
    
    // 返回类型 @{ @"name":@"通知",
    // no,ne,wc,course,fi,pu,homework,cb
    
    //    [self.appIconArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //        NSString * str = dict[@"code"];
    //        NSString * name = dict[@"name"];
    //
    //        if ([model.kindCode isEqualToString:str]) {
    //
    //            cell.logImage.image = [UIImage imageNamed:dict[@"imageStr"]];
    //            cell.sendUserLabel.text = name;
    //
    //            if ([model.kindCode isEqualToString:@"ar"]) {
    //                cell.checkDetailLabel.text = @"暂无详情";
    //            }
    //        }
    //
    //    }];
    
    
    if ([model.readFlag isEqualToString:@"1"]) {
        cell.readImg.hidden = YES;
    } else if([model.readFlag isEqualToString:@"0"]) {
        cell.readImg.hidden = NO;
    }
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}
- (void)viewDidAppear:(BOOL)animated {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"消息";
    if (kDevice_Is_iPhoneX) {
        _topLayout.constant = 88;
        _bottomLayout.constant = 88;
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor TabBarColorGreen];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.tableView reloadData];
    
    
    [self.allMessages enumerateObjectsUsingBlock:^(NoticeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.readFlag integerValue]) {
            [self.tabBarController.tabBar showBadgeOnItemIndex:0];
            *stop = YES;
        }else [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }];
    
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *Apparray = [[NSMutableArray alloc] init];
    
    if (self.allMessages.count == 0) {
        return;
    }
    // 添加选中的cell到选中的临时数组
    NoticeModel * model = self.allMessages[indexPath.section];
    
    if ([_rightItem.title isEqualToString:@"取消"]) {
        
        [self.chooseArray addObject:indexPath];
        
        if (self.chooseArray.count == self.allMessages.count) {
            self.button.selected = YES;
        }
        
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
    }
    else {
        
        //设置已读
        NSString *string = [NSString stringWithFormat:@"%@/bd/mobile/baseData!setMessageRead.action", BaseURL];
        
        NSString * url = [NSString stringWithFormat:@"%@?id=%@&sys_username=%@&sys_auto_authenticate=true&sys_password=%@&imToken=%@&dataSourceName=%@&userId=%@",string,model.ID,_userName,_password,self.token,_dataSourceName,_userId];
        //        NSLog(@"  setRead ===  %@",url);
        [TYHHttpTool gets:url params:nil success:^(id json) {
            
        } failure:^(NSError *error) {
            
        }];
        
        if ([model.kindCode isEqualToString:@"zmail"] || [model.kindCode isEqualToString:@"no"]) {
            TYHNewDetailViewController *detailViewController = [[TYHNewDetailViewController alloc] initWithNibName:@"TYHNewDetailViewController" bundle:nil];
            detailViewController.isComeFromPushNoticeList = YES;
            model.readFlag = @"1";
            detailViewController.model = nil;
            detailViewController.result = self.result;
            detailViewController.modelID = model.sourceId;
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID];
            detailViewController.userId = userID;
            detailViewController.token = self.token;
            detailViewController.modelArray = _allMessages;
            
            // 删除返回
            detailViewController.returnNameArrayBlock = ^(NSMutableArray * modelArray){
                _allMessages = [NSMutableArray arrayWithArray:modelArray];
                [self.tableView reloadData];
            };
            
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        }
        else
        {
            NSString * appCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFARLT_APPCODE];
            NSArray *codeArray = [appCode componentsSeparatedByString:@","];
            codeArray = [NSMutableArray arrayWithArray:codeArray];
            
            __block BOOL codeWithin = NO;
            
            [codeArray enumerateObjectsUsingBlock:^(NSString *code, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([code isEqualToString:model.kindCode]) {
                    codeWithin = YES;
                }
            }];
            //跳转按钮隐藏
            if (!codeWithin) {
                model.readFlag = @"1";
                CANoticeDetailControllerView *attView = [CANoticeDetailControllerView new];
                attView.titleString = model.title;
                attView.detailString = model.content;
                attView.navTitleString = model.operationName;
                attView.shouldHideRightBar = YES;
                [self.navigationController pushViewController:attView animated:YES];
                return ;
            }
            //跳转按钮显示
            else
            {
                model.readFlag = @"1";
                CANoticeDetailControllerView *attView = [CANoticeDetailControllerView new];
                attView.titleString = model.title;
                attView.detailString = model.content;
                attView.navTitleString = model.operationName;
                attView.shouldHideRightBar = NO;
                attView.model = model;
                [self.navigationController pushViewController:attView animated:YES];
                return ;
            }
            
        }
        
    }
}

#pragma mark ======取消选中的设置
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([_rightItem.title isEqualToString:@"取消"]) {
        
        self.button.selected = NO;
        [self.chooseArray removeObject:indexPath];
        
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(unsigned long)self.chooseArray.count]];
    }
}




//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}


//  sourceID 跟应用进通知的ID一样
#pragma mark ==========   删除的实现
- (IBAction)deleteBtn:(id)sender {
    
    if (self.chooseArray.count > 0) {
        
        int deletCount = 0;
        
        NSMutableArray * idArray = [NSMutableArray array];
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            NoticeModel * model = self.allMessages[indexPath.section];
            
            [self.chooseDic addObject:self.allMessages[indexPath.section]];
            deletCount++;
            //            NSLog(@"model.ID = %@",model.ID);
            if (model.ID.length != 0) {
                
                [idArray addObject:model.ID];
            }
        }
        //  同步更新网络数据
        //        NSLog(@"idArray = %@",idArray);
        NSString  *idStr = [idArray componentsJoinedByString:@","];
        //        NSLog(@"idStr = %@",idStr);
        NSString * strCount = [NSString stringWithFormat:@"是否要移除这%d条通知",deletCount];
        
        NSString *string = [NSString stringWithFormat:@"%@/bd/mobile/baseData!setMessageDelete.action",_IMURL];
        
        NSString * url = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&dataSourceName=%@&userId=%@",string,_userName,_password,idStr,_dataSourceName,_userId];
        //        NSLog(@" setDelete == %@",url);
        
        MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
        self.hub = hub;
        hub.alpha = 0.5;
        self.urlStr = url;
        self.deleteCount = deletCount;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:strCount message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
                [self unEditCell];
            }];
            UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault)  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.view addSubview:hub];
                
                // 删除消息
                [TYHHttpTool gets:url params:nil success:^(id json) {
                    
                    NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
                    
                    if ([data isEqualToString:@"ok"] || [data isEqualToString:@"true"]) {
                        
                        [self.hub removeFromSuperview];
                        NSString * str = [NSString stringWithFormat:@"%d条已移除",deletCount];
                        
                        [self.view makeToast:str duration:1 position:CSToastPositionCenter];
                        
                        // 3. 更新表格
                        [self.allMessages removeObjectsInArray:self.chooseDic];
                        [self.tableView reloadData];
                        
                        [self unEditCell];
                    }
                    
                } failure:^(NSError *error) {
                    
                    [self.hub removeFromSuperview];
                    //                    NSLog(@"%@",[error localizedDescription]);
                }];
                
            }];
            
            [alertVc addAction:cancel];
            [alertVc addAction:confirm];
            
            [self presentViewController:alertVc animated:YES completion:nil];
        }else {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:strCount message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    
    if (buttonIndex == 1){
        
        [self.view addSubview:self.hub];
        
        // 删除消息
        [TYHHttpTool gets:self.urlStr params:nil success:^(id json) {
            
            NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"]) {
                
                [self.hub removeFromSuperview];
                NSString * str = [NSString stringWithFormat:@"%d条已移除",self.deleteCount];
                [self.view makeToast:str duration:1 position:CSToastPositionCenter];
                
                // 3.更新表格
                [self.allMessages removeObjectsInArray:self.chooseDic];
                [self.tableView reloadData];
                
                [self unEditCell];
            }
            
        } failure:^(NSError *error) {
            
            [self.hub removeFromSuperview];
            //            NSLog(@"%@",[error localizedDescription]);
        }];
        
        
    }
    [self unEditCell];
}
@end
