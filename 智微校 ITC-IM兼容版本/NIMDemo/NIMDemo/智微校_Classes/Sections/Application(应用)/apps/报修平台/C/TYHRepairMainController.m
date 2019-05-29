//
//  TYHRepairMainController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHRepairMainController.h"
#import "UIView+SDAutoLayout.h"
#import <Reachability.h>
#import "TYHRepairDefine.h"
#import "TYHRepairMainHeaderView.h"
#import "UIButton+Extention.h"
#import "TYHRepairItemCell.h"

#import "TYHNewRepairController.h"
#import "TYHRepairMainModel.h"
#import "TYHRepairNetRequestHelper.h"

#import "MyRepairServiceMainController.h"
#import "RepairManagementMainController.h"
#import "MyReairApplicationMainController.h"
#import "NSString+NTES.h"

#define kWindow  [UIApplication sharedApplication].keyWindow
static  NSString * repairHeaderCell =  @"TYHRepairMainHeaderView";

@interface TYHRepairMainController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TYHRepairMainHeaderViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,CAAnimationDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * carButton;

@property(nonatomic,retain)NSMutableArray *itemArray;

//顶部栏描述
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIWebView * webView2;
@property (nonatomic, strong) UIView * backView; // 蒙版
@property (nonatomic, strong) UIView * popView;
@end

@implementation TYHRepairMainController
{
    NSString *checkString;
    NSString *grantString;
    NSString *numString;
    
    NSString *mainInfoString;
    
    CGFloat clientheight2;
    BOOL popWeb;
}

#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpCollectionView];
    [self createBarItem];
    [self webViewConfig];
    
    [self.view addSubview:self.carButton];
}



#pragma mark - initData
- (void)getNewData {
    
    
    __weak typeof(self) weakSelf = self;
    
    
    [SVProgressHUD showWithStatus:@"正在获取报修数据"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper getRepairMainIndexInfo:^(BOOL successful, NSMutableArray *repairItemArray,NSString *describitionString) {
        _itemArray = [NSMutableArray arrayWithArray:repairItemArray];
        
        if ([NSString isBlankString:describitionString] || [describitionString isEqualToString:@"<p><br /></p>"] || [describitionString isEqualToString:@"(null)"]) {
            mainInfoString = @"暂无报修须知";
        }
        else mainInfoString = describitionString;

        [weakSelf.webView loadHTMLString:mainInfoString baseURL:nil];
        
        [SVProgressHUD dismiss];
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取最新报修数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
}

#pragma mark - initView
- (UIButton *)carButton {
    
    if (_carButton == nil) {
        CGFloat height = 49;
        NSString * title = @"我要报修";
        self.carButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _carButton = [UIButton addWithTarget:self action:@selector(toReserveCar) title:title titleColor:[UIColor whiteColor] image:@"新建通知" highImage:@"新建通知"];
        _carButton.frame = CGRectMake(0, self.view.height - height , self.view.width, height);
        if (kDevice_Is_iPhoneX) {
            _carButton.frame = CGRectMake(0, self.view.height - height  - 24, self.view.width, height);
        }
        _carButton.backgroundColor = [UIColor TabBarColorRepair];
    }
    return _carButton;
}

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor RepairBGColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width/4, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 75 + AdjustHeight , SCREEN_WIDTH, SCREEN_HEIGHT - 75 - AdjustHeight) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;

    [collectionView registerNib:[UINib nibWithNibName:@"TYHRepairItemCell" bundle:nil] forCellWithReuseIdentifier:@"TYHRepairItemCell"];
    // 注册headView
    [collectionView registerClass:[TYHRepairMainHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:repairHeaderCell];
    
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
    return _itemArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_itemArray[section] isKindOfClass:[myRepairModel class]]) {
        return 4;
    }
    else if([_itemArray[section] isKindOfClass:[repairManageModel class]])
    {
        return 4;
    }
    else if([_itemArray[section] isKindOfClass:[myTaskModel class]])
    {
        return 2;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TYHRepairItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYHRepairItemCell" forIndexPath:indexPath];
    cell.number.backgroundColor = [UIColor redColor];
    cell.number.textColor = [UIColor whiteColor];
    if ([_itemArray[indexPath.section] isKindOfClass:[myRepairModel class]]) {
        switch (indexPath.item) {
            case 0:
            {
                cell.name.text = @"未接单";
                cell.number.text = [_itemArray[indexPath.section] wjd];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_wjd_a"];
                return cell;
            }
                break;
            case 1:
            {
                cell.name.text = @"维修中";
                cell.number.text = [_itemArray[indexPath.section] wxz];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_wxz_a"];
                return cell;
            }
                break;
            case 2:
            {
                cell.name.text = @"待评价";
                cell.number.text = [_itemArray[indexPath.section] dfk];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_dfk_a"];
                return cell;
            }
                break;
            case 3:
            {
                cell.name.text = @"已完成";
                cell.number.text = [_itemArray[indexPath.section] yxh];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_yxh_a"];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else if([_itemArray[indexPath.section] isKindOfClass:[repairManageModel class]])
    {
        switch (indexPath.item) {
            case 0:
            {
                cell.name.text = @"待处理";
                cell.number.text = [_itemArray[indexPath.section] dcl];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_dcl_b"];
                return cell;
            }
                break;
            case 1:
            {
                cell.name.text = @"已派单";
                cell.number.text = [_itemArray[indexPath.section] ypd];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_ypd_b"];
                return cell;
            }
                break;
            case 2:
            {
                cell.name.text = @"已完成";
                cell.number.text = [_itemArray[indexPath.section] ywc];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_yxh_a"];
                return cell;
            }
                break;
            case 3:
            {
                cell.name.text = @"费用审批";
                cell.number.text = [_itemArray[indexPath.section] fysp];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_fysp_b"];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else if([_itemArray[indexPath.section] isKindOfClass:[myTaskModel class]])
    {
        switch (indexPath.item) {
            case 0:
            {
                cell.name.text = @"维修中";
                cell.number.text = [_itemArray[indexPath.section] wxz];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_wxz_a"];
                return cell;
            }
                break;
            case 1:
            {
                cell.name.text = @"已完成";
                cell.number.text = [_itemArray[indexPath.section] yfk];
                cell.backImage.image = [UIImage imageNamed:@"icon_rm_yxh_a"];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model  = _itemArray[indexPath.section];
    if ([model isKindOfClass:[myRepairModel class]]) {
        
        MyReairApplicationMainController *repairView = [MyReairApplicationMainController new];
        repairView.defaultIndex = indexPath.item + 1;
        [self.navigationController pushViewController:repairView animated:YES];
        
    }
    else if([model isKindOfClass:[repairManageModel class]]) {
        
        RepairManagementMainController *repairView = [RepairManagementMainController new];
        repairView.defaultIndex = indexPath.item + 1;
        [self.navigationController pushViewController:repairView animated:YES];
        
    }
    else if([model isKindOfClass:[myTaskModel class]]) {
        
        MyRepairServiceMainController *repairView = [MyRepairServiceMainController new];
        repairView.defaultIndex = indexPath.item + 1;
        [self.navigationController pushViewController:repairView animated:YES];
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TYHRepairMainHeaderView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:repairHeaderCell forIndexPath:indexPath];
    header.delegate = self;
    if ([_itemArray[indexPath.section] isKindOfClass:[myRepairModel class]]) {
        header.titleLabel.text = @"我的报修";
        [header.checkBtn setTitle:@"查看全部报修单" forState:UIControlStateNormal];
        header.type = @"0";
    }
    else if([_itemArray[indexPath.section] isKindOfClass:[repairManageModel class]])
    {
        header.titleLabel.text = @"报修管理";
        [header.checkBtn setTitle:@"查看全部维修单" forState:UIControlStateNormal];
        header.type = @"1";
    }
    else if([_itemArray[indexPath.section] isKindOfClass:[myTaskModel class]])
    {
        header.titleLabel.text = @"我的维修";
        [header.checkBtn setTitle:@"查看全部维修单" forState:UIControlStateNormal];
        header.type = @"2";
    }
    return header;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/4, 70);
        return itemSize;
}


// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 40);
}


#pragma mark - HeaderViewDelegate
-(void)CheckAllRepairListWithType:(NSString *)type
{
    switch ([type integerValue]) {
        case 0:
        {
            MyReairApplicationMainController *repairView = [MyReairApplicationMainController new];
            repairView.defaultIndex = 0;
            [self.navigationController pushViewController:repairView animated:YES];
        }
            break;
        case 1:
        {
            RepairManagementMainController *repairView = [RepairManagementMainController new];
            repairView.defaultIndex = 0;
            [self.navigationController pushViewController:repairView animated:YES];
        }
            break;
        case 2:
        {
            MyRepairServiceMainController *repairView = [MyRepairServiceMainController new];
            repairView.defaultIndex = 0;
            [self.navigationController pushViewController:repairView animated:YES];
        }
            break;
        default:
            break;
    }
}




#pragma mark - Action
- (void)toReserveCar {
    TYHNewRepairController *applyView = [TYHNewRepairController new];
    [self.navigationController pushViewController:applyView animated:YES];
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - WebAbout

- (void)webViewConfig {
        self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.userInteractionEnabled = YES;
    self.webView.multipleTouchEnabled = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
        
        _webView.layer.masksToBounds = YES;
        _webView.layer.cornerRadius = 3.f;
        _webView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _webView.layer.borderWidth = .5f;
    
//    self.webView.sd_layout
//    .leftSpaceToView(self.collectionView,0)
//    .rightSpaceToView(self.collectionView, 0)
//    .topSpaceToView(self.collectionView, 0)
//    .heightIs(30);
    
    [self.view addSubview:self.webView];
    
    
    self.webView2 = [[UIWebView alloc] init];
    self.webView2.delegate = self;
    self.webView2.scrollView.bounces = NO;
    self.webView2.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView2.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView2.scrollView.showsVerticalScrollIndicator = NO;
    
    UILabel *tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, AdjustHeight, SCREEN_WIDTH, 75)];
    tapLabel.backgroundColor = [UIColor clearColor];
    tapLabel.userInteractionEnabled = YES;
    [self.view addSubview:tapLabel];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclikeWeb:)];
    singleTap.delegate= self;
    //        singleTap.cancelsTouchesInView = NO;
    [tapLabel addGestureRecognizer:singleTap];
    
}

// 手势 蒙版
- (void)onclikeWeb:(UITapGestureRecognizer *)tap {
    // 动画展示
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = 20;
        CGFloat y = 134;
        CGFloat width = self.view.width - 2 * x;
        CGFloat heigth = 300;
        self.popView.frame = CGRectMake(x, y, width, heigth);
    }];
    
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    [animation setDelegate:self];
    animation.values = @[@(0)];
    animation.duration = 0.5;
    [animation setKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.popView.layer addAnimation:animation forKey:@"shake"];
    // 添加标题
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _popView.width, 44)];
    
    [_popView addSubview:label];
    label.backgroundColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:216/255.0 alpha:1];
    label.text = @"报修须知";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(_popView.width - 36, 7, 26, 26);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_popView addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"btn_cm_close"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(closePopView) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.webView2 loadHTMLString:mainInfoString baseURL:nil];
    //
    // 添加内容
    [self.popView addSubview:self.webView2];
    
    //  添加蒙版
    [kWindow addSubview:self.backView];
    self.backView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    // 在蒙版上添加 popView;
    [kWindow addSubview:self.popView];
    [kWindow bringSubviewToFront:self.popView];
}


- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        popWeb = NO;
    }
    return _backView;
}
- (UIView *)popView {
    
    if (_popView == nil) {
        
        self.popView = [[UIView alloc] init];
        _popView.layer.masksToBounds = YES;
        _popView.layer.cornerRadius = 4;
        self.popView.backgroundColor = [UIColor whiteColor];
    }
    return _popView;
}

- (void)closePopView {
    
    [_backView removeFromSuperview];
    [_popView removeFromSuperview];
    _backView = nil;
    _popView = nil;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    clientheight2 = [clientheight_str floatValue];
    if (clientheight2 > 100 && popWeb) {
        webView.frame = CGRectMake(5, AdjustHeight + 5 , self.view.frame.size.width - 10, 70);
    } else {
        if ([webView isEqual:self.webView2]) {
            webView.frame = CGRectMake(0, 44, _popView.width, _popView.height - 44);
        }
    }
    
    if ([webView isEqual:self.webView]) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
    }
    if ([webView isEqual:self.webView2]) {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'";
        [_webView2 stringByEvaluatingJavaScriptFromString:str];
    }
}


#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"报修";
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorRepair]];
    
    [self.view endEditing:YES];
    
    popWeb = YES;
    [self getNewData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
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
