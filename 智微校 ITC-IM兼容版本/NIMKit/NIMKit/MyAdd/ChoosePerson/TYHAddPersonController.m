//
//  TYHAddPersonController.m
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "TYHAddPersonController.h"

#import <SVProgressHUD.h>
#import "UserModel.h"
#import "ContactModelListHelper.h"
#import "ContactModel.h"
#import <UIImageView+WebCache.h>
#import "TYHContactCell_NIMKIT.h"
#import "TYHContactDetailCell_NIMKIT.h"
#import "TYHAddPersonCell.h"
#import <UIView+Toast.h>
#import "NIMContactSelectViewController.h"


#define BaseURL [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_BASEURL"]

@interface TYHAddPersonController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,retain)NSMutableArray *ListArray;
@property(nonatomic,retain)NSMutableArray *IndexArray;

@property (nonatomic) BOOL isSelect;
@property (strong, nonatomic) NSMutableArray *selectArray;

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *indexList;

@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;

@end

@implementation TYHAddPersonController
{
    //    BOOL isAlreadyInserted;
    BOOL isIndexList;
    NSUInteger lastContactsHash;
    NSMutableArray *IndexListArray;
    
    NSMutableArray *searchResultArray;
    NSMutableArray *searchResultsModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择联系人";
    [self tableViewConfig];
    [self requestData];
    [self DataConfig];
    [self initMysearchBarAndMysearchDisPlay];
    [self creatLeftItem];
    // Do any additional setup after loading the view from its nib.
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
//    self.navigationController.navigationBar.translucent = NO;//translucent 临时注释
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    self.navigationController.navigationBar.translucent = YES;
    [SVProgressHUD dismiss];
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

-(void)returnClicked
{
    NIMContactSelectViewController *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [takeView AddPerson:_selectPersonArray];
    takeView.delegate = self;
    [self.navigationController popToViewController:takeView animated:true];
}




#pragma mark - 获取数据
-(void)requestData
{
    //    isAlreadyInserted = NO;
    [SVProgressHUD showWithStatus:@"获取数据中..."];
    ContactModelListHelper *helper = [[ContactModelListHelper alloc]init];
    if(_type)
    {//班级分组
        [helper getContactCompletionWithClasses:^(BOOL successful, NSMutableArray *schoolArray) {
            if (successful) {
                _ListArray = [NSMutableArray arrayWithArray:schoolArray];
                _IndexArray = [NSMutableArray arrayWithArray:schoolArray];
                searchResultsModelArray = [NSMutableArray arrayWithArray:helper.dataSource];
            }
            [_mainTableview reloadData];
            [SVProgressHUD dismiss];
        }];
    }
    else
    {//组织机构
        [helper getContactCompletionWIthSchool:^(BOOL successful, NSMutableArray *schoolArray) {
            if (successful) {
                _ListArray = [NSMutableArray arrayWithArray:schoolArray];
                _IndexArray = [NSMutableArray arrayWithArray:schoolArray];
                searchResultsModelArray = [NSMutableArray arrayWithArray:helper.dataSource];
            }
            [_mainTableview reloadData];
            [SVProgressHUD dismiss];
        }];
    }
}

-(void)DataConfig
{
    _isSelect = NO;
    _selectArray = [NSMutableArray array];
//    _selectPersonArray = [NSMutableArray array];
}

#pragma mark - TableviewInit
-(void)tableViewConfig
{
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableview];
}

#pragma mark-TableView Datasource&Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        
        static NSString *myCell = @"InviteJoinListViewCellidentifier";
        
        TYHAddPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
        
        if (cell == nil) {
            
            cell = [[TYHAddPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        }
        UserModel * model = searchResultArray[indexPath.row];
        [cell.portraitImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl]] placeholderImage:[UIImage imageNamed:@"defult_head_img"]];
        cell.portraitImg.layer.masksToBounds = YES;
        cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
        cell.nameLabel.text = model.name;
        cell.selecImage.hidden = YES;
        return cell;
    }
        if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
            static NSString *iden = @"TYHContactCell_NIMKIT";
            TYHContactCell_NIMKIT *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[TYHContactCell_NIMKIT alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            }
            ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            cell.titleLabel.text = model.name;
            return cell;
        }
        
        else if([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
            TYHAddPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYHContactDetailCell_NIMKIT"];
            if (!cell) {
                cell = [[TYHAddPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYHContactDetailCell_NIMKIT"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClicked:)];
                cell.contentView.userInteractionEnabled = YES;
                [cell.contentView addGestureRecognizer:tap];
                
            }
            UserModel *model = [self.ListArray objectAtIndex:indexPath.row];
            [cell updateContent:model];
            
            cell.selecImage.tag =indexPath.row+1000;
            if ([_selectPersonArray containsObject:model.accId] && ![self isBlankString:model.accId]) {
                cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
            }
            else{
                cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
            }
            return cell;
        }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _mySearchDisplayController.searchResultsTableView) {

        return;
    }
    
    UserModel *usermodel = [self.ListArray objectAtIndex:indexPath.row];
    
    if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]) {
        TYHContactDetailCell_NIMKIT *cell = (TYHContactDetailCell_NIMKIT *)[tableView cellForRowAtIndexPath:indexPath];
        if (self.isSelect) {
            for (NSString *user in self.selectArray) {
                if ([user isEqualToString:usermodel.voipAccount]) {
                    [self.selectArray removeObject:usermodel.voipAccount];
                    cell.userIcon.image = [UIImage imageNamed:@"未选中"];
                    return;
                }
            }
            [self.selectArray addObject:usermodel.voipAccount];
            cell.userIcon.image = [UIImage imageNamed:@"选中"];
            return;
        }
        
        //....
        return;
    }
    TYHContactCell_NIMKIT *cell = (TYHContactCell_NIMKIT *)[tableView cellForRowAtIndexPath:indexPath];
    ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
    if (model.childs) {
        BOOL isAlreadyInserted = NO;
        for (ContactModel *contactModel in model.childs) {
            NSInteger index = [self.ListArray indexOfObjectIdenticalTo:contactModel];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        
        if (isAlreadyInserted) {
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            [self miniMizeThisRows:model.childs];
        }else{
            cell.icon.image = [UIImage imageNamed:@"展开"];
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(ContactModel *dInner in model.childs ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.ListArray insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    if (model.userList) {
        BOOL isAlreadyInserted = NO;
        for (UserModel *userModel in model.userList) {
            NSInteger index = [self.ListArray indexOfObjectIdenticalTo:userModel];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        if (isAlreadyInserted) {
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            [self miniMizeThisRowsWithUserModel:model.userList];
        }else{
            cell.icon.image = [UIImage imageNamed:@"展开"];
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(UserModel *dInner in model.userList ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.ListArray insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}

//返回行缩进 有三个方法一起配合使用才生效
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
            ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
            return model.IndentationLevel*1;
        }
        else
        {
            ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
            return model.IndentationLevel*1 - 1;
        }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _mySearchDisplayController.searchResultsTableView){
        return searchResultArray.count;
    }
    else if (_ListArray.count > 0&& _ListArray) {
        return _ListArray.count;
    }else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        return  50;
    }
    else
    {
        if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]])
        {
            return 50;
        }
        else
        {
            return 50;
        }
    }
}

#pragma mark-TableView InsertCell
-(void)miniMizeThisRows:(NSArray*)ar{
    for (ContactModel *model in ar) {
        NSUInteger indexToRemove = [self.ListArray indexOfObjectIdenticalTo:model];
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisRowsWithUserModel:model.userList];
        }
        if (model.childs && model.childs.count > 0) {
            [self miniMizeThisRows:model.childs];
        }
        if([self.ListArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [self.ListArray removeObjectIdenticalTo:model];
            [_mainTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

// 2
-(void)miniMizeThisRowsWithUserModel:(NSArray*)ar{
    for (UserModel *model in ar) {
        
        NSUInteger indexToRemove = [self.ListArray indexOfObjectIdenticalTo:model];
        if([self.ListArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [self.ListArray removeObjectIdenticalTo:model];
            [_mainTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
#pragma mark-TableView Index About
-(void)updateContent
{
    IndexListArray = [NSMutableArray array];
    [self miniMizeTheArr:_IndexArray];
    self.contacts = IndexListArray;
}

-(void)miniMizeTheArr:(NSArray *)ar
{
    for (ContactModel *model in ar) {
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisArrayWithUserModel:model.userList];
        }
        if (model.childs && model.childs.count > 0)
        {
            [self miniMizeTheArr:model.childs];
        }
    }
}

-(void)miniMizeThisArrayWithUserModel:(NSArray*)ar{
    for (UserModel *model in ar) {
        [IndexListArray addObject:model];
    }
}
#pragma mark - SearchBarInit
// 初始化 搜索框
-(void)initMysearchBarAndMysearchDisPlay
{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width * 320 ,40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _mainTableview.tableHeaderView = _mySearchBar;
    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    _mySearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _mySearchDisplayController.searchResultsTableView.tableHeaderView= [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    searchResultArray = [NSMutableArray array];
    
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    NSMutableArray *tempResults = [NSMutableArray array];
    
    //去重
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (UserModel *model in searchResultsModelArray) {
        [dic setObject:model.name forKey:model.accId];
    }
    NSMutableArray *tmpModelArray = [NSMutableArray array];
    for (NSString *string in dic.allKeys) {
        UserModel *model = [UserModel new];
        model.accId = string;
        [tmpModelArray addObject:model];
    }
    [tmpModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserModel *model = obj;
        model.name = dic.allValues[idx];
    }];
    searchResultsModelArray = [NSMutableArray arrayWithArray:tmpModelArray];
    //去重结束
    
    for (UserModel *model in searchResultsModelArray) {
        NSString *storeString = model.name;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:model];
        }
    }
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObjectsFromArray:tempResults];
    searchResultArray = [NSMutableArray arrayWithArray:arry];
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

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _mySearchBar.showsCancelButton = YES;
    NSArray *subViews;
    
    subViews = _mySearchBar.subviews;
    
    NSLog(@"subViews = %@", subViews);
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}


#pragma mark - Other

-(void)cellSelectBtnClicked:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:_mainTableview];
    NSIndexPath * indexPath = [_mainTableview indexPathForRowAtPoint:point];
    
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    if([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
        UserModel *model = [self.ListArray objectAtIndex:indexPath.row];
        NSString *voipSrting = model.accId;
//        NSLog(@"model.name == %@",model.name);
//        if ( [_selectPersonArray containsObject:model.voipAccount]) {
//            selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
//            [self.view makeToast:@"群组内已存在该成员或该成员是创建者" duration:0.8 position:nil];
//        }
//        else
//        {
            if ([_selectPersonArray containsObject:voipSrting] ) {
                selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
                
                
                NSLog(@"_selectedArray == %@",_selectPersonArray);
                [_selectPersonArray removeObject:voipSrting];
                
                
                NSLog(@"_selectedArray == %@",_selectPersonArray);
            }
            else{
                selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
                
                
                NSLog(@"_selectedArray == %@",_selectPersonArray);
                [_selectPersonArray addObject:voipSrting];
                
                NSLog(@"_selectedArray == %@",_selectPersonArray);
            }
//        }
//        countLabel.text = [NSString stringWithFormat:@"一共勾选了%d个人",(int)_selectedArray.count];
//        [rightBtn setTitle:[NSString stringWithFormat:@"提交(%lu)",(long)_selectedArray.count]];
        //    [rightBtn setTitle:[@"提交(%d)",(int)_selectedArray.count]];
    }
}


- (BOOL) isBlankString:(NSString *)string; {
    
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
