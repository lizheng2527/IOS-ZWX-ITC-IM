//
//  TYHReverseCarController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/6/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHReverseCarController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+SDAutoLayout.h"
#import "LTView.h"
#import "NSString+Empty.h"
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "TYHHttpTool.h"
#import "UILabel+Shake.h"
#import <UIView+Toast.h>
#import <MJRefresh.h>
#import "TYHChoosePlaceController.h"
#import "NSString+NTES.h"
#import "WHChooseWareHouseController.h"
#import "WHNetHelper.h"


#define kWidth self.view.frame.size.width
#define kWindow  [UIApplication sharedApplication].keyWindow
#define kHeight 40

@interface TYHReverseCarController ()<UITextFieldDelegate>

@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) NSArray * arrayStr;
@property (nonatomic, strong) NSArray * arrayStr2;
@property (nonatomic, strong) LTView * view1;
@property (nonatomic, strong) LTView * view2;
@property (nonatomic, strong) UIButton * commitBtn;
@property (nonatomic, strong) UIButton * currentSelectedBtn;

@property (nonatomic, strong) NSMutableArray * arrayView;
@property (nonatomic, strong) NSMutableArray * arrayView2;

@property (nonatomic, strong) UIView * backView2;
// 蒙版
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * popView;

@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) NSString * dateDetailBack;
@property (nonatomic, copy) NSString * dateDetail;

@property (nonatomic, copy) NSString * hoursDetailBack;
@property (nonatomic, copy) NSString * hoursDetail;

@property (nonatomic, copy) NSString * place;
@property (nonatomic, strong) UIButton * placeBtn;

@property (nonatomic, strong) UIButton * hourBtn;
@property (nonatomic, strong) UIButton * hourBtnBack;
//以下三个是临时添加
@property(nonatomic,strong)UIButton *hourBtnArrive;
@property(nonatomic,strong)UIButton *hourBtnArriveBack;
@property(nonatomic,copy)NSString *hourArriveDetailBack;

@property (nonatomic, strong) UIButton * dateBtn;
@property (nonatomic, strong) UIButton * dateBtnBack;
@property (nonatomic, strong) LDCalendarView * calendarView;//日历控件
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
//  address,userCount,personList,reason,instruction

@property (nonatomic, copy) NSString * address;   // 必填
@property (nonatomic, copy) NSString * userCount; // 必填
@property (nonatomic, copy) NSString * personList;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * instruction;

@property (nonatomic, copy) NSString * backCount; // 必填
@property (nonatomic, copy) NSString * backAddress;
@property (nonatomic, copy) NSString * backPersonList;

@property (nonatomic, copy) NSString * tempStr;

@property (nonatomic, copy) NSString * departmentID;
@property (nonatomic, copy) NSString * departmentName;
@property(nonatomic,retain)UILabel *departmentLabel;


@end

@implementation TYHReverseCarController

static int b;

- (NSArray *)arrayStr2 {

    if (_arrayStr2 == nil) {
        _arrayStr2 = @[@"返程日期",@"返程时间",@"乘车地点",@"返程人数",@"人员名单"];
    }
    return _arrayStr2;
}
- (NSArray *)arrayStr {
    
    if (_arrayStr == nil) {
        
        _arrayStr = @[@"用车日期",@"出发时间",@"到达时间",@"到达地点",@"用车人数",@"人员名单",@"用车原因",@"补充说明",@"返程"];
        // ,@"返程日期",@"返程时间",@"乘车地点",@"返程人数",@"人员名单"
    }
    return _arrayStr;
}

- (void)initData {
    
//    _userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_V3ID]; // V3id
      _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    _phoneNumber  = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_MOBIENUM];
    self.name =  [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFARLT_UserName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    // Do any additional setup after loading the view from its nib.
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
    [commitBtn setTitle:@"提交订车单" forState:(UIControlStateNormal)];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4;
    self.commitBtn = commitBtn;
    [commitBtn addTarget:self action:@selector(commitReverse:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)commitReverse:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    for (LTView * view in self.arrayView) {
        
        if (view.tag == 1001 && [NSString isBlankString:self.hoursDetail]) {
            [view.label shake];
        }
        if (view.tag == 1002 && [NSString isBlankString:self.address]) {
            [view.label shake];
        }
        if (view.tag == 1003 && [NSString isBlankString:self.userCount]) {
            [view.label shake];
        }
        
        if (self.arrayView2.count > 0) {
            
            for (LTView * view in self.arrayView2) {
                if (view.tag == 1009 + 1 && [NSString isBlankString:self.hoursDetailBack]) {
                    [view.label shake];
                } else if (view.tag == 1010 + 1 && [NSString isBlankString:self.backAddress]) {
                    [view.label shake];
                } else if (view.tag == 1011 + 1 && [NSString isBlankString:self.backCount]) {
                    [view.label shake];
                }
                if ([NSString isBlankString:self.hoursDetailBack] || [NSString isBlankString:self.backAddress]|| [NSString isBlankString:self.backCount]|| [NSString isBlankString:self.address] || [NSString isBlankString:self.userCount]|| [NSString isBlankString:self.hoursDetail]) {
                
                    [self.view makeToast:@"缺少必填内容" duration:1 position:CSToastPositionCenter];
                    
                    return;
                }
            }
        } else {
        
            if ([NSString isBlankString:self.address] || [NSString isBlankString:self.userCount]|| [NSString isBlankString:self.hoursDetail]) {
    
                [self.view makeToast:@"缺少必填内容" duration:1 position:CSToastPositionCenter];
                return;
            }
        }

    }
    
    
    if ([NSString isBlankString:self.departmentID] ) {
        [self.view makeToast:@"请在最上方选择部门" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [window addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在提交订车单";
   
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    // 必填
    
    params[@"sys_auto_authenticate"] = @"true";
    params[@"sys_username"] = self.userName;
    params[@"sys_password"] = self.password;
    params[@"userId"] = self.userId;
    params[@"departmentId"] = _departmentID;
    params[@"phone"] = self.phoneNumber;
    params[@"useDate"] = self.dateDetail;
    params[@"arriveTime"] = self.hourArriveDetailBack.length?self.hourArriveDetailBack:@"";
    params[@"address"] = self.address;
    params[@"userCount"] = self.userCount;
    params[@"dataSourceName"] = dataSourceName;
    
    
    // 选填
    params[@"personList"] = self.personList;
    params[@"reason"] = self.reason;
    params[@"instruction"] = self.instruction;
    params[@"startTime"] = self.hoursDetail;
    
    // 返程参数
    if (_currentSelectedBtn.tag == 2002 && _currentSelectedBtn.selected == YES) {
        // 返程用车
        
        params[@"backDate"] = self.dateDetailBack;
        params[@"backAddress"] = self.backAddress;
        params[@"backTime"] = self.hoursDetailBack;
        params[@"backCount"] = self.backCount;
        params[@"backPersonList"] = self.backPersonList;
    }
    
//    NSLog(@"params = %@",params);
    
    [TYHHttpTool posts:_urlStr params:params success:^(id json) {
        NSString * string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        if ([string isEqualToString:@"ok"]) {
            
            [hub removeFromSuperview];
            [self.view makeToast:@"订车单已提交,请等待派车" duration:2 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self.view makeToast:string duration:2.5 position:CSToastPositionCenter];
            [hub removeFromSuperview];
        }
        
        
    } failure:^(NSError *error) {
        // 不知道为什么 已经派车成功还是走这里
        [hub removeFromSuperview];
        [self.view makeToast:@"提交错误" duration:2 position:CSToastPositionCenter];
    }];
    
}
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
#pragma mark === 创建子控件
- (void)setupSubview {
    
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
    
    imageView.image = [UIImage imageNamed:@"icon_carmanager"];
    imageView.layer.cornerRadius = 30.0f;
    imageView.layer.masksToBounds = YES;
    
    
    //  USER_DEFAULT_ORIGANIZATION_ID 组织 Id
    UILabel * phoneLabel = [[UILabel alloc] init];
    [topView addSubview:phoneLabel];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.sd_layout
    .leftSpaceToView(imageView, 10)
    .centerYEqualToView(imageView)
    .heightIs(21).widthIs(160);
    // 这个需要传值
    if ([NSString isBlankString:_phoneNumber]) {
        phoneLabel.text = [NSString stringWithFormat:@"手机: 暂无"];
    } else {
        phoneLabel.text = [NSString stringWithFormat:@"手机: %@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MOBIENUM]];
    }
    
    UILabel * nameLabel = [[UILabel alloc] init];
    [topView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.sd_layout
    .leftSpaceToView(imageView, 10)
    .bottomSpaceToView(phoneLabel,5)
    .heightIs(21).widthIs(160);
    // 这个需要传值
    nameLabel.text = [NSString stringWithFormat:@"姓名: %@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME]];
    
    _departmentLabel = [[UILabel alloc] init];
    [topView addSubview:_departmentLabel];
    
    _departmentLabel.font = [UIFont systemFontOfSize:14];
    _departmentLabel.sd_layout
    .topSpaceToView(phoneLabel, 5)
    .leftSpaceToView(imageView, 10)
    .heightIs(21).widthIs(160);
    // 这里需要传值
    
    _departmentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(departmentChoose:)];
    [_departmentLabel addGestureRecognizer:ges];
    
    if ([NSString isBlankString:_department]) {
        _departmentLabel.text = @"< 请选择部门 >";
        _departmentLabel.textColor = [UIColor orangeColor];
    }else
    {
        _departmentLabel.text = [NSString stringWithFormat:@"部门: %@",_department];
        _departmentID = _departmentId;
        _departmentName = _department;
    }
    
    // 快速创建 N 个 View
    for (int i = 0; i< self.arrayStr.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y + 10 + i *kHeight, kWidth, kHeight) description:self.arrayStr[i] Delegate:self];
        view.textField.tag = 1000 + i;
        view.tag = view.textField.tag;
        view.backgroundColor = [UIColor whiteColor];
        view.textField.textColor = [UIColor darkGrayColor];
        // 保存上一个 view
        [self.arrayView addObject:view];
        [self.view addSubview:view];
        
        if (i == 0) {
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(topView, 10)
            .heightIs(kHeight);
            
            // 获取当前时间   [NSDate date] 今天
            NSDate *  senddate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*1];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            self.dateDetail = locationString;
            UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = view.textField.frame;
            [view addSubview:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [button setTitle:locationString forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(selectDate:) forControlEvents:(UIControlEventTouchUpInside)];
            button.tag = 1000;
            
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
                [button setTitle:@"选择时间" forState:(UIControlStateNormal)];
                [button addTarget:self action:@selector(selectDate2:) forControlEvents:(UIControlEventTouchUpInside)];
                button.tag = 1001;
                self.hourBtn = button;
                
            }
            if(i == 2)
            {
                UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = view.textField.frame;
                [view addSubview:button];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
                [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
                [button setTitle:@"选择时间(选填)" forState:(UIControlStateNormal)];
                [button addTarget:self action:@selector(selectDate2:) forControlEvents:(UIControlEventTouchUpInside)];
                button.tag = 8001;
                self.hourBtnArrive = button;
            }
            
            if (i == 3) {
                
                UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = view.textField.frame;
                [view addSubview:button];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
                [button setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
                
                [button addTarget:self action:@selector(choosePalce:) forControlEvents:(UIControlEventTouchUpInside)];
//                button.tag = 1004;
                self.placeBtn = button;
                
            } else if (i == 6 || i == 7 || i == 5) {
                
                view.textField.placeholder = @"选填";
                
            } else if (i == 8) {
                
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
                label1.text = @"不用车";
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
                label2.text = @"用车";
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
        self.hoursDetailBack = nil;
        self.dateDetailBack = nil;
        self.backAddress = nil;
        self.backCount = nil;
        self.backPersonList = nil;
        
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
    .heightIs(25 + kHeight * 5);
    
    UILabel * topview2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, 25)];
    [backView addSubview:topview2];
    
    topview2.text = @"  返程信息";
    topview2.font = [UIFont systemFontOfSize:13];
    
    // 快速创建 N 个 View
    for (int i = 0; i< self.arrayStr2.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0 , topview2.frame.origin.y + topview2.height + i*kHeight, kWidth, kHeight) description:self.arrayStr2[i] Delegate:self];
        view.textField.tag = 1008 +  i;
        view.tag = view.textField.tag;
        view.backgroundColor = [UIColor whiteColor];
        [self.arrayView2 addObject:view];
        
        // 保存上一个 view
        if (i == 0) {
            
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(topview2, 0)
            .heightIs(kHeight);
            
            // 获取当前时间
//            NSDate *  senddate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
//            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//            [dateformatter setDateFormat:@"YYYY-MM-dd"];
//            NSString *  locationString=[dateformatter stringFromDate:senddate];
            self.dateDetailBack = self.dateDetail;
            UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = view.textField.frame;
            [view addSubview:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            button.tag = 1002;
            [button setTitle:self.dateDetail forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(selectDate:) forControlEvents:(UIControlEventTouchUpInside)];
            
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
                [button setTitle:@"选择时间" forState:(UIControlStateNormal)];
                [button addTarget:self action:@selector(selectDate2:) forControlEvents:(UIControlEventTouchUpInside)];
                button.tag = 1003;
                self.hourBtnBack = button;
                
            } else if (i == 4) {
                
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
- (void)choosePalce:(UIButton *)btn {

    TYHChoosePlaceController * placeVc = [[TYHChoosePlaceController alloc] init];
    
    placeVc.placeBlock = ^(NSString * place) {
    
        [self.placeBtn setTitle:place forState:(UIControlStateNormal)];
        self.address = place;
    };
    
    [self.navigationController pushViewController:placeVc animated:YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1002) {
//        self.address = textField.text;
    } else if (textField.tag == 1003 + 1) {
        self.userCount = textField.text;
    } else if (textField.tag == 1004 + 1) {
        self.personList = textField.text;
    } else if (textField.tag == 1005 + 1) {
        self.reason = textField.text;
    } else if (textField.tag == 1006 + 1) {
        self.instruction = textField.text;
    } else if (textField.tag == 1010 ) {
        self.backAddress = textField.text;
    } else if (textField.tag == 1011) {
        self.backCount = textField.text;
    } else if (textField.tag == 1012) {
        self.backPersonList = textField.text;
    }
}

#pragma mark === 选择日历
- (void)selectDate:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [self.view addSubview:_calendarView];
    }
    
    __weak typeof(self) weakSelf = self;
    _calendarView.complete = ^(NSArray *result) {
        
        if (result) {
            weakSelf.seletedDays = [result mutableCopy];
            
            for (NSNumber *interval in weakSelf.seletedDays) {
                
                NSString * partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"YYYY-MM-dd"];
                if (btn.tag == 1000) {
                    _dateDetail = partStr;
                    [btn setTitle: partStr forState:(UIControlStateNormal)];
                } else if (btn.tag == 1002) {
                    
                    _dateDetailBack = partStr;
                    
                    int a = [LDCalendarView compareDate:weakSelf.dateDetail date:weakSelf.dateDetailBack];
                    b = a;
                    
                    if (a <= 0) {
                        
                        [btn setTitle:partStr forState:(UIControlStateNormal)];
                    } else {
                    
                        
                        [btn setTitle:weakSelf.dateDetail forState:(UIControlStateNormal)];
                        [weakSelf.view makeToast:@"选择返程时间有误已默认当前日期" duration:2 position:CSToastPositionCenter];
                    }
                    
                }
            }
        }
    };

    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;
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
        
    }
    else if(btn.tag == 8001)
    {
        self.hourArriveDetailBack = self.tempStr;
        [self.hourBtnArrive setTitle:self.hourArriveDetailBack forState:(UIControlStateNormal)];
    }
    
    else if (btn.tag == 1003) {
        self.hoursDetailBack = self.tempStr;
        // 这里操作 时间先后判断
        int a = [LDCalendarView compareDate2:self.hoursDetail date:self.hoursDetailBack];
        if (b < 0) {// 不需要比较
            [self.hourBtnBack setTitle:self.hoursDetailBack forState:(UIControlStateNormal)];
        }
        else {
        
            if (a <= 0) {
                [self.hourBtnBack setTitle:self.hoursDetailBack forState:(UIControlStateNormal)];
            } else {
                
                [self.hourBtnBack setTitle:@"选择时间" forState:(UIControlStateNormal)];
                [self.view makeToast:@"返程时间不能早于出发时间" duration:2 position:CSToastPositionCenter];
            }
        }
        
    }
}

- (void)currentDate:(UIDatePicker *)date {
    
    // 获取选择的时间
    NSDate *select = [date date]; // 获取被选中的时间
//    NSLog(@"select = %@",select);
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    // 把date类型转为设置好格式的string类型
    
    // 这是中间变量
    self.tempStr = dateAndTime;
    // 同一天比较 时间 不同天比较天
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender{
    [self currentDate:sender];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1000 || textField.tag == 1001 || textField.tag == 1008 || textField.tag == 1009 ) {
        //写你要实现的：页面跳转的相关代码
        
        return NO;
        
    } else {
        
        if (textField.tag == 1003 + 1 || textField.tag == 1011) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        return YES;
    }
    
}



-(void)departmentChoose:(id)sender
{
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [SVProgressHUD showWithStatus:@"获取部门列表中"];
    
    [helper getApplyDepartmentListWithApplyID:@"" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        WHChooseWareHouseController *choseView = [WHChooseWareHouseController new];
        choseView.typeString = @"订车";
        choseView.chooseWareHouseOrDepartment = 2;
        choseView.assetDatasource = dataSource;
        [self.navigationController pushViewController:choseView animated:YES];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取部门列表失败" duration:1 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    
    
}

-(void)didselectedCarDepartment:(NSString *)departID DepartmentName:(NSString *)name
{
    _departmentID =departID;
    _departmentName = name;
    _departmentLabel.text = [NSString stringWithFormat:@"部门: %@",_departmentName];
    
}


@end
