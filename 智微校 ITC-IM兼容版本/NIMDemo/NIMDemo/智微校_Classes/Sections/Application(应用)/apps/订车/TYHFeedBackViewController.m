//
//  TYHFeedBackViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/21/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHFeedBackViewController.h"
#import <UIView+Toast.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "LTView.h"
#import "UIView+SDAutoLayout.h"
#import "TYHHttpTool.h"
#import "TYHCarManagerController.h"
#import "UILabel+Shake.h"
#import "NSString+Empty.h"
#import "LDCalendarView.h"

#define kWidth self.view.frame.size.width
#define kWindow  [UIApplication sharedApplication].keyWindow
#define kHeight 40

@interface TYHFeedBackViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) NSArray * arrayStr;
@property (nonatomic, strong) NSArray * arrayStr2;
@property (nonatomic, strong) LTView * view1;
@property (nonatomic, strong) LTView * view2;
@property (nonatomic, strong) UIButton * commitBtn;
// 时间显示 btn
@property (nonatomic, strong) UIButton * hourBtn;
// 蒙版
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * popView;

@property (nonatomic, copy) NSString * hoursDetail; // 必填
@property (nonatomic, copy) NSString * realCount; //
@property (nonatomic, copy) NSString * realAddress; //
@property (nonatomic, copy) NSString * note;


@property (nonatomic, strong) UIButton * backhoursDetailBtn; //
@property (nonatomic, copy) NSString * backhoursDetail; //
@property (nonatomic, copy) NSString * backCount; // 必填
@property (nonatomic, copy) NSString * backPerson;

@property (nonatomic, strong) NSMutableArray *arrayView2;
@property (nonatomic, strong) NSMutableArray *arrayView;

@property (nonatomic, strong) UIButton * currentSelectedBtn;
@property (nonatomic, strong) UIView * backView2;
@property (nonatomic, copy) NSString * tempStr;
@end

@implementation TYHFeedBackViewController
- (NSMutableArray *)arrayView2 {
    
    if (_arrayView2 == nil) {
        _arrayView2 = [[NSMutableArray alloc] init];
    }
    return _arrayView2;
}
- (NSMutableArray *)arrayView {
    
    if (_arrayView == nil) {
        _arrayView = [[NSMutableArray alloc] init];
    }
    return _arrayView;
}
- (NSArray *)arrayStr {
    
    if (_arrayStr == nil) {
        _arrayStr = @[@"实际上车人数",@"实际目的地",@"实际外出时间",@"其他说明",@"是否返程"];
    }
    return _arrayStr;
}
- (NSArray *)arrayStr2 {
    
    if (_arrayStr2 == nil) {
        _arrayStr2 = @[@"返程时间",@"返程人数",@"人员名单"];
    }
    return _arrayStr2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的反馈";
    
    TPKeyboardAvoidingScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    // 页面背景颜色
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1]];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //  创建所有控件
    [self setupSubview];
    
    // 添加 提交订车单
    [self setupCommitBtn];
    
    [self.scrollView setupAutoContentSizeWithBottomView: self.commitBtn bottomMargin:10];
    
}
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
    [commitBtn setTitle:@"提交反馈" forState:(UIControlStateNormal)];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4;
    self.commitBtn = commitBtn;
    [commitBtn addTarget:self action:@selector(commitReverse:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)commitReverse:(UIButton *)btn {

    [self.view endEditing:YES];
    
    for (LTView * view in self.arrayView) {
        
        if (view.tag == 1000 && [NSString isBlankString:self.realCount]) {
            
            [view.label shake];
            
        } else if (view.tag == 1001 && [NSString isBlankString:self.realAddress]) {
            
            [view.label shake];
        } else if (view.tag == 1002 && [NSString isBlankString:self.hoursDetail]) {
            
            [view.label shake];
        }
        if (self.arrayView2.count > 0) {
            
            for (LTView * view in self.arrayView2) {
                
                if (view.tag == 1005 && [NSString isBlankString:self.backhoursDetail]) {
                    
                    [view.label shake];
                    
                } else if (view.tag == 1006 && [NSString isBlankString:self.backCount]) {
                    
                    [view.label shake];
                    
                }
                
                if ([NSString isBlankString:self.backhoursDetail] || [NSString isBlankString:self.backCount ] || [NSString isBlankString:self.realAddress]|| [NSString isBlankString:self.realCount] || [NSString isBlankString:self.hoursDetail]) {
                    [self.view makeToast:@"缺少必填项" duration:2 position:nil];
                    return;
                }
            }
        } else {
            
            if ([NSString isBlankString:self.realAddress]|| [NSString isBlankString:self.realCount] || [NSString isBlankString:self.hoursDetail]) {
                [self.view makeToast:@"缺少必填项" duration:2 position:nil];
                return;
            }
        }
        
    }
    
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [kWindow addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在反馈";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"realCount"] = self.realCount;
    params[@"realAddress"] = self.realAddress;
    params[@"realTime"] = self.hoursDetail;
    params[@"note"] = self.note;
    
    // 返程信息
    // 返程参数
    if (_currentSelectedBtn.tag == 2002 && _currentSelectedBtn.selected == YES) {
        // 返程用车
        params[@"backTime"] = self.backhoursDetail;
        params[@"backCount"] = self.backCount;
        params[@"backPersonList"] = self.backPerson;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@",self.urlStr];
//    NSLog(@"url = %@",url);
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [TYHHttpTool posts:url params:params success:^(id json) {
//        NSLog(@"jsonjson =  = %@",json);
//        NSString * string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
        if (_One) {
            
            [hub removeFromSuperview];
            [window makeToast:@"反馈成功" duration:2 position:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            // 返回 1
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        } else {
        
            // 正在操作
//            if ([string isEqualToString:@"ok"]) {
            
                [hub removeFromSuperview];
                if (self.returnCheckSuccess2) {
                    
                    self.returnCheckSuccess2(YES);
                }
                [window makeToast:@"反馈成功" duration:2 position:nil];
//            } else {
//                [window makeToast:string duration:2 position:nil];
//            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        // 不知道为什么 已经派车成功还是走这里
        [hub removeFromSuperview];
        self.returnCheckSuccess2(YES);
        [window makeToast:@"反馈成功" duration:2 position:nil];
        NSLog(@"%@",[error localizedDescription]);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

////  创建所有控件
- (void)setupSubview {

    // 快速创建 N 个 View
    for (int i = 0; i< self.arrayStr.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, 10 + i *kHeight, kWidth, kHeight) description:self.arrayStr[i] Delegate:self];
        view.textField.tag = 1000 + i;
        view.tag = view.textField.tag;
        view.label.frame =CGRectMake(0, 0, kWidth/3.0, kHeight -1);
        view.textField.frame =CGRectMake(kWidth/3.0, 0, kWidth * 2/3.0, kHeight -1);
        view.label.font = [UIFont systemFontOfSize:15];
        view.textField.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = [UIColor whiteColor];
//        view.textField.textColor = [UIColor lightGrayColor];
        // 保存上一个 view
        [self.arrayView addObject:view];
        [self.view addSubview:view];
        
        if (i == 0) {
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(self.scrollView, 10)
            .heightIs(kHeight);
            
        }
        else {
            // 特殊处理
            if (i == 2) {
                
                UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = view.textField.frame;
                [view addSubview:button];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
                [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
                [button setTitle:@"选择时间" forState:(UIControlStateNormal)];
                [button addTarget:self action:@selector(selectDate2:) forControlEvents:(UIControlEventTouchUpInside)];
                button.tag = 1001;
                self.hourBtn = button;
                
            } else if (i == 4) {
            
                [view.textField removeFromSuperview];
                // 添加 button 是否返程按钮
                UIButton * button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [view addSubview:button1];
                button1.selected = YES;
                button1.sd_layout
                .leftSpaceToView(view, kWidth/4)
                .centerYEqualToView(view)
                .widthIs(kHeight)
                .heightIs(kHeight);
                self.currentSelectedBtn = button1;
                
                // 用 label 替代 button tittle 的好处
                UILabel * label1 = [[UILabel alloc] init];
                [view addSubview:label1];
                label1.text = @"否";
                label1.textColor = [UIColor darkGrayColor];
                
                label1.sd_layout
                .leftSpaceToView(button1,0)
                .centerYEqualToView(view)
                .widthIs(60)
                .heightIs(kHeight);
                
                button1.tag = 2001;
                [button1 setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
                [button1 setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
                button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [button1 addTarget:self action:@selector(selectedUnuseBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                
                // 创建用车按钮
                UIButton * button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [view addSubview:button2];
                
                button2.sd_layout
                .leftSpaceToView(label1, 0)
                .centerYEqualToView(view)
                .widthIs(kHeight)
                .heightIs(kHeight);
                
                UILabel * label2 = [[UILabel alloc] init];
                [view addSubview:label2];
                label2.text = @"是";
                label2.textColor = [UIColor darkGrayColor];
                
                label2.sd_layout
                .leftSpaceToView(button2,0)
                .centerYEqualToView(view)
                .widthIs(2*kHeight)
                .heightIs(kHeight);
                
                [button2 setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
                [button2 setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
                button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
                button2.tag = 2002;
                [button2 addTarget:self action:@selector(selectedUnuseBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                
            }else if (i == 3) {
                view.textField.placeholder = @"选填";
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
- (void)selectedUnuseBtn:(id )sender{
    
    UIButton * btn = (UIButton *)sender;
    // 设置当前按钮状态
    self.currentSelectedBtn.selected = NO;
    // 设置传入按钮选中的状态
    btn.selected = YES;
    // 设置当前按钮为传入的状态
    self.currentSelectedBtn = btn;
    
    if (btn.tag == 2001) {
        
        [self.backView2 removeFromSuperview];
        [self.arrayView2 removeAllObjects];
        // 这是 backview2 上的view的参数需要置空
        self.backhoursDetail = nil;
        self.backCount = nil;
        self.backPerson = nil;
        
        self.commitBtn.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .rightSpaceToView(self.scrollView, 20)
        .topSpaceToView(self.view1,10)
        .heightIs(50);
        
    } else if(btn.tag == 2002){
        
        [self setupNewsubviews];
        self.commitBtn.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .rightSpaceToView(self.scrollView, 20)
        .topSpaceToView(self.backView2,10)
        .heightIs(50);
        
    }
    [self.scrollView setupAutoContentSizeWithBottomView:self.commitBtn bottomMargin:10];
    
}
- (void)setupNewsubviews {

    UIView * backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    self.backView2 = backView;
    [self.scrollView addSubview:backView];
    
    backView.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .rightSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.view1, 0)
    .heightIs(25 + kHeight * 3);
    
    UILabel * topview2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, 25)];
    [backView addSubview:topview2];
    
    topview2.text = @"  返程信息";
    topview2.font = [UIFont systemFontOfSize:13];
    
    // 快速创建 N 个 View
    for (int i = 0; i< self.arrayStr2.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0 , topview2.frame.origin.y + topview2.height + i*kHeight, kWidth, kHeight) description:self.arrayStr2[i] Delegate:self];
        view.textField.tag = 1005 +  i;
        view.tag = view.textField.tag;
        view.backgroundColor = [UIColor whiteColor];
//        view.textField.textColor = [UIColor lightGrayColor];
        [self.arrayView2 addObject:view];
        
        // 保存上一个 view
        if (i == 0) {
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(topview2, 0)
            .heightIs(kHeight);
            
            // 获取当前时间
            UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = view.textField.frame;
            [view addSubview:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [button setTitle:@"选择时间" forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(selectDate2:) forControlEvents:(UIControlEventTouchUpInside)];
            button.tag = 1003;
            self.backhoursDetailBtn = button;
            
        }
        
        else {
            // 特殊处理
            if (i == 2) {
                
                view.textField.placeholder = @"选填";
                
            }
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(self.view2, 0)
            .heightIs(kHeight);
            
        }
        [self.backView2 addSubview:view];
        // 保存上一个 View
        self.view2 = view;
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
- (void)selectDate2:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    self.backView.hidden = NO;
    self.popView.hidden = NO;
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
    [oneDatePicker setDate:[NSDate date] animated:YES];
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
    
    if (btn.tag == 1001) {
        self.hoursDetail = self.tempStr;
        [self.hourBtn setTitle:self.hoursDetail forState:(UIControlStateNormal)];
        
    } else if (btn.tag == 1003) {
        self.backhoursDetail = self.tempStr;
        // 这里操作 时间先后判断
       int a = [LDCalendarView compareDate2:self.hoursDetail date:self.self.backhoursDetail];
        
        if (a <= 0) {
            [self.backhoursDetailBtn setTitle:self.backhoursDetail forState:(UIControlStateNormal)];
        } else {
            
            [self.backhoursDetailBtn setTitle:@"选择时间" forState:(UIControlStateNormal)];
            [self.view makeToast:@"返程时间不能早于出发时间" duration:2 position:nil];
        }
    }
   
}
#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender{
    [self currentDate:sender];
}
- (void)currentDate:(UIDatePicker *)date {
    
    // 获取选择的时间
    NSDate *select = [date date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    
    // 这是中间变量
    self.tempStr = dateAndTime;
    // 同一天比较 时间 不同天比较天
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//     NSLog(@"%ld === %@",(long)textField.tag,textField.text);
    if (textField.tag == 1000) {
        self.realCount = textField.text;
    } else if (textField.tag == 1001) {
        self.realAddress = textField.text;
    } else if (textField.tag == 1003) {
        self.note = textField.text;
    }else if (textField.tag == 1006) {
        self.backCount = textField.text;
    } else if (textField.tag == 1007) {
        self.backPerson = textField.text;
    }
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//
//    if (textField.tag == 1000 || textField.tag == 1006) {
//    
//        if ([self isPureNumandCharacters:textField.text]) {
//            
//            return YES;
//        } else {
//            
//            [self.view makeToast:@"请输入数字" duration:1 position:CSToastPositionCenter];
//            return NO;
//        }
//    }else {
//    
//        return YES;
//    }
//}
//// 判断是否是数字
//- (BOOL)isPureNumandCharacters:(NSString *)string
//{
//    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
//    
//    if(string.length > 0)
//    {
//        return NO;
//    }
//    return YES;
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1002 ) {
        // || textField.tag == 1004
        //写你要实现的：页面跳转的相关代码
        
        return NO;
        
    } else {
        
        if (textField.tag == 1000 || textField.tag == 1006) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        return YES;
    }
    
}
@end
