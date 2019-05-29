//
//  WHOutListSearchController.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WHOutListSearchController.h"

#import "WHOutListCell.h"
#import "WHDiliverController.h"
#import "WHOutDetailController.h"
#import "NSString+NTES.h"
#import "WHMyApplicationModel.h"
#import "WHNetHelper.h"

#import "WHOutDetailController.h"
#import <UIView+Toast.h>
#import "WHAddApplicationDiliverController.h"
#import "WHOutResignController.h"
#import "WHOutResignCell.h"
#import "WHOutModel.h"

@interface WHOutListSearchController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation WHOutListSearchController
{
    NSString *searchString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


#pragma mark - DataRequest
-(void)requestDataWithUserName:(NSString *)userName
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在搜索中";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper searchGetOutByUserName:userName andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        self.dataArray = [NSMutableArray arrayWithArray:dataSource];
        if (!dataSource.count) {
            [self.view makeToast:@"未搜索到该用户的数据" duration:1.5 position:CSToastPositionCenter];
        }
        searchString = _textField.text;
        [_mainTableView reloadData];
        _textField.text = searchString;
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [self.view makeToast:@"搜索失败,可能网络问题" duration:1.5 position:CSToastPositionCenter];
        [hud removeFromSuperview];
    }];
    
    
}


#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"出库单";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    
    _isEdited = YES;
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"WHOutResignCell";
    WHOutResignCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHOutResignCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行下载任务，防止主线程卡顿
        cell.model = _dataArray[indexPath.row];
    });
    
    [cell.resignBtn addTarget:self action:@selector(cellBtnClicked:eventCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lookBtn addTarget:self action:@selector(cellBtnClicked:eventLook:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 290)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.placeholder = @"请输入用户名";
    if (_isEdited) {
        [_textField becomeFirstResponder];
    }
    _textField.text = searchString.length?searchString:@"";
    [view addSubview:_textField];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}



#pragma mark - Actions

- (void)cellBtnClicked:(id)sender eventCheck:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableView];
    NSIndexPath *indexPath= [_mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        WHOutResignController *whdView = [WHOutResignController new];
        WHOutModel *model = _dataArray[indexPath.row];
        whdView.outID = model.outID;
        [self.navigationController pushViewController:whdView animated:YES];
    }
}

- (void)cellBtnClicked:(id)sender eventLook:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_mainTableView];
    NSIndexPath *indexPath= [_mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        WHOutDetailController *dView = [WHOutDetailController new];
        dView.outID = [_dataArray[indexPath.row] outID];
        [self.navigationController pushViewController:dView animated:YES];
    }
}


-(void)addAction:(id)sender
{
    if ([NSString isBlankString:_textField.text]) {
        [_textField resignFirstResponder];
        [self.view makeToast:@"请输入搜索关键字" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    [self.view endEditing:YES];
    
    if (_textField.text.length > 0) {
//        NSString *keyWord = [_textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self requestDataWithUserName:_textField.text];
        [_textField resignFirstResponder];
        _isEdited = NO;
    }
    else
    {
        [_textField resignFirstResponder];
        _isEdited = NO;
        [self.view makeToast:@"请输入搜索关键字" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - Other
-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    
    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(addAction:)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
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
