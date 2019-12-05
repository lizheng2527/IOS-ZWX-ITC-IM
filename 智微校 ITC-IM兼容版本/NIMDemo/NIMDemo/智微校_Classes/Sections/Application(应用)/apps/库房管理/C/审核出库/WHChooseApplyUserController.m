//
//  WHChooseApplyUserController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/13.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHChooseApplyUserController.h"
#import "ContactModelListHelper.h"
#import "ContactModel.h"
#import "SessionViewCell.h"
#import <UIImageView+WebCache.h>
#import "TYHContactCell.h"
#import "InviteJoinListViewCell.h"
#import <UIView+Toast.h>
#import "TYHContactDetailCell.h"
#import "TYHNewSendViewController.h"
#import "TYHNewAPPViewController.h"
#import <MJExtension.h>
#import "TYHWarehouseDefine.h"

#import "WHDiliverController.h"
#import "WHAddApplicationDiliverController.h"
#import "PCheckSearchController.h"
#import "ProjectNewApplicationController.h"
#import "PProjectApprovalCheckController.h"

#define HeadBtnWidth 55
#define HeadBtnHeight 70
#define WIDTH ([UIScreen mainScreen].bounds.size.width / 320 )
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface WHChooseApplyUserController ()<UISearchBarDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSArray * resultsData;
@property (nonatomic, strong) NSMutableArray * resultsArray;
@property (nonatomic, strong) NSMutableArray * resultsModelArray;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, strong) UITableView * groupTableView;
@property (nonatomic, strong) NSString * IDStr;
@property (nonatomic, strong) NSString * NameStr;

@property(nonatomic,retain)NSMutableArray *modelArray;

@end

@implementation WHChooseApplyUserController
{
    BOOL isAlreadyInserted;
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (![_inType isEqualToString:@"项目"]  && ![_inType isEqualToString:@"项目2"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor TabBarColorWarehouse];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


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
    
    //    [self creatLeftItem];
    [self creatTableView];
    isAlreadyInserted = NO;
    
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelFont = [UIFont systemFontOfSize:12];
    HUD.labelText = @"加载数据中";
    self.HUD = HUD;
    
    ContactModelListHelper *myHelper = [[ContactModelListHelper alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * strUrl = [NSString stringWithFormat:@"%@%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@",k_V3ServerURL,_urlStr,_userName,_password,_userId];
        
        [myHelper getContactCompletionNoticeContact:strUrl block:^(BOOL Successful, NSMutableArray *myArray) {
            
            if (Successful) {
                _groupArray = [NSMutableArray arrayWithArray:myArray];
                // 模型name数组
                _resultsData = [NSMutableArray arrayWithArray:myHelper.nameSource];
                _resultsModelArray = [NSMutableArray arrayWithArray:myHelper.dataSource];
                _resultsArray = [NSMutableArray array];
                [self.groupTableView reloadData];
                [self.HUD removeFromSuperview];
            }
            
        }];
        
    });
    
    [self initMysearchBarAndMysearchDisPlay];
}


- (void)returnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//  初始化tableview
- (void)creatTableView {
    
    _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,20, WIDTH * 320,HEIGHT)];
    if (self.whoWillIn) {
        _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH * 320,HEIGHT - 64)];
    }
    _groupTableView.dataSource = self;
    _groupTableView.delegate = self;
    _groupTableView.bounces = NO;
    
    [self.view addSubview:_groupTableView];
    
    [_groupTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

// 初始化 搜索框
-(void)initMysearchBarAndMysearchDisPlay
{
//    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,WIDTH * 320 ,40)];
//    _mySearchBar.delegate = self;
//    _mySearchBar.placeholder = @"姓名";
//    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    self.groupTableView.tableHeaderView = _mySearchBar;
    
//    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
//    _mySearchDisplayController.delegate = self;
//    _mySearchDisplayController.searchResultsDataSource = self;
//    _mySearchDisplayController.searchResultsDelegate = self;
//    _mySearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    _mySearchDisplayController.searchResultsTableView.tableHeaderView= [[UIView alloc]initWithFrame:CGRectZero];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
     
    _searchController.searchResultsUpdater = self;
     
    _searchController.dimsBackgroundDuringPresentation = NO;
     
    _searchController.hidesNavigationBarDuringPresentation = NO;
     
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
     _searchController.searchBar.placeholder = @"姓名";
    self.groupTableView.tableHeaderView = self.searchController.searchBar;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
     
    NSString *searchString = [self.searchController.searchBar text];
     
     _resultsArray = [NSMutableArray array];
       
       NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
       NSMutableArray *tempResults = [NSMutableArray array];
       
       //去重
       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       for (UserModel *model in _resultsModelArray) {
           [dic setObject:model.name forKey:model.userId];
       }
       NSMutableArray *tmpModelArray = [NSMutableArray array];
       for (NSString *string in dic.allKeys) {
           UserModel *model = [UserModel new];
           model.userId = string;
           [tmpModelArray addObject:model];
       }
       [tmpModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           UserModel *model = obj;
           model.name = dic.allValues[idx];
       }];
       _resultsModelArray = [NSMutableArray arrayWithArray:tmpModelArray];
       //去重结束
       
       for (UserModel *model in _resultsModelArray) {
           NSString *storeString = model.name;
           NSRange storeRange = NSMakeRange(0, storeString.length);
           NSRange foundRange = [storeString rangeOfString:searchString options:searchOptions range:storeRange];
           if (foundRange.length) {
               [tempResults addObject:storeString];
           }
       }
       NSMutableArray *arry = [NSMutableArray array];
       [arry addObjectsFromArray:tempResults];
       _resultsArray = [NSMutableArray arrayWithArray:arry];
    //刷新表格
 
    [self.groupTableView reloadData];
}

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//
//
//    
//
//    //    _resultsArray =  [NSMutableArray arrayWithArray:[[NSSet setWithArray:arry] allObjects]];
//}



#pragma mark - UISearchDisplayController delegate methods
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
//
//    [self filterContentForSearchText:searchString  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]  objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
//
//    return YES;
//
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
//
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//
//    return YES;
//}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    if (_IDStr.length != 0) {
        
        if ([self.inType isEqualToString:@"项目"]) {
            PCheckSearchController *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
            [takeView didselectedUser:_IDStr userName:_NameStr];
            [self.navigationController popToViewController:takeView animated:true];
            return;
        }
        else if([self.inType isEqualToString:@"项目2"]) {

            PProjectApprovalCheckController *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
            [takeView didselectedUser:_IDStr userName:_NameStr];
            [self.navigationController popToViewController:takeView animated:true];
            return;
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(didselectedUser:userName:)]) {
            
            WHAddApplicationDiliverController
            *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            [takeView didselectedUser:_IDStr userName:_NameStr];
            [self.navigationController popToViewController:takeView animated:true];
        }
        
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarTextDidEndEditing");
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
    
    NSLog(@"subViews = %@", subViews);
    
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
    
    if(self.searchController.active){
        return _resultsArray.count;
    }else {
        
        if (_groupArray.count >0 && _groupArray) {
            return _groupArray.count;
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        return  55;
    }
    else if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]])
    {
        return 50;
    }
    else if([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]])
    {
        return 55;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        
        static NSString *myCell = @"InviteJoinListViewCellidentifier";
        
        InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
        
        if (cell == nil) {
            
            cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
            
        }
        NSString * name = _resultsArray[indexPath.row];
        cell.portraitImg.image = [self dealImageWIthVoipAccount:@""];
        cell.portraitImg.layer.masksToBounds = YES;
        cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
        cell.nameLabel.text = name;
        cell.selecImage.hidden = YES;
        return cell;
        
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
                
            }
            UserModel *model = [self.groupArray objectAtIndex:indexPath.row];
            
            cell.portraitImg.image = [self dealImageWIthVoipAccount:model.voipAccount];
            
            cell.portraitImg.layer.masksToBounds = YES;
            cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
            cell.nameLabel.text =model.name;
            cell.selecImage.hidden = YES;
            
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchController.active) {
        
        NSString * name = _resultsArray[indexPath.row];
        NSLog(@"%@",name);
        
        //        NSArray *array = [[NSSet setWithArray:_resultsModelArray] allObjects];
        for (UserModel * model in _resultsModelArray) {
            
            if ([model.name isEqualToString:name]) {
                
                NSLog(@"%@====%@",model.name,model.userId);
                _IDStr = model.userId;
                _NameStr = model.name;
                
                [self searchBarCancelButtonClicked:_mySearchBar];
                
                //                if (_IDStr.length != 0) {
                //                        TYHNewAPPViewController
                //                        *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                //                        [takeView didselectedPerson:model.userId name:model.name];
                //                        [self.navigationController
                //                         popToViewController:takeView animated:true];
                //                }
                //                break;
            }
        }
        
    } else {
        
        UserModel *usermodel = [self.groupArray objectAtIndex:indexPath.row];
        if ([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]) {
            //            TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if ([self.delegate respondsToSelector:@selector(didselectedUser:userName:)]) {
                
                
                WHAddApplicationDiliverController
                *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                [takeView didselectedUser:usermodel.userId userName:usermodel.name];
                [self.navigationController popToViewController:takeView animated:true];
                //                [self dismissViewControllerAnimated:YES completion:^{
                //
                //                    [self.delegate didselectedPerson:usermodel.userId name:usermodel.name];
                //                }];
                
                if ([self.inType isEqualToString:@"项目"]) {
                    PCheckSearchController
                    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count- 1];
                    [takeView didselectedUser:usermodel.userId userName:usermodel.name];
                    [self.navigationController
                     popToViewController:takeView animated:true];
                    return;
                }
                else if([self.inType isEqualToString:@"项目2"]) {
                    PProjectApprovalCheckController
                    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count- 1];
                    [takeView didselectedUser:usermodel.userId userName:usermodel.name];
                    [self.navigationController
                     popToViewController:takeView animated:true];
                    return;
                }
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
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //    self.navigationController.navigationBarHidden = YES;
    //
    //    self.navigationController.navigationBar.barTintColor = [UIColor TabBarColorYellow];
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


- (void)viewDidDisappear:(BOOL)animated{
    self.searchController.active = FALSE;
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
