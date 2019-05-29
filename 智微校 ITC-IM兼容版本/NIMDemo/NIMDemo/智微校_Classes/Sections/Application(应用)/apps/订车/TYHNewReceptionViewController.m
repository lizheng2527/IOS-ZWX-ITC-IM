//
//  TYHNewReceptionViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/29/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHNewReceptionViewController.h"
#import "UIView+Extention.h"
#import "ButtonCell.h"
#import "UIView+SDAutoLayout.h"
#import "TYHCarManagerController.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "UIButton+Extention.h"
#import "TYHReverseCarController.h"
#import <UIView+Toast.h>
#import <Reachability.h>
#import "NumberModel.h"
#import "NSString+Empty.h"


#define kWindow  [UIApplication sharedApplication].keyWindow
static  NSString * headerCell =  @"headerCell";

@interface TYHNewReceptionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIWebView * webView2;
@property (nonatomic, strong) UIView * backView; // 蒙版
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) NSMutableDictionary * myOrderCarArray;
@property (nonatomic, strong) NSMutableDictionary * myTaskArray;
@property (nonatomic, strong) NSMutableDictionary * orderCarManagerArray;
@property (nonatomic, strong) NSMutableArray * numberArray;
@property (nonatomic, strong) NSMutableArray * numberArray2;

@property (nonatomic, copy) NSString * orderCheck;
@property (nonatomic, strong) NSDictionary * orderDict;
@property (nonatomic, copy) NSString * webUrl;
@property (nonatomic, strong) UIButton * carButton;
@property (nonatomic, strong) NSArray * dict2;

@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, assign) BOOL IfDriver;

@property (nonatomic, copy) NSString * titleText1;
@property (nonatomic, copy) NSString * titleText2;
@property (nonatomic, copy) NSString * titleText3;

@end

@implementation TYHNewReceptionViewController
{
    CGFloat clientheight2;
    BOOL  popWeb;
    BOOL  orderCheckY;
    BOOL  driverY;
    BOOL  managerY;
    BOOL  normolY;
}
- (NSMutableArray *)numberArray {

    if (_numberArray == nil) {
        self.numberArray = [[NSMutableArray alloc] init];
    }
    return _numberArray;
}
- (NSDictionary *)orderDict {
    
    if (_orderDict == nil) {
        self.orderDict = [[NSDictionary alloc] init];
    }
    return _orderDict;
}

- (NSMutableDictionary *)orderCarManagerArray {

    if (_orderCarManagerArray == nil) {
        self.orderCarManagerArray = [[NSMutableDictionary alloc] init];
    }
    return _orderCarManagerArray;
}
- (NSMutableDictionary *)myTaskArray {

    if (_myTaskArray == nil) {
        self.myTaskArray = [[NSMutableDictionary alloc] init];
    }
    return _myTaskArray;
}


- (NSMutableDictionary *)myOrderCarArray {

    if (_myOrderCarArray == nil) {
        self.myOrderCarArray = [[NSMutableDictionary alloc] init];
    }
    return _myOrderCarArray;
}
- (UIButton *)carButton {

    if (_carButton == nil) {
        CGFloat height = 49;
        NSString * title = @"我要订车";
        self.carButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _carButton = [UIButton addWithTarget:self action:@selector(toReserveCar) title:title titleColor:[UIColor lightGrayColor] image:@"新建通知" highImage:@"新建通知"];
        _carButton.frame = CGRectMake(0, self.view.height - height , self.view.width, height);
        _carButton.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    }
    return _carButton;
}
- (NSMutableArray *)numberArray2 {

    if (_numberArray2 == nil) {
        _numberArray2 = [[NSMutableArray alloc] init];
    }
    return _numberArray2;
}
- (void)initData {
    
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGINNAME];
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    if(!_password.length) _password = @"";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1]];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.carButton];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self.scrollView addSubview:self.webView];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.webView.sd_layout
    .leftSpaceToView(_scrollView,5)
    .rightSpaceToView(_scrollView, 5)
    .topSpaceToView(_scrollView, AdjustHeight + 2.5)
    .heightIs(50);
    
    _webView.layer.masksToBounds = YES;
    _webView.layer.cornerRadius = 3.f;
    _webView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _webView.layer.borderWidth = .5f;
    
    [self setUpWebViewData];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    
    // 3 是由谁身份决定的 默认是3 有2,1

    [self setUpCollectionView];
    self.collectionView.sd_layout
    .leftSpaceToView(_scrollView, 0)
    .rightSpaceToView(_scrollView, 0)
    .topSpaceToView(self.webView, 2.5)
    .heightIs((self.view.width/4 + 50)*3);
    [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [window addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在获取详情";
    
    self.hub = hub;
    
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    // 这是需要传递到下个页面的数据
    NSString * str = [NSString stringWithFormat:@"%@/cm/carMobile!getInputBaseInformation.action?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,_userName,_password,dataSourceName];
    [TYHHttpTool get:str params:nil success:^(id json) {
        // 我要 订车
//        NSLog(@"json = json = %@",json);
        self.dict2 = json[@"deptData"];
    } failure:^(NSError *error) {
        [self.hub removeFromSuperview];
    }];
}

- (void)getNewData {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSString * urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getIndex.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&operationCode=carmanage&dataSourceName=%@",k_V3ServerURL,_userName,_password,dataSourceName];

    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
        // json 字典  2 = orderCarManage 3 =  myTask  1 = myOrderCar
        [self.hub removeFromSuperview];
        if (self.numberArray.count != 0) {
            [self.numberArray removeAllObjects];
        }
        
        self.myOrderCarArray = json[@"myOrderCar"];
        self.orderCarManagerArray = json[@"orderCarManage"];//
        self.myTaskArray = json[@"myTask"];
        
        if (self.myOrderCarArray.count > 0) {
            
            // 普通
            normolY = YES;  // 这个都会出现
            [self.numberArray addObject:self.myOrderCarArray];
        } else {
            normolY = NO;
        }
        
        if (self.orderCarManagerArray.count > 0) {
            
            managerY = YES;
            // 管理员
            [self.numberArray addObject:self.orderCarManagerArray];
        } else {
            
            // 表示司机 或者 管理
            managerY = NO;
            
        }
        if (self.myTaskArray.count > 0) {
            
            driverY = YES;
            // 司机
            [self.numberArray addObject:self.myTaskArray];
        } else {
        
            driverY = NO;
        }
        
        NSString * number = json[@"orderCarManage"][@"orderCheck"];
        if (number) {
            orderCheckY = [number intValue] >= 0 ? YES:NO;
        } else {
            
            orderCheckY = NO;
        }
        
        self.numberArray2 = [NumberModel mj_objectArrayWithKeyValuesArray:self.numberArray];
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        [self.hub removeFromSuperview];
    }];

    
    
}

- (UIWebView *)webView {
    
    if (_webView == nil) {
        
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        self.webView.scrollView.bounces = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.userInteractionEnabled = YES;
        self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        // webView 添加手势
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclikeWeb:)];
        singleTap.delegate= self;
        singleTap.cancelsTouchesInView = NO;
        [self.webView addGestureRecognizer:singleTap];
        
    }
    return _webView;
}
- (UIWebView *)webView2 {
    
    if (_webView2 == nil) {
        
        self.webView2 = [[UIWebView alloc] init];
        self.webView2.delegate = self;
        self.webView2.scrollView.bounces = NO;
        self.webView2.dataDetectorTypes = UIDataDetectorTypeNone;
        self.webView2.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView2.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _webView2;
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
    label.backgroundColor = [UIColor TabBarColorOrange];
    label.text = @"订车须知";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(_popView.width - 36, 7, 26, 26);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_popView addSubview:button];

    [button setImage:[UIImage imageNamed:@"btn_cm_close"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(closePopView) forControlEvents:(UIControlEventTouchUpInside)];
//
    // 添加内容
    [self.popView addSubview:self.webView2];
    [self setUpWebViewData];
    [self.webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];

    //  添加蒙版
    [kWindow addSubview:self.backView];
    self.backView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    // 在蒙版上添加 popView;
    [kWindow addSubview:self.popView];
    [kWindow bringSubviewToFront:self.popView];
}

- (void)closePopView {

    [_backView removeFromSuperview];
    [_popView removeFromSuperview];
    _backView = nil;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}
- (void)setUpWebViewData {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSString * webUrl = [NSString stringWithFormat:@"%@/cm/carMobile!getNotice.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&dataSourceName=%@",k_V3ServerURL,_userName,_password,dataSourceName];
    
    self.webUrl = webUrl;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error) {
        [self.hub removeFromSuperview];
        [self.view makeToast:@"数据异常" duration:2 position:nil];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    //设置到WebView上
    clientheight2 = [clientheight_str floatValue];
    if (clientheight2 > 100 && popWeb) {
        webView.frame = CGRectMake(5, 5, self.view.frame.size.width, 160);
    } else {
        webView.frame = CGRectMake(0, 44, _popView.width, _popView.height - 44);
    }//  少大约20 自己加上的
    
    //NSString * contentStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    
}
- (void)setUpCollectionView {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width/4, self.view.width/4 - 10);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellWithReuseIdentifier:@"ButtonCell"];
    
    // 注册headView
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.scrollView addSubview:collectionView];
    
}

- (void)toReserveCar {
    TYHReverseCarController * reverseCar = [[TYHReverseCarController alloc] init];
    reverseCar.title = @"我的订车单";
    reverseCar.userName = _userName;
    reverseCar.password = _password;
    reverseCar.urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!saveOrderCar.action",k_V3ServerURL];
    NSString * departmentId = @"";
    NSString * name = @"";
    if (self.dict2.count >= 1 && ![NSString isBlankString:self.dict2[0][@"id"]] ) {
        departmentId = self.dict2[0][@"id"];
    }
    if ( self.dict2.count >= 1 && ![NSString isBlankString:self.dict2[0][@"name"]] ) {
        name = self.dict2[0][@"name"];
    }
    reverseCar.departmentId = departmentId;
    reverseCar.department = name;
    
    [self.navigationController pushViewController:reverseCar animated:YES];
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.numberArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.numberArray[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    if (normolY) { // 正常情况
            
        if (managerY) { // 是否是管理员
        
            if (indexPath.section == 0 && self.numberArray[0] != nil) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待派车";
                    cell.backImage.image = [UIImage imageNamed:@"待派车"];
                    NSString * num = self.numberArray[0][@"dpc"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[0][@"pcz"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"派车中";
                    cell.backImage.image = [UIImage imageNamed:@"派车中"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[0][@"ypc"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"已派车";
                    cell.backImage.image = [UIImage imageNamed:@"已派车"];
                } else if (indexPath.item == 3) {
                    
                    cell.name.text = @"待评价";
                    NSString * num = self.numberArray[0][@"dpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.backImage.image = [UIImage imageNamed:@"待评价"];
                }
                
            } else if (indexPath.section == 1 ) {
                
                if (orderCheckY) {
                    if (indexPath.item == 0) {
                        cell.name.text = @"待审核";
                        cell.backImage.image = [UIImage imageNamed:@"待审核"];
                        NSString * num = self.numberArray[1][@"orderCheck"];
                        [self getCellHidden:cell withNum:num];
                    } else if (indexPath.item == 1) {
                        
                        cell.name.text = @"待派车";
                        cell.backImage.image = [UIImage imageNamed:@"未派车b"];
                        NSString * num = self.numberArray[1][@"dpc"];
                        [self getCellHidden:cell withNum:num];
                    } else if (indexPath.item == 2) {
                        
                        NSString * num = self.numberArray[1][@"pcz"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"派车中";
                        cell.backImage.image = [UIImage imageNamed:@"派车中b"];
                    } else if (indexPath.item == 3) {
                        
                        NSString * num = self.numberArray[1][@"ypc"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"已派车";
                        cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    }
                } else {
                    
                    if (indexPath.item == 0) {
                        cell.name.text = @"待派车";
                        cell.backImage.image = [UIImage imageNamed:@"未派车b"];
                        NSString * num = self.numberArray[1][@"dpc"];
                        [self getCellHidden:cell withNum:num];
                    } else if (indexPath.item == 1) {
                        
                        NSString * num = self.numberArray[1][@"pcz"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"派车中";
                        cell.backImage.image = [UIImage imageNamed:@"派车中b"];
                    } else if (indexPath.item == 2) {
                        
                        NSString * num = self.numberArray[1][@"ypc"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"已派车";
                        cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    }
                    
                }
                
            } else if (indexPath.section == 2) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待确认";
                    cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    NSString * num = self.numberArray[2][@"wqr"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[2][@"wjs"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待结束";
                    cell.backImage.image = [UIImage imageNamed:@"未审核b"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[2][@"wpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待反馈";
                    cell.backImage.image = [UIImage imageNamed:@"待评价c"];
                }
                
            }

        } else {
            
        
            if (indexPath.section == 0 && self.numberArray[0] != nil) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待派车";
                    cell.backImage.image = [UIImage imageNamed:@"待派车"];
                    NSString * num = self.numberArray[0][@"dpc"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[0][@"pcz"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"派车中";
                    cell.backImage.image = [UIImage imageNamed:@"派车中"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[0][@"ypc"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"已派车";
                    cell.backImage.image = [UIImage imageNamed:@"已派车"];
                } else if (indexPath.item == 3) {
                    
                    cell.name.text = @"待评价";
                    NSString * num = self.numberArray[0][@"dpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.backImage.image = [UIImage imageNamed:@"待评价"];
                }
                
            }
            else if (indexPath.section == 1 ) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待确认";
                    cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    NSString * num = self.numberArray[1][@"wqr"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[1][@"wjs"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待结束";
                    cell.backImage.image = [UIImage imageNamed:@"未审核b"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[1][@"wpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待反馈";
                    cell.backImage.image = [UIImage imageNamed:@"待评价c"];
                }
            }
        }
    }
    else { // 没有我的订车单
        // 不正常情况
        if (managerY) { // 有订车单管理
            if (indexPath.section == 0 && self.numberArray[0] != nil) {
                if (orderCheckY) {
                    if (indexPath.item == 0) {
                        cell.name.text = @"待审核";
                        cell.backImage.image = [UIImage imageNamed:@"待审核"];
                        NSString * num = self.numberArray[0][@"orderCheck"];
                        [self getCellHidden:cell withNum:num];
                        
                    } else if (indexPath.item == 1) {
                        
                        cell.name.text = @"待派车";
                        cell.backImage.image = [UIImage imageNamed:@"未派车b"];
                        NSString * num = self.numberArray[0][@"dpc"];
                        [self getCellHidden:cell withNum:num];
                    } else if (indexPath.item == 2) {
                        
                        NSString * num = self.numberArray[0][@"pcz"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"派车中";
                        cell.backImage.image = [UIImage imageNamed:@"派车中b"];
                    } else if (indexPath.item == 3) {
                        
                        NSString * num = self.numberArray[0][@"ypc"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"已派车";
                        cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    }
                } else {
                    
                    if (indexPath.item == 0) {
                        cell.name.text = @"待派车";
                        cell.backImage.image = [UIImage imageNamed:@"未派车b"];
                        NSString * num = self.numberArray[0][@"dpc"];
                        [self getCellHidden:cell withNum:num];
                    } else if (indexPath.item == 1) {
                        
                        NSString * num = self.numberArray[0][@"pcz"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"派车中";
                        cell.backImage.image = [UIImage imageNamed:@"派车中b"];
                    } else if (indexPath.item == 2) {
                        
                        NSString * num = self.numberArray[0][@"ypc"];
                        [self getCellHidden:cell withNum:num];
                        cell.name.text = @"已派车";
                        cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    }
                }
                
            } else if (indexPath.section == 1 ) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待确认";
                    cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    NSString * num = self.numberArray[1][@"wqr"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[1][@"wjs"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待结束";
                    cell.backImage.image = [UIImage imageNamed:@"未审核b"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[1][@"wpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待反馈";
                    cell.backImage.image = [UIImage imageNamed:@"待评价c"];
                }
  
            }
        } else { // 无订车单 只有我的任务
            if (indexPath.section == 0 && self.numberArray[0] != nil) {
                
                if (indexPath.item == 0) {
                    cell.name.text = @"待确认";
                    cell.backImage.image = [UIImage imageNamed:@"已派车b"];
                    NSString * num = self.numberArray[0][@"wqr"];
                    [self getCellHidden:cell withNum:num];
                } else if (indexPath.item == 1) {
                    
                    NSString * num = self.numberArray[0][@"wjs"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待结束";
                    cell.backImage.image = [UIImage imageNamed:@"未审核b"];
                } else if (indexPath.item == 2) {
                    
                    NSString * num = self.numberArray[0][@"wpj"];
                    [self getCellHidden:cell withNum:num];
                    cell.name.text = @"待反馈";
                    cell.backImage.image = [UIImage imageNamed:@"待评价c"];
                }
            }
        }
    }
    
    return cell;
}
- (void)getCellHidden:(ButtonCell *)cell withNum:(NSString *)num {
    // 不论 num 是NSString 还是 NSNumber
   int number =  [num intValue];
    
    if (number == 0) {
        
        cell.number.hidden = YES;
    } else {
        
        cell.number.hidden = NO;
        cell.number.text = [NSString stringWithFormat:@"%d",number];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ButtonCell * cell = (ButtonCell*)[collectionView cellForItemAtIndexPath:indexPath];
   
    NSInteger index;
    NSInteger index2;
    TYHCarManagerController * carManager = [[TYHCarManagerController alloc] init];
    
    // 计算每行个数
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        [self.view makeToast:@"网络异常请检查网络" duration:2 position:nil];
        return;
    };
    
    index2 = [self.numberArray[indexPath.section] count];
   
    if (normolY) { // 正常情况
        
        if (managerY) { // 是否是管理员
   
            if (indexPath.section == 0) {
                // 5个页面
                index = indexPath.item + 1;
                index2 = index2 + 1;
                carManager.title = self.titleText1;
            } else if (indexPath.section == 1) {
                
                // 6个页面
                if (index2 == 3) {
                    
                    index = indexPath.item + 2;
                    carManager.uncheckTag = 2000;
                    
                } else {
                    index = indexPath.item + 1;
                }
                index2 = 6;
                
                carManager.title = self.titleText2;
                
            } else if (indexPath.section == 2) {
                
                // 4 个页面
                index = indexPath.item + 1;
                index2 = index2 + 1;
                carManager.title = self.titleText3;
            }
        } else { // 没有管理员
            
            if (indexPath.section == 0) {
                // 5个页面
                index = indexPath.item + 1;
                index2 = index2 + 1;
                carManager.title = self.titleText1;
            } else if (indexPath.section == 1) {
                
                // 4 个页面
                index = indexPath.item + 1;
                index2 = index2 + 1;
                carManager.title = self.titleText3;
                
            }
        
        }

    } else { // 没有订车单
        
         if (managerY) {
         
             if (indexPath.section == 0) {
                 // 6个页面
                 if (index2 == 3) {
                     
                     index = indexPath.item + 2;
                     carManager.uncheckTag = 2000;
                     
                 } else {
                     index = indexPath.item + 1;
                 }
                 index2 = 6;
                 
                 carManager.title = self.titleText2;
                 
             } else if (indexPath.section == 2) {
                 
                 // 4 个页面
                 index = indexPath.item + 1;
                 index2 = index2 + 1;
                 carManager.title = self.titleText3;
             }
            
         }
         else {
             
             if (indexPath.section == 0) { // 只是司机的情况
                 
                 // 4 个页面
                 index = indexPath.item + 1;
                 index2 = index2 + 1;
                 carManager.title = self.titleText3;
             }
             
         }
    
    }
    
    
    carManager.name = cell.name.text;
    carManager.indexItem = index;
    carManager.indexAll = index2;
    carManager.userName = self.userName;
    carManager.password = self.password;
    carManager.userId = self.userId;
    [self.navigationController pushViewController:carManager animated:YES];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell forIndexPath:indexPath];
    UIColor * color = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    header.backgroundColor = color;
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 10, collectionView.frame.size.width, 40);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(enterAllManager:) forControlEvents:(UIControlEventTouchUpInside)];
    button.tag = indexPath.section + 1000;
    // 添加 俩label
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    [button addSubview:leftLabel];
    leftLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(header.width - 120, 5, 110, 30)];
    rightLabel.text = @"查看全部订车单>";
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.textColor = [UIColor grayColor];
    [button addSubview:rightLabel];
    // 还有分割线
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, header.width, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [button addSubview:view];
    
//    NSLog(@"_numberArray = %@",_numberArray);
    
    if (normolY) { // 正常情况
        
        if (managerY) { // 是否是管理员
        
            if (indexPath.section == 0) {
                
                leftLabel.text = @"我的订车单";
                self.titleText1 = leftLabel.text;
                
            } else if (indexPath.section == 1) {
                
                leftLabel.text = @"订车单管理";
                self.titleText2 = leftLabel.text;
            } else if (indexPath.section == 2){
                
                leftLabel.text = @"我的任务";
                self.titleText3 = leftLabel.text;
            }
        } else {
            
            if (indexPath.section == 0) {
                
                leftLabel.text = @"我的订车单";
                self.titleText1 = leftLabel.text;
                
            } else if (indexPath.section == 1) {
                
                leftLabel.text = @"我的任务";
                self.titleText3 = leftLabel.text;
            }
        
        }
    } else {
    
        if (managerY) { // 是管理员
            
            if (indexPath.section == 0) {
                
                leftLabel.text = @"订车单管理";
                self.titleText1 = leftLabel.text;
                
            } else if (indexPath.section == 1) {
                
                leftLabel.text = @"我的任务";
                self.titleText3 = leftLabel.text;
                
            }
        }
        else { // 只是司机
            if (indexPath.section == 0) {
                
                leftLabel.text = @"我的任务";
                self.titleText3 = leftLabel.text;
            }
        }
        
    }
    [header addSubview:button];
    
    return header;
}
// 点击 header
- (void)enterAllManager:(UIButton *)button {

    TYHCarManagerController * contentVC = [[TYHCarManagerController alloc] init];
    
    NSInteger index2;
    index2 = [self.numberArray[button.tag - 1000] count];
    
    if (normolY) { // 正常情况
        
        if (managerY) { // 是否是管理员
    
            if (button.tag - 1000 == 0) {
                
                // 5个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText1;
            } else if (button.tag - 1000 == 1) {
                
                // 6个页面// 6个页面
                index2 = 6;
                contentVC.title = self.titleText2;
                
            } else if (button.tag - 1000 == 2) {
                
                // 4 个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText3;
            }
        }
        else {

            if (button.tag - 1000 == 0) {
                
                // 5个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText1;
            } else if (button.tag - 1000 == 1) {
                
                // 4 个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText3;
            }
        }

    } else {
        
        if (managerY) {
            
            if (button.tag - 1000 == 0) {
                
                // 6个页面// 6个页面
                index2 = 6;
                contentVC.title = self.titleText2;
                
            } else if (button.tag - 1000 == 1) {
                
                // 4 个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText3;
            }
        } else {
            
            if (button.tag - 1000 == 1) {
                
                // 4 个页面
                index2 = index2 + 1;
                contentVC.title = self.titleText3;
            }
        }
    }
    
    
    contentVC.indexItem = 0;  // 默认显示页面
    contentVC.indexAll = index2; // title 个数
    contentVC.userName = self.userName;
    contentVC.password = self.password;
    contentVC.userId = self.userId;
    
    [self.navigationController pushViewController:contentVC animated:YES];
}

// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, 50);
    
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"订车管理";
    
    popWeb = YES;
    [self getNewData];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorOrange]];
}
@end
