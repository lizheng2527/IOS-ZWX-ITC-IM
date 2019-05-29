//
//  RMChargeDealController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RMChargeDealController.h"
#import <UIView+Toast.h>
#import "TYHRepairDefine.h"
#import "TYHHttpTool.h"
#import "TYHRepairNetRequestHelper.h"

@interface RMChargeDealController ()<UITextViewDelegate>

@end

@implementation RMChargeDealController
{
    BOOL isPass;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    RadioButton-Unselected
    [self initTapGesture];
    isPass = YES;
    self.title = @"费用审批";
    [self createBarItem];
    _reasonTextView.layer.masksToBounds = YES;
    _reasonTextView.layer.borderWidth = 0.5f;
    _reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _reasonTextView.layer.cornerRadius = 3.0f;
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:116/255.0 green:139/255.0 blue:216/255.0 alpha:0.9]];
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


#pragma mark - Actions
//提交审核结果
- (IBAction)submitAction:(id)sender {
    
    [self.reasonTextView resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在提交审核";
    
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper submitChargeWithRepairID:self.repairID YESorNO:isPass reasonText:self.reasonTextView.text andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        [hud removeFromSuperview];
        [self.view makeToast:@"审核已提交" duration:1.5 position:CSToastPositionCenter];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
        [self.view makeToast:@"审核提交失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}

-(NSMutableDictionary *)getResultDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}


-(void)initTapGesture
{
    UITapGestureRecognizer *gesPass = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passBtnClickAction:)];
    [_passLabel addGestureRecognizer:gesPass];
    
    UITapGestureRecognizer *gesUnpass = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unPassBtnClickAction:)];
    [_unPassLabel addGestureRecognizer:gesUnpass];
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passBtnClickAction:(id)sender {
    [_unPassBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_passBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isPass = YES;
}

- (IBAction)unPassBtnClickAction:(id)sender {
    [_passBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_unPassBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isPass = NO;
}


#pragma mark TextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.reasonTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.reasonTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
