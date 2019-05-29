//
//  PAddServerRecordController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PAddServerRecordController.h"
#import "SDAutoLayout.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PAddServerRecordCell.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"
#import "ProjectNetHelper.h"

#import "PickerView.h"
#import "ACMediaFrame.h"

@interface PAddServerRecordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;

@end

@implementation PAddServerRecordController
{
    PAddServerRecordCell *mainCell;
    __block NSMutableArray *uploadImageArray;
    
    NSString  *emailString;     //服务人邮箱    string
    NSString  *linkManString;     //    学校接口人    string
    NSString  *linkManPhoneString;     //    接口人电话    string
    NSString  *phoneNumString;     //    服务人电话    string
    NSString  *projectIdString;     //    项目Id    string
    NSString  *projectNameString;     //    项目名称    string
    NSString  *remarkString;     //    备注    string
    NSString  *selfEvaluationString;     //    自我评价    string
    NSString  *serviceContentString;     //    服务内容    string
    NSString  *serviceObjectString;     //    服务对象    string
    NSString  *servicePlaceString;     //    服务地点    string
    NSString  *serviceTargetString;     //    服务目标    string
    NSString  *serviceTimeEndString;     //    服务结束时间    string
    NSString  *serviceTimeStartString;     //    服务开始时间    string
    NSString  *serviceWayString;     //    服务方式    string
    NSString  *serviceorString;     //    服务人    string
    NSString  *sketchString;     //    服务简述    string
    NSString  *togetherString;     //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"服务记录";
    [self createBarItem];
    [self uploadViewInit];
    
    _uploadImageViewHeigh = 0;
    uploadImageArray = [NSMutableArray array];
}

#pragma mark - initView
-(void)initTableView
{
    _mainTableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
}


-(void)createBarItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}




//-(void)createApplyButton
//{
//    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    applyButton.frame = CGRectMake(self.view.width / 2, self.view.height - 30, 60, 20);
//    [applyButton setTitle:@"申请立项" forState: UIControlStateNormal];
//    [applyButton setBackgroundColor:[UIColor lightGrayColor]];
//
//    [self.view addSubview:applyButton];
//}

#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"PAddServerRecordCell";
    PAddServerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PAddServerRecordCell" owner:self options:nil].firstObject;
    }
    
    if (!_bgView.superview) {
        [cell.contentView addSubview:_bgView];
    }
    
    mainCell = cell;
    [cell.chooseDateButton addTarget:self action:@selector(chooseDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseTimeButton addTarget:self action:@selector(chooseStartDateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.applyUserLabel.text = _applyer;
    cell.applyUserPhoneLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MOBIENUM];
    cell.projectNameLabel.text = _projectName;
    
    cell.serviceWaysTextfield.delegate = self;   cell.serviceWaysTextfield.tag = 700001;
    cell.servicePlaceTextfield.delegate = self;  cell.servicePlaceTextfield.tag = 700002;
    cell.serviceCustomTextfield.delegate = self;  cell.serviceCustomTextfield.tag = 700003;
    cell.schoolLinkerTextfield.delegate = self;  cell.schoolLinkerTextfield.tag = 700004;
    cell.schoolLinkerPhoneTextfield.delegate = self;  cell.schoolLinkerPhoneTextfield.tag = 700005;
    cell.serviceAddPersonTextfield.delegate = self;  cell.serviceAddPersonTextfield.tag = 700006;
    
    cell.textView_Jianshu.delegate = self;   cell.textView_Jianshu.tag = 710001;
    cell.textView_Target.delegate = self;  cell.textView_Target.tag = 710002;
    cell.textView_Member.delegate = self;  cell.textView_Member.tag = 710003;
    cell.textView_SelfGrade.delegate = self; cell.textView_SelfGrade.tag = 71004;
    cell.textView_Remark.delegate = self;  cell.textView_Remark.tag = 710005;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 890 + 30 * 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - CellActions
-(void)chooseDateAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_DateAndTime];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
        
        //        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.chooseDateButton setTitle:dateString forState:UIControlStateNormal];
        serviceTimeStartString = dateString;
    };
}

-(void)chooseStartDateAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_DateAndTime];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
        
        //        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.chooseTimeButton setTitle:dateString forState:UIControlStateNormal];
        serviceTimeEndString = dateString;
    };
}


-(void)submitAction:(id)sender
{
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MOBIENUM];
    serviceorString = _applyer;
    projectNameString = _projectName;
    phoneNumString = phoneNum;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setValue:bidRate.length?bidRate:@"" forKey:@"bidRate"];
    
    
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:userID forKey:@"applyer"];
    
    [dic setValue:projectNameString.length? projectNameString:@"" forKey:@"projectName"];
    [dic setValue:emailString.length?emailString:@"" forKey:@"email"];
    [dic setValue:linkManString.length?linkManString:@"" forKey:@"linkMan"];
    [dic setValue:serviceWayString.length?serviceWayString:@"" forKey:@"serviceWay"];
    [dic setValue:sketchString.length?sketchString: @"" forKey:@"sketch"];
    [dic setValue:togetherString.length?togetherString:@"" forKey:@"together"];
    [dic setValue:remarkString.length?remarkString: @"" forKey:@"remark"];
    [dic setValue:phoneNumString.length?phoneNumString: @"" forKey:@"phoneNum"];
    [dic setValue:_projectID.length?_projectID: @"" forKey:@"projectId"];
    [dic setValue:linkManPhoneString.length?linkManPhoneString: @"" forKey:@"linkManPhone"];
    [dic setValue:serviceObjectString.length? serviceObjectString:@"" forKey:@"serviceObject"];
    [dic setValue:servicePlaceString.length?servicePlaceString: @"" forKey:@"servicePlace"];
    [dic setValue:serviceTargetString.length?serviceTargetString: @"" forKey:@"serviceTarget"];
    [dic setValue:serviceTimeEndString.length?serviceTimeEndString: @"" forKey:@"serviceTimeEnd"];
    [dic setValue:serviceTimeStartString.length?serviceTimeStartString: @"" forKey:@"serviceTimeStart"];
    [dic setValue:serviceorString.length?serviceorString:@"" forKey:@"serviceor"];
    [dic setValue:selfEvaluationString.length?selfEvaluationString:@"" forKey:@"selfEvaluation"];
    [dic setValue:serviceContentString.length?serviceContentString:@"" forKey:@"serviceContent"];
    
    [SVProgressHUD showWithStatus:@"上传数据中"];
    
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper saveNewServiceRecordWithUserDic:dic UploadImageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        [self.view makeToast:@"提交成功" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"提交失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}


#pragma mark - TextFieldDelegate & TextViewDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 700001) {
        serviceWayString = toBeString;
    }else if(textField.tag == 700002)
    {
        servicePlaceString = toBeString;
    }else if(textField.tag == 700003)
    {
        serviceObjectString = toBeString;
    }
    else if(textField.tag == 700004)
    {
        linkManString = toBeString;
    }
    else if(textField.tag == 700005)
    {
        linkManPhoneString = toBeString;
    }
    else if(textField.tag == 700006)
    {
        togetherString = toBeString;
    }
    
    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 710001) {
        sketchString = textView.text;
    }
    else if (textView.tag == 710002) {
        serviceTargetString = textView.text;
    }else if(textView.tag == 710003)
    {
        serviceContentString = textView.text;
    }else if(textView.tag == 710004)
    {
        selfEvaluationString = textView.text;
    }
    else if(textView.tag == 710005)
    {
        remarkString = textView.text;
    }
}





// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(90, 870, [UIScreen mainScreen].bounds.size.width - 100, height)];
    
    //2、初始化
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    
    //3、选择媒体类型：ACMediaType
    mediaView.type = ACMediaTypePhotoAndCamera;
    
    mediaView.mediaArray = [NSMutableArray array];
    mediaView.imageMaxCount = 6;
    //是否需要显示图片上的删除按钮
    //mediaView.showDelete = NO;
    
    //5、随时获取新的布局高度
    [mediaView observeViewHeight:^(CGFloat value) {
        
        _bgView.height = value ;
        _uploadImageViewHeigh = (value - 40) / 2;
        if (_uploadImageViewHeigh < 60) {
            _uploadImageViewHeigh = 0;
        }
        
        //        [_mainTableview reloadData];
        
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        //        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //6、随时获取已经选择的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        uploadImageArray = [NSMutableArray arrayWithArray:list];
    }];
    _bgView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:mediaView];
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
