//
//  PAddVisitRecordController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PAddVisitRecordController.h"
#import "SDAutoLayout.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PAddVisitRecordCell.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"
#import "ProjectNetHelper.h"
#import "PickerView.h"

#import "ACMediaFrame.h"

@interface PAddVisitRecordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;

@end

@implementation PAddVisitRecordController
{
    PAddVisitRecordCell *mainCell;
    
    __block NSMutableArray *uploadImageArray;
    
    NSString *emailString;    //拜访人邮箱    string
    NSString *linkManString;    //具体联系人    string
    NSString *linkManEmailString;   //联系人邮箱    string
    NSString *linkManPhoneString;    //联系人电话    string
    NSString *phoneNumString;   //拜访人电话    string
    NSString *projectIdString;    //项目ID    string
    NSString *remarkString;    //备注    string
    NSString *togetherString;   //随行人员    string
    NSString *visitDateString;    //拜访日期    string
    NSString *visitObjectString;   // 拜访对象    string
    NSString *visitPlaceString;    //拜访地点    string
    NSString *visitReasonString;    //拜访原因    string
    NSString *visitSchoolString;    //学校或公司名称    string
    NSString *visitSketchString;    //拜访简述    string
    NSString *visitTimeEndString;    //拜访结束时间    string
    NSString *visitTimeStartString;    //拜访开始时间    string
    NSString *visitWayString;    //拜访方式    string
    NSString *visitorIdString;    //拜访人
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"拜访记录";
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
    static NSString *iden = @"PAddVisitRecordCell";
    PAddVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PAddVisitRecordCell" owner:self options:nil].firstObject;
    }
    
    if (!_bgView.superview) {
        [cell.contentView addSubview:_bgView];
    }
    
    
    mainCell = cell;
    [cell.chooseDateButton addTarget:self action:@selector(chooseDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseStartDateButton addTarget:self action:@selector(chooseStartDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseEndDateButton addTarget:self action:@selector(chooseEndDateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.visitorLabel.text = _applyer;
    cell.phoneLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MOBIENUM];
    cell.projectNameLabel.text = _projectName;
    
    cell.visitWaysTextfield.delegate = self;   cell.visitWaysTextfield.tag = 500001;
    cell.visitPlaceTextfield.delegate = self;  cell.visitPlaceTextfield.tag = 500002;
    cell.visitCustomTextfield.delegate = self;  cell.visitCustomTextfield.tag = 500003;
    cell.visitSchoolTextfield.delegate = self;  cell.visitSchoolTextfield.tag = 500004;
    cell.visitLinkerTextfield.delegate = self;  cell.visitLinkerTextfield.tag = 500005;
    cell.visitLinkerPhoneTextfield.delegate = self;  cell.visitLinkerPhoneTextfield.tag = 500006;
    cell.visitLinkerEmailTextfield.delegate = self;  cell.visitLinkerEmailTextfield.tag = 500007;

    cell.visitJianshuTextview.delegate = self;   cell.visitJianshuTextview.tag = 510001;
    cell.visitReasonTextView.delegate = self;  cell.visitReasonTextView.tag = 510002;
    cell.togetherMemberTextView.delegate = self;  cell.togetherMemberTextView.tag = 510003;
    cell.remarkTextview.delegate = self;  cell.remarkTextview.tag = 510004;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 856 + 30 * 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CellActions
-(void)chooseDateAction:(id)sender
{
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}

-(void)chooseStartDateAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_Time];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
        
        //        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.chooseStartDateButton setTitle:dateString forState:UIControlStateNormal];
        visitTimeStartString = dateString;
    };
}

-(void)chooseEndDateAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_Time];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
        
        //        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.chooseEndDateButton setTitle:dateString forState:UIControlStateNormal];
        visitTimeEndString = dateString;
    };
}


-(void)submitAction:(id)sender
{
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];

    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MOBIENUM];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setValue:bidRate.length?bidRate:@"" forKey:@"bidRate"];
    
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:userID forKey:@"applyer"];
    
    [dic setValue:_projectName forKey:@"projectName"];
    [dic setValue:linkManString.length?linkManString:@"" forKey:@"linkMan"];
    [dic setValue:linkManEmailString.length?linkManEmailString:@"" forKey:@"linkManEmail"];
    [dic setValue:linkManPhoneString.length?linkManPhoneString:@"" forKey:@"linkManPhone"];
    [dic setValue:phoneNum.length?phoneNum:@"" forKey:@"phoneNum"];
    [dic setValue:_projectID.length?_projectID:@"" forKey:@"projectId"];
    [dic setValue:remarkString.length?remarkString:@"" forKey:@"remark"];
    [dic setValue:togetherString.length?togetherString:@"" forKey:@"together"];
    [dic setValue:visitDateString.length?visitDateString:@"" forKey:@"visitDate"];
    [dic setValue:visitObjectString.length?visitObjectString:@"" forKey:@"visitObject"];
    [dic setValue:visitPlaceString.length?visitPlaceString:@"" forKey:@"visitPlace"];
    [dic setValue:visitReasonString.length?visitReasonString:@"" forKey:@"visitReason"];
    [dic setValue:visitSchoolString.length?visitSchoolString:@"" forKey:@"visitSchool"];
    [dic setValue:visitSketchString.length?visitSketchString:@"" forKey:@"visitSketch"];
    [dic setValue:visitTimeEndString.length?visitTimeEndString:@"" forKey:@"visitTimeEnd"];
    [dic setValue:visitTimeStartString.length?visitTimeStartString:@"" forKey:@"visitTimeStart"];
    [dic setValue:visitWayString.length?visitWayString:@"" forKey:@"visitWay"];
    [dic setValue:userID.length?userID:@"" forKey:@"visitorId"];
    
    
    [SVProgressHUD showWithStatus:@"上传数据中"];
    
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper saveNewVisitRecordWithUserDic:dic UploadImageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
            [self.view makeToast:@"提交成功" duration:1.5 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            [SVProgressHUD dismiss];
            [_mainTableview reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"提交失败" duration:1.5 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];

    
}


#pragma mark - TextFieldDelegate & TextViewDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 500001) {
        visitWayString = toBeString;
    }else if(textField.tag == 500002)
    {
        visitPlaceString = toBeString;
    }else if(textField.tag == 500003)
    {
        visitSchoolString = toBeString;
    }
    else if(textField.tag == 500004)
    {
        visitObjectString = toBeString;
    }
    else if(textField.tag == 500005)
    {
        linkManString = toBeString;
    }
    else if(textField.tag == 500006)
    {
        linkManPhoneString = toBeString;
    }else if(textField.tag == 500007)
    {
        linkManEmailString = toBeString;
    }
    
    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 510001) {
        visitSketchString = textView.text;
    }
    else if (textView.tag == 510002) {
        visitReasonString = textView.text;
    }else if(textView.tag == 510003)
    {
        togetherString = textView.text;
    }else if(textView.tag == 510004)
    {
        remarkString = textView.text;
    }
}



#pragma QTCustomCalendarPickerViewDelegate
//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *result = @"点击";
    if ([cal isMemberOfClass:[IDJCalendar class]]) {//阳历
        
        NSString *year =[NSString stringWithFormat:@"%@",cal.year];
        NSString *month = [cal.month intValue] > 9 ? cal.month:[NSString stringWithFormat:@"0%@",cal.month];
        NSString *day = [cal.day intValue] > 9 ? cal.day:[NSString stringWithFormat:@"0%@",cal.day];
        result = [NSString stringWithFormat:@"%@-%@-%@",year,month, day];
        
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {//阴历
        
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
        
        NSArray *array=[_cal.month componentsSeparatedByString:@"-"];
        NSString *dateStr = @"";
        if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
            dateStr = [NSString stringWithFormat:@"%@%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        } else {
            dateStr = [NSString stringWithFormat:@"%@闰%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        }
        result = [NSString stringWithFormat:@"%@%@",dateStr, [NSString stringWithFormat:@"%@", [_cal.chineseDays objectAtIndex:[_cal.day intValue]-1]]];
    }
    
    [mainCell.chooseDateButton setTitle:result forState:UIControlStateNormal];
    visitDateString = result;
}


// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(90, 800, [UIScreen mainScreen].bounds.size.width - 100, height)];
    
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
