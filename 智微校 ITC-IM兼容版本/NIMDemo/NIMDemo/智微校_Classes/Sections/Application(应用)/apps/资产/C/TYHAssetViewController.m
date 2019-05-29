//
//  TYHAssetViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/18.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHAssetViewController.h"
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


#define kWindow  [UIApplication sharedApplication].keyWindow
static  NSString * headerCell =  @"headerCell";
typedef NS_ENUM(NSInteger, AssetManagerInteger) {
    ManagerIntegerNomal,
    ManagerIntegerManager,
    ManagerIntegerTask
};


@interface TYHAssetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * carButton;

@end

@implementation TYHAssetViewController
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
    [self initData];
    [self setUpCollectionView];
    [self createBarItem];
    [self.view addSubview:self.carButton];
}



#pragma mark - initData
- (void)initData {
    itemArray = [NSMutableArray array];
    _userName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *V3Pwd = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    if ([NSString isBlankString:V3Pwd]) {
        V3Pwd = @"";
    }
    _password = V3Pwd;
    itemArray = [AssetModelHandler getAssetManagerItemArrayWithUserKind:0];
}

- (void)getNewData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getIndexJson:^(BOOL successful, TYHAssetManagerItemModel *tmpModel) {
        checkString = tmpModel.check;
        grantString = tmpModel.grant;
        [helper getGrantNumJson:^(BOOL successful, TYHAssetManagerItemModel *tmpModel) {
            numString = tmpModel.num;
            [hud removeFromSuperview];
            [self.collectionView reloadData];
        } failure:^(NSError *error) {
            [hud removeFromSuperview];
        }];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
    
}


#pragma mark - initView
- (UIButton *)carButton {
    
    if (_carButton == nil) {
        CGFloat height = 49;
        NSString * title = @"我要申请资产";
        self.carButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _carButton = [UIButton addWithTarget:self action:@selector(toReserveCar) title:title titleColor:[UIColor grayColor] image:@"新建通知" highImage:@"新建通知"];
        _carButton.frame = CGRectMake(0, self.view.height - height - 64, self.view.width, height);
        if (kDevice_Is_iPhoneX) {
            _carButton.frame = CGRectMake(0, self.view.height - height - 64 - 34, self.view.width, height);
        }
        _carButton.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    }
    return _carButton;
}


- (void)setUpCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width/4, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    
    
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
        if (indexPath.row == 1) {
            cell.number.text = checkString;
            if ([checkString integerValue] > 0) {
                cell.number.hidden = NO;
            }
        }
        if (indexPath.row == 2) {
            cell.number.text = grantString;
            if ([grantString integerValue] > 0) {
                cell.number.hidden = NO;
            }
        }
        return cell;
    }
    else
    {
        AssetManagerNoticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetManagerNoticeCell" forIndexPath:indexPath];
        if (![NSString isBlankString:numString]) {
            cell.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
            
            cell.titleBuQainLabel.text = [NSString stringWithFormat:@"当前您有%@个需要补签的发放记录,请及时到管理员处补签",numString];
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
        switch (indexPath.row) {
            case 0:
            {
                AssetMineController *mineView = [AssetMineController new];
                [self.navigationController pushViewController:mineView animated:YES];
                
            }break;
            case 1:
            {
                AssetCheckController *checkView = [AssetCheckController new];
                [self.navigationController pushViewController:checkView animated:YES];
            }break;
            case 2:
            {
                AssetDiliverController *diliverView = [AssetDiliverController new];
                [self.navigationController pushViewController:diliverView animated:YES];
            }break;
            case 3:
            {
                AssetMyAssetsController *myAssetView = [AssetMyAssetsController new];
                [self.navigationController pushViewController:myAssetView animated:YES];
            }
                break;
            default:
                break;
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
        leftLabel.text = @"资产管理";
    }
    else
    {
        leftLabel.frame = CGRectMake(40, 5, 100, 30);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"icon_aleart"];
        [button addSubview:imageView];
        leftLabel.text = @"资产提醒";
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
        CGSize itemSize = CGSizeMake(self.view.width/4, 70);
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
    AssetApplyController *applyView = [AssetApplyController new];
    [self.navigationController pushViewController:applyView animated:YES];
    
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"资产管理";
    
    [self getNewData];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorAssetColor]];
    [self.view endEditing:YES];
    
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
   
//    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
}
@end
