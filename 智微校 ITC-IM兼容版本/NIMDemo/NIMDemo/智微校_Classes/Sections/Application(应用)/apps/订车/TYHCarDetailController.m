//
//  TYHCarDetailController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarDetailController.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "CarDetailModel.h"
#import "OaCarDataModel.h"
#import "LTView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+Extention.h"
#import <UIView+Toast.h>
#import "UIButton+Extention.h"
#import "TYHFeedBackViewController.h"
#import "TYHPaiViewController.h"
#import "TYHCheckViewController.h"
#import "TYHFeedBackCotroller.h"
#import "StarDataModel.h"
#import "OaCarDataModel.h"
#import <MJExtension.h>
#import "LHRatingView.h"
#import "DriverDetailModel.h"
#import "OaCar2Model.h"
#import <UIView+Toast.h>
#import "PublicDefine.h"
#import "NSString+Empty.h"
#import "ValuePickerView.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight1 [UIScreen mainScreen].bounds.size.height
#define kWindow  [UIApplication sharedApplication].keyWindow
#define kHeight 32

#define Color colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1
@interface TYHCarDetailController ()<UITextFieldDelegate,ratingViewDelegate>

@property (nonatomic, strong) NSMutableArray * carDetailArray;
@property (nonatomic, strong) NSArray *arrayStr;
@property (nonatomic, strong) NSArray *arrayStr2;
@property (nonatomic, strong) NSArray *arrayStr3;
@property (nonatomic, strong) NSArray *arrayStr4;
@property (nonatomic, strong) NSArray *arrayStr5;
@property (nonatomic, strong) LTView * view1;
@property (nonatomic, strong) LTView * view2;
@property (nonatomic, strong) LTView * view3;
@property (nonatomic, strong) LTView * view4;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * commitBtn;

@property (nonatomic, assign) BOOL fan;
@property (nonatomic, assign) BOOL chengFeedback;
@property (nonatomic, assign) BOOL sijiFeedback;

@property (nonatomic, assign) BOOL check;

@property (nonatomic, strong) NSMutableArray * allData;
@property (nonatomic, strong) NSMutableArray * allData2;
@property (nonatomic, strong) NSMutableArray * allDataTemp;

@property (nonatomic, copy) NSString * loginName;
@property (nonatomic, copy) NSString * strUrl2;
@property (nonatomic, strong) NSMutableArray * telephones;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalOneFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optinalTwoFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalThreeFrame;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,assign)__block NSInteger userChooseIndex;
@end

@implementation TYHCarDetailController

- (NSMutableArray *)telephones {
    
    if (_telephones == nil) {
        
        _telephones = [[NSMutableArray alloc] init];
    }
    return _telephones;
}

- (NSMutableArray *)allDataTemp {
    
    if (_allDataTemp == nil) {
        _allDataTemp = [[NSMutableArray alloc] init];
    }
    return _allDataTemp;
}

- (NSMutableArray *)allData2 {
    
    if (_allData2 == nil) {
        _allData2 = [[NSMutableArray alloc] init];
    }
    return _allData2;
}
- (NSMutableArray *)allData {
    
    if (_allData == nil) {
        _allData = [[NSMutableArray alloc] init];
    }
    return _allData;
}

- (NSArray *)arrayStr {
    
    if (_arrayStr == nil) {
        
        if (!self.fan) {
            
            _arrayStr = @[@"用车人",@"联系电话",@"用车部门",@"用车日期",@"出发时间",@"到达时间",@"到达地点",@"用车人数",@"人员名单",@"用车原因",@"补充说明",@"是否返程",@""];
        }else {
            
            _arrayStr = @[@"用车人",@"联系电话",@"用车部门",@"用车日期",@"出发时间",@"到达时间",@"到达地点",@"用车人数",@"人员名单",@"用车原因",@"补充说明",@"是否返程",@"",@"返程日期",@"返程时间",@"乘车地点",@"返程人数",@"人员名单",@""];
        }
    }
    return _arrayStr;
}
// 有司机反馈
- (NSArray *)arrayStr5  {
    
    if (_arrayStr5 == nil) {
        
        // 乘客评价
        if (_chengFeedback) {
            
            _arrayStr5 = @[@"乘客评价",@"服务态度",@"安全",@"准时",@"车内环境",@"反馈意见",@"司机反馈",@"实际上车人数",@"实际目的地",@"实际出发时间",@"其他说明"];
        } else {
            _arrayStr5 = @[@"司机反馈",@"实际上车人数",@"实际目的地",@"实际出发时间",@"其他说明"];
        }
        
    }
    return _arrayStr5;
}

- (NSArray *)arrayStr4 {
    
    if (_arrayStr4 == nil) {
        _arrayStr4 = @[@"乘客评价",@"服务态度",@"安全",@"准时",@"反馈意见"];
    }
    return _arrayStr4;
}

- (NSArray *)arrayStr2 {
    
    if (_arrayStr2 == nil) {
        
        _arrayStr2 = @[@"审核情况",@"审核人",@"审核意见"];
        
    }
    return _arrayStr2;
}

//  是否有乘客
- (NSArray *)arrayStr3 {
    
    if (_arrayStr3 == nil) {
        
        _arrayStr3 = @[@"派车单",@"司机",@"使用车辆",@"上车时间",@"上车地点",@""];
    }
    return _arrayStr3;
}

- (NSMutableArray *)carDetailArray {
    
    if (_carDetailArray == nil) {
        _carDetailArray = [[NSMutableArray alloc] init];
    }
    return _carDetailArray;
}

- (void)initData {
    
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGINNAME];
    // USER_DEFARLT_UserName
    // 用车人和司机与登录名相同就隐藏 拨打电话选项
    
    _loginName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFARLT_UserName];
    //    NSLog(@"_loginName = %@",_loginName);
    
    NSString *V3Pwd = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    if ([NSString isBlankString:V3Pwd]) {
        V3Pwd = @"";
    }
    _password = V3Pwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    
    // 页面背景颜色
    [self.scrollView setBackgroundColor:[UIColor Color]];
    
    // 完成详情 不需要留底部页面
    if (self.optionalOneStr == nil) {
        self.scrollView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view,0)
        .bottomSpaceToView(self.view,0);
        
    } else {
//        self.scrollView.sd_layout
//        .leftSpaceToView(self.view, 0)
//        .rightSpaceToView(self.view, 0)
//        .topSpaceToView(self.view,0)
//        .bottomSpaceToView(self.view,50);  //空出50出来,下方有按钮出现
        
        self.scrollView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view,0)
        .bottomSpaceToView(self.view,0);
    }
    
    [self getDetailStatus];
    [self setupButton];
    
}

- (void)setupButton {
    
    // 设置显示隐藏
    
    if (self.optionalOneStr == nil) self.OptinalOneButton.hidden = YES;
    if (self.optionalThreeStr == nil) self.OptinalThreeButton.hidden = YES;
    if (self.optionalTwoStr == nil) self.OptinalTwoButton.hidden = YES;
    
    
    [self.OptinalOneButton setTitle:self.optionalOneStr forState:(UIControlStateNormal)];
    [self.OptinalOneButton addTarget:self action:@selector(didClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
    self.OptinalOneButton.layer.cornerRadius = 3;
    self.OptinalOneButton.layer.borderWidth = 0.5;
    self.OptinalOneButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.OptinalTwoButton setTitle:self.optionalTwoStr forState:(UIControlStateNormal)];
    [self.OptinalTwoButton addTarget:self action:@selector(didClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
    self.OptinalTwoButton.layer.cornerRadius = 3;
    self.OptinalTwoButton.layer.borderWidth = 0.5;
    self.OptinalTwoButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.OptinalThreeButton setTitle:self.optionalThreeStr forState:(UIControlStateNormal)];
    [self.OptinalThreeButton addTarget:self action:@selector(didClickOperation:) forControlEvents:(UIControlEventTouchUpInside)];
    self.OptinalThreeButton.layer.cornerRadius = 3;
    self.OptinalThreeButton.layer.borderWidth = 0.5;
    self.OptinalThreeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //    if (self.optionalOneStr.length == 2) {
    //
    //        self.optionalOneFrame.constant = 50;
    //
    //    } else if (self.optionalTwoStr.length == 4) {
    //
    //        self.optinalTwoFrame.constant = 60;
    //
    //    } else if (self.optionalThreeStr.length == 5) {
    //
    //        self.optionalThreeFrame.constant = 70;
    //
    //    } else if (self.optionalTwoStr.length == 2) {
    //
    //        self.optionalThreeFrame.constant = 50;
    //
    //    } else if (self.optionalThreeStr.length == 4) {
    //
    //        self.optionalThreeFrame.constant = 60;
    //
    //    } else if (self.optionalOneStr.length == 5) {
    //
    //        self.optionalThreeFrame.constant = 70;
    //    }
    
}


- (void)didClickNewButton:(UIButton *)btn{
    
    NSString * name = [NSString stringWithFormat:@"确认%@吗?", btn.currentTitle];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:btn.currentTitle message:name preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            //                NSLog(@"strUrl = = %@",strUrl);
            [TYHHttpTool gets:self.strUrl2 params:nil success:^(id json) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            } failure:^(NSError *error) {
                //                        NSLog(@"error == %@",[error localizedDescription]);
            }];
            
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:btn.currentTitle   message:name delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }
    
}
#pragma mark  ----  alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [TYHHttpTool gets:self.strUrl2 params:nil success:^(id json) {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        } failure:^(NSError *error) {
            //            NSLog(@"error == %@",[error localizedDescription]);
        }];
        
    }
}

- (void)didClickOperation:(UIButton *)btn {
    
    if([btn.currentTitle isEqualToString:@"结束派车"]) {
        
        NSString * baseUrl = @"/cm/carMobile!passOrderCar.action";
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , _userName, _password,_carOrderId];
        
        //        NSLog(@"endUrl = %@",endUrl);
        // 结束需要将此 cell 移除
        [TYHHttpTool get:endUrl params:nil success:^(id json) {
            
            //            NSLog(@"json = %@ %@",[json class], json);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            //            NSLog(@"error = %@",[error localizedDescription]);
        }];
        
    }
    else if([btn.currentTitle isEqualToString:@"结束任务"]) {
        
        NSString * baseUrl = @"/cm/carMobile!driverEndTask.action";
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        
        // 结束需要将此 cell 移除
        [TYHHttpTool get:endUrl params:nil success:^(id json) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            // 结束后到反馈页面
            NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
            //  assignCarId，realCount，realTime，realAddress，note
            NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@", k_V3ServerURL, baseUrl , _userName, _password,_carOrderId];
            
            TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
            feedback.urlStr = endUrl2;
            [self.navigationController pushViewController:feedback animated:YES];
            
            
        } failure:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"error = %@",[error localizedDescription]);
            // 结束后到反馈页面
            NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
            //  assignCarId，realCount，realTime，realAddress，note
            NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@", k_V3ServerURL, baseUrl , _userName, _password,_carOrderId];
            
            TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
            feedback.urlStr = endUrl2;
            [self.navigationController pushViewController:feedback animated:YES];
        }];
        
    } else if([btn.currentTitle isEqualToString:@"确认出车"]) {
        
        NSString * baseUrl = @"/cm/carMobile!driverEnsureBus.action";
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        
        // 结束需要将此 cell 移除
        [TYHHttpTool get:endUrl params:nil success:^(id json) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            NSLog(@"error = %@",[error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else if([btn.currentTitle isEqualToString:@"反馈"]) {
        
        // 司机反馈
        NSString * baseUrl = @"/cm/carMobile!driverFeedback.action";
        //  assignCarId，realCount，realTime，realAddress，note
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&assignCarId=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        
        TYHFeedBackViewController * feedback = [[TYHFeedBackViewController alloc] init];
        
        feedback.urlStr = endUrl;
        feedback.One = YES;
        
        [self.navigationController pushViewController:feedback animated:YES];
    }
    
    else if ([btn.currentTitle isEqualToString:@"派车"]||[btn.currentTitle isEqualToString:@"继续派车"]) {
        
        TYHPaiViewController * paiVc = [[TYHPaiViewController alloc] init];
        
        NSString * baseUrl = @"/cm/carMobile!getCarsInfo.action";
        paiVc.urlStr  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&operationCode=carmanage", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        
        paiVc.username = _userName;
        paiVc.password = _password;
        paiVc.carOrderId = _carOrderId;
        paiVc.One = YES;
        [self.navigationController pushViewController:paiVc animated:YES];
        
    } else if([btn.currentTitle isEqualToString:@"审核"]) {
        // id，status( 1通过  2不通过) ，advice
        TYHCheckViewController * checkVc = [[TYHCheckViewController alloc] init];
        checkVc.title  = @"订车单审核";
        NSString * baseUrl = @"/cm/carMobile!checkOrderCar.action";
        
        checkVc.urlStr  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        checkVc.One = YES;
        [self.navigationController pushViewController:checkVc animated:YES];
        
    } else if ([btn.currentTitle isEqualToString:@"取消订车单"]) {
        // 取消订车单
        NSString *baseUrl = @"/cm/carMobile!cancelOrderCar.action";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , self.userName, self.password, _carOrderId];
        
        self.strUrl2 = strUrl;
        
        [self didClickNewButton:btn];
        
    }
    else if ([btn.currentTitle isEqualToString:@"不予派车"]) {
        // 不予派车
        NSString *baseUrl = @"/cm/carMobile!unPassOrderCar.action";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , self.userName, self.password, _carOrderId];
        
        self.strUrl2 = strUrl;
        [self didClickNewButton:btn];
        
    }
    else if([btn.currentTitle isEqualToString:@"结束派车"]) {
        
        NSString * baseUrl = @"/cm/carMobile!passOrderCar.action";
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        
        NSLog(@"endUrl = %@",endUrl);
        // 结束需要将此 cell 移除
        [TYHHttpTool get:endUrl params:nil success:^(id json) {
            
            NSLog(@"json = %@ %@",[json class], json);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"error = %@",[error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else if([btn.currentTitle isEqualToString:@"评价"]) {
        
        NSString * baseUrl = @"/cm/carMobile!toCarUserFeedback.action";// 获取评价页某些数据
        NSString * baseUrl2 = @"/cm/carMobile!saveCarUserFeedback.action"; // 提交评价
        
        NSString * endUrl  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl , _userName, _password, _carOrderId];
        NSString * endUrl2  = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@", k_V3ServerURL, baseUrl2 , _userName, _password, _carOrderId];
        
        TYHFeedBackCotroller * feedBack = [[TYHFeedBackCotroller alloc] init];
        feedBack.title = @"用车评价";
        feedBack.One = YES;
        // 也可以转成模型传过去
        [TYHHttpTool get:endUrl params:nil success:^(id json) {
            
            //            NSLog(@"json222 = %@",json);
            
            feedBack.urlStr = endUrl;
            feedBack.urlStr2 = endUrl2;
            feedBack.starData = json[@"starData"];
            
            NSArray * array = json[@"assignData"];
            feedBack.assignData = array;
            
            //            NSDictionary * dict = array[0];
            //            feedBack.driverStr = dict[@"driver"];
            //            feedBack.carNum = dict[@"carName"];
            //            feedBack.driverId = dict[@"assignId"];
            
            [self.navigationController pushViewController:feedBack animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark === 创建topView
- (void)createTopView {
    
    
    
    
    CarDetailModel * detailModel;
    OaCarDataModel * model;
    
    DriverDetailModel * detailModel2;
    OaCar2Model * detailModel3;
    
    if (self.tag == 1001) {
        
        detailModel2 = self.carDetailArray[0];
        detailModel3 = detailModel2.oaCarData[_userChooseIndex];
        // 司机 Telephone
        if (![NSString isBlankString:detailModel3.telephone]) {
            
            [self.telephones addObject:detailModel3.telephone];
        } else {
            
            [self.telephones addObject:@"无"];
            
        }
        
    } else {
        detailModel = self.carDetailArray[0];
        if (![NSString isBlankString:detailModel.telephone]) {
            
            [self.telephones addObject:detailModel.telephone];
        } else {
            
            [self.telephones addObject:@"无"];
        }
    }
    
    
    if (detailModel.backCount == nil) {
        self.fan = NO;
        
    } else {
        self.fan = YES;
    }
    
    
    [self.allData addObjectsFromArray:self.arrayStr];
    // 这样来判定 是否是审核人
    if ([self.optionalOneStr isEqualToString:@"审核"]) {
        
        _check = NO;
        
    } else {
        
        if ([detailModel.checkFlag isEqualToString:@"1"]) {
            // && [detailModel.checkStatus isEqualToString:@"1"]
            // 已审核  审核通过 checkStatus 1 审核不通过 checkStatus 0
            if ([detailModel.checkStatusView isEqualToString:@"未审核"]) {
                
                _check = NO;
                
            } else {
                
                _check = YES;
                [self.allData addObjectsFromArray:self.arrayStr2];
            }
        }
    }
    
    
    UIButton *chooseUserbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseUserbutton setTitle:@"选择用车人" forState:UIControlStateNormal];
    chooseUserbutton.layer.masksToBounds = YES;
    chooseUserbutton.layer.borderWidth = 1.f;
    chooseUserbutton.layer.borderColor = [UIColor orangeColor].CGColor;
    chooseUserbutton.layer.cornerRadius = 4.f;
    chooseUserbutton.titleLabel.font = [UIFont systemFontOfSize:13];
    [chooseUserbutton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    chooseUserbutton.frame = CGRectMake(160, 6 , 75, 20);
    [chooseUserbutton addTarget:self action:@selector(initPickview) forControlEvents:UIControlEventTouchUpInside];
    if (detailModel2.oaCarData && detailModel2.oaCarData.count > 1) {
         [self.view addSubview:chooseUserbutton];
    }
   
    
    // 快速创建 N 个 View
    for (int i = 0; i< self.allData.count; i++) {
        
        LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, 10 +i *kHeight, kWidth, kHeight) description:self.allData[i] Delegate:self];
        
        if (detailModel2.oaCarData && detailModel2.oaCarData.count > 1 && i == 0) {
            [view addSubview:chooseUserbutton];
        }
        
        
        view.textField.tag = 1000 + i;
        view.textField.font = [UIFont systemFontOfSize:14];
        if (i == 10 + 1 && !self.fan) {
            view.imageView.hidden = NO;
        } else {
            if (i == 16 + 1) {
                view.imageView.hidden = NO;
            } else {
                
                view.imageView.hidden = YES;
            }
        }
        view.label.textAlignment = NSTextAlignmentCenter;
        view.label.font = [UIFont systemFontOfSize:14];
        view.textField.userInteractionEnabled = NO;
        view.backgroundColor = [UIColor whiteColor];
        // 保存上一个 view
        [self.view addSubview:view];
        
        if (i == 0) {
            view.sd_layout
            .leftSpaceToView(self.scrollView, 0)
            .rightSpaceToView(self.scrollView, 0)
            .topSpaceToView(self.scrollView, 10)
            .heightIs(kHeight);
            
        }
        else {
            
            if (i == 11 + 1) {
                
                // 表明有返程
                if (!self.fan) {
                    
                    if ([_loginName isEqualToString:model.driver] || [_loginName isEqualToString:detailModel.carUserName]) {
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(0.00001);
                        
                    } else {
                        
                        UIButton * button = [UIButton addWithTarget:self action:@selector(callTelephone:) title:@"拨打电话" titleColor:[UIColor lightGrayColor] image:@"拨打电话" highImage:@"拨打电话"];
                        
                        button.frame = CGRectMake(0, 0, kWidth/2, 45);
                        [view addSubview:button];
                        
                        UIButton * button2 = [UIButton addWithTarget:self action:@selector(sendMessage:) title:@"发送短信" titleColor:[UIColor lightGrayColor] image:@"发送短信" highImage:@"发送短信"];
                        
                        button2.frame = CGRectMake(kWidth/2, 0, kWidth/2, 45);
                        [view addSubview:button2];
                        
                        button.tag = 4000;
                        button2.tag = 4000;
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(button.height);
                        
                    }
                    
                } else {
                    
                    view.label.text = nil;
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                    label.text = @"返程信息";
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    
                    view.backgroundColor = [UIColor Color];
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(label.height);
                    
                }
                
            }
            
            else if (i == 12 + 1) {
                
                if(_check && !self.fan) {
                    
                    view.label.text = nil;
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                    label.text = @"审核情况";
                    label.font = [UIFont systemFontOfSize:12];
                    
                    [view addSubview:label];
                    
                    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 120, 0, 100, 20)];
                    label2.textAlignment = NSTextAlignmentCenter;
                    if([detailModel.checkStatus isEqualToString:@"1"]){
                        
                        label2.text = @"审核通过";
                        label2.textColor = [UIColor  TabBarColorGreen];
                    } else if ([detailModel.checkStatus isEqualToString:@"0"]){
                        
                        label2.text = @"审核未通过";
                        label2.textColor = [UIColor  redColor];
                    }
                    label2.font = [UIFont systemFontOfSize:12];
                    
                    [view addSubview:label2];
                    
                    view.backgroundColor = [UIColor Color];
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(label.height);
                    
                }
                
            }
            else if (i == 18 + 1) {
                
                if(_check && self.fan) {
                    
                    view.label.text = nil;
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                    label.text = @"审核情况";
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    
                    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 120, 0, 100, 20)];
                    label2.textAlignment = NSTextAlignmentCenter;
                    if([detailModel.checkStatus isEqualToString:@"1"]){
                        
                        label2.text = @"审核通过";
                        label2.textColor = [UIColor  TabBarColorGreen];
                    } else if ([detailModel.checkStatus isEqualToString:@"0"]){
                        
                        label2.text = @"审核不通过";
                        label2.textColor = [UIColor  redColor];
                    }
                    label2.font = [UIFont systemFontOfSize:12];
                    
                    [view addSubview:label2];
                    
                    view.backgroundColor = [UIColor Color];
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(label.height);
                    
                }
                
            }
            else if (i == 17 + 1) {
                
                if (self.fan) {
                    
                    if ([_loginName isEqualToString:detailModel3.checkUser] || [_loginName isEqualToString:detailModel.carUserName]) {
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(0.00001);
                        
                    } else {
                        
                        UIButton * button = [UIButton addWithTarget:self action:@selector(callTelephone:) title:@"拨打电话" titleColor:[UIColor lightGrayColor] image:@"拨打电话" highImage:@"拨打电话"];
                        
                        button.frame = CGRectMake(0, 0, kWidth/2, 45);
                        [view addSubview:button];
                        
                        UIButton * button2 = [UIButton addWithTarget:self action:@selector(sendMessage:) title:@"发送短信" titleColor:[UIColor lightGrayColor] image:@"发送短信" highImage:@"发送短信"];
                        
                        button2.frame = CGRectMake(kWidth/2, 0, kWidth/2, 45);
                        [view addSubview:button2];
                        
                        button.tag = 4000;
                        button2.tag = 4000;
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(button.height);
                    }
                }
                else  {
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(kHeight);
                }
                
            }else {
                
                view.sd_layout
                .leftSpaceToView(self.scrollView, 0)
                .rightSpaceToView(self.scrollView, 0)
                .topSpaceToView(self.view1, 0)
                .heightIs(kHeight);
            }
        }
        
        if (self.tag == 1001) {
            
            if (i == 0) {
                view.textField.text = detailModel3.carUserName;
            } else if (i == 1) {
                if ([NSString isBlankString:detailModel3.telephone]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel3.telephone;
                }
            } else if (i == 2) {
                view.textField.text = detailModel3.departmentName;
            } else if (i == 3) {
                view.textField.text = detailModel3.userDate;
            } else if (i == 4) {
                view.textField.text = detailModel3.startTime;
            }
            else if (i == 4 + 1) {
                view.textField.text = detailModel3.arriveTime;
            } else if (i == 5 + 1) {
                view.textField.text = detailModel3.address;
            } else if (i == 6 + 1) {
                view.textField.text = detailModel3.userCount;
            } else if (i == 7 + 1) {
                if ([NSString isBlankString:detailModel3.personList]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel3.personList;
                }
            } else if (i == 8 + 1) {
                if ([NSString isBlankString:detailModel3.reason]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel3.reason;
                }
            } else if (i == 9 + 1) {
                
                if ([NSString isBlankString:detailModel3.instruction]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel3.instruction;
                }
            } else if (i == 10 + 1) {
                if ([NSString isBlankString:detailModel3.backCount]) {
                    
                    view.textField.text = @"否";
                } else {
                    
                    view.textField.text = @"是";
                    
                }
                
            }
            
            // 有返程责设置返程
            if (self.fan) {
                
                if (i == 12 + 1) {
                    view.textField.text = detailModel3.backDate;
                } else if (i == 13 + 1) {
                    
                    view.textField.text = detailModel3.backTime;
                } else if (i == 14 + 1) {
                    
                    view.textField.text = detailModel3.backAddress;
                } else if (i == 15 + 1) {
                    
                    view.textField.text = detailModel3.backCount;
                } else if (i == 16 + 1) {
                    
                    view.textField.text = detailModel3.backPerson;
                }
                
                if (_check) {
                    
                    if (i == 19 + 1) {
                        
                        view.textField.text = detailModel3.checkUser;
                        
                    } else if (i == 20 + 1) {
                        
                        view.textField.text = detailModel3.checkAdvice;
                        
                    }
                }
                
            } else {
                // 没返程
                if (_check) {
                    
                    if (i == 13 + 1) {
                        view.textField.text = detailModel3.checkUser;
                        
                    } else if (i == 14 + 1) {
                        view.textField.text = detailModel3.checkAdvice;
                        
                    }
                }
                
            }
            
        } else {
            
            if (i == 0) {
                view.textField.text = detailModel.carUserName;
            } else if (i == 1) {
                view.textField.text = detailModel.telephone.length?detailModel.telephone:@"无";
            } else if (i == 2) {
                view.textField.text = detailModel.departmentName;
            } else if (i == 3) {
                view.textField.text = detailModel.userDate;
            }else if (i == 4) {
                view.textField.text = detailModel.startTime;
            }
            else if (i == 4 + 1) {
                view.textField.text = detailModel.arriveTime;
            } else if (i == 5 + 1) {
                view.textField.text = detailModel.address;
            } else if (i == 6 + 1) {
                view.textField.text = detailModel.userCount;
            } else if (i == 7 + 1) {
                if ([NSString isBlankString:detailModel.personList]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel.personList;
                }
            } else if (i == 8 + 1) {
                if ([NSString isBlankString:detailModel.reason]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel.reason;
                }
            } else if (i == 9 + 1) {
                if ([NSString isBlankString:detailModel.instruction]) {
                    
                    view.textField.text = @"无";
                } else {
                    view.textField.text = detailModel.instruction;
                }
            } else if (i == 10 + 1) {
                if ([NSString isBlankString:detailModel.backCount]) {
                    
                    view.textField.text = @"否";
                } else {
                    
                    view.textField.text = @"是";
                    
                }
                
            }
            
            // 有返程责设置返程
            if (self.fan) {
                
                if (i == 12 + 1) {
                    view.textField.text = detailModel.backDate;
                } else if (i == 13 + 1) {
                    
                    view.textField.text = detailModel.backTime;
                } else if (i == 14 + 1) {
                    
                    view.textField.text = detailModel.backAddress;
                } else if (i == 15 + 1) {
                    
                    view.textField.text = detailModel.backCount;
                } else if (i == 16 + 1) {
                    if ([NSString isBlankString:detailModel.backPerson]) {
                        view.textField.text = @"无";
                    }
                    else
                    view.textField.text = detailModel.backPerson;
                }
                
                if (_check) {
                    
                    if (i == 19 + 1) {
                        
                        view.textField.text = detailModel.checkUser;
                        
                    } else if (i == 20 + 1) {
                        
                        view.textField.text = detailModel.checkAdvice;
                        
                    }
                }
                
            } else {
                
                // checkStatus == 1;
                // i == 12 不需要设置
                if (_check) {
                    
                    if (i == 13 + 1) {
                        
                        view.textField.text = detailModel.checkUser;
                        
                    } else if (i == 14 + 1) {
                        
                        view.textField.text = detailModel.checkAdvice;
                        
                    }
                }
            }
            
            
        }
        
        [self.scrollView addSubview:view];
        // 保存上一个 View
        self.view1 = view;
    }
    
    
    // 审核未知 需重新创建 表示
    if (self.tag == 1001) {
        
        if (self.carDetailArray.count > 0) {
            
            [self setupNewSubViews2];
        }
        
    }
    else {
        
        if (detailModel.oaCarData.count > 0) {
            
            [self setupNewSubViews2];
            
        }
    }
}

- (void)setupNewSubViews2 {
    
    
    CarDetailModel * detailModel;
    OaCarDataModel * model;
    
    // 司机
    DriverDetailModel * detailModel2;
    OaCar2Model * detailModel3;
    if (self.tag == 1001) {
    
        detailModel2 = self.carDetailArray[0];
        // 可能有多个派车的情况
        
            // 先移除再添加
            [self.allData2 removeAllObjects];
            [self.allData2 addObjectsFromArray:self.arrayStr3];
            
            detailModel3 = detailModel2.oaCarData[_userChooseIndex];
            
            if ([detailModel3.feedBackFlag isEqualToString:@"1"]) {
                
                // 有乘客评价
                self.chengFeedback = YES;
                
            } else {
                // 无乘客评价
                self.chengFeedback = NO;
            }
            
            // 司机有无反馈  判断必填反馈参数
            if (detailModel2.realTime == nil) {
                
                // 乘客评价
                if(self.chengFeedback){
                    [self.allData2 addObjectsFromArray:self.arrayStr4];
                }
                
            } else {
                // 有司机反馈
                [self.allData2 addObjectsFromArray:self.arrayStr5];
            }
            
            // 快速创建 N 个 View
            for (int i = 0; i< self.allData2.count; i++) {
                
                
                LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, 10 +i *kHeight, kWidth, kHeight) description:self.allData2[i] Delegate:self];
                view.textField.tag = 1000 + i;
                view.textField.font = [UIFont systemFontOfSize:14];
                view.backgroundColor = [UIColor whiteColor];
                if (i == 4 ) {
                    view.imageView.hidden = NO;
                } else {
                    
                    view.imageView.hidden = YES;
                }
                // i>10 才表示有乘客反馈 否则没有 则不需要处理
                if (self.chengFeedback) {
                    
                    if (i > 10 + 1) {
                        
                        view.label.frame =CGRectMake(0, 0, kWidth/3.0, kHeight -1);
                        view.textField.frame =CGRectMake(kWidth/3.0, 0, kWidth * 2/3.0, kHeight -1);
                    }
                } else {
                    
                    if (i > 6) {
                        view.label.frame =CGRectMake(0, 0, kWidth/3.0, kHeight -1);
                        view.textField.frame =CGRectMake(kWidth/3.0, 0, kWidth * 2/3.0, kHeight -1);
                    }
                }
                
                view.label.textAlignment = NSTextAlignmentCenter;
                view.label.font = [UIFont systemFontOfSize:14];
                view.textField.userInteractionEnabled = NO;
                // 保存上一个 view
                [self.view addSubview:view];
                
                if (i == 0) {
                    
                    view.label.text = nil;
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                    
                    label.text = [NSString stringWithFormat:@"派车记录"];
                    
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    view.backgroundColor = [UIColor Color];
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(label.height);
                    
                }
                else {
                    
                    if (i == 5) {
                        
                        if ([_loginName isEqualToString:detailModel3.orderUser] || [_loginName isEqualToString:detailModel2.driver]) {
                            
                            view.sd_layout
                            .leftSpaceToView(self.scrollView, 0)
                            .rightSpaceToView(self.scrollView, 0)
                            .topSpaceToView(self.view1, 0)
                            .heightIs(0.000001);
                            
                        } else {
                            // 表明有返程
                            UIButton * button = [UIButton addWithTarget:self action:@selector(callTelephone:) title:@"拨打电话" titleColor:[UIColor lightGrayColor] image:@"拨打电话" highImage:@"拨打电话"];
                            
                            button.frame = CGRectMake(0, 0, kWidth/2, 45);
                            [view addSubview:button];
                            
                            UIButton * button2 = [UIButton addWithTarget:self action:@selector(sendMessage:) title:@"发送短信" titleColor:[UIColor lightGrayColor] image:@"发送短信" highImage:@"发送短信"];
                            
                            button2.frame = CGRectMake(kWidth/2, 0, kWidth/2, 45);
                            [view addSubview:button2];
                            
                            button.tag = 4001 + _userChooseIndex;
                            button2.tag = 4001 + _userChooseIndex;
                            
                            [self.telephones addObject:detailModel3.telephone.length?detailModel3.telephone:@""];
                            
                            view.sd_layout
                            .leftSpaceToView(self.scrollView, 0)
                            .rightSpaceToView(self.scrollView, 0)
                            .topSpaceToView(self.view1, 0)
                            .heightIs(button.height);
                        }
                        
                    }
                    
                    else if (i == 6) {
                        
                        view.label.text = nil;
                        
                        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                        if (self.chengFeedback) {
                            label.text = @"乘客评价";
                        } else {
                            label.text = @"司机反馈";
                        }
                        label.font = [UIFont systemFontOfSize:12];
                        [view addSubview:label];
                        
                        view.backgroundColor = [UIColor Color];
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(label.height);
                    }
                    else if (i == 7 || i==8 || i== 9 || i == 10) {
                        
                        if (self.chengFeedback) {
                            
                            StarDataModel * model2;
                            StarDataModel * model3;
                            StarDataModel * model4;
                            StarDataModel * model5;
                            
                            model2 = detailModel3.starData[0];
                            model3 = detailModel3.starData[1];
                            model4 = detailModel3.starData[2];
                            model5 = detailModel3.starData[3];
                            
                            LHRatingView * rateView  = [[LHRatingView alloc] initWithFrame:CGRectMake(kWidth - 145, 2, 100, 28)];
                            rateView.userInteractionEnabled = NO;
                            rateView.ratingType = INTEGER_TYPE;//整颗星
                            
                            if (i == 7) {
                                rateView.score = [model2.value floatValue];
                            } else if (i == 8) {
                                rateView.score = [model3.value floatValue];
                            } else if (i == 9) {
                                rateView.score = [model4.value floatValue];
                            }
                            else if(i == 10)  rateView.score = [model4.value floatValue];
                            
                            [view addSubview:rateView];
                            
                        } else {
                            
                        }

                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(kHeight);
                    }
                    else if (i == 11 + 1) {
                        
                        // 若没有乘客反馈 则
                        view.label.text = nil;
                        
                        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                        label.text = @"司机反馈";
                        label.font = [UIFont systemFontOfSize:12];
                        [view addSubview:label];
                        
                        view.backgroundColor = [UIColor Color];
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(label.height);
                        
                    }else {
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(kHeight);
                    }
                    
                    
                    if (self.chengFeedback) {
                        
                        if (i == 1) {
                            view.textField.text = detailModel2.driver;
                        } else if (i == 2) {
                            NSString * str = [NSString stringWithFormat:@"%@ %@",detailModel2.carName,detailModel2.carNum];
                            view.textField.text = str;
                        } else if (i == 3) {
                            view.textField.text = detailModel3.useTime;
                        } else if (i == 4) {
                            view.textField.text = detailModel3.useAddress;
                        }  else if (i == 10 + 1) {
                            view.textField.text = detailModel3.feedBackAdvice.length?detailModel3.feedBackAdvice:@"无";
                        } else if (i == 12 + 1) {
                            view.textField.text = detailModel2.realCount;
                        } else if (i == 13 + 1) {
                            view.textField.text = detailModel2.realAddress;
                        } else if (i == 14 + 1) {
                            view.textField.text = detailModel2.realTime;
                        } else if (i == 15 + 1) {
                            view.textField.text = detailModel2.note.length?detailModel2.note:@"无";
                        }
                        
                    } else {
                        
                        if (i == 1) {
                            view.textField.text = detailModel2.driver;
                        } else if (i == 2) {
                            NSString * str = [NSString stringWithFormat:@"%@ %@",detailModel2.carName,detailModel2.carNum];
                            view.textField.text = str;
                        } else if (i == 3) {
                            view.textField.text = detailModel3.useTime;
                        } else if (i == 4) {
                            view.textField.text = detailModel3.useAddress;
                        } else if (i == 7) {
                            view.textField.text = detailModel2.realCount;
                        } else if (i == 8) {
                            view.textField.text = detailModel2.realAddress;
                        } else if (i == 9) {
                            view.textField.text = detailModel2.realTime;
                        } else if (i == 10) {
                            view.textField.text = detailModel2.note;
                        }
                        
                    }
                    
                }
                
                [self.scrollView addSubview:view];
                // 保存上一个 View
                self.view1 = view;
            }
    // 非司机为1001的判定===========================
    // 非司机为1001的判定===========================
    // 非司机为1001的判定===========================
    
    
    } else {
        
        detailModel = self.carDetailArray[0];
        
            [self.allData2 removeAllObjects];
            [self.allData2 addObjectsFromArray:self.arrayStr3];
            
            model = detailModel.oaCarData[_userChooseIndex];
            
            if ([model.feedBackFlag isEqualToString:@"1"]) {
                
                self.chengFeedback = YES;
                
            } else {
                // 无乘客反馈
                self.chengFeedback = NO;
            }
            
            // 司机有无反馈  判断必填反馈参数
            if ([model.status isEqualToString:@"3"]) {
                
                // 有司机反馈
                [self.allData2 addObjectsFromArray:self.arrayStr5];
                
            } else {
                // 乘客评价
                if(self.chengFeedback){
                    [self.allData2 addObjectsFromArray:self.arrayStr4];
                }
            }
            
            // 快速创建 N 个 View
            for (int i = 0; i< self.allData2.count; i++) {
                
                LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, 10 +i *kHeight, kWidth, kHeight) description:self.allData2[i] Delegate:self];
                view.textField.tag = 1000 + i;
                view.textField.font = [UIFont systemFontOfSize:14];
                view.backgroundColor = [UIColor whiteColor];
                if (i == 4 ) {
                    view.imageView.hidden = NO;
                } else {
                    
                    view.imageView.hidden = YES;
                }
                // i>10 才表示有乘客反馈 否则没有 则不需要处理
                if (self.chengFeedback) {
                    
                    if (i > 10 + 1) {
                        
                        view.label.frame =CGRectMake(0, 0, kWidth/3.0, kHeight -1);
                        view.textField.frame =CGRectMake(kWidth/3.0, 0, kWidth * 2/3.0, kHeight -1);
                    }
                } else {
                    
                    if (i > 6) {
                        view.label.frame =CGRectMake(0, 0, kWidth/3.0, kHeight -1);
                        view.textField.frame =CGRectMake(kWidth/3.0, 0, kWidth * 2/3.0, kHeight -1);
                    }
                }
                
                view.label.textAlignment = NSTextAlignmentCenter;
                view.label.font = [UIFont systemFontOfSize:14];
                view.textField.userInteractionEnabled = NO;
                //        view.backgroundColor = [UIColor whiteColor];
                // 保存上一个 view
                [self.view addSubview:view];
                
                if (i == 0) {
                    
                    view.label.text = nil;
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];

                    label.text = [NSString stringWithFormat:@"派车单"];
                    
                    label.font = [UIFont systemFontOfSize:12];
                    [view addSubview:label];
                    view.backgroundColor = [UIColor Color];
                    
                    view.sd_layout
                    .leftSpaceToView(self.scrollView, 0)
                    .rightSpaceToView(self.scrollView, 0)
                    .topSpaceToView(self.view1, 0)
                    .heightIs(label.height);
                    
                }
                else {
                    
                    if (i == 5) {
                        
                        if ([_loginName isEqualToString:detailModel3.orderUser] || [_loginName isEqualToString:detailModel2.driver]) {
                            
                            view.sd_layout
                            .leftSpaceToView(self.scrollView, 0)
                            .rightSpaceToView(self.scrollView, 0)
                            .topSpaceToView(self.view1, 0)
                            .heightIs(0.000001);
                            
                        } else {
                            // 表明有返程
                            
                            UIButton * button = [UIButton addWithTarget:self action:@selector(callTelephone:) title:@"拨打电话" titleColor:[UIColor lightGrayColor] image:@"拨打电话" highImage:@"拨打电话"];
                            
                            button.frame = CGRectMake(0, 0, kWidth/2, 45);
                            [view addSubview:button];
                            
                            UIButton * button2 = [UIButton addWithTarget:self action:@selector(sendMessage:) title:@"发送短信" titleColor:[UIColor lightGrayColor] image:@"发送短信" highImage:@"发送短信"];
                            
                            [self.telephones addObject:model.phone];// 这是多个派车单
                            
                            button2.frame = CGRectMake(kWidth/2, 0, kWidth/2, 45);
                            [view addSubview:button2];
                            
                            button.tag = 4001 + _userChooseIndex;
                            button2.tag = 4001 + _userChooseIndex;
                            
                            view.sd_layout
                            .leftSpaceToView(self.scrollView, 0)
                            .rightSpaceToView(self.scrollView, 0)
                            .topSpaceToView(self.view1, 0)
                            .heightIs(button.height);
                        }
                        
                    }
                    
                    else if (i == 6) {
                        
                        view.label.text = nil;
                        
                        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                        if (self.chengFeedback) {
                            label.text = @"乘客评价";
                        } else {
                            label.text = @"司机反馈";
                        }
                        label.font = [UIFont systemFontOfSize:12];
                        [view addSubview:label];
                        
                        view.backgroundColor = [UIColor Color];
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(label.height);
                    }
                    else if (i == 7 || i==8 || i== 9 || i == 10) {
                        
                        if (self.chengFeedback) {
                            
                            StarDataModel * model2;
                            StarDataModel * model3;
                            StarDataModel * model4;
                            StarDataModel * model5;
                            
                            model2 = model.starData[0];
                            model3 = model.starData[1];
                            model4 = model.starData[2];
                            model5 = detailModel3.starData[3];
                            
                            LHRatingView * rateView  = [[LHRatingView alloc] initWithFrame:CGRectMake(kWidth - 135, 2, 100, 28)];
                            rateView.userInteractionEnabled = NO;
                            rateView.ratingType = INTEGER_TYPE;//整颗星
                            
                            if (i == 7) {
                                rateView.score = [model2.value floatValue];
                            } else if (i == 8) {
                                rateView.score = [model3.value floatValue];
                            } else if (i == 9) {
                                rateView.score = [model4.value floatValue];
                            }else if(i == 10) rateView.score = [model4.value floatValue];
                            
                            [view addSubview:rateView];
                            
                        } else {
                            
                            
                        }
                        
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(kHeight);
                    }
                    else if (i == 11 + 1) {
                        
                        // 若没有乘客反馈 则
                        view.label.text = nil;
                        
                        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                        label.text = @"司机反馈";
                        label.font = [UIFont systemFontOfSize:12];
                        [view addSubview:label];
                        
                        view.backgroundColor = [UIColor Color];
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(label.height);
                        
                    }else {
                        
                        view.sd_layout
                        .leftSpaceToView(self.scrollView, 0)
                        .rightSpaceToView(self.scrollView, 0)
                        .topSpaceToView(self.view1, 0)
                        .heightIs(kHeight);
                    }
                    
                    
                    if (self.chengFeedback) {
                        if (i == 1) {
                            view.textField.text = model.driver;
                        } else if (i == 2) {
                            NSString * str = [NSString stringWithFormat:@"%@ %@",model.carName,model.carNum];
                            view.textField.text = str;
                        } else if (i == 3) {
                            view.textField.text = model.useTime;
                        } else if (i == 4) {
                            view.textField.text = model.useAddress;
                        }  else if (i == 10 + 1) {
                            view.textField.text = model.feedBackAdvice.length?model.feedBackAdvice:@"无";
                        } else if (i == 12 + 1) {
                            view.textField.text = model.realCount;
                        } else if (i == 13 + 1) {
                            view.textField.text = model.realAddress;
                        } else if (i == 14 + 1) {
                            view.textField.text = model.realTime;
                        } else if (i == 15 + 1) {
                            view.textField.text = model.note.length?model.note:@"无";
                        }
                        
                    } else {
                        
                        if (i == 1) {
                            view.textField.text = model.driver;
                        } else if (i == 2) {
                            NSString * str = [NSString stringWithFormat:@"%@ %@",model.carName,model.carNum];
                            view.textField.text = str;
                        } else if (i == 3) {
                            view.textField.text = model.useTime;
                        } else if (i == 4) {
                            view.textField.text = model.useAddress;
                        } else if (i == 7) {
                            view.textField.text = model.realCount;
                        } else if (i == 8) {
                            view.textField.text = model.realAddress;
                        } else if (i == 9) {
                            view.textField.text = model.realTime;
                        } else if (i == 10) {
                            view.textField.text = model.note;
                        }
                    }
                    
                }
                
                [self.scrollView addSubview:view];
                // 保存上一个 View
                self.view1 = view;
            }
        }
}
/*
 1、调用 自带mail
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];
 2、调用 电话phone
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
 3、调用 SMS
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://800888"]];
 4、调用自带 浏览器 safari
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hzlzh.com"]];
 */
- (void)sendMessage:(UIButton *)btn{
    
    [self isMobileTelephone:@"sms://" string:self.telephones[btn.tag - 4000]];
    
}
- (void)callTelephone:(UIButton *)btn{
    
    [self isMobileTelephone:@"tel://" string:self.telephones[btn.tag - 4000]];
}

- (void)isMobileTelephone:(NSString*)str string:(NSString *)telephone{
    
    // 合理否
    if ([NSString isMobileNumber:telephone] == NO) {
        [self.view makeToast:@"号码不合法" duration:2 position:nil];
        
    } else {
        
        NSString * telephone2 = [NSString stringWithFormat:@"%@%@",str,telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephone2]];
    }
}

- (void)getDetailStatus {
    
    // /cm/carMobile!getOrderCarInfo.action
    // /cm/carMobile!getAssignCarInfo.action tag 1001; // 司机
    
    NSString * urlStr;
    if (self.tag == 1001) {
        
        urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getAssignCarInfo.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&id=%@",k_V3ServerURL,_userName,_password,_carOrderId];
        [TYHHttpTool get:urlStr params:nil success:^(id json) {
            
            NSLog(@"jsonjsonjson == %@",json);
            
            DriverDetailModel * driverModel = [DriverDetailModel objectWithKeyValues:json];
            
            [self.carDetailArray addObject:driverModel];
            [self createTopView];
            [self.scrollView setupAutoContentSizeWithBottomView:self.view1 bottomMargin:0];
            
        } failure:^(NSError *error) {
        }];
    } else {
        
        urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getOrderCarInfo.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&id=%@",k_V3ServerURL,_userName,_password,_carOrderId];
        [TYHHttpTool get:urlStr params:nil success:^(id json) {
            
            NSLog(@"jsonjsonjson111 == %@",json);
            CarDetailModel * carDetailModel = [CarDetailModel objectWithKeyValues:json];
            [self.carDetailArray addObject:carDetailModel];
            [self createTopView];
            [self.scrollView setupAutoContentSizeWithBottomView:self.view1 bottomMargin:0];
            
        } failure:^(NSError *error) {
        }];
    }
}


-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择用车人";
    self.pickerView.appType = @"订车管理";
    
    
    __weak typeof(self) weakSelf = self;
    DriverDetailModel * detailModel2;
    
    detailModel2 = self.carDetailArray[0];
    
    NSMutableArray *array = [NSMutableArray array];
    for (OaCar2Model *model in detailModel2.oaCarData) {
        [array addObject:model.carUserName];
    }
    self.pickerView.dataSource = array;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        weakSelf.userChooseIndex = index;
        
        
        [weakSelf.allData removeAllObjects];
        [weakSelf.allData2 removeAllObjects];
        
        [weakSelf createTopView];
    };
    [self.pickerView show];
    
}


@end
