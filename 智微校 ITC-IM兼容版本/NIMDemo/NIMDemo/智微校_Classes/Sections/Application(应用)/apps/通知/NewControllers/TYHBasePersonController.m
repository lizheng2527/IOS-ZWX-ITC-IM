//
//  TYHBasePersonController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/6.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHBasePersonController.h"
#import "ContactModelListHelper.h"
#import "ContactModel.h"
#import "SessionViewCell.h"
#import <UIImageView+WebCache.h>
#import "TYHContactCell.h"
#import "InviteJoinListViewCell.h"
#import <UIView+Toast.h>
#import "TYHContactDetailCell.h"
#import "TYHNewSendViewController.h"


#define HeadBtnWidth 55
#define HeadBtnHeight 70
#define WIDTH ([UIScreen mainScreen].bounds.size.width / 320 )
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface TYHBasePersonController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel * lable2;

@property (nonatomic, strong) UIBarButtonItem * btnItem;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) NSArray * resultsData;

@property (nonatomic, strong) NSMutableArray * resultsArray;

@property (nonatomic, strong) NSMutableArray * resultsModelArray;

@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;

@end

@implementation TYHBasePersonController
{
    BOOL isAlreadyInserted;
}

- (NSMutableArray *)tempArray {
    
    if (_tempArray == nil) {
        self.tempArray = [NSMutableArray  arrayWithArray:_modelArray];
    }
    return _tempArray;
}

- (NSArray *)resultsData {
    
    if (_resultsData == nil) {
        self.resultsData = [[NSArray alloc] init];
    }
    return _resultsData;
}

- (NSMutableArray *)selectArray {
    
    if (_selectArray) {
        self.selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
- (NSMutableArray *)showTableView {
    
    if (_showTableView == nil) {
        _showTableView = [[NSMutableArray alloc] init];
    }
    return _showTableView;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelFont = [UIFont systemFontOfSize:12];
    HUD.labelText = @"获取数据中";
    self.HUD = HUD;
    
//    _groupTableView.contentInset = UIEdgeInsetsZero;
//    _groupTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    self.navigationController.navigationBar.translucent = NO;
}



//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBar.translucent = YES;
//}


- (void)creatLeftItem {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedArray = [NSMutableArray arrayWithArray:_chooseArray];
//    NSLog(@"111 chooseArray = %@",_chooseArray);
//    NSLog(@"111 selectedArray = %@",_selectedArray);
    
    self.setArray = [NSSet setWithArray:_selectedArray];
//    [self creatLeftItem];
    
    [self creatTableView];
    
    isAlreadyInserted = NO;
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    ContactModelListHelper *myHelper = [[ContactModelListHelper alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * strUrl = [NSString stringWithFormat:@"%@%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",BaseURL,_urlStr,_userName,_password,_userId,self.token,dataSourceName];
        
        [myHelper getContactCompletionNoticeContact:strUrl block:^(BOOL Successful, NSMutableArray *myArray) {
            
            if (Successful) {
                
                _groupArray = [NSMutableArray arrayWithArray:myArray];
                
//                NSLog(@"_groupArray = %@",_groupArray);
                
                // 模型name数组
                _resultsData = [NSMutableArray arrayWithArray:myHelper.nameSource];
                
                _resultsModelArray = [NSMutableArray arrayWithArray:myHelper.dataSource];
                
                _resultsArray = [NSMutableArray array];
                
//                NSLog(@"_resultsData %@",_resultsData);
                [self.groupTableView reloadData];
                
                [self.HUD removeFromSuperview];
            }
            
        }];
        
    });
    
    
    [_showTableView addObject:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ID]];
    
    
    [self setRightItem];
    
    [self initMysearchBarAndMysearchDisPlay];
}
- (void)setRightItem {
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(self.view.frame.size.width - 44, 0, 50, 40);
    button.backgroundColor = [UIColor TabBarColorGreen];
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    lable1.font = [UIFont systemFontOfSize:12];
    lable1.textColor = [UIColor whiteColor];
    lable1.text = @"确定";
    lable1.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable1];
    UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 50, 20)];
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [UIColor whiteColor];
    if (_setArray == nil) {
        
        lable2.text = @"0";
    } else {
        
        lable2.text = [NSString stringWithFormat:@"%d",(int)_setArray.count];
    }
    lable2.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable2];
    
    self.lable2 = lable2;
    
    [button addTarget:self action:@selector(backChoosePerson) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * butItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.btnItem = butItem;
    
    self.navigationItem.rightBarButtonItem = self.btnItem;
}


- (void)returnClicked {
    
    self.returnTextArrayBlock(self.selectedArray);
    
    self.returnUserModelBlock(self.modelArray);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)backChoosePerson {
    
    TYHNewSendViewController * sendVc = [[TYHNewSendViewController alloc] init];
    
    sendVc.modelArray =  self.modelArray;
    
//    NSLog(@" sendVc.modelArray  == %@",sendVc.modelArray);
    
    [self.navigationController pushViewController:sendVc animated:YES];
    
}
//  初始化tableview
- (void)creatTableView {
    
    _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH * 320,HEIGHT - 64)];
    
    _groupTableView.dataSource = self;
    _groupTableView.delegate = self;
    _groupTableView.bounces = NO;
    
    [self.view addSubview:_groupTableView];
    
    [_groupTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

// 初始化 搜索框
-(void)initMysearchBarAndMysearchDisPlay
{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,WIDTH * 320 ,40)];
    _mySearchBar.delegate = self;
    _mySearchBar.placeholder = @"姓名";
    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.groupTableView.tableHeaderView = _mySearchBar;
    
    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    _mySearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _mySearchDisplayController.searchResultsTableView.tableHeaderView= [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [_resultsArray removeAllObjects];
    
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    NSMutableArray *tempResults = [NSMutableArray array];
    for (int i = 0; i < _resultsData.count; i++) {
        NSString *storeString = _resultsData[i];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:storeString];
        }
    }
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObjectsFromArray:tempResults];
    
    _resultsArray =  [NSMutableArray arrayWithArray:[[NSSet setWithArray:arry] allObjects]];
    
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]  objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    
    return YES;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _mySearchBar.showsCancelButton = YES;
    NSArray *subViews;
    
    if (is_IOS_7) {
        subViews = [(_mySearchBar.subviews[0]) subviews];
    }
    else {
        subViews = _mySearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == _mySearchDisplayController.searchResultsTableView){
        return _resultsArray.count;
    }else {
        
        if (_groupArray.count >0 && _groupArray) {
            return _groupArray.count;
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        return  50;
    }
    else if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]])
    {
        return 50;
    }
    else if([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]])
    {
        return 50;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        
        //        if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
        
        static NSString *myCell = @"InviteJoinListViewCellidentifier";
        
        InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
        
        if (cell == nil) {
            
            cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClickeGroups:)];
            cell.contentView.userInteractionEnabled = YES;
            [cell.contentView addGestureRecognizer:tap];
        }
        
        for (UserModel * model in _resultsModelArray) {
            
            if ([model.name isEqualToString:_resultsArray[indexPath.row]]) {
                
                cell.selecImage.frame = CGRectMake(self.view.frame.size.width - 50, 15.0f, 22.25f, 22.25f);
                
                cell.portraitImg.image = [self dealImageWIthVoipAccount:model.voipAccount];
                
                cell.portraitImg.layer.masksToBounds = YES;
                cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
                cell.nameLabel.text = model.name;
                cell.selecImage.tag = indexPath.row+1000000;
                
                if ([_selectedArray containsObject:model.strId]  || [_showTableView containsObject:model.strId]) {
                    cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
                }
                else{
                    
                    cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
                }
            }
        }
        
        return cell;
        //        }
        
    }else {
        
        
        NSInteger indentationLevel = 0;
        if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
            static NSString *iden = @"TYHContactCell";
            TYHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactCell" owner:self options:nil].firstObject;
                indentationLevel = cell.indentationLevel;
            }
            ContactModel *model = [self.groupArray objectAtIndex:indexPath.row];
            if (isAlreadyInserted) {
                cell.icon.image = [UIImage imageNamed:@"展开"];
            } else{
                cell.icon.image = [UIImage imageNamed:@"未展开"];
            }
            cell.titleLabel.text = model.name;
            return cell;
        }
        else if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
            
            static NSString *contactlistcellid = @"InviteJoinListViewCellidentifier";
            InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
            if (cell == nil) {
                cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClickeGroup:)];
                cell.contentView.userInteractionEnabled = YES;
                [cell.contentView addGestureRecognizer:tap];
            }
            UserModel *model = [self.groupArray objectAtIndex:indexPath.row];
            
            cell.selecImage.frame = CGRectMake(self.view.frame.size.width - 50, 15.0f, 22.25f, 22.25f);
            cell.portraitImg.image = [self dealImageWIthVoipAccount:model.voipAccount];
            
            cell.portraitImg.layer.masksToBounds = YES;
            cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
            cell.nameLabel.text =model.name;
            cell.selecImage.tag =indexPath.row+1000;
            if ([_selectedArray containsObject:model.strId]  || [_showTableView containsObject:model.strId]) {
                cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
            }
            else{
                
                cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
            }
            return cell;
        }
    }
    return nil;
}

- (void)cellSelectBtnClickeGroups:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:_mySearchDisplayController.searchResultsTableView];
    
    NSIndexPath * indexPath = [_mySearchDisplayController.searchResultsTableView indexPathForRowAtPoint:point];
    
    NSLog(@"indexPath.row = %ld",indexPath.row);
    
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000000) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    for (UserModel * model in _resultsModelArray) {
        
        if ([model.name isEqualToString:_resultsArray[indexPath.row]]) {
            
            NSString * voipSrting = model.strId;
            NSLog(@"_showTableView1111 == %@",_showTableView);
            
            NSLog(@"voipSrting11111   == %@",voipSrting);
            if ( [_showTableView containsObject:model.strId]) {
                selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
            } else{
                if ([_selectedArray containsObject:voipSrting]) {
                    
                    selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
                    [_selectedArray removeObject:voipSrting];
                    
                    if (self.tempArray.count != 0) {
                        
                        
                        [self.tempArray enumerateObjectsUsingBlock:^(UserModel *models, NSUInteger idx, BOOL *stop) {
                            
                            if ([models.strId isEqualToString:voipSrting]) {
                                *stop = YES;
                                [self.tempArray removeObject:models];
                            }
                        }];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
                    
                    self.setArray = [NSSet setWithArray:self.selectedArray];
                } else {
                    selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
                    [_selectedArray addObject:voipSrting];
                    
                    [self.tempArray addObject:model];
                    
                    self.setArray = [NSSet setWithArray:self.selectedArray];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
                }
                self.modelArray = self.tempArray;
            }
            
            
            NSLog(@"_selectedArray 111 == %@",_selectedArray);
            [_mySearchDisplayController.searchResultsTableView reloadData];
        }
    }
    
    [self.groupTableView reloadData];
    
    [self setRightItem];
    
}

- (void)cellSelectBtnClickeGroup:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:_groupTableView];
    NSIndexPath * indexPath = [_groupTableView indexPathForRowAtPoint:point];
    
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    if([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
        
        UserModel *model = [self.groupArray objectAtIndex:indexPath.row];
        NSString *voipSrting = model.strId;
        
        NSLog(@"model.voipAccount == %@",model.strId);
        if ( [_showTableView containsObject:model.strId]) {
            selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
            [self.view makeToast:@"" duration:0.8 position:nil];
        }
        else{
            
            if ([_selectedArray containsObject:voipSrting] ) {
                selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
                [_selectedArray removeObject:voipSrting];
                
                
                if (self.tempArray.count != 0) {
                    
                    
                    [self.tempArray enumerateObjectsUsingBlock:^(UserModel *models, NSUInteger idx, BOOL *stop) {
                        
                        if ([models.strId isEqualToString:voipSrting]) {
                            *stop = YES;
                            [self.tempArray removeObject:models];
                        }
                    }];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
                
                self.setArray = [NSSet setWithArray:self.selectedArray];
            }
            else{
                
                selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
                [_selectedArray addObject:voipSrting];
                
                [self.tempArray addObject:model];
                
                
                self.setArray = [NSSet setWithArray:self.selectedArray];
                
                [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
            }
            
            self.modelArray = self.tempArray;
            
        }
        
        [_groupTableView reloadData];
        
        [self setRightItem];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *voipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ID];
    if (tableView == _mySearchDisplayController.searchResultsTableView)
    {
        //        NSArray *array = [[NSSet setWithArray:_modelArray]allObjects];
        //        for (UserModel *model in array) {
        //            if ([model.name isEqualToString:_resultsData[indexPath.row]]) {
        //
        //
        //            }
        //        }
    } else {
        
        UserModel *usermodel = [self.groupArray objectAtIndex:indexPath.row];
        if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]) {
            TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([voipAccount isEqualToString:usermodel.strId]) {
                return;
            }
            if (self.isSelect) {
                for (NSString *user in self.selectedArray) {
                    if ([user isEqualToString:usermodel.strId]) {
                        [self.selectedArray removeObject:usermodel.strId];
                        cell.userIcon.image = [UIImage imageNamed:@"未选中"];
                        return;
                    }
                }
                [self.selectedArray addObject:usermodel.voipAccount];
                cell.userIcon.image = [UIImage imageNamed:@"选中"];
                return;
            }
        }
        
        TYHContactCell *cell = (TYHContactCell *)[tableView cellForRowAtIndexPath:indexPath];
        ContactModel *model = [self.groupArray objectAtIndex:indexPath.row];
        
        
        if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[InviteJoinListViewCell class]]) {
            return;
        }
        else {
            if (model.childs && model.childs.count > 0) {
               
                for (ContactModel *contactModel in model.childs) {
                    NSInteger index = [self.groupArray indexOfObjectIdenticalTo:contactModel];
                    isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                    if(isAlreadyInserted) break;
                }
                
                if (isAlreadyInserted) {
                    cell.icon.image = [UIImage imageNamed:@"未展开"];
                    [self miniMizeThisRowsGroup:model.childs];
                }else{
                    cell.icon.image = [UIImage imageNamed:@"展开"];
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
                    for(ContactModel *dInner in model.childs ) {
                        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [self.groupArray insertObject:dInner atIndex:count++];
                    }
                    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            if (model.userList && model.userList.count) {
//                BOOL isAlreadyInserted = NO;
                for (UserModel *userModel in model.userList) {
                    NSInteger index = [self.groupArray indexOfObjectIdenticalTo:userModel];
                    isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                    if(isAlreadyInserted) break;
                }
                if (isAlreadyInserted) {
                    
                    cell.icon.image = [UIImage imageNamed:@"未展开"];
                    [self miniMizeThisRowsWithUserModelGroup:model.userList];
                }else{
                    cell.icon.image = [UIImage imageNamed:@"展开"];
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
                    for(UserModel *dInner in model.userList ) {
                        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [self.groupArray insertObject:dInner atIndex:count++];
                    }
                    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 1
-(void)miniMizeThisRowsGroup:(NSArray*)ar{
    
    for (ContactModel *model in ar) {
        
        NSUInteger indexToRemove = [self.groupArray indexOfObjectIdenticalTo:model];
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisRowsWithUserModelGroup:model.userList];
        }
        
        if (model.childs && model.childs.count > 0) {
            [self miniMizeThisRowsGroup:model.childs];
        }
        if([self.groupArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [self.groupArray removeObjectIdenticalTo:model];
            [self.groupTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                         [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                         ]
                                       withRowAnimation:UITableViewRowAnimationNone];
        }

     
    }
}

// 2
-(void)miniMizeThisRowsWithUserModelGroup:(NSArray*)ar{
    
    for (UserModel *model in ar) {
    
        NSUInteger indexToRemove = [self.groupArray indexOfObjectIdenticalTo:model];
        
        if([self.groupArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [self.groupArray removeObjectIdenticalTo:model];
            [self.groupTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                         [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                         ]
                                       withRowAnimation:UITableViewRowAnimationNone];
        }

    }
}

#pragma mark - 返回行缩进 有三个方法一起配合使用才生效
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _groupTableView) {
        
        if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
            ContactModel *model = [self.groupArray objectAtIndex:indexPath.row];
            return model.IndentationLevel*1;
        }
        else
        {
            ContactModel *model = [self.groupArray objectAtIndex:indexPath.row];
            return model.IndentationLevel*1 - 1;
            
        }
    }
    return 0;
    
}
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

@end
