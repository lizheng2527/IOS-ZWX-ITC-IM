//
//  AssetApplyCheckController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/2.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetApplyCheckController.h"
#import "AssetNetWorkHelper.h"
#import <UIView+Toast.h>

@interface AssetApplyCheckController ()<UITextViewDelegate>

@end

@implementation AssetApplyCheckController
{
    BOOL isPass;
}

-(void)setAssetID:(NSString *)assetID
{
    _assetID = assetID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    RadioButton-Unselected
    [self initTapGesture];
    isPass = YES;
    self.title = @"申请审核";
    [self createBarItem];
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

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"审核提交中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper saveAssetCheckWithCheckReason:_reasonTextView.text checkRestult:isPass?@"3":@"2" checkApplyID:_assetID andStatus:^(BOOL successful, NSMutableArray *datasource) {
        
         [hud removeFromSuperview];
        [self.view makeToast:@"审核成功" duration:1 position:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
         [hud removeFromSuperview];
        [self.view makeToast:@"审核提交失败,可能是网络问题" duration:1 position:nil];
    }];
    
    
    [self.reasonTextView resignFirstResponder];
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
