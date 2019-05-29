
//  TYHNewNoticeViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/28.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "TYHNewNoticeViewController.h"
#import "TYHTittleViewController.h"
#import "TYHNewDetailViewController.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "DropDownMenu.h"
#import "UIView+Extention.h"
#import "UIBarButtonItem+Extention.h"
#import "TitleButton.h"
#import "NoticeModel.h"
#import <UIView+Toast.h>
#import <MBProgressHUD.h>
#import "NewNoticeCell.h"
#import "SingleManager.h"
#import "TYHNewSendViewController.h"

@interface TYHNewNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,DropDownMenuDelegate,TitleMenuDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * tempArray;
@property (nonatomic, strong) NSMutableArray * allMessages;
@property (nonatomic, strong) NSMutableArray * chooseArray;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, assign) NSInteger pageFlag;
@property (nonatomic, strong) UIBarButtonItem * leftItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *SendNoticeBtn;
- (IBAction)sendNoticeBtn:(id)sender;

@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) NewNoticeCell * cell ;

@property (nonatomic, strong) NoticeModel * model;
@property (nonatomic, strong) TitleButton * titleButton;
@property (nonatomic, copy) NSString * eachString;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, copy) NSString * titleNew;
@property (nonatomic, strong) NSMutableArray * chooseDic;
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, copy) NSString * result;

@property (nonatomic, copy) NSString * unReadCount;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, assign) NSInteger deleteCount;

@property (nonatomic, strong) DropDownMenu * drop;
@property(nonatomic,copy)NSString *dataSourceName;
@end

@implementation TYHNewNoticeViewController


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
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    _organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    _userName = [NSString stringWithFormat:@"%@",tempUserName];
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
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
    [self setUpNavigationBar];
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    // 创建tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing =YES;
    
    //  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewNoticeCell" bundle:nil]  forCellReuseIdentifier:@"newnoticeCell"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    //  初始化开始的全部数据源
    self.eachString = [NSString stringWithFormat:@"%@/no/noticeMobile!getAllNoticeList.action",BaseURL];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGR];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //  判断 是否有发通知权限
    NSString * urlStr = [NSString stringWithFormat:@"%@/bd/mobile/baseData!ifNewNoticeGranted.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",BaseURL,_userName,_password,_userId,self.token,_dataSourceName];
//    NSLog(@"urlStr = %@",urlStr);
    [TYHHttpTool gets:urlStr params:nil success:^(id json) {
        
        //        NSLog(@"%@ === %@",json,[json class]);
        NSString * result = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if([result isEqualToString:@"1"]) {
            
            self.SendNoticeBtn.hidden = NO;
            
        } else {
            self.SendNoticeBtn.hidden = YES;
        }
        
        self.result = result;
    } failure:^(NSError *error) {
        
    }];

}
- (void)setUpNavigationBar{
    
    // 返回Item
    [self creatLeftItem];
    // 创建EditItem
    [self creatRightItem];
    // 定义titleView
    [self creatTitleView];
}
- (void)getAllUnreadCount {
    
    NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!getUnReadNoticeCount.action",BaseURL];
    //   未读消息总数
    NSString * url = [NSString stringWithFormat:@"%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,_userId,self.token,_dataSourceName];
//    NSLog(@"%@",url);
    
    [TYHHttpTool gets:url params:nil success:^(id json) {
        
//        NSLog(@"%@ === %@",json,[json class]);
        self.unReadCount = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
    } failure:^(NSError *error) {
        
    }];
}
// 触发长按手势
-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self editCell];
        
        CGPoint point = [gesture locationInView:_tableView];
        
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:point];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        
        NoticeModel * model = self.allMessages[indexPath.row];
        
        if ([_rightItem.title isEqualToString:@"取消"]) {
            // 1 是 关注 hidden 是 NO;  0 是未关注 hidden 是 YES;
            if (!model.attentionFlag) {
                [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            }
            else {
                [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            }
        }
        
        [self.chooseArray addObject:indexPath];
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
    }
}
#pragma mark   -------  定义EditItem
- (void)creatRightItem {
    
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editCell)];
    _rightItem.tintColor = [UIColor whiteColor];
    NSUInteger size = 13;
    UIFont * font = [UIFont boldSystemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [_rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

#pragma mark  =========    点击编辑的一些状态变化
- (void)editCell{
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"] || [_rightItem.title isEqualToString:@"编辑"]) {
        
        if (self.allMessages != nil && ![self.allMessages isKindOfClass:[NSNull class]] && self.allMessages.count != 0) {
            
            [self.SendNoticeBtn setHidden:YES];
            
            [self.tableView setEditing:YES animated:YES];
            
            _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(unEditCell)];
            _rightItem.tintColor = [UIColor whiteColor];
            NSUInteger size = 13;
            UIFont * font = [UIFont boldSystemFontOfSize:size];
            NSDictionary * attributes = @{NSFontAttributeName: font};
            [_rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = _rightItem;
            self.navigationItem.titleView = nil;
            self.navigationItem.title = @"多选";
            self.attentionBtn.hidden = NO;
            self.deleteBtn.hidden = NO;
            [self creatLeftItem];
        }
        else {
            [self.tableView setEditing:NO animated:YES];
            [self.view makeToast:@"暂无数据无法编辑" duration:2 position:nil];
        }
    }
}

#pragma mark   =====  取消编辑恢复原来状态
- (void)unEditCell{
    
    [self.tableView setEditing:NO animated:YES];
    [self creatRightItem];
    
    //  不需要每次都alloc 创建  直接赋值就行
    self.navigationItem.titleView = _titleButton;
    
    [self creatLeftItem];
    self.attentionBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    
    
    if ([self.result isEqualToString:@"1"]) {
        
        self.SendNoticeBtn.hidden = NO;
    } else {
        [self.SendNoticeBtn setHidden:YES];
    }
    a = 0;
    b = 0;
    [self.chooseArray removeAllObjects];
}

#pragma mark   -------  定义titleView下拉菜单
- (void)creatTitleView {
    
    _titleButton = [[TitleButton alloc] init];
    _titleButton.titleTypeByV3App = @"notice";
    
    NSString * name = self.aNewTitle?self.aNewTitle:@"收件箱";
    [_titleButton setTitle:name forState:UIControlStateNormal];
    
    
    // 监听标题点击
    [_titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
}

#pragma mark   ======  titleView的菜单设置
- (void)titleClick:(UIButton *)btn{
    
    [self getAllUnreadCount];
    
    // 创建下拉菜单
    DropDownMenu *drop = [[DropDownMenu alloc] init];
    self.drop = drop;
    // 设置下拉菜单弹出、销毁事件的监听者
    drop.delegate = self;
    
    // 2.设置要显示的内容
    TYHTittleViewController *titleMenuVC = [[TYHTittleViewController alloc] init];
    titleMenuVC.drop = drop;
    titleMenuVC.delegate = self;
    
    int a = [_unReadCount intValue];
//    NSLog(@"bbbbbbbb=== %d",a);
    titleMenuVC.count = a;
    titleMenuVC.index = _index;
    titleMenuVC.view.height = 44*4;
    titleMenuVC.view.width = self.view.frame.size.width;
    
    drop.contentController = titleMenuVC;
    
    // 显示
    [drop showFrom:btn];
}

#pragma mark   -------  定义返回按钮
- (void)creatLeftItem {
    
    if ([_rightItem.title isEqualToString:@"取消"]) {
        
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"已选择0" style:UIBarButtonItemStyleBordered target:self action:nil];
        _leftItem.tintColor = [UIColor whiteColor];
        
        
        NSUInteger size = 13;
        UIFont * font = [UIFont boldSystemFontOfSize:size];
        NSDictionary * attributes = @{NSFontAttributeName: font};
        [_leftItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        UIBarButtonItem * leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(selectAll:) image:@"全选01" highImage:@"全选02"];
        
        self.navigationItem.leftBarButtonItems = @[leftBtn,_leftItem];
        
    } else {
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            _leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        } else {
            _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        }
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = _leftItem;
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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.chooseArray addObject:indexPath];
                
                // 这是标记选中cell 的方法
                if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
                    
                    NoticeModel * model = self.allMessages[indexPath.row];
                    
                    if (model.attentionFlag) {
                        
                        [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                        [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    }
                    else {
                        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                        [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                        
                    }
                    
                        if ([self.titleNew isEqualToString:@"关注"]) {
                            [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                            [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                        }
                    
                }
                [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
            }
            self.button.selected = !self.button.selected;
            
        }
    }
    else {
        
        [self.chooseArray removeAllObjects];
        
        for (int i=0; i<self.allMessages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
                
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
            
            [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
        }
        self.button.selected = !self.button.selected;
        
    }
}
- (void)returnClicked {
    
    if (self.drop) {
        [self.drop dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.drop) {
        [self.drop dismiss];
    }
}
#pragma mark - DropdownMenuDelegate
//下拉菜单被销毁了
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

//下拉菜单显示了
- (void)dropdownMenuDidShow:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}
#pragma mark - TitleMenuDelegate
-(void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title
{
//    NSLog(@"indexPath = %ld", (long)indexPath.row);
//    NSLog(@"当前选择了%@", title);
    self.titleNew = title;
    
    _index = indexPath.row;
    
    // 修改导航栏的标题
    [_titleButton setTitle:title forState:UIControlStateNormal];
    if ([self.titleNew isEqualToString:@"收件箱"]) {
        
        self.eachString = [NSString stringWithFormat:@"%@/no/noticeMobile!getAllNoticeList.action",BaseURL];
        
        [self getNotiveData:self.eachString];
        
    } else if ([self.titleNew isEqualToString:@"未读"]) {
        NSString * unreadStr = [NSString stringWithFormat:@"%@/no/noticeMobile!getUnReadNoticeList.action",BaseURL];
        
        [self getNotiveData:unreadStr];
        self.eachString = unreadStr;
        
    } else if ([self.titleNew isEqualToString:@"关注"]) {
        NSString * attentionStr = [NSString stringWithFormat:@"%@/no/noticeMobile!getAttentionNoticeList.action", BaseURL];
        
        [self getNotiveData:attentionStr];
        self.eachString = attentionStr;
    } else {
    
        NSString * sendStr = [NSString stringWithFormat:@"%@/no/noticeMobile!getSendNoticeList.action", BaseURL];
        
        [self getNotiveData:sendStr];
        self.eachString = sendStr;
    }
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
    params[@"imToken"] = [NSString stringWithFormat:@"%@",self.token];
    [TYHHttpTool get:self.eachString params:params success:^(id json) {
        
        NSArray * newArray = [NoticeModel mj_objectArrayWithKeyValuesArray:json];
        
        [self.allMessages addObjectsFromArray:newArray];
        
        [self.tableView reloadData];
        
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark   -------  获取所有通知
- (void)getNotiveData:(NSString *)string {
    
    [self.allMessages removeAllObjects];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,_userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",_password];
    params[@"dataSourceName"] = _dataSourceName;
    params[@"userId"] = [NSString stringWithFormat:@"%@",_userId];
    _pageFlag = 1;
    params[@"pageFlag"] = [NSString stringWithFormat:@"%ld",(long)_pageFlag];
    params[@"imToken"] = [NSString stringWithFormat:@"%@",self.token];
    NSString * url = [NSString stringWithFormat:@"%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&pageFlag=%ld&imToken=%@&dataSourceName=%@",string,_userName,_password,_userId,(long)_pageFlag,self.token,_dataSourceName];
//    NSLog(@"%@",url);
    // 全部消息
    [TYHHttpTool get:url params:nil success:^(id json) {
        
        NSArray * newArray = [NoticeModel mj_objectArrayWithKeyValuesArray:json];
        [self.allMessages addObjectsFromArray:newArray];
        
//        NSLog(@"json22222 = %@",json);
        
        [self.tableView reloadData];
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.allMessages.count == 0) {
        return 1;
    }
//    NSLog(@"%ld",(long)self.allMessages.count);
    return self.allMessages.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.allMessages.count == 0) {
        return self.view.height;
    }
    return 80.0f;
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
    
    static NSString * noticeCell = @"newnoticeCell";
    NewNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCell];
    if (cell == nil) {
        cell = [[NewNoticeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:noticeCell];
    }
    
    cell.tintColor = [UIColor TabBarColorYellow];
    
    NoticeModel * model = self.allMessages[indexPath.row];
    
    cell.contentLabel.text = model.content;
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = model.time;
    
    // 2 是已读 0 未读
    if ([model.readFlag isEqualToString:@"2"]) {
       
        cell.readImg.hidden = YES;
   
    } else if([model.readFlag isEqualToString:@"0"]) {
        cell.readImg.hidden = NO;
    }
    if ([self.titleNew isEqualToString:@"发件箱"]) {
        cell.readImg.hidden = YES;
    }
    
    if (model.attentionFlag) {
        
        cell.attentionImage.hidden = NO;
    } else {
        cell.attentionImage.hidden = YES;
    }
    
    if (model.attachmentFlag != nil && ![model.attachmentFlag isKindOfClass:[NSNull class]] && model.attachmentFlag.count != 0) {
        
        if ([self.titleNew isEqualToString:@"发件箱"]) {
            
            NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:@"我"];
            NSTextAttachment * attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"附件01"];
            attch.bounds = CGRectMake(3, 5, 13, 13);
            
            NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri appendAttributedString:string];
            cell.sendUserLabel.text = @"我";
            
        } else {
            
            NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:model.sendUser];
            NSTextAttachment * attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"附件01"];
            attch.bounds = CGRectMake(3, 5, 13, 13);
            
            
            NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri appendAttributedString:string];
            cell.sendUserLabel.attributedText = attri;
        }
        
    }else {
        
        if ([self.titleNew isEqualToString:@"发件箱"]) {
            cell.sendUserLabel.text = @"我";
        } else {
            
            cell.sendUserLabel.text = model.sendUser;
        }
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
    self.navigationController.navigationBar.barTintColor = [UIColor TabBarColorYellow];
    self.attentionBtn.backgroundColor = [UIColor TabBarColorYellow];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    //translucent 临时注释
    [self getAllUnreadCount];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self.titleNew isEqualToString:@"未读"]) {

        for (int i=0; i<self.allMessages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];

            NoticeModel * model = self.allMessages[indexPath.row];
            if ([model.readFlag isEqualToString:@"2"]) {

                [self.allMessages removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.allMessages.count == 0)return;
    // 添加选中的cell到选中的临时数组
    NoticeModel * model = self.allMessages[indexPath.row];
    
    if ([_rightItem.title isEqualToString:@"取消"]) {
        
        [self.chooseArray addObject:indexPath];
        
        if (self.chooseArray.count == self.allMessages.count) {
            self.button.selected = YES;
        }
        for (NSIndexPath * index in self.chooseArray) {
            // 1 是 关注 hidden 是 NO;  0 是未关注 hidden 是 YES;
            
            NoticeModel * indexModel = self.allMessages[index.row];
            
            if (self.chooseArray.count < 2) {
                if (indexModel.attentionFlag) {
                    [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                } else {
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                }
            }
            else {
                if (!indexModel.attentionFlag) {
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                }
            }
            
        }
        
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(long)self.chooseArray.count]];
    }
    else {
        model.readFlag = @"2";
        TYHNewDetailViewController *detailViewController = [[TYHNewDetailViewController alloc] initWithNibName:@"TYHNewDetailViewController" bundle:nil];
        
        // Pass the selected object to the new view controller.
        NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!setNoticeRead.action",BaseURL];
        
        NSString * url = [NSString stringWithFormat:@"%@?userId=%@&id=%@&sys_username=%@&sys_auto_authenticate=true&sys_password=%@&imToken=%@&dataSourceName=%@",string,_userId,model.ID,_userName,_password,self.token,_dataSourceName];
//        NSLog(@"url == %@",url);
        // 全部消息
        [TYHHttpTool gets:url params:nil success:^(id json) {
//            NSLog(@"json3 == %@",json);
        } failure:^(NSError *error) {
//             NSLog(@"error3 == %@",error);
        }];
        
        detailViewController.model = model;
        if ([self.titleNew isEqualToString:@"发件箱"]) {
        
            detailViewController.model.sendUser = @"我";
        }
        detailViewController.result = self.result;
        detailViewController.userId = _userId;
        detailViewController.modelID = model.ID;
        detailViewController.modelArray = _allMessages;

        // 删除返回
        detailViewController.returnNameArrayBlock = ^(NSMutableArray * modelArray){
            
            _allMessages = [NSMutableArray arrayWithArray:modelArray];
            [self.tableView reloadData];
        };
        // 关注返回
        detailViewController.atttentionFlag = ^(BOOL atttentionFlag) {
            
            model.attentionFlag = atttentionFlag;
            if ([self.titleNew isEqualToString:@"关注"]) {
                 //   关注页面进入 若取消关注也需要移除
                if (atttentionFlag == NO) {
                    [_allMessages removeObjectAtIndex:indexPath.row];
                }
            }
            [self.tableView reloadData];
        };
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark ======取消选中的设置
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_rightItem.title isEqualToString:@"取消"]) {
        
        self.button.selected = NO;
        [self.chooseArray removeObject:indexPath];
        
        for (NSIndexPath * index in self.chooseArray) {
            // 1 是 关注 hidden 是 NO;  0 是未关注 hidden 是 YES;
            NoticeModel * indexModel = self.allMessages[index.row];
            if (self.chooseArray.count < 2) {
                if (indexModel.attentionFlag) {
                    [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                } else {
                    
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                }
            }
            else {
                if (indexModel.attentionFlag) {
                    [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                }
                else {
                    
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                }
            }
        }
        [_leftItem setTitle:[NSString stringWithFormat:@"已选择%ld",(unsigned long)self.chooseArray.count]];
    }
}

#pragma mark ======= 关注和取消关注的实现
- (IBAction)attentionBtn:(id)sender {
    
    if (self.chooseArray.count > 0) {
        
        for (NSIndexPath * indexPath in self.chooseArray ) {
            
            NoticeModel * model = self.allMessages[indexPath.row];
            
            if (model.attentionFlag) {
                
                if ([self.titleNew isEqualToString:@"关注"]) {
                    
                    [self.chooseDic addObject:self.allMessages[indexPath.row]];
                    
                }
                a ++ ;
            }  else {
                
                b ++;
            }
        }
        
        MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
        hub.alpha = 0.5;
        [self.view addSubview:hub];
        
        
        for (NSIndexPath * indexPath in self.chooseArray ) {
            
            NoticeModel * model = self.allMessages[indexPath.row];
            
            if (model.attentionFlag && b == 0) {
                
                model.attentionFlag = NO;
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:(UITableViewRowAnimationNone)];
                
                NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!ajaxLightoff.action",BaseURL];
                
                NSString * url = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,model.ID,self.token,_dataSourceName];
                // 取消关注
                
                NSString * str = [NSString stringWithFormat:@"%d条已取消关注",a];
                [TYHHttpTool gets:url params:nil success:^(id json) {
                    
                    NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
                    if ([data isEqualToString:@"ok"]) {
                        [hub removeFromSuperview];
                        [self.view makeToast:str duration:1 position:nil];
                    }
                    
                } failure:^(NSError *error) {
                    
//                    NSLog(@"error === %@",[error localizedDescription]);
                }];
                
            } else {
                
                model.attentionFlag = YES;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:(UITableViewRowAnimationAutomatic)];
                
                //  同步更新网络数据
                NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!ajaxLighton.action",BaseURL];
                
                NSString * url = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,model.ID,self.token,_dataSourceName];
                
                // 关注消息
                NSString * str = [NSString stringWithFormat:@"%d条已关注",b];
                [TYHHttpTool gets:url params:nil success:^(id json) {
                    NSString * data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
                    if ([data isEqualToString:@"ok"]) {
                    
                        [hub removeFromSuperview];
                        [self.view makeToast:str duration:1 position:nil];
                    }
                } failure:^(NSError *error) {
//                    NSLog(@"error === %@",error);
                }];
                
            }
        }
        
        if ([self.titleNew isEqualToString:@"关注"]) {
            // 3. 更新表格
            [self.allMessages removeObjectsInArray:self.chooseDic];
        }
        [self.tableView reloadData];
    }
    [self unEditCell];
}

#pragma mark ==========   删除的实现
- (IBAction)deleteBtn:(id)sender {
    
    if (self.chooseArray.count > 0) {
        
        int deletCount = 0;
        
        NSMutableArray * idArray = [NSMutableArray array];
        for (NSIndexPath * indexPath in self.chooseArray) {
            
            NoticeModel * model = self.allMessages[indexPath.row];
            
            [self.chooseDic addObject:self.allMessages[indexPath.row]];
            deletCount++;
            if (model.ID.length != 0) {
                
                [idArray addObject:model.ID];
            }
        }
        //  同步更新网络数据
        NSString  *idStr = [idArray componentsJoinedByString:@","];
        NSString * strCount = [NSString stringWithFormat:@"是否要移除这%d条通知",deletCount];
        NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!setNoticeDelete.action",BaseURL];
        
        NSString * url = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,idStr,self.token,_dataSourceName];
        self.urlStr = url;
        self.deleteCount = deletCount;
        
//        NSLog(@"url33333 == %@",url);
        MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
        self.hub = hub;
        hub.alpha = 0.5;
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
                    
                    if ([data isEqualToString:@"ok"]) {
                        
                        [self.hub removeFromSuperview];
                        
                        NSString * str = [NSString stringWithFormat:@"%d条已移除",deletCount];
                        
                        [self.view makeToast:str duration:1 position:nil];
                        [self getAllUnreadCount];
                        // 3. 更新表格
                        [self.allMessages removeObjectsInArray:self.chooseDic];
                        [self.tableView reloadData];
                        
                        [self unEditCell];
                    }
                } failure:^(NSError *error) {
                    
                    [self.hub removeFromSuperview];
                    
//                    NSLog(@"error  === %@",[error localizedDescription]);
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
                
                NSString * str = [NSString stringWithFormat:@"%ld条已移除",self.deleteCount];
                
                [self.view makeToast:str duration:1 position:nil];
                [self getAllUnreadCount];
                // 3. 更新表格
                [self.allMessages removeObjectsInArray:self.chooseDic];
                [self.tableView reloadData];
                
                [self unEditCell];
            }
        } failure:^(NSError *error) {
            
            [self.hub removeFromSuperview];
//            NSLog(@"error  === %@",[error localizedDescription]);
        }];

    }
    [self unEditCell];
}


- (IBAction)sendNoticeBtn:(id)sender {
    
    TYHNewSendViewController * sendVc = [[TYHNewSendViewController alloc] init];
    
    [self.navigationController pushViewController:sendVc animated:YES];
    
}
@end
