//
//  TYHCreatOrderController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCreatOrderController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+SDAutoLayout.h"
#import "LTView.h"
#import "TYHHttpTool.h"
#import "UILabel+Shake.h"
#import <UIImageView+WebCache.h>
#import <CZPicker.h>
#import <MJExtension.h>
#import "PaiDetailModel.h"
#import "DriverDataModel.h"
#import <UIView+Toast.h>
#import "NSString+Empty.h"

#define kWidth self.view.frame.size.width

#define kWindow  [UIApplication sharedApplication].keyWindow
#define kHeight 40
@interface TYHCreatOrderController ()<UITextFieldDelegate,CZPickerViewDelegate,CZPickerViewDataSource>

@property (nonatomic, strong) CZPickerView * picker;
@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) LTView * view1;
@property (nonatomic, strong) NSArray * arrayStr;
// 蒙版
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UIButton * perSonButton;
@property (nonatomic, strong) UIButton *hourBtnBack;
@property (nonatomic, strong) NSString *hoursDetailBack;
@property (nonatomic, strong) NSString *goOnCar;

@property (nonatomic, copy) NSString * driverId;
//@property (nonatomic, copy) NSString * driverName;


// 模型数组
@property (nonatomic, strong) NSMutableArray * driverArray;
@property (nonatomic, strong) NSMutableArray * driverIdArray;
@property (nonatomic, strong) NSMutableArray * driverNameArray;
@end

@implementation TYHCreatOrderController
- (NSArray *)arrayStr {
    
    if (_arrayStr == nil) {
        _arrayStr = @[@"出车司机",@"出发时间",@"上车地点"];
    }
    return _arrayStr;
    
}
- (void)initBaseData {

    TPKeyboardAvoidingScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    // 页面背景颜色
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1]];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self.scrollView setupAutoContentSizeWithBottomView: self.commitBtn bottomMargin:10];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"派车详情";
    [self initBaseData];
    [self setupNewsubviews];
    
    // 添加 提交订车单
    [self setupCommitBtn];
    
    [self getAssignCar];
}
- (NSMutableArray *)driverArray {

    if (_driverArray == nil) {
        
        _driverArray = [[NSMutableArray alloc] init];
    }
    return _driverArray;
}
- (void)getAssignCar {

    // 获取司机 driverData 信息 driverDataId driverDataName
    [TYHHttpTool get:self.urlStr params:nil success:^(id json) {
       
//        NSLog(@"%@",[json class]);
        PaiDetailModel * detailModel = [PaiDetailModel objectWithKeyValues:json];
       // 司机 model 数据
        for (DriverDataModel * driverModel in detailModel.driverData) {
            
            // 数组只保存司机姓名
            [self.driverArray addObject:driverModel];
        }
   
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupNewsubviews {
    
    // 创建顶部视图
    UIView * topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];
    
    UIImageView * imageView  = [[UIImageView alloc] init];
    [topView addSubview:imageView];
    
    topView.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.scrollView, 5)
    .heightIs(90);
    
    imageView.sd_layout
    .leftSpaceToView(topView, 15)
    .centerYEqualToView(topView)
    .heightIs(60).widthIs(60);
    
    NSString * strUrl = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,_carModel.carPicUrl];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"icon_carmanager"]];
    imageView.layer.cornerRadius = 30.0f;
    imageView.layer.masksToBounds = YES;
    
    UILabel * phoneLabel = [[UILabel alloc] init];
    [topView addSubview:phoneLabel];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.sd_layout
    .leftSpaceToView(imageView, 10)
    .centerYEqualToView(imageView)
    .heightIs(21).widthIs(160);
    // 这个需要传值  车牌号
    phoneLabel.text = _carModel.carNum;
    
    UILabel * nameLabel = [[UILabel alloc] init];
    [topView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.sd_layout
    .leftSpaceToView(imageView, 10)
    .bottomSpaceToView(phoneLabel,5)
    .heightIs(21).widthIs(160);
    // 这个需要传值 // 车品牌
    nameLabel.text = self.carModel.carName;
    
    UILabel * departmentLabel = [[UILabel alloc] init];
    [topView addSubview:departmentLabel];
    
    departmentLabel.font = [UIFont systemFontOfSize:14];
    departmentLabel.sd_layout
    .topSpaceToView(phoneLabel, 5)
    .leftSpaceToView(imageView, 10)
    .heightIs(21).widthIs(160);
    
    // 这里需要传值   限乘 人数
    departmentLabel.text = [NSString stringWithFormat:@"限乘%@人",_carModel.limitCount];
    
    // 快速创建 N 个 View
    for (int i = 0; i< self.arrayStr.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y + 10 + i *kHeight, kWidth, kHeight) description:self.arrayStr[i] Delegate:self];
        view.textField.tag = 1000 + i;
        view.tag = view.textField.tag;
        view.backgroundColor = [UIColor whiteColor];
//        view.textField.textColor = [UIColor lightGrayColor];
        // 保存上一个 view
        [self.view addSubview:view];
        
        // 保存上一个 view
        if (i == 0) {
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(topView, 10)
            .heightIs(kHeight);
            
            UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = view.textField.frame;
            [view addSubview:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            button.tag = 1000;
            [button setTitle:@"点击选择" forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(selectPerson:) forControlEvents:(UIControlEventTouchUpInside)];
            self.perSonButton = button;
        }
        
        else {
            // 特殊处理
            if (i == 1) {
                
                UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = view.textField.frame;
                [view addSubview:button];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
                [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
                [button setTitle:@"点击设置" forState:(UIControlStateNormal)];
                [button addTarget:self action:@selector(selectDate:) forControlEvents:(UIControlEventTouchUpInside)];
                button.tag = 1001;
                self.hourBtnBack = button;
            } 
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(self.view1, 0)
            .heightIs(kHeight);
            
        }
        [self.scrollView addSubview:view];
        // 保存上一个 View
        self.view1 = view;
    }
}
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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

- (void)selectDate:(UIButton *)btn {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = 20;
        CGFloat y = 134;
        CGFloat width = self.view.width - 2 * x;
        CGFloat heigth = 300;
        self.popView.frame = CGRectMake(x, y, width, heigth);
    }];
    //  添加蒙版
    self.backView.frame = kWindow.bounds;
    [kWindow addSubview:self.backView];
    
    // 在蒙版上添加 popView;
    [kWindow addSubview:self.popView];
    [kWindow bringSubviewToFront:self.popView];
    
    // 添加时 分 按钮
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.popView.width, 40)];
    label.text = @"选择        时            分";
    label.backgroundColor = [UIColor TabBarColorOrange];
    label.textColor = [UIColor whiteColor];
    label.textAlignment =  NSTextAlignmentCenter;
    [self.popView addSubview:label];
    
    UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
    [self currentDate:oneDatePicker];
    oneDatePicker.backgroundColor = [UIColor whiteColor];
    oneDatePicker.frame = CGRectMake(0, label.height, self.popView.width , 220);
//    oneDatePicker.date = [NSDate date]; // 设置初始时间
    [oneDatePicker setDate:[NSDate date] animated:YES]; // 设置时间，有动画效果
    oneDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    oneDatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
    oneDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
    oneDatePicker.datePickerMode = UIDatePickerModeTime; // 设置样式
    [oneDatePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    [self.popView addSubview:oneDatePicker]; // 添加到View上
    
    // 添加确定按钮
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(40, oneDatePicker.origin.y + oneDatePicker.height+5, self.popView.width - 80, 30);
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setBackgroundImage:[[UIImage imageNamed:@"b_com_bt_blue_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.popView addSubview:button];
    button.tag = btn.tag;
    [button addTarget:self action:@selector(dismiss:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)dismiss:(UIButton *)btn {
    
    [self.backView removeFromSuperview];
    [self.popView removeFromSuperview];
    _backView = nil;
    
    [self.hourBtnBack setTitle:self.hoursDetailBack forState:(UIControlStateNormal)];
}

- (void)currentDate:(UIDatePicker *)date {
    
    // 获取选择的时间
    NSDate *select = [date date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    self.hoursDetailBack = dateAndTime;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender{
    
    [self currentDate:sender];
}

#pragma mark == selectDate
- (void)selectPerson:(UIButton *)btn{

    _picker = [[CZPickerView alloc] initWithHeaderTitle:@"选择司机" cancelButtonTitle:@"离开" confirmButtonTitle:@"确认"];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.headerTitleColor = [UIColor orangeColor];
    _picker.headerBackgroundColor = [UIColor whiteColor];
    _picker.needFooterView = NO;
    [_picker show];

}
#pragma mark == setupCommitBtn
- (void)setupCommitBtn {

    UIButton * commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:commitBtn];
    [self.scrollView addSubview:commitBtn];
    
    commitBtn.sd_layout
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .topSpaceToView(self.view1,10)
    .heightIs(50);
    
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"蓝色按钮"] forState:(UIControlStateNormal)];
    [commitBtn setTitle:@"生成订车单" forState:(UIControlStateNormal)];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4;
    self.commitBtn = commitBtn;
    [commitBtn addTarget:self action:@selector(createOrderReverse:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)createOrderReverse:(UIButton *)btn {

    [self.view endEditing:YES];
    
    if ([NSString isBlankString:_perSonButton.titleLabel.text] || [NSString isBlankString:_goOnCar]||[NSString isBlankString:_hoursDetailBack]) {
        [self.view makeToast:@"缺少必填项" duration:2 position:nil];
        return;
    }
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [self.view addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在生成派车单";
    
    // /cm/carMobile!saveAssignCar.action 生成派车单
    NSString * saveUrl = @"/cm/carMobile!saveAssignCar.action";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    // id 订车单 id
    // id，carId，driverId，useTime（时分），useAddress，leaveTime（时分）
    NSString * url = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,saveUrl];
    
    params[@"dataSourceName"] = dataSourceName;
    params[@"sys_username"] = self.usename;
    params[@"sys_password"] = self.password;
    params[@"sys_auto_authenticate"] = @"true";
    params[@"id"] = self.carOrderId;
    params[@"carId"] = _carModel.carId;
    params[@"driverId"] = self.driverId; // 司机 id?
    params[@"useTime"] = self.hoursDetailBack; //
    params[@"useAddress"] = self.goOnCar; // 上车地点
    params[@"leaveTime"] = self.hoursDetailBack; // 离开时间
    
//    NSLog(@"params = %@",params);
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    [TYHHttpTool gets:url params:params success:^(id json) {
        
//        if ([self.count isEqualToString:@"0"]) {
//            
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
//        }
        
        [window makeToast:@"订车单已生成" duration:2 position:nil];
        [hub removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        // 不知道为什么 已经派车成功还是走这里
        [hub removeFromSuperview];
        NSLog(@"%@",[error localizedDescription]);
    }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1002) {
        self.goOnCar = textField.text;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1000 || textField.tag == 1001){
        // || textField.tag == 1004
        //写你要实现的：页面跳转的相关代码
        return NO;
        
    } else {
        
        return YES;
    }
    
}
#pragma mark- 更改CzPicker的字体
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    [self.view endEditing:YES];
    DriverDataModel * model = self.driverArray[row];
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:model.driverName
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:14.0]
                                            }];
    return att;
}

#pragma mark- CzPicker的Delegate和DataSource
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    //  pop 显示个数
    return self.driverArray.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    
    DriverDataModel * model = self.driverArray[row];
    // 回调显示
    self.driverId = model.driverId;
    [_perSonButton setTitle:model.driverName forState:UIControlStateNormal];
}


@end
