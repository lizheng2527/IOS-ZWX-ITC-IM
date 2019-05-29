//
//  TYHPaiViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/13/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHPaiViewController.h"
#import "PaiCheCell.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "PaiCarModel.h"
#import "TitleButton.h"
#import "DropDownMenu.h"
#import "TYHCarTitleController.h"
#import "UIView+Extention.h"
#import "CarDataModel.h"
#import "SchoolDataModel.h"
#import "AggignDataModel.h"
#import <UIImageView+WebCache.h>
#import "TYHCreatOrderController.h"
#import "PublicDefine.h"
#import <UIView+Toast.h>

@interface TYHPaiViewController ()<UITableViewDelegate,UITableViewDataSource,DropDownMenuDelegate,TitleMenuDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topViewLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * schoolArray;
@property (nonatomic, strong) NSMutableArray * carArray;
@property (nonatomic, strong) NSMutableArray * assignArray;
@property (nonatomic, copy) NSString * departmentName;
@property (nonatomic, strong) TitleButton * titleButton;
@property (nonatomic, copy) NSString * aNewTitle;
@property (nonatomic, assign) __block NSInteger index;
@property (nonatomic, strong) NSMutableArray * carDataArray;
@property (nonatomic, strong) NSMutableArray * isScopeArray;
@property (nonatomic, strong) NSMutableArray * tempArray;
@property (nonatomic, assign) BOOL isScope;

@property (nonatomic, strong) UIButton * rightItem;

@property (nonatomic, strong) DropDownMenu *drop;

@property (nonatomic, copy) NSString * count;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation TYHPaiViewController
- (NSMutableArray *)tempArray {

    if (_tempArray == nil) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}
- (NSMutableArray *)isScopeArray {

    if (_isScopeArray == nil) {
        
        _isScopeArray = [[NSMutableArray alloc] init];
    }
    return _isScopeArray;
}
- (NSMutableArray *)carDataArray {

    if (_carDataArray == nil) {
        _carDataArray = [[NSMutableArray alloc] init];
    }
    return _carDataArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"校区 ^";
    self.topViewLabel.superview.layer.borderWidth = 0.2;
    self.topViewLabel.superview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView registerNib:[UINib nibWithNibName:@"PaiCheCell" bundle:nil] forCellReuseIdentifier:@"CheCell"];
    
    _topViewLabel.text = @"已派 x 人 未派 x 人";
    [self.tableView reloadData];
    
    
    //创建长按手势监听
//    UILongPressGestureRecognizer *cell = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(TableviewCellLongPressed:)];
//    
//    //将长按手势添加到需要实现长按操作的视图里
//    [self.tableView addGestureRecognizer:cell];
    
//    [self createLeftItem];
}
- (void)TableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {

//    // 取得选中的行
//    CGPoint point = [gestureRecognizer locationInView:self.tableView];
//    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
//    if (indexPath == nil) {
//        NSLog(@"nil");
//    }else {
//        NSLog(@"长按的行号是：%d",[indexPath row]);
//    }
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
//    }
//    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        
//        NSLog(@"UIGestureRecognizerStateChanged");
//    }
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        
//        NSLog(@"UIGestureRecognizerStateEnded");
//    }
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    
    
    [self getData];
    
    if (kDevice_Is_iPhoneX) {
        _topLayout.constant = AdjustHeight;
    }
}
#pragma mark   -------  定义返回按钮
- (void)createLeftItem {
    
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.drop) {
        [self.drop dismiss];
    }
}
- (void)returnClicked {
    if (self.drop) {
        [self.drop dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark   -------  定义titleView下拉菜单
- (void)creatTitleView {
    
    _titleButton = [[TitleButton alloc] init];
    NSString * name = self.aNewTitle?self.aNewTitle:self.departmentName;
    
    _titleButton.titleTypeByV3App = @"no";
    
    [_titleButton setTitle:name forState:UIControlStateNormal];
    
    // 监听标题点击
    [_titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
}

#pragma mark   ======  titleView的菜单设置
- (void)titleClick:(UIButton *)btn{

    // 创建下拉菜单
    DropDownMenu *drop = [[DropDownMenu alloc] init];
    // 设置下拉菜单弹出、销毁事件的监听者
    drop.delegate = self;
    
    // 2.设置要显示的内容
    TYHCarTitleController *titleMenuVC = [[TYHCarTitleController alloc] init];
    titleMenuVC.drop = drop;
    titleMenuVC.delegate = self;

    titleMenuVC.dataArray = self.schoolArray;
    titleMenuVC.index = _index;
    titleMenuVC.view.x = 30;
    titleMenuVC.view.y = 30;
    titleMenuVC.view.height = self.view.height - 50;
    titleMenuVC.view.width = self.view.width - 60 ;
    
    drop.contentController = titleMenuVC;
    self.drop = drop;
    // 显示
    [drop showFrom:btn];
}

#pragma mark - DropdownMenuDelegate
//下拉菜单被销毁了
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

//下拉菜单显示了
- (void)dropdownMenuDidShow:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}
#pragma mark - TitleMenuDelegate
-(void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title {
    _index = indexPath.row;
    self.aNewTitle = title;
    // 修改导航栏的标题
    [_titleButton setTitle:title forState:UIControlStateNormal];
    [self.carArray removeAllObjects];
    
    [self.carArray addObjectsFromArray:self.carDataArray[_index]];
    
    
    PaiCarModel * model = self.isScopeArray[0];
    SchoolDataModel *schoolModel = model.schoolsData[_index];
    self.isScope = schoolModel.isScope;
    
//    NSLog(@"self.isScope = %d",self.isScope);
    
    [self.tableView reloadData];
}

- (NSMutableArray *)schoolArray {

    // 校区数组
    if (_schoolArray == nil) {
        _schoolArray = [[NSMutableArray alloc] init];
    }
    return _schoolArray;
}
- (NSMutableArray *)carArray {

    // 页面显示数组
    if (_carArray == nil) {
        _carArray = [[NSMutableArray alloc] init];
    }
    return _carArray;
}
- (void)getData {
    // 先移除
    [TYHHttpTool get:self.urlStr params:nil success:^(id json) {
        
        [self.isScopeArray removeAllObjects];
        [self.schoolArray removeAllObjects];
        [self.carArray removeAllObjects];//carDataArray
        [self.carDataArray removeAllObjects];
//        NSLog(@"jsonjsonjsonjson == %@",json);
        
        PaiCarModel * model = [PaiCarModel objectWithKeyValues:json];
        self.topViewLabel.text = [NSString stringWithFormat:@"已派 %@ 人 未派 %@ 人",model.assignCount, model.noAssignCount];
        
        self.count = model.noAssignCount;
        
        [self.isScopeArray addObject:model];
        
        // title 下拉列表
        
        
        [model.schoolsData enumerateObjectsUsingBlock:^(SchoolDataModel * schoolModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.schoolArray addObject:schoolModel.schoolName];
            //            // 页面显示列表
            [self.carDataArray addObject:schoolModel.carData];
            if (schoolModel.isCurrSchool) {
                _index = idx;
            }
        }];
        

        SchoolDataModel *schoolModel = model.schoolsData[_index];
        self.isScope = schoolModel.isScope;
        // title
        self.departmentName = schoolModel.schoolName;
        // 必须放到里面
        
        [self creatTitleView];
        [self createRightItem];
        
        // 默认显示第0组
        [self.carArray addObjectsFromArray:self.carDataArray[_index]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
    }];
    
}

// 转单
- (void)changeToNextPage:(UIButton *)btn {

    [self.view makeToast:@"暂未开通" duration:2 position:nil];
    
}
- (void)createRightItem {
    
//    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    button.frame = CGRectMake(self.view.frame.size.width - 100, 10, 60, 44);
//    [button addTarget:self action:@selector(changeToNextPage:) forControlEvents:(UIControlEventTouchUpInside)];
//    [button setTitle:@"转单" forState:(UIControlStateNormal)];
//
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = item;
    
    //ITC - 临时注释
//    self.rightItem = button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.carArray.count == 0) {
        return self.view.height;
    }
    return 144;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.carArray.count == 0) {
        return 1;
    }
    return self.carArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.carArray.count == 0) {
        
        static NSString *noMessageCellid = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height / 2 - 50,[UIScreen mainScreen].bounds.size.width, 50.0f)];
          
            noMsgLabel.text = @"无可使用车辆";
            noMsgLabel.font = [UIFont systemFontOfSize:15];
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1]];
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.isScope) {
            
            self.rightItem.hidden = YES;
            
        } else {
            
            self.rightItem.hidden = NO;
        }
        return cell;
    }
    
    PaiCheCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CheCell"];
   
    if (!cell) {
        cell = [[PaiCheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheCell"];
    }
    
    CarDataModel * carModel = self.carArray[indexPath.row];
//    NSLog(@"carModel = %@",carModel.carName);
    cell.carType.text = carModel.carName;
    cell.carNumber.text = carModel.carNum;
    cell.carPerson.text = [NSString stringWithFormat:@"限乘%@人",carModel.limitCount];
    cell.countLabel.text = [NSString stringWithFormat:@"今日已派车%@次",carModel.assignCount];
//    NSLog(@"class = %@ %@",[carModel.fullFlag class],carModel.fullFlag);
    // 0 false 1 true
    if ([carModel.fullFlag isEqualToString:@"0"]) {
        
        cell.fullLabel.hidden = YES;
        
        [cell.useButton setBackgroundColor:[UIColor TabBarColorOrange]];
        cell.useButton.userInteractionEnabled = YES;
        
    } else {
        cell.fullLabel.hidden = NO;
        
        [cell.useButton setBackgroundColor:[UIColor lightGrayColor]];
        cell.useButton.userInteractionEnabled = NO;
    }
    
    NSString * strUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,carModel.carPicUrl];
//    NSLog(@"strUrl%@",strUrl);
    [cell.carimageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"icon_carmanager"]];
    
    [cell.useButton addTarget:self action:@selector(didUseCurrentCar:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.useButton.tag = indexPath.row;
    
    
    if (_isScope) {
        
        cell.useButton.hidden = NO;
        self.rightItem.hidden = YES;
        
    } else {
        
        cell.useButton.hidden = YES;
        self.rightItem.hidden = NO;
    }
    
    return cell;
}

#pragma mark === gotoNextPage 
- (void)didUseCurrentCar:(UIButton *)btn {
    
    if ([self.count isEqualToString:@"0"]) {
    
        [self.view makeToast:@"已完成派车" duration:2 position:nil];
        
    } else {
    
        TYHCreatOrderController * creatOrderVC = [[TYHCreatOrderController alloc] init];
        CarDataModel * carModel = self.carArray[btn.tag];
        creatOrderVC.carModel = carModel;
        creatOrderVC.carOrderId = self.carOrderId;
        //    /cm/carMobile!toAssignCar.action
        creatOrderVC.usename = _username;
        creatOrderVC.password = _password;
        creatOrderVC.count = self.count;
        creatOrderVC.urlStr  = [NSString stringWithFormat:@"%@/cm/carMobile!toAssignCar.action?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&carId=%@&id=%@&dataSourceName=%@", k_V3ServerURL, _username, _password,carModel.carId,self.carOrderId,[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"]]; //车辆 ID
        
        [self.navigationController pushViewController:creatOrderVC animated:YES];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PaiCheCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    if (_carArray.count) {
        if (cell.fullLabel.hidden == NO) {
            
            cell.useButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            cell.useButton.backgroundColor = [UIColor orangeColor];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
