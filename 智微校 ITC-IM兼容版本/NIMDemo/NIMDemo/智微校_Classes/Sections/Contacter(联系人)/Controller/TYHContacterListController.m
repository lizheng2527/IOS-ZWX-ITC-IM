//
//  TYHContacterListController.m
//  NIM
//
//  Created by 中电和讯 on 16/12/7.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "TYHContacterListController.h"
#import "NSString+NTES.h"
#import "UserModel.h"
#import "ContactModelListHelper.h"
#import "ContactModel.h"
#import <UIImageView+WebCache.h>
#import "TYHContactCell.h"
#import "TYHContactDetailCell.h"
#import "InviteJoinListViewCell.h"
#import "NTESPersonalCardViewController.h"
#import "LYEmptyViewHeader.h"
#import "SSChatController.h"

@interface TYHContacterListController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,retain)NSMutableArray *ListArray;
@property(nonatomic,retain)NSMutableArray *IndexArray;

@property (nonatomic) BOOL isSelect;
@property (strong, nonatomic) NSMutableArray *selectArray;

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *indexList;

@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;
@end

@implementation TYHContacterListController
{
//    BOOL isAlreadyInserted;
    BOOL isIndexList;
    NSUInteger lastContactsHash;
    NSMutableArray *IndexListArray;
    
    NSMutableArray *searchResultArray;
    NSMutableArray *searchResultsModelArray;
}



-(instancetype)initWithType:(NSInteger )type
{
    self = [super init];
    if (self) {
        _isClassOrSchool = type;
        if (!type) {
            self.title = @"组织机构";
        }
        else self.title = @"班级";
    }
    
//    self.title = @"通讯录";
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = @"通讯录";
    // Do any additional setup after loading the view from its nib.
    [self tableViewConfig];
    [self createBarItem];
    [self requestData];
    [self DataConfig];
    
    
    [self initMysearchBarAndMysearchDisPlay];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
//    self.navigationController.navigationBar.translucent = NO; //translucent 临时注释
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    self.navigationController.navigationBar.translucent = YES;
    [SVProgressHUD dismiss];
}

#pragma mark - 切换NavBar相关
-(void)createBarItem
{

    if (![TYHIMHandler sharedInstance].IMShouldEnabled) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 44)];
        
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
        title.text = @"通讯录";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont boldSystemFontOfSize:17];
        [titleView addSubview:title];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(55, 12, 20, 20)];
        imageview.image = [UIImage imageNamed:@"iv_change_down"];
        [titleView addSubview:imageview];
        
        
        titleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChangeListType:)];
        [titleView addGestureRecognizer:ges];
        
        ///** IM用户身份 **/
        //public static final String USER_STUDENT = "0";    //学生
        //public static final String USER_PARENT  = "1";    //家长
        //public static final String USER_TEACHER = "2";  //教师
        //public static final String USER_ADMIN   = "3";    //管理员
        //public static final String USER_OTHER   = "4";    //其他
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"2"] ) {
            self.navigationItem.titleView = titleView;
            _isClassOrSchool = 1;
        }
        else if([[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"0"] ||  [[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"1"])
        {
            title.frame = titleView.frame;
            _isClassOrSchool = 0;
            [imageview removeFromSuperview];
        }
        else  if ([[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"3"] || [[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"4"]) {
            _isClassOrSchool = 0;
            title.frame = titleView.frame;
            [imageview removeFromSuperview];
        }
        
    }
}

-(void)ChangeListType:(id)sender
{
//    [_mainTableview reloadData];
//    UIButton *button = (UIButton *)sender;
//    button.selected = ! button.selected;
//    [[NSUserDefaults standardUserDefaults]setBool:button.selected forKey:USER_DEFAULT_TREEorNot];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    isIndexList = [[NSUserDefaults standardUserDefaults]boolForKey:USER_DEFAULT_TREEorNot];
//    if (isIndexList) {
//        [self updateContent];
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:USER_DEFAULT_TREEorNot];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    [_mainTableview reloadData];
    
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"切换联系人结构" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOrg = [UIAlertAction actionWithTitle:@"组织结构" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        _isClassOrSchool = 1;
        [self requestData];
    }];
    [controller addAction:actionOrg];
    
    UIAlertAction *actionClass = [UIAlertAction actionWithTitle:@"班级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        _isClassOrSchool = 0;
        [self requestData];
    }];
    [controller addAction:actionClass];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [controller addAction:actionCancel];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 获取数据
-(void)requestData
{
//    isAlreadyInserted = NO;
    [SVProgressHUD showWithStatus:@"获取数据中..."];
    ContactModelListHelper *helper = [[ContactModelListHelper alloc]init];
    //1 class  0 school
    if (_isClassOrSchool) {
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
    else
    {
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
}

-(void)DataConfig
{
    _isSelect = NO;
    isIndexList = NO;
    _selectArray = [NSMutableArray array];
}


#pragma mark - TableviewInit
-(void)tableViewConfig
{
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.tableFooterView = [UIView new];
    _mainTableview.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"" titleStr:nil  detailStr:nil btnTitleStr:@"点击获取通讯录列表" btnClickBlock:^{
        [self requestData];
    }];
    
}

#pragma mark-TableView Datasource&Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        
        static NSString *myCell = @"InviteJoinListViewCellidentifier";
        
        InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
        
        if (cell == nil) {
            
            cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        }
        UserModel * model = searchResultArray[indexPath.row];
        [cell.portraitImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
        cell.portraitImg.layer.masksToBounds = YES;
        cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
        cell.nameLabel.text = model.name;
        cell.selecImage.hidden = YES;
        return cell;
    }
    if (isIndexList) {
        [_mainTableview registerClass:[InviteJoinListViewCell class]
                 forCellReuseIdentifier:@"contactsCellSchool"];
        
        static NSString *iden = @"contactsCellSchool";
        InviteJoinListViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:iden
                                        forIndexPath:indexPath];
        
        cell.selecImage.hidden = YES;
        cell.nameLabel.frame = CGRectMake(70.0f, 12.5f, self.view.frame.size.width-80.0f, 25.0f);
        
        [cell updateContent:_contacts[ indexPath.section ][ indexPath.row ]];
        return cell;
    }
    else
    {
        if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
            static NSString *iden = @"TYHContactCell";
            TYHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactCell" owner:self options:nil].firstObject;
            }
            ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
            cell.icon.image = model.isAlreadyInserted?[UIImage imageNamed:@"未展开"]:[UIImage imageNamed:@"展开"];
            cell.titleLabel.text = model.name;
            return cell;
        }
        
        else if([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
            TYHContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYHContactDetailCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactDetailCell" owner:self options:nil].firstObject;
            }
            UserModel *model = [self.ListArray objectAtIndex:indexPath.row];
            cell.model = model;
            return cell;
        }
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        UserModel * model = searchResultArray[indexPath.row];
//        self.navigationController.navigationBar.translucent = YES;
        [self pushToChatVC:model];
        
        return;
    }
    if (isIndexList) {
        UserModel *model = _contacts[ indexPath.section ][ indexPath.row ];
        [self pushToChatVC:model];
        
        return;
    }
    
    
    UserModel *usermodel = [self.ListArray objectAtIndex:indexPath.row];
    
    if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]) {
        TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
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
//        [self addFriend:usermodel.userId.length?usermodel.userId:@""];
        [self pushToChatVC:usermodel];
        
        return;
    }
    TYHContactCell *cell = (TYHContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
    if (model.childs) {
//        BOOL isAlreadyInserted = NO;
        model.isAlreadyInserted = NO;
        for (ContactModel *contactModel in model.childs) {
            NSInteger index = [self.ListArray indexOfObjectIdenticalTo:contactModel];
            model.isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(model.isAlreadyInserted) break;
        }
        
        if (model.isAlreadyInserted) {
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
        model.isAlreadyInserted = NO;
//        BOOL isAlreadyInserted = NO;
        for (UserModel *userModel in model.userList) {
            NSInteger index = [self.ListArray indexOfObjectIdenticalTo:userModel];
            model.isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(model.isAlreadyInserted) break;
        }
        if (model.isAlreadyInserted) {
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
    if ([tableView isEqual:_mySearchDisplayController.searchResultsTableView]) {
        return 0;
    }
    
    else {
        if (isIndexList) {
            return 0;
        }
        else
        {
            if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
                ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
                return model.IndentationLevel*1;
            }
            else
            {
                ContactModel *model = [self.ListArray objectAtIndex:indexPath.row];
                return model.IndentationLevel*1 - 1;
            }
        }
    }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _mySearchDisplayController.searchResultsTableView){
        return searchResultArray.count;
    }
    else if (isIndexList) {
        return [_contacts[section] count];
    }
    else  if (_ListArray.count > 0&& _ListArray) {
        return _ListArray.count;
    }else
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isIndexList) {
            return [_contacts count];
    }
    else
        return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mySearchDisplayController.searchResultsTableView) {
        return  50;
    }
    else if (isIndexList) {
        return 50;
    }
    else
    {
        if ([[self.ListArray objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]])
        {
            return 50;
        }
        else
        {
            return 45;
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

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    if (isIndexList) {
        return index;
    }
    else return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (isIndexList) {
            return _indexList;
    }
    else return [NSArray array];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (isIndexList) {
            return _indexList[ section ];
    }
    else
        return @"";
}

- (NSArray *)arrayForSections:(NSArray *)objects {
    SEL selector = @selector(name);
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    // sectionTitlesCount 27 , A - Z + #
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    // Create 27 sections' data
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    //去重
    NSMutableArray *objectArray = [[NSMutableArray arrayWithArray:objects] mutableCopy];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (UserModel *model in objectArray) {
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
    objectArray = [NSMutableArray arrayWithArray:tmpModelArray];
    //去重结束
    
    
    // Insert records
    for (id object in objects) {
        NSInteger sectionNumber = [collation sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    // Remove empty sections
    NSMutableArray *existTitleSections = [NSMutableArray array];
    
    for (NSArray *section in mutableSections) {
        if ([section count] > 0) {
            [existTitleSections addObject:section];
        }
    }
    // Remove empty sections Index in |indexList|
    NSMutableArray *existTitles = [NSMutableArray array];
    NSArray *allSections = [collation sectionIndexTitles];
    
    for (NSUInteger i = 0; i < [allSections count]; i++) {
        if ([mutableSections[ i ] count] > 0) {
            [existTitles addObject:allSections[ i ]];
        }
    }
    self.indexList = existTitles;
    return existTitleSections;
}

- (void)setContacts:(NSArray *)objects {
    if (objects.hash == lastContactsHash) {
        return;
    }
    lastContactsHash = objects.hash;
    _contacts = [self arrayForSections:objects];
    [_mainTableview reloadData];
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


#pragma mark - Other
- (void)addFriend:(NSString *)userId{
//    __weak typeof(self) wself = self;
//    [SVProgressHUD show];
//    [SVProgressHUD dismiss];
    
    
    NSMutableArray *_datas = [NSMutableArray new];
    [_datas addObjectsFromArray:@[@{@"image":@"icon_shuru",//头像
                                    @"title":@"用户1",
                                    @"detail":@"我勒个去???？",
                                    @"sectionId":@"13540033103",
                                    @"type":@"1"
                                    },
                                  @{@"image":@"icon_yuying",//头像
                                    @"title":@"用户2",
                                    @"detail":@"啊哈?",
                                    @"sectionId":@"13540033104",
                                    @"type":@"1"
                                    }]];

    SSChatController *vc = [SSChatController new];
    
    vc.chatType = 1;
    vc.sessionId = userId;
    vc.titleString = _datas[0][@"title"];
    vc.receiverID = userId;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (users.count) {
////            NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId];
////            [wself.navigationController pushViewController:vc animated:YES];
//
//        }else{
//            if (wself) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户不存在" message:@"请检查你输入的帐号是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//    }];
}


-(void)pushToChatVC:(UserModel *)model
{
    if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
        __weak typeof(self) wself = self;
        [SVProgressHUD show];
        
        if (model.accId) {
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[model.accId] completion:^(NSArray *users, NSError *error) {
                [SVProgressHUD dismiss];
                if (users.count) {
                    NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:model.accId];
                    [wself.navigationController pushViewController:vc animated:YES];
                }else{
                    if (wself) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户不存在" message:@"请检查你输入的帐号是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
            }];
        }else
        {
            [self.view makeToast:@"该账户暂未开通" duration:1.5 position:CSToastPositionCenter];
        }
        
    }
    else
    {
        SSChatController *vc = [SSChatController new];
        vc.chatType = 1;
        vc.sessionId = model.userId;
        vc.receiverID = model.userId;
        vc.titleString = model.name;
        vc.receiverHeadIconURL = model.headPortraitUrl;
        
        if ([model.userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID]]) {
            [self.view makeToast:@"您不能给自己留言" duration:1.5 position:CSToastPositionCenter];
        }else
            [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
    
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
