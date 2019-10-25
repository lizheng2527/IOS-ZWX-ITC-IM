//
//  TYHWarehouseManagementController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/14.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "TYHWarehouseManagementController.h"
#import "ButtonCell.h"
#import "UIView+SDAutoLayout.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "UIButton+Extention.h"
#import <UIView+Toast.h>
#import <Reachability.h>
#import "AssetHeadView.h"
#import "AssetManagerNoticeCell.h"
#import "AssetModelHandler.h"
#import "TYHAssetModel.h"
#import "NSString+Empty.h"
#import "AssetCheckController.h"
#import "AssetApplyController.h"
#import "AssetDiliverController.h"
#import "AssetMineController.h"
#import "AssetSearchController.h"
#import "AssetNetWorkHelper.h"
#import "AssetMyAssetsController.h"

#import "TYHWarehouseDefine.h"
#import "WHApplicationController.h"
#import "WHMineController.h"
#import "WHWaitCheckController.h"
#import "WHStatisticsController.h"
#import "WHOutListController.h"
#import "WHNetHelper.h"
#import "WHApplicationModel.h"
#import "WHApplicationListController.h"

#define kWindow  [UIApplication sharedApplication].keyWindow
static  NSString * headerCell =  @"headerCell";

@interface TYHWarehouseManagementController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * carButton;

@property(nonatomic,retain)WHMainPageModel *mainModel;
@end

@implementation TYHWarehouseManagementController
{
    NSMutableArray *itemArray;
    NSString *checkString;
    NSString *grantString;
    NSString *numString;
}

#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpCollectionView];
    [self createBarItem];
    
    [self.view addSubview:self.carButton];
}



#pragma mark - initData
- (void)initDataWithModel:(WHMainPageModel *)model
{
    itemArray = [NSMutableArray array];
    itemArray = [AssetModelHandler getWareHouseItemArrayWithWHMainPageModel:model];
    NSLog(@"%@",itemArray);
}

- (void)getNewData {
    [SVProgressHUD showWithStatus:@"获取数据中"];
    WHNetHelper *helper = [WHNetHelper new];
    [helper getMainPageInfo:^(BOOL successful, WHMainPageModel *model) {
        self.mainModel = [[WHMainPageModel alloc]init];
        self.mainModel = model;
        [self initDataWithModel:model];
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
}


#pragma mark - initView
- (UIButton *)carButton {
    
    if (_carButton == nil) {
        CGFloat height = 49;
        NSString * title = @"我要申领物品";
        self.carButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _carButton = [UIButton addWithTarget:self action:@selector(toReserveCar) title:title titleColor:[UIColor whiteColor] image:@"新建通知" highImage:@"新建通知"];
        _carButton.frame = CGRectMake(0, self.view.height - height , self.view.width, height);
        if (kDevice_Is_iPhoneX) {
            _carButton.frame = CGRectMake(0, self.view.height - height - 24, self.view.width, height);
        }
        _carButton.backgroundColor = [UIColor TabBarColorWarehouse];
    }
    return _carButton;
}


- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor WarehouseBGColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width/5, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    collectionView.frame = CGRectMake(0, AdjustHeight, collectionView.width, collectionView.height - AdjustHeight);
    
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellWithReuseIdentifier:@"ButtonCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"AssetManagerNoticeCell" bundle:nil] forCellWithReuseIdentifier:@"AssetManagerNoticeCell"];
    
    // 注册headView
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}


-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return itemArray.count;
    }
    else
        return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TYHAssetManagerItemModel *managerModel = itemArray[indexPath.row];
        ButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
        cell.managerItemModel = managerModel;
        return cell;
    }
    else
    {
        AssetManagerNoticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetManagerNoticeCell" forIndexPath:indexPath];
        if (![NSString isBlankString:numString]) {
            cell.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
            cell.titleBuQainLabel.text = [NSString stringWithFormat:@"当前您有%@份申请审核通过",@"1"];
        }
        
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        [self.view makeToast:@"网络异常请检查网络" duration:2 position:nil];
        return;
    };
    if (indexPath.section == 0) {
        
        TYHAssetManagerItemModel *model = itemArray[indexPath.item];
        if ([model.itemName isEqualToString:@"我的"]) {
            WHMineController *mineView = [WHMineController new];
            [self.navigationController pushViewController:mineView animated:YES];
        }
        else if ([model.itemName isEqualToString:@"待审核"]) {
            WHWaitCheckController *checkView = [WHWaitCheckController new];
            [self.navigationController pushViewController:checkView animated:YES];
        }
        else if ([model.itemName isEqualToString:@"发放"]) {
            WHApplicationListController *alistView = [WHApplicationListController new];
            [self.navigationController pushViewController:alistView animated:YES];
        }
        else if ([model.itemName isEqualToString:@"出库"]) {
            WHOutListController *diliverView = [WHOutListController new];
            [self.navigationController pushViewController:diliverView animated:YES];
        }
        else if ([model.itemName isEqualToString:@"统计"]) {
            WHStatisticsController *myAssetView = [WHStatisticsController new];
            [self.navigationController pushViewController:myAssetView animated:YES];
        }
    }
    //    ButtonCell * cell = (ButtonCell*)[collectionView cellForItemAtIndexPath:indexPath];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    AssetHeadView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell forIndexPath:indexPath];
    UIColor * color = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    header.backgroundColor = color;
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 10, collectionView.frame.size.width, 40);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(enterAllManager:) forControlEvents:(UIControlEventTouchUpInside)];
    // 添加 俩label
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
    [button addSubview:leftLabel];
    if (indexPath.section == 0) {
        leftLabel.text = @"易耗品管理";
    }
    else
    {
        leftLabel.frame = CGRectMake(40, 5, 100, 30);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"icon_aleart"];
        [button addSubview:imageView];
        leftLabel.text = @"通知提醒";
    }
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.font = [UIFont boldSystemFontOfSize:16];
    // 还有分割线
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, header.width, 0.5f)];
    view.backgroundColor = [UIColor lightGrayColor];
    [button addSubview:view];
    [header addSubview:button];
    
    return header;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize itemSize = CGSizeMake(self.view.width/5, 70);
        return itemSize;
    }
    else
    {
        CGSize itemSize = CGSizeMake(self.view.width, 50);
        return itemSize;
    }
}

// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 50);
}

#pragma mark - Action
// 点击 header
- (void)enterAllManager:(UIButton *)button {
    
}

- (void)toReserveCar {
    WHApplicationController *applyView = [WHApplicationController new];
    [self.navigationController pushViewController:applyView animated:YES];
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"易耗品管理";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorWarehouse]];
    [self.navigationController.navigationBar setValue:@0.8 forKeyPath:@"backgroundView.alpha"];
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault
    
    
    [self getNewData];
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
   
}

@end
