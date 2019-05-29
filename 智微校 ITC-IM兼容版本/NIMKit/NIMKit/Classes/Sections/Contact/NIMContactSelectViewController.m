//
//  NIMContactSelectViewController.m
//  NIMKit
//
//  Created by chris on 15/9/14.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMContactSelectViewController.h"
#import "NIMContactSelectTabView.h"
#import "NIMContactPickedView.h"
#import "NIMGroupedUsrInfo.h"
#import "NIMGroupedData.h"
#import "NIMContactDataCell.h"
#import "UIView+NIM.h"
#import "NIMKit.h"
#import "NIMKitDependency.h"
#import "NIMGlobalMacro.h"

#import "UIView+Toast.h"
#import "TYHAddPersonController.h"

@interface NIMContactSelectViewController ()<UITableViewDataSource, UITableViewDelegate, NIMContactPickedViewDelegate>{
    NSMutableArray *_selectecContacts;
}
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NIMContactSelectTabView *selectIndicatorView;

@property (nonatomic, assign) NSInteger maxSelectCount;

@property(nonatomic, strong) NSDictionary *contentDic;

@property(nonatomic, strong) NSArray *sectionTitles;

@end

@implementation NIMContactSelectViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _maxSelectCount = NSIntegerMax;
    }
    return self;
}

- (instancetype)initWithConfig:(id<NIMContactSelectConfig>) config{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 164, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  - 64 - 50 - 44) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.selectIndicatorView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setUpNav];
    
    self.selectIndicatorView.pickedView.delegate = self;
    [self.selectIndicatorView.doneButton addTarget:self action:@selector(onDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, 100) style:UITableViewStylePlain];
    self.groupTableView.delegate = self;
    self.groupTableView.dataSource = self;
    self.groupTableView.bounces = NO;
    self.groupTableView.tableHeaderView = [UIView new];
    [self.view addSubview:self.groupTableView];
}

- (void)setUpNav
{
    self.navigationItem.title = [self.config respondsToSelector:@selector(title)] ? [self.config title] : @"选择联系人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelBtnClick:)];
    if ([self.config respondsToSelector:@selector(showSelectDetail)] && self.config.showSelectDetail) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
        [label setText:self.detailTitle];
        [label sizeToFit];
    }
}

- (void)refreshDetailTitle
{
    UILabel *label = (UILabel *)self.navigationItem.rightBarButtonItem.customView;
    [label setText:self.detailTitle];
    [label sizeToFit];
}

- (NSString *)detailTitle
{
    NSString *detail = @"";
    if ([self.config respondsToSelector:@selector(maxSelectedNum)])
    {
        detail = [NSString stringWithFormat:@"%zd/%zd",_selectecContacts.count,_maxSelectCount];
    }
    else
    {
        detail = [NSString stringWithFormat:@"已选%zd人",_selectecContacts.count];
    }
    return detail;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.selectIndicatorView.nim_width = self.view.nim_width;
    //    self.tableView.nim_height = self.view.nim_height - self.selectIndicatorView.nim_height;
    self.selectIndicatorView.nim_bottom = self.view.nim_height;
}

- (void)show{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];
}

- (void)setConfig:(id<NIMContactSelectConfig>)config{
    _config = config;
    if ([config respondsToSelector:@selector(maxSelectedNum)]) {
        _maxSelectCount = [config maxSelectedNum];
        _contentDic = @{}.mutableCopy;
        _sectionTitles = @[].mutableCopy;
    }
    [self makeData];
}

- (void)onCancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^() {
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
        if([_delegate respondsToSelector:@selector(didCancelledSelect)]) {
            [_delegate didCancelledSelect];
        }
    }];
}

- (IBAction)onDoneBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];    
    if (_selectecContacts.count) {
        if ([self.delegate respondsToSelector:@selector(didFinishedSelect:)]) {
            [self.delegate didFinishedSelect:_selectecContacts];
        }
        if (self.finshBlock) {
            self.finshBlock(_selectecContacts);
            self.finshBlock = nil;
        }
    }
    else {
        if([_delegate respondsToSelector:@selector(didCancelledSelect)]) {
            [_delegate didCancelledSelect];
        }
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
    }
}

- (void)makeData{
    NIMKit_WEAK_SELF(weakSelf);
    [self.config getContactData:^(NSDictionary *contentDic, NSArray *titles) {
        self.contentDic = contentDic;
        self.sectionTitles = titles;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    if ([self.config respondsToSelector:@selector(alreadySelectedMemberId)])
    {
        _selectecContacts = [[self.config alreadySelectedMemberId] mutableCopy];
    }
    
    _selectecContacts = _selectecContacts.count ? _selectecContacts : [NSMutableArray array];
    for (NSString *selectId in _selectecContacts) {
        NIMKitInfo *info;
        info = [self.config getInfoById:selectId];
        [self.selectIndicatorView.pickedView addMemberInfo:info];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return self.sectionTitles.count;
    }else return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        NSArray *arr = [self.contentDic valueForKey:self.sectionTitles[section]];
        return arr.count;
    }else return 2;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        if ([self.sectionTitles[0] isEqualToString:@"$"] && section == 0) {
            return @"机器人";
        }else {
            return self.sectionTitles[section];
        }
    }else return @"";
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        NSString *title = self.sectionTitles[indexPath.section];
        NSMutableArray *arr = [self.contentDic valueForKey:title];
        id<NIMGroupMemberProtocol> contactItem = arr[indexPath.row];
        
        NIMContactDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectContactCellID"];
        if (cell == nil) {
            cell = [[NIMContactDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectContactCellID"];
        }
        cell.accessoryBtn.hidden = NO;
        cell.accessoryBtn.selected = [_selectecContacts containsObject:[contactItem memberId]];
        NIMKitInfo *info = [self.config getInfoById:[contactItem memberId]];
        [cell refreshItem:contactItem withMemberInfo:info];
        return cell;
    }
    else
    {
        static NSString *iden = @"idenn";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"组织结构";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"班级分组";
        }
        cell.imageView.image = [UIImage imageNamed:@"mk-photo"];
        
        return cell;
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     if ([tableView isEqual:self.tableView]) {
         return [self.sectionTitles mutableCopy];
     }else return [NSMutableArray array];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([tableView isEqual:self.tableView]) {
        NSString *title = self.sectionTitles[indexPath.section];
        NSMutableArray *arr = [self.contentDic valueForKey:title];
        id<NIMGroupMemberProtocol> member = arr[indexPath.row];
        
        NSString *memberId = [(id<NIMGroupMemberProtocol>)member memberId];
        NIMContactDataCell *cell = (NIMContactDataCell *)[tableView cellForRowAtIndexPath:indexPath];
        NIMKitInfo *info;
        info = [self.config getInfoById:memberId];
        if([_selectecContacts containsObject:memberId]) {
            [_selectecContacts removeObject:memberId];
            cell.accessoryBtn.selected = NO;
            [self.selectIndicatorView.pickedView removeMemberInfo:info];
        } else if(_selectecContacts.count >= _maxSelectCount) {
            if ([self.config respondsToSelector:@selector(selectedOverFlowTip)]) {
                NSString *tip = [self.config selectedOverFlowTip];
                [self.view makeToast:tip duration:2.0 position:CSToastPositionCenter];
            }
            cell.accessoryBtn.selected = NO;
        } else {
            [_selectecContacts addObject:memberId];
            cell.accessoryBtn.selected = YES;
            [self.selectIndicatorView.pickedView addMemberInfo:info];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else if ([tableView isEqual:self.groupTableView]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TYHAddPersonController *addPersonVC = [TYHAddPersonController new];
        addPersonVC.type = indexPath.row;
        addPersonVC.selectPersonArray = [NSMutableArray arrayWithArray:_selectecContacts];
        [self.navigationController pushViewController:addPersonVC animated:YES];
    }
    
    
    [self refreshDetailTitle];
}

#pragma mark - ContactPickedViewDelegate

- (void)removeUser:(NSString *)userId {
    [_selectecContacts removeObject:userId];
    [_tableView reloadData];
    [self refreshDetailTitle];
}

#pragma mark - Private

- (NIMContactSelectTabView *)selectIndicatorView{
    if (_selectIndicatorView) {
        return _selectIndicatorView;
    }
    CGFloat tabHeight = 50.f;
    CGFloat tabWidth  = 320.f;
    _selectIndicatorView = [[NIMContactSelectTabView alloc] initWithFrame:CGRectMake(0, 0, tabWidth, tabHeight)];
    return _selectIndicatorView;
}


//addPerson
-(void)AddPerson:(NSMutableArray *)selectPersonArray
{
    NSMutableArray *tmpPersonArray = [NSMutableArray arrayWithArray:_selectecContacts];
    _selectecContacts = [NSMutableArray arrayWithArray:selectPersonArray];
    for (NSString *selectId in selectPersonArray) {
        NIMKitInfo *info;
//        if (self.selectType == NIMContactSelectTypeTeam) {
            info = [[NIMKit sharedKit] infoByTeam:selectId option:nil];
//        }else{
//            info = [[NIMKit sharedKit] infoByUser:selectId option:nil];
//        }
        [self.selectIndicatorView.pickedView addMemberInfo:info];
    }
    
    //如果点进去之后取消勾选,这边要删除
    if (tmpPersonArray.count && !_selectecContacts.count) {
        for (NSString *selectId in selectPersonArray) {
            
            NIMKitInfo *info;
//            if (self.selectType == NIMContactSelectTypeTeam) {
                info = [[NIMKit sharedKit] infoByTeam:selectId option:nil];
//            }else{
//                info = [[NIMKit sharedKit] infoByUser:selectId option:nil];
//            }
            [self.selectIndicatorView.pickedView removeMemberInfo:info];
        }
    }
    [self.tableView reloadData];
}


@end

