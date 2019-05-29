//
//  WHCheckController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHCheckController.h"
#import "WHNetHelper.h"
#import <UIView+Toast.h>


@interface WHCheckController ()<UITextViewDelegate>


@end

@implementation WHCheckController
{
    BOOL isPass;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    RadioButton-Unselected
    [self initTapGesture];
    isPass = YES;
    self.title = @"审核";
    [self createBarItem];
    _reasonTextView.layer.masksToBounds = YES;
    _reasonTextView.layer.borderWidth = 0.5f;
    _reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _reasonTextView.layer.cornerRadius = 3.0f;
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
    
    WHNetHelper *helper = [WHNetHelper new];
    [helper ApplicationCheckWithResultJson:[self getResultDic] andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        [self.view makeToast:@"审核提交成功" duration:1 position:CSToastPositionCenter];
        [hud removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"审核提交失败 !" duration:1 position:CSToastPositionCenter];
        [hud removeFromSuperview];
    }];
}

-(NSMutableDictionary *)getResultDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([_checkKind isEqualToString:@"dept"]) {
        [dic setValue:isPass?@"2":@"1" forKey:@"checkStatus"];
    }else [dic setValue:isPass?@"4":@"3" forKey:@"checkStatus"];
    [dic setValue:_applyID forKey:@"id"];
    [dic setValue:_checkKind forKey:@"kind"];
    [dic setValue:_reasonTextView.text forKey:@"checkOpinion"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
