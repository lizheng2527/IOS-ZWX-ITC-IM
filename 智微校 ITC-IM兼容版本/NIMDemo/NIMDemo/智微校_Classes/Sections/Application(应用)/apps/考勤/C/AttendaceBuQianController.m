//
//  AttendaceBuQianController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendaceBuQianController.h"
#import "PickerView.h"
#import "UIView+SDAutoLayout.h"
#import "AttendanceNetHelper.h"
#import <UIView+Toast.h>
#import "NSString+Empty.h"
#import "AttendanceModel.h"


#define kWindow  [UIApplication sharedApplication].keyWindow

@interface AttendaceBuQianController ()<UIPickerViewDelegate>

// 蒙版
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UIButton *hourBtnBack;
@property (nonatomic, strong) NSString *hoursDetailBack;
@end

@implementation AttendaceBuQianController
{
    PickerView *picker;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补签";
    [self createBarItem];
}

#pragma mark - initData
-(void)setAddress:(NSString *)address
{
    _address = address;
}

-(void)requestData
{
    [self.view endEditing:YES];
    if ([NSString isBlankString:_address]) {
        [self.view makeToast:@"请在考勤界面选取地址" duration:1 position:nil];
        return;
    }
    else if ([NSString isBlankString:self.hoursDetailBack]) {
        [self.view makeToast:@"请选择补签时间" duration:1 position:nil];
        return;
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"获取统计数据中";
        
        AttendanceNetHelper *helper = [AttendanceNetHelper new];
        [helper doBuqianActionWithAddress:_address note:_textView.text andFlag:self.hoursDetailBack status:^(BOOL successful, AttendanceModel *model) {
            if ([model.status isEqualToString:@"success"]) {
                [hud removeFromSuperview];
                [self.view makeToast:@"补签成功" duration:1 position:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"buqianRefresh" object:nil];
                });
            }
            else
            {
                [hud removeFromSuperview];
                [self.view makeToast:@"补签失败" duration:1 position:nil];
            }
            
        } failure:^(NSError *error) {
            [hud removeFromSuperview];
            [self.view makeToast:@"补签失败,可能是网络问题" duration:1 position:nil];
        }];
    }
}
#pragma mark - initView

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff4c4c4c)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
}

-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
- (IBAction)buqianAction:(id)sender {
    [self requestData];
}


- (IBAction)chooseTimeAction:(id)sender {
    [self selectDate:nil];
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择时间
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
    label.text = @"选择补签时间";
    label.backgroundColor = UIColorFromRGB(0xff4c4c4c);
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
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    oneDatePicker.locale = locale;
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
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    
    if (![self isCurrentDate:dateString beforeInputDate:self.hoursDetailBack]) {
        [self.view makeToast:@"补签时间不可晚于当前" duration:2.5 position:CSToastPositionCenter];
        
        [self.chooseTimeBtn setTitle:@"选择时间" forState:UIControlStateNormal];
        self.hoursDetailBack = @"";
    }
    else if(![NSString isBlankString:_endTime])
    {
        if ([self isCurrentDate:self.hoursDetailBack beforeInputDate:_endTime]) {
            [self.view makeToast:@"补签时间不可在打卡下班时间之后" duration:2.5 position:CSToastPositionCenter];
            [self.chooseTimeBtn setTitle:@"选择时间" forState:UIControlStateNormal];
            self.hoursDetailBack = @"";
        }
    }else
    {
        [self.chooseTimeBtn setTitle:self.hoursDetailBack forState:UIControlStateNormal];
    }
    
//    [self.hourBtnBack setTitle:self.hoursDetailBack forState:(UIControlStateNormal)];
}


-(BOOL)isCurrentDate: (NSString *)currentDate beforeInputDate:(NSString *)inputDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *dateInput = [dateFormatter dateFromString:inputDate];
    NSDate *dateCurrent = [dateFormatter dateFromString:currentDate];
    
    if ([dateInput isEqualToDate:[dateInput earlierDate:dateCurrent]]) {
        return YES;
    }
    else return NO;
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

- (void)oneDatePickerValueChanged:(UIDatePicker *) sender{
    
    [self currentDate:sender];
    
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
