//
//  ProjectNewApplicationController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectNewApplicationController.h"
#import "ProjectNewApplicationCell.h"
#import "TPKeyboardAvoidingTableView.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"
#import "ProjectNetHelper.h"
#import "ValuePickerView.h"


@interface ProjectNewApplicationController()<UITableViewDelegate,UITableViewDataSource,GYZCustomCalendarPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,retain)ValuePickerView *pickerView;

@end

@implementation ProjectNewApplicationController
{
    ProjectNewApplicationCell *mainCell;
    BOOL isYES;
    
    NSString *choosePersonID;
    NSString *choosePersonName;
    NSString *chooseTime;
    NSString *applyUserPhone;
    
    
    
    NSString *projectName;
    NSString *projectFrom;
    NSString *bidRate;
    NSString *bidDate;
    NSString *clientName;
    NSString *clienLeader;
    NSString *clientPhone;
    NSString *contractAmount;
    NSString *preCost;
    NSString *maoLi;
    NSString *maoLiLv;
    NSString *projectDes;
    NSString *projectOppent;
    NSString *projectPartner;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"立项申请单";
    //    [self createApplyButton];
    [self createBarItem];
    
    _pickerView = [[ValuePickerView alloc]init];
}

#pragma mark - initView
-(void)initTableView
{
    projectFrom = @"新客户";
    
    _mainTableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
    //    _mainTableview.rowHeight = 168;
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
    static NSString *iden = @"ProjectNewApplicationCell";
    ProjectNewApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProjectNewApplicationCell" owner:self options:nil].firstObject;
    }
    mainCell = cell;
    [cell.bidYESButton addTarget:self action:@selector(YesClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bidNoButton addTarget:self action:@selector(NoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.projectFromButton addTarget:self action:@selector(chooseCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [cell.projectBidDateButton addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.projectFromButton setTitle:projectFrom forState:UIControlStateNormal];
    
    cell.projectNameLabel.delegate = self;   cell.projectNameLabel.tag = 400001;
    cell.projectBitRateTextfield.delegate = self;  cell.projectBitRateTextfield.tag = 400002;
    cell.clientNameTextfield.delegate = self;  cell.clientNameTextfield.tag = 400003;
    cell.clientPersonTextfield.delegate = self;  cell.clientPersonTextfield.tag = 400004;
    cell.clientPhoneTextfield.delegate = self;  cell.clientPhoneTextfield.tag = 400005;
    cell.contractAmountTextfield.delegate = self;  cell.contractAmountTextfield.tag = 400006;
    cell.preCostTextfield.delegate = self;  cell.preCostTextfield.tag = 400007;
    cell.maoliTextfield.delegate = self;  cell.maoliTextfield.tag = 400008;
    cell.maoLiLvTextfield.delegate = self;  cell.maoLiLvTextfield.tag = 400009;
    
    cell.textView_Partner.delegate = self;   cell.textView_Partner.tag = 410001;
    cell.textView_Describe.delegate = self;  cell.textView_Describe.tag = 410002;
    cell.textView_Opponent.delegate = self;  cell.textView_Opponent.tag = 410003;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 740;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    [mainCell.projectBidDateButton setTitle:result forState:UIControlStateNormal];
    bidDate = result;
    
}




#pragma mark - CellAbout

- (void)YesClickAction:(id)sender {
    [mainCell.bidNoButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [mainCell.bidYESButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isYES = YES;
}

- (void)NoClickAction:(id)sender {
    [mainCell.bidYESButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [mainCell.bidNoButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isYES = NO;
}

-(void)chooseCustomer:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *pickerDatasurce = [NSMutableArray arrayWithObjects:@"新客户",@"老客户",@"内部",@"合作渠道",@"其他", nil];
    self.pickerView.dataSource = pickerDatasurce;
    
    self.pickerView.pickerTitle = @"领用类型";
    //    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [mainCell.projectFromButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        projectFrom = stateArr[0];
    };
    [self.pickerView show];
}

-(void)chooseDate:(id)sender
{
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}




-(void)submitAction:(id)sender
{
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_MOBIENUM];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:dateString forKey:@"applyTime"];
    [dic setValue:userID.length?userID:@"" forKey:@"applyerId"];
    [dic setValue:bidRate.length?bidRate:@"" forKey:@"bidRate"];
    [dic setValue:isYES?@"0":@"1" forKey:@"bidornot"];
    [dic setValue:clienLeader.length?clienLeader:@"" forKey:@"clientLeader"];
    [dic setValue:clientPhone.length?clientPhone:@"" forKey:@"clientLeaderPhone"];
    [dic setValue:clientName.length?clientName:@"" forKey:@"clientName"];
    [dic setValue:projectOppent.length?projectOppent:@"" forKey:@"competitors"];
    [dic setValue:contractAmount.length?contractAmount:@"" forKey:@"contractAmount"];
    [dic setValue:bidDate.length?bidDate:@"" forKey:@"getbidTime"];
    [dic setValue:maoLi.length?maoLi:@"" forKey:@"maoli"];
    [dic setValue:maoLiLv.length?maoLiLv:@"" forKey:@"maolilv"];
    [dic setValue:projectPartner.length?projectPartner:@"" forKey:@"partner"];
    [dic setValue:phoneNum.length?phoneNum:@"" forKey:@"phoneNum"];
    [dic setValue:preCost.length?preCost:@"" forKey:@"preCost"];
    [dic setValue:projectDes.length?projectDes:@"" forKey:@"projectDescribe"];
    [dic setValue:projectFrom.length?projectFrom:@"" forKey:@"projectFrom"];
    [dic setValue:projectName.length?projectName:@"" forKey:@"projectName"];
    
    [SVProgressHUD showWithStatus:@"上传数据中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper saveNewProjectApplicationWithUserDic:dic UploadImageArray:[NSMutableArray array] andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        if (successful) {
            [self.view makeToast:@"提交成功" duration:1.5 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - TextFieldDelegate & TextViewDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 400001) {
        projectName = toBeString;
    }else if(textField.tag == 400002)
    {
        bidRate = toBeString;
    }else if(textField.tag == 400003)
    {
        clientName = toBeString;
    }
    else if(textField.tag == 400004)
    {
        clienLeader = toBeString;
    }
    else if(textField.tag == 400005)
    {
        clientPhone = toBeString;
    }
    else if(textField.tag == 400006)
    {
        contractAmount = toBeString;
    }else if(textField.tag == 400007)
    {
        preCost = toBeString;
    }else if(textField.tag == 400008)
    {
        maoLi = toBeString;
    }else if(textField.tag == 400009)
    {
        maoLiLv = toBeString;
    }

    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 410001) {
        projectPartner = textView.text;
    }else if(textView.tag == 410002)
    {
        projectDes = textView.text;
    }else if(textView.tag == 410003)
    {
        projectOppent = textView.text;
    }
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
