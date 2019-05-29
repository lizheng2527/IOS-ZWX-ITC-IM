//
//  PProjectApprovalCheckController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PProjectApprovalCheckController.h"
#import "WHChooseApplyUserController.h"
#import "ProjectNetHelper.h"


@interface PProjectApprovalCheckController ()<UITextViewDelegate,ChoosePersonDelete>

@end

@implementation PProjectApprovalCheckController
{
    BOOL isPass;
    NSString *choosePersonID;
    NSString *choosePersonName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    RadioButton-Unselected
    [self initTapGesture];
    isPass = YES;
    self.title = @"申请审核";
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
    
    [SVProgressHUD showWithStatus:@"正在提交审核"];
    
    NSString *checkStuas = isPass?@"1":@"0";
    
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper checkProjectApplicationWithProjectID:_projectID checkStatus:checkStuas note:_reasonTextView.text serverIDs:choosePersonID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"审核提交成功" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"审核提交失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
    
}



- (IBAction)choosePersonAction:(id)sender {
    
        WHChooseApplyUserController * baseVc = [[WHChooseApplyUserController alloc] init];
        baseVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        baseVc.userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
        baseVc.password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
        baseVc.urlStr = @"/bd/mobile/baseData!getTeacherTree.action";
        baseVc.title = @"选择客户";
        baseVc.whoWillIn = YES;
        baseVc.delegate = self;
        baseVc.inType = @"项目2";
    
        [self.navigationController pushViewController:baseVc animated:YES];

    
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
    
    [_chooseBtn setTitle:@"点击选择人员" forState:UIControlStateNormal];
    if (choosePersonName.length) {
        [_chooseBtn setTitle:choosePersonName forState:UIControlStateNormal];
    }
}

- (IBAction)unPassBtnClickAction:(id)sender {
    [_passBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_unPassBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isPass = NO;
    
    [_chooseBtn setTitle:@"不可选" forState:UIControlStateNormal];
}


- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name {
    choosePersonID = urlId;
    choosePersonName = name;
    [self.chooseBtn setTitle:name forState:UIControlStateNormal];
}

- (void)didselectedUser:(NSString *)userID userName:(NSString *)name
{
    choosePersonID = userID;
    choosePersonName = name;
    [self.chooseBtn setTitle:name forState:UIControlStateNormal];
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
