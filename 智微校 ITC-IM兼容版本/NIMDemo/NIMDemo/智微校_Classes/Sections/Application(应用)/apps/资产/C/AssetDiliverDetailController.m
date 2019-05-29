//
//  AssetDiliverDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetDiliverDetailController.h"
#import "AssetDetailController.h"
#import "AssetDiliverFooterView.h"
#import "AssetDrawController.h"
#import "AssetNetWorkHelper.h"
#import "TYHAssetModel.h"
#import <MJExtension.h>
#import <UIView+Toast.h>

@interface AssetDiliverDetailController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AssetDiliverDetailController
{
    NSInteger footerViewHeight;
    
    UIButton *leftBtn;
    UILabel *leftLabel;
    
    UIButton *rightBtn;
    UILabel *rightLabel;
    
    UIButton *addPicBtn;
    AssetDiliverFooterView *footView;
    
    AssetMineReturnModel *model;
    NSMutableArray *assetNeedDiliverArray;
    
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    footerViewHeight = 120;
    // Do any additional setup after loading the view from its nib.
    self.title = @"发放资产";
    [self initView];
    if (_dataArray.count) {
        _assetUserPerson.text = _assetUser;
        _assetReceiveOrganization.text = _assetDepartmentName;
    }
    else
    {
        [self requestData];
    }
    [self createBarItem];
    _mainTableView.sectionFooterHeight = footerViewHeight;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"tmpImageDataa"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getGrantDetailJsonWithReturnId:_returnID andStatus:^(BOOL successful, AssetMineReturnModel *returnModel) {
        model = [AssetMineReturnModel new];
        model = returnModel;
        [self initView];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    }];
}

-(void)setReturnID:(NSString *)returnID
{
    _returnID = returnID;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count && dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
        assetNeedDiliverArray = [NSMutableArray array];
        for (AssetMineDetailModel *amdModel in _dataArray) {
            NSDictionary *statusDict = amdModel.mj_keyValues;
            AssetDetailModel *tmpModel = [AssetDetailModel new];
            tmpModel = [AssetDetailModel mj_objectWithKeyValues:statusDict];
            [assetNeedDiliverArray addObject:tmpModel];
        }
    }
    else
        _dataArray = [NSMutableArray array];
}


#pragma mark - initView
-(void)initView
{
    _assetUserPerson.text = model.user;
    _assetReceiveOrganization.text = model.department;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.bounces = NO;
    
//    _mainTableView.tableFooterView = footView;
    _mainTableView.rowHeight = 50;
    _mainTableView.backgroundColor = [UIColor TabBarColorGray];
    
}

-(void)createBarItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}


-(void)initFootView
{
    //yes:Left   no:Right
            leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame = CGRectMake(20, 10, 20, 20);
            [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(LeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:leftBtn];
    
            leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 20 + 5, 10, 80, 20)];
            leftLabel.text = @"上传签字";
            leftLabel.font = [UIFont boldSystemFontOfSize:13];
            UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LeftBtnAction:)];
            leftLabel.userInteractionEnabled = YES;
            [leftLabel addGestureRecognizer:leftTap];
            leftLabel.textColor = [UIColor darkGrayColor];
            leftLabel.userInteractionEnabled = YES;
            [footView addSubview:leftLabel];
    
            rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(115 + 30, 10, 20, 20);
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:rightBtn];
    
            rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightBtn.frame.origin.x + rightBtn.frame.size.width + 5, 10, 80, 20)];
            rightLabel.text = @"后续补签";
            rightLabel.font = [UIFont boldSystemFontOfSize:13];
            rightLabel.textColor = [UIColor darkGrayColor];
            rightLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RightBtnAction:)];
            rightLabel.userInteractionEnabled = YES;
            [rightLabel addGestureRecognizer:rightTap];
            [footView addSubview:rightLabel];
    
        addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addPicBtn.frame = CGRectMake(30, 40, 70, 70);
        [addPicBtn setBackgroundImage:[UIImage imageNamed:@"AlbumAddBtnHL@2x"] forState:UIControlStateNormal];
        [addPicBtn addTarget:self action:@selector(AddPicAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:addPicBtn];
    
}
#pragma mark - tableView datasource & delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celll"];
    AssetDetailModel *detailModel = [AssetDetailModel new];
    if (!_dataArray.count) {
        detailModel = [model.returnAssetsArray objectAtIndex:indexPath.row];
    }
    else
    {
        detailModel = [assetNeedDiliverArray objectAtIndex:indexPath.row];
    }
//    AssetDetailModel *detailModel = [model.returnAssetsArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"celll"];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row + 1,detailModel.name];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AssetDetailModel *detailModel = [AssetDetailModel new];
    if (_dataArray.count && _dataArray) {
        detailModel = [assetNeedDiliverArray objectAtIndex:indexPath.row];
    }
    else
    {
        detailModel = [model.returnAssetsArray objectAtIndex:indexPath.row];
    }
    AssetDetailController *dView = [AssetDetailController new];
    dView.assetCode = detailModel.code;
    [self.navigationController pushViewController:dView animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (assetNeedDiliverArray.count > 0 ) {
        return assetNeedDiliverArray.count;
    }
    else if (model.returnAssetsArray.count > 0) {
        return model.returnAssetsArray.count;
    }else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footerViewHeight;
}

//自定义footView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footView = [AssetDiliverFooterView new];
    footView.userInteractionEnabled = YES;
    footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    footView.backgroundColor = [UIColor TabBarColorGray];
    [self initFootView];
    return footView;
}

#pragma mark - Actions
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction
{
    
    NSMutableString *assetIDs = [NSMutableString string];
    for (AssetMineDetailModel *amdModel in _dataArray ) {
        [assetIDs appendString:[NSString stringWithFormat:@"%@,",amdModel.assetId]];
    }
    if ([_whoGoinType isEqualToString:@"补签"]) {
        assetIDs = [NSMutableString string];
        for (AssetDetailModel *asModel in model.returnAssetsArray) {
            [assetIDs appendString:[NSString stringWithFormat:@"%@,",asModel.assetId]];
        }
    }
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    UIImage *imageNeedUpload = [UIImage imageWithData:imageData];
    NSMutableArray *imageArray = [NSMutableArray array];
    if (imageNeedUpload && imageNeedUpload != nil) {
        [imageArray addObject:imageNeedUpload];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"发放资产中";

    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper submitAssetDiliverWithAssetIDs:assetIDs ApplicationRecordID:_applicationRecordId DepartmentID:_departmentId userID:_applyUserID LocationID:_returnID uploadFiles:[NSMutableArray arrayWithArray:imageArray] andStatus:^(BOOL successful, NSMutableArray *datasource) {
        
        [hud removeFromSuperview];
        [self.view makeToast:@"发放成功" duration:1 position:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
        [hud removeFromSuperview];
        [self.view makeToast:@"发放失败,可能是网络问题" duration:1 position:nil];
    }];
}

-(void)LeftBtnAction:(id)sender
{
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    footerViewHeight = 120;
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    if (imageData) {
        [addPicBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
        footerViewHeight = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height + 40;
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    }
    addPicBtn.hidden = NO;
    footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
}

-(void)RightBtnAction:(id)sender
{
    if ([_whoGoinType isEqualToString:@"补签"]) {
        [self.view makeToast:@"补签模式下禁用" duration:1 position:nil];
    }
    else
    {
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        footerViewHeight = 40;
        addPicBtn.hidden = YES;
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    }
}

-(void)AddPicAction:(id)sender
{
    AssetDrawController *drawView = [AssetDrawController new];
    [self presentViewController:drawView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    if (imageData) {
        [addPicBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
        footerViewHeight = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height + 40;
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    }
}

@end
